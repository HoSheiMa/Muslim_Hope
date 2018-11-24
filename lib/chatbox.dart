import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:islamlearntree/chat_page.dart';
import 'package:islamlearntree/config.dart';

class ChatBox extends StatefulWidget {
  final String who;
  ChatBox({this.who});
  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  var widget1 = Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Center(
      child: CircularProgressIndicator(),
    )
  ]);

  var done1 = false;
  @override
  Widget build(BuildContext context) {
    done1 == false
        ? Firestore.instance
            .collection('chat_')
            .document(widget.who)
            .snapshots()
            .listen((d) {
            print('Done!');
            if (d.exists == false) {
              setState(() {
                widget1 = Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: Text(
                      'No Data Yet.',
                      style: TextStyle(fontSize: 32.0, color: Colors.grey[200]),
                    )),
                  ],
                );
              });
              return;
            }
            var datawidget = <Widget>[];
            var keys = d.data.keys.toList();
            for (int ix = 0; ix < keys.length; ix++) {
              Firestore.instance
                  .collection('users')
                  .where('user', isEqualTo: keys[ix])
                  .getDocuments()
                  .then((d) {
                print('id');
                var img = d.documents.first.data['link_image'];
                datawidget.add(Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: new Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: new BoxDecoration(
                            image: new DecorationImage(
                              image: new NetworkImage(url + img + media),
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(50.0)),
                          ),
                        ),
                        title: Text(keys[ix]),
                      ),
                      ButtonTheme.bar(
                        // make buttons use the appropriate styles for cards
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: const Text('Go ChatBox'),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return ChatPage(
                                    nameNeeduser: keys[ix],
                                    needuser: keys[ix],
                                    visitor: widget.who,
                                  );
                                }));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
              }).then((d) {
                setState(() {
                  done1 = true;
                  widget1 = Column(
                    children: datawidget,
                  );
                });
              });
            }

            // print(datawidget.toString());
          })
        : null;
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('chat_').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return widget1;
        },
      ),
    );
  }
}
