import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

var pagefive = Pageinfo();

class Pageinfo extends StatefulWidget {
  @override
  _PageinfoState createState() => _PageinfoState();
}

class _PageinfoState extends State<Pageinfo> {
  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.8;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 15.0),
        child: Column(
          children: <Widget>[
            Center(
              child: Text(
                'Muslim Hope.',
                style: TextStyle(fontSize: 32.0),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Image.asset('assets/logo.png'),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              padding: EdgeInsets.only(left: 15.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.infoCircle,
                    size: 32.0,
                    color: Colors.grey,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'About Program',
                      style: TextStyle(fontSize: 22.0),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: c_width,
              padding: EdgeInsets.only(left: 15.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'An advocacy application aimed at helping new Muslims answer their questions about Islam through a direct conversation with doctors specializing in Islam',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              padding: EdgeInsets.only(left: 15.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.commentAlt,
                    size: 32.0,
                    color: Colors.grey,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Contant Us',
                      style: TextStyle(fontSize: 22.0),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: c_width,
              padding: EdgeInsets.only(left: 15.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.whatsapp,
                    color: Colors.green,
                    size: 32.0,
                  ),
                  Text(
                    'Whatsapp',
                    style: TextStyle(color: Colors.green, fontSize: 28.0),
                  ),
                ],
              ),
            ),
            Container(
              width: c_width,
              padding: EdgeInsets.only(left: 15.0),
              child: InkWell(
                onTap: () {
                  Clipboard.setData(new ClipboardData(text: '00972599980046'));
                  Scaffold.of(context).showSnackBar(new SnackBar(
                      content: new Text(
                          "Copied numbre to Clipboard : 00972599980046")));
                },
                child: Text(
                  '00972599980046',
                  style: TextStyle(fontSize: 28.0),
                ),
              ),
            ),
            Container(
              width: c_width,
              padding: EdgeInsets.only(left: 15.0),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              launch('https://www.facebook.com/muslimhope2/');
                            },
                            child: Icon(
                              FontAwesomeIcons.facebook,
                              color: Color(0xFF4267b2),
                              size: 52.0,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              launch('https://www.instagram.com/muslimhope22/');
                            },
                            child: Icon(
                              FontAwesomeIcons.instagram,
                              color: Colors.deepPurple,
                              size: 52.0,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
