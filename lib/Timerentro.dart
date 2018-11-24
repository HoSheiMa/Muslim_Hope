import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:islamlearntree/_myHome.dart';
import 'package:islamlearntree/main.dart';

class EntroTime extends StatefulWidget {
  @override
  _EntroTimeState createState() => _EntroTimeState();
}

class _EntroTimeState extends State<EntroTime> {
  @override
  Widget build(BuildContext context) {
    RestartableTimer _timer =
        new RestartableTimer(new Duration(seconds: 2), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return MyHomePage(
          title: 'Islam',
          activer: null,
        );
      }));
    });
    return Container(
      color: Color(0xFFF5F5DC),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/logo.png'),
        ],
      ),
    );
  }
}

class EntroTime2 extends StatefulWidget {
  @override
  _EntroTime2State createState() => _EntroTime2State();
}

class _EntroTime2State extends State<EntroTime2> {
  @override
  Widget build(BuildContext context) {
    RestartableTimer _timer =
        new RestartableTimer(new Duration(seconds: 2), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return Intro();
      }));
    });
    return Container(
      color: Color(0xFFF5F5DC),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/logo.png'),
        ],
      ),
    );
  }
}
