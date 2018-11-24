import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Btn1 extends StatefulWidget {
  @override
  Btn1State createState() {
    return new Btn1State();
  }
}

class Btn1State extends State<Btn1> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Hello1');
      },
      child: new Container(
          width: 60.0,
          height: 60.0,
          alignment: FractionalOffset.center,
          decoration: new BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.lightGreen,
              Colors.green,
            ]),
            borderRadius: new BorderRadius.all(const Radius.circular(6.0)),
          ),
          child: Icon(
            Icons.help,
            color: Colors.white,
            size: 60.0,
          )),
    );
  }
}

var app1 = SliverAppBar(
  leading: Icon(Icons.settings),
  pinned: true,
  expandedHeight: 380.0,
  flexibleSpace: FlexibleSpaceBar(
    background: Image.asset(
      'assets/bg.png',
      fit: BoxFit.cover,
    ),
    title: Text('Dome'),
  ),
);

var grid1 = SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 200.0,
  mainAxisSpacing: 1.0,
  crossAxisSpacing: 1.0,
  childAspectRatio: 1.0,
);
var colorsMainBox = [
  Color(0xFFFF8C42),
  Color(0xFFFFF275),
  Color(0xFF6699CC),
  Color(0xFFFF3C38),
  Color(0xFFA23E48),
  Color(0xFFFE5F55),
  Color(0xFFE63462),
  Color(0xFF333745),
  Color(0xFFEEF5DB)
];
var pageOne = StreamBuilder(
    stream: Firestore.instance.collection('names').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData)
        return new Center(
          child: new CircularProgressIndicator(),
        );

      return Container(
        decoration: BoxDecoration(
          color: Color(0xFFF5F5DC),
          image: DecorationImage(image: AssetImage('assets/logo.png')),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            // app1,
            SliverAppBar(
              title: Center(child: Text('Islam the way of life')),
            ),
            SliverGrid(
              gridDelegate: grid1,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  var r = Random().nextInt(8);
                  return Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorsMainBox[r]),
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white,
                    ),

                    // margin: EdgeInsets.all(2.0),
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new RecvPageContent(
                                    id: snapshot.data.documents[index]['id'])));
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 15.0),
                              child: (snapshot.data.documents[index]['image']
                                          .runtimeType
                                          .toString() ==
                                      'Null')
                                  ? Icon(
                                      FontAwesomeIcons.lightbulb,
                                      size: 42.0,
                                      color: Colors.grey,
                                    )
                                  : Container(
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data.documents[index]
                                            ['image'],
                                        width: 42.0,
                                        placeholder: Container(
                                            width: 50.0,
                                            child:
                                                new CircularProgressIndicator()),
                                        errorWidget: new Icon(Icons.error),
                                      ),
                                    ),
                            ),
                            Text(
                              snapshot.data.documents[index]['name'],
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ]),
                    ),
                  );
                },
                childCount: snapshot.data.documents.length,
              ),
            ),
          ],
        ),
      );
    });

class RecvPageContent extends StatefulWidget {
  RecvPageContent({Key key, @required this.id}) : super(key: key);
  final String id;
  @override
  RecvPageContentState createState() => RecvPageContentState();
}

var videos = {};

class RecvPageContentState extends State<RecvPageContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: Firestore.instance.collection('pages_content').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return new Center(
                  child: new CircularProgressIndicator(),
                );
              }
              //print( snapshot.data.documents.length);
              for (int i = 0; i < snapshot.data.documents.length; i++) {
                if (snapshot.data.documents[i]['id'] == widget.id) {
                  List<Widget> eles = [];
                  var Home__ = Scaffold(
                      appBar: AppBar(
                        title: Text(snapshot.data.documents[i]['name']),
                      ),
                      body: Container(
                        padding: EdgeInsets.all(10.0),
                        color: Colors.grey[300],
                        child: SingleChildScrollView(
                          child: Column(
                            children: eles,
                          ),
                        ),
                      ));
                  for (int ii = 0;
                      ii < snapshot.data.documents[i]['length'];
                      ii++) {
                    var snap =
                        snapshot.data.documents[i][ii.toString()].split("->");
                    if (snap[0] == "image") {
                      eles.add(Row(
                        children: [
                          Expanded(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: snap[1],
                              width: 42.0,
                              placeholder: Container(
                                  width: 50.0,
                                  height: 50.0,
                                  child: new CircularProgressIndicator()),
                              errorWidget: new Icon(Icons.error),
                            ),
                          )
                        ],
                      ));
                    } else if (snap[0] == "title") {
                      eles.add(Container(
                        padding: EdgeInsets.all(6.0),
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          snap[1],
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ));
                    } else if (snap[0] == "video") {
                      // bool _isPlaying = false;
                      VideoPlayerController _controller;
                      _controller = VideoPlayerController.network(
                        snap[1],
                      )
                        // ..addListener(() {
                        //   final bool isPlaying = _controller.value.isPlaying;
                        //   if (isPlaying != _isPlaying) {
                        //     setState(() {
                        //       _isPlaying = isPlaying;
                        //     });
                        //   }
                        // })
                        ..setVolume(1.0)
                        ..initialize();
                      print("---------------------------> v$ii");
                      videos["v$ii"] = _controller;
                      eles.add(InkWell(
                        onTap: () {
                          print(videos);
                          print("v$ii");
                          videos["v$ii"].initialize();
                          videos["v$ii"].play();
                        },
                        child: Container(
                          child: new AspectRatio(
                            aspectRatio: 16.0 / 9.0,
                            child: VideoPlayer(videos["v$ii"]),
                          ),
                        ),
                      ));
                      continue;
                    } else {
                      eles.add(Text(
                        snapshot.data.documents[i][ii.toString()],
                        style: TextStyle(fontSize: 16.0, color: Colors.green),
                      ));
                    }
                  }
                  return Home__;
                }
              }
              return null;
            }));
  }
}
