import 'package:flutter/material.dart';
import 'package:islamlearntree/Login_SingUp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotAllow extends StatefulWidget {
  @override
  _NotAllowState createState() => _NotAllowState();
}

class _NotAllowState extends State<NotAllow> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  image:
                      DecorationImage(image: AssetImage('assets/error.png'))),
              height: 300.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: 15.0),
                    child: Icon(
                      FontAwesomeIcons.exclamation,
                      color: Colors.red,
                    )),
                Text(
                  'This Side Should log in frist to show it.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: Color(0xFF128C7E),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return LoginPage();
                      }));
                    },
                    child: Icon(FontAwesomeIcons.externalLinkAlt),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
