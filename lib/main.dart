import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'docviewer.dart';
import 'home.dart';

void main() {
  runApp(Root());
}



class Root extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Root();
  }
}

class _Root extends State<Root>{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.red[400]),
      routes:{
      '/': (context) => Home(),
      '/viewer': (context) => Viewer()
      },
    );
  }
}