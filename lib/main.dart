import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:islamlearntree/Timerentro.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:islamlearntree/_myHome.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:islamlearntree/Login_SingUp.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:islamlearntree/entroPages.dart';
import 'dart:async';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'MuslimHope',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primaryColor: new Color(0xFF128C7E),
      ),
      home: ControllerPages(),
    );
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/log_in_entro_exists.txt');
}

class ControllerPages extends StatefulWidget {
  @override
  _ControllerPagesState createState() => _ControllerPagesState();
}

class _ControllerPagesState extends State<ControllerPages> {
  @override
  Widget build(BuildContext context) {
    var x = _localFile.then((d) {
      d.exists().then((c) {
        if (c == false) {
          print('Not Found!');
          d.create();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return EntroTime2();
          }));
        } else {
          print('found!');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) {
             return EntroTime();
          }));
        }
      });
    });
    return Center(
        child:
            CircularProgressIndicator()); //MyHomePage(title: 'Islam', activer: null,);// LoginPage();
   
  }
}

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new IntroViewsFlutter(
        [page, page2, page3],
        onTapDoneButton: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return MyHomePage(
              title: 'Islam',
              activer: null,
            );
          }));
        },
        showSkipButton: true,
        pageButtonTextStyles: new TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontFamily: "Regular",
        ),
      ),
    );
  }
}
