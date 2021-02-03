import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class SavedItems extends StatefulWidget {
  @override
  _SavedItemsState createState() => _SavedItemsState();
}

class _SavedItemsState extends State<SavedItems> {

  Future<List> genItems() async {
    super.initState();
    List l;
    Directory directory = await getApplicationDocumentsDirectory();
    Stream<FileSystemEntity> children = directory.list(followLinks: false);
    children.forEach((element){
      String _e = basename(element.path);
      _e = _e.substring(_e.indexOf(".")+1);

      if(_e == "txt"){
        l.add(element.path);
      }
    });
    
    return l;

  }

  @override
  Widget build(BuildContext ctx) {
    return FutureBuilder<List>(
      future: genItems(),
      builder: (ctx, AsyncSnapshot<List> snapshot){
        if(snapshot.hasData){
          return ListView.builder(itemCount: snapshot.data.length, itemBuilder: (BuildContext context, int index){
                    // String key = _countries.keys.elementAt(index);
                    return new Text(snapshot.data.elementAt(index));});
        }
        else{
          return Center(child: Text("Select a file to view", textScaleFactor: 2, style: TextStyle(color: Colors.green[400])));
        }
      }
    );
  }
}