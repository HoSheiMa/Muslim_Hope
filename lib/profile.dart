import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:islamlearntree/Login_SingUp.dart';
import 'package:islamlearntree/chat_page.dart';
import 'package:islamlearntree/config.dart';
import 'dart:convert' as JSON;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class profileShow extends StatefulWidget {
  final String visitor;
  final String needuser;

  profileShow({this.visitor, this.needuser});
  @override
  _profileShowState createState() => _profileShowState();
}

class _profileShowState extends State<profileShow> {
  var colr_active_stars = Colors.grey;
  star_action() async {
    Firestore.instance
        .collection('verified accounts')
        .where('id', isEqualTo: widget.needuser)
        .getDocuments()
        .then((d) async {
      List starsJson =
          JSON.jsonDecode(d.documents.single.data['stars'].toString());

      if (!starsJson.contains(widget.visitor)) {
        starsJson.add(widget.visitor);
      } else {
        for (var i = 0; i < starsJson.length; i++) {
          if (starsJson[i] == widget.visitor) {
            starsJson.removeAt(i);
          }
        }
      }
      var starsText = JSON.jsonEncode(starsJson);
      var id = (d.documents.first.documentID);
      var ref = Firestore.instance.document("/verified accounts/$id");

      Firestore.instance.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(ref);
        if (postSnapshot.exists) {
          await tx.update(ref, <String, dynamic>{
            'stars': starsText,
          });
        }
      });
    });
  }

  var loading_w = SingleChildScrollView(
    child: Container(
      height: 300.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    if(widget.needuser != widget.visitor) { Firestore.instance
        .collection('verified accounts')
        .where('id', isEqualTo: widget.needuser)
        .getDocuments()
        .then((d) async {
      List starsJson =
          JSON.jsonDecode(d.documents.single.data['stars'].toString());

      if (starsJson.contains(widget.visitor)) {
        setState(() {
          colr_active_stars = Colors.yellow;
        });
      } else {
        setState(() {
          colr_active_stars = Colors.grey;
        });
      }
    });}
    Firestore.instance
        .collection('users')
        .where('user', isEqualTo: widget.needuser)
        .getDocuments()
        .then((d) {
      setState(() {
        var focus_user = d.documents.first.data;
        loading_w = SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
              top: 50.0,
            ),
            child: Column(
              children: <Widget>[
                new ClipRRect(
                  borderRadius: new BorderRadius.circular(550.0),
                  child: d.documents.single.data['link_image'] != 'null'
                      ? Image.network(
                          url + d.documents.single.data['link_image'] + media,
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/anon.png',
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(30.0),
                      child: Text(
                        focus_user['name'],
                        style: TextStyle(
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Wrap(
                  //  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    widget.visitor != null
                        ? (widget.needuser != widget.visitor)
                            ? RaisedButton(
                                padding: EdgeInsets.all(15.0),
                                color: Colors.blue,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Speak',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Icon(
                                      FontAwesomeIcons.facebookMessenger,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return ChatPage(
                                      visitor: widget.visitor,
                                      needuser: widget.needuser,
                                      nameNeeduser: focus_user['name'],
                                    );
                                  }));
                                },
                              )
                            : Container()
                        : Container(),
                  ],
                ),
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.info,
                          color: Colors.grey,
                        ),
                        title: Text('religion : ' + focus_user['religion']),
                        // subtitle: null,
                        // Column(
                        //   children: <Widget>[
                        //     Text(focus_user['date']),
                        //     Text(focus_user['religion']),
                        //   ],
                        // ),
                        //
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.info,
                          color: Colors.grey,
                        ),
                        title: Text("date : " + focus_user['date']),
                        // subtitle: null,
                        // Column(
                        //   children: <Widget>[
                        //     Text(focus_user['date']),
                        //     Text(focus_user['religion']),
                        //   ],
                        // ),
                        //
                      ),
                    ],
                  ),
                ),
                Padding(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              FontAwesomeIcons.info,
                              color: Colors.grey,
                            ),
                            title: Text('Information!'),
                            subtitle: Text(focus_user['info']),
                          ),
                        ],
                      ),
                    ),
                    padding: EdgeInsets.only(top: 5.0)),
                (widget.needuser == widget.visitor && widget.visitor != null)
                    ? RaisedButton(
                        color: Colors.red,
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return LoginPage();
                          }));
                        },
                        child: Text(
                          'Log Out',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        );
      });
    });
    return Scaffold(
      body: loading_w,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          (widget.needuser != widget.visitor)
              ? FloatingActionButton(
                  heroTag: 'else',
                  mini: true,
                  backgroundColor: colr_active_stars,
                  child: Icon(FontAwesomeIcons.star),
                  onPressed: star_action,
                )
              : Container(),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          (widget.needuser != widget.visitor)
              ? FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: Icon(FontAwesomeIcons.arrowLeft),
                  onPressed: () {
                    Navigator.pop(context);
                  })
              : Container()
        ],
      ),
    );
  }
}
