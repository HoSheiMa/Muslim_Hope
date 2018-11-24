import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:islamlearntree/Login_SingUp.dart';
import 'package:islamlearntree/chatbox.dart';
import 'package:islamlearntree/config.dart';
import 'package:islamlearntree/notAllow.dart';
import 'package:islamlearntree/profile.dart';
import 'elements.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'info.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final String activer;

  MyHomePage({Key key, this.title, this.activer}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

/* List mainTitls = []; */
class _MyHomePageState extends State<MyHomePage> {
  int cIndex = 0;
  var icons = [
    FontAwesomeIcons.readme,
    FontAwesomeIcons.addressCard,
    FontAwesomeIcons.facebookMessenger,
    FontAwesomeIcons.bars,
    FontAwesomeIcons.headset
  ];
  @override
  Widget build(BuildContext context) {
    var pageTwo = (widget.activer == null)
        ? LoginPage() //NotAllow()
        : Container(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('verified accounts')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.only(top: 5.0),
                  itemBuilder: (BuildContext context, int index) {
                    String name = snapshot.data.documents[index]['name'];
                    String type = snapshot.data.documents[index]['type'];
                    String id = snapshot.data.documents[index]['id'];
                    String imagr =
                        url + snapshot.data.documents[index]['image'] + media;

                    return Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: new Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                  image: new NetworkImage(imagr),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(50.0)),
                              ),
                            ),
                            title: Text(name),
                            subtitle: Text(type),
                          ),
                          ButtonTheme.bar(
                            // make buttons use the appropriate styles for cards
                            child: ButtonBar(
                              children: <Widget>[
                                FlatButton(
                                  child: const Text('Visit Profile'),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return profileShow(
                                          needuser: id,
                                          visitor: widget.activer);
                                    }));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: snapshot.data.documents.length,
                );
              },
            ),
          );

    var pageFour = (widget.activer == null)
        ? LoginPage() //NotAllow()
        : profileShow(
            needuser: widget.activer,
            visitor: widget.activer,
          );
    var pageThree = (widget.activer == null)
        ? LoginPage() //NotAllow()
        : ChatBox(
            who: widget.activer,
          );
    List pages = [pageOne, pageTwo, pageThree, pageFour, pagefive];

    return new Scaffold(
      appBar: (cIndex != 0)
          ? AppBar(
              title: Center(child: Icon(icons[cIndex])),
            )
          : null,
      body: pages[cIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        fixedColor: Color(0xFF075E54),
        currentIndex: cIndex,
        onTap: (int needlyindex) {
          setState(() {
            cIndex = needlyindex;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: new Icon(icons[0], color: Color(0xFF128C7E)),
              title: new Text(
                'Content',
                style: TextStyle(color: Color(0xFF128C7E)),
              )),
          BottomNavigationBarItem(
            icon: new Icon(icons[1], color: Color(0xFF128C7E)),
            title: new Text(
              'Accounts',
              style: TextStyle(color: Color(0xFF128C7E)),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(icons[2], color: Color(0xFF128C7E)),
            title: new Text(
              'MASSAGES',
              style: TextStyle(color: Color(0xFF128C7E)),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(icons[3], color: Color(0xFF128C7E)),
            title: new Text(
              'Me',
              style: TextStyle(color: Color(0xFF128C7E)),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(icons[4], color: Color(0xFF128C7E)),
            title: new Text(
              'About',
              style: TextStyle(color: Color(0xFF128C7E)),
            ),
          ),
        ],
      ),
    );
  }
}
