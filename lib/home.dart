import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'saveditems.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

    File file;

  Future<void> openDoc() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.any, withData: true);
    String extension = result.files.single.name;
    extension = extension.substring(extension.indexOf(".")+1);
    if(extension == "pdf"){
      Navigator.pushReplacementNamed(context, '/viewer', arguments: {
        'file': result.files.single
      });
    }
    else{
      Navigator.push(context, MaterialPageRoute<void>( builder: (context) => AlertDialog(content: Text("File type invalid"),actions: [BackButton(onPressed:(){Navigator.pop(context);},)],)));
    }
  }
  
  // Directory dir;

  // Future<void> openDir() async {
  //   Directory
  // }

  // @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: SafeArea(child: SavedItems()),
            bottomNavigationBar: BottomNavigationBar(
            items: [BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"), BottomNavigationBarItem(icon: IconButton(icon: Icon(Icons.file_upload),onPressed: ()=> openDoc(),), label: "Open document")],)
          );
  }
}