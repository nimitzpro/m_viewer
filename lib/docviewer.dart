import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:path_provider/path_provider.dart';

class Viewer extends StatefulWidget{
  @override
  ViewerState createState() => ViewerState();
}

class ViewerState extends State<Viewer>{


  @override
  Widget build(BuildContext context) {

    Map data;


    data = ModalRoute.of(context).settings.arguments;
    // print(data['file']);
    // return(Text(data['file'].toString()));
    return PDFScreen(pathPDF: data['file'].path);
  }
}

// ignore: must_be_immutable
class PDFScreen extends StatefulWidget{
 

  final String pathPDF;

  const PDFScreen ({ Key key, this.pathPDF }): super(key: key);

  @override
  PDFScreenState createState() => PDFScreenState();
}



class PDFScreenState extends State<PDFScreen> {
  bool perPage = false;
  int cDuration = 10;
  dynamic counter = 10;
  Timer timer;
  bool isPlaying = false;

  int _actualPageNumber = 1, _allPagesCount = 0;
  bool isSampleDoc = true;
  PdfController _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfController(
      // document: PdfDocument.openAsset("lib/assets/test.pdf"),
      document: PdfDocument.openFile(widget.pathPDF)
    );
  }

  void startTimer(){
    isPlaying = true;
    timer = Timer.periodic(Duration(seconds: 1),(timer){
      setState(() {
        if(counter > 1){
          counter--;
        }
        else{
          if(_actualPageNumber != _allPagesCount){
            _pdfController.nextPage(duration: Duration(milliseconds: 500), curve: Cubic(2,2,2,2));
            counter = cDuration;
          }
          else{
            counter = "Done!";
            timer.cancel();
            isPlaying = false;
          }
        }
      });
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async{
    final path = await _localPath;
    String name = basename(widget.pathPDF);
    name = name.substring(0, name.indexOf("."));
    return File('$path/$name.txt');
  }

  Future<File> writeCounter() async {
  final file = await _localFile;

  // add JSON : include whether counter is per page, file path, etc.

  // Write the file.
  return file.writeAsString('$counter');
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
              onPressed: (){
                Navigator.popAndPushNamed(context, "/");
              },
            ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
            Text("$_actualPageNumber/$_allPagesCount"),
            Text("$counter"),
            IconButton(icon: Icon(Icons.save), onPressed: writeCounter)],),
          centerTitle: true,
        ),
    body: PdfView(
            documentLoader: Center(child: CircularProgressIndicator()),
            pageLoader: Center(child: CircularProgressIndicator()),
            controller: _pdfController,
            onDocumentLoaded: (document) {
              setState(() {
                _actualPageNumber = 1;
                _allPagesCount = document.pagesCount;
              });
            },
            onPageChanged: (page) {
              setState(() {
                _actualPageNumber = page;
              });
            }
    ),
    bottomNavigationBar: BottomNavigationBar(
      items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: !isPlaying && counter == cDuration ? "Start Timer" : "Reset Timer", // Flip logic
            icon: IconButton(
              icon: Icon(Icons.timer), 
              onPressed: (){
                if(!isPlaying){
                  setState(()=>counter = cDuration);
                  startTimer();
                }
                else{
                timer.cancel();
                setState((){
                  counter = cDuration;
                  isPlaying = false;
                });
                }
              }
            ),
          ),
          BottomNavigationBarItem(
            label: isPlaying ? "Pause" : "Resume",
            icon: IconButton(
              icon: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              onPressed: (){
                if(isPlaying){
                  timer.cancel();
                  setState(() {
                    isPlaying = false;  
                  });
                }
                else startTimer();
              }
              )
          ),
          BottomNavigationBarItem(
            label: "Set Timer Length",
            icon: IconButton(
              icon: Icon(Icons.settings),
              onPressed: (){
                if(isPlaying){
                  timer.cancel();
                  setState(() {
                    isPlaying = false;  
                  });
                }
                var _textFieldController;
                var temp;
                        Navigator.push(context, MaterialPageRoute<void>( builder: (context) => AlertDialog(
                        title: Text('Change timer interval'),  
                        content: TextField(  
                        controller: _textFieldController,
                        keyboardType: TextInputType.number,
                         inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
        decoration: InputDecoration(hintText:cDuration.toString()),  
        onChanged: (value){
          temp = int.parse(value);
        },
      ),  
      actions: <Widget>[  
        new FlatButton(  
          child: new Text('Set'),  
          onPressed: () {  
            Navigator.pop(context);
            if(temp > 0){
              setState(() {
                cDuration = temp;
                counter = cDuration;
              });
            }
          },  
        )  
      ],  
    )));  
  }
  ),
  ) 
      ],),
    );
  }
}
