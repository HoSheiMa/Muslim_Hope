import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:flutter/material.dart';

var page = new PageViewModel(
  pageColor: Color(0xFF197741),
  iconImageAssetPath: null, // 'assets/taxi-driver.png',
  iconColor: null,
  bubbleBackgroundColor: null,
  body: Text(
    'Browse the most important topics about Islam.',
  ),
  title: Text('Get to know Islam', style: TextStyle(fontSize: 32.0)),
  mainImage: Image.asset(
    'assets/bg4.png',
    height: 320.0,
    width: 320.0,
    alignment: Alignment.center,
  ),
  textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
);
var page2 = new PageViewModel(
  pageColor: Color(0xFF197741),
  iconImageAssetPath: null, // 'assets/taxi-driver.png',
  iconColor: null,
  bubbleBackgroundColor: null,
  body: Text(
    'Doctors and professors specialized in the fundamentals of religion and the call to Islam.',
  ),
  title: Text('advice and questions.', style: TextStyle(fontSize: 32.0)),
  mainImage: Image.asset(
    'assets/man2.png',
    height: 285.0,
    width: 285.0,
    alignment: Alignment.center,
  ),
  textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
);
var page3 = new PageViewModel(
  pageColor: Color(0xFF197741),
  iconImageAssetPath: null, // 'assets/taxi-driver.png',
  iconColor: null,
  bubbleBackgroundColor: null,
  body: Text(
    'You can speak a voice chat with a specialist doctor',
  ),
  title: Text('Communication',
  style: TextStyle(fontSize: 32.0),),
  mainImage: Image.asset(
    'assets/man1.png',
    height: 285.0,
    width: 285.0,
    alignment: Alignment.center,
  ),
  textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
);
