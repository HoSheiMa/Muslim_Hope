import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';
import 'dart:io' as io;
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:islamlearntree/profile.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert' as JSON;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:islamlearntree/config.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'time.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatPage extends StatefulWidget {
  final String visitor;
  final String nameNeeduser;
  final String needuser;

  ChatPage(
      {@required this.visitor,
      @required this.needuser,
      @required this.nameNeeduser});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var videos = {};
  //var x = {"eslam": 'HoSheiMa'};
  var sendMsg = GlobalKey<FormFieldState>();
  var msg = "";
  var file_image;

  String chatBoxId = null;
  get_img() async {
    var image_name = "image_chat" + Random().nextInt(1000000).toString();
    file_image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var ref = await FirebaseStorage.instance
        .ref()
        .child('$image_name')
        .putFile(file_image)
        .onComplete
        .then((d) async {
      await Firestore.instance
          .collection("chat")
          .document('$chatBoxId')
          .get()
          .then((d) async {
        var sender = widget.visitor;
        var id_new_msg = d.data['length_msg'];
        var new_id_msg = int.parse(id_new_msg) + 1;
        await Firestore.instance
            .collection("chat")
            .document("$chatBoxId")
            .setData({
          "$id_new_msg": "[\"$sender\",\"image->$image_name\",\"12:!23\"]",
          "length_msg": "$new_id_msg",
        }, merge: true);
      });
    });
  }

  get_img_from_cam() async {
    var image_name = "image_chat" + Random().nextInt(1000000).toString();
    file_image = await ImagePicker.pickImage(source: ImageSource.camera);
    var ref = await FirebaseStorage.instance
        .ref()
        .child('$image_name')
        .putFile(file_image)
        .onComplete
        .then((d) async {
      await Firestore.instance
          .collection("chat")
          .document('$chatBoxId')
          .get()
          .then((d) async {
        var time_ = time_now();
        var sender = widget.visitor;
        var id_new_msg = d.data['length_msg'];
        var new_id_msg = int.parse(id_new_msg) + 1;
        await Firestore.instance
            .collection("chat")
            .document("$chatBoxId")
            .setData({
          "$id_new_msg": "[\"$sender\",\"image->$image_name\",\"$time_\"]",
          "length_msg": "$new_id_msg",
        }, merge: true);
      });
    });
  }

  var recording = false;

  @override
  Widget build(BuildContext context) {
    var who_sender = widget.needuser;
    var who_visiter = widget.visitor;
    chat_systeming() {
      var rand_key = "chatkey" + Random().nextInt(100000).toString();
      var time_ = time_now();
      Firestore.instance.collection('chat').document(rand_key).setData({
        'key': rand_key,
        'length_msg': '6',
        '0': "[\"$who_sender\",\"Thanks. for Choose us.\",\"$time_\"]",
        '1':
            "[\"$who_sender\",\"Here can speak with you and help you faster\",\"$time_\"]",
        '2':
            "[\"$who_sender\",\"You can record voice and send in chat.\",\"$time_\"]",
        '3':
            "[\"$who_sender\",\"You can alse send images and medias\",\"$time_\"]",
        '4': "[\"$who_sender\",\"Hello\",\"$time_\"]",
        '5': "[\"$who_sender\",\"can i help you?\",\"$time_\"]",
      }).then((d) {
        Firestore.instance
            .collection('users')
            .where('user', isEqualTo: widget.visitor)
            .getDocuments()
            .then((d) {
          // chat_.add("['$who_sender', '$rand_key']");
          // Firestore.instance
          //     .collection('users')
          //     .document(d.documents.first.documentID)
          //     .setData({'chat_': '$chat_'}, merge: true);
          Firestore.instance
              .collection("chat_")
              .document("$who_visiter")
              .setData({
            "$who_sender": "$rand_key",
          }, merge: true).then((d) {
            Firestore.instance
                .collection("chat_")
                .document("$who_sender")
                .setData({
              "$who_visiter": "$rand_key",
            }, merge: true).then((d) {
              setState(() {
                chatBoxId = rand_key;
              });
            });
          });
        });
      });
      print('Not Found!');
    }

    requestPermission() async {
      final res =
          await SimplePermissions.requestPermission(Permission.RecordAudio);
    }

    _start() async {
      try {
        if (await AudioRecorder.hasPermissions) {
          setState(() {
            recording = true;
          });
          await AudioRecorder.start();
        } else {
          requestPermission();
        }
      } catch (e) {
        print(e);
      }
    }

    _stop() async {
      var record_ = await AudioRecorder.stop().then((d) {
        var f = io.File(d.path);
        var fNRandom = "file_" + Random().nextInt(10000000).toString();
        FirebaseStorage.instance
            .ref()
            .child(fNRandom)
            .putFile(f)
            .onComplete
            .then((d) {
          Firestore.instance
              .collection("chat")
              .document('$chatBoxId')
              .snapshots()
              .first
              .then((d) {
            var l = d.data['length_msg'];
            var lN = int.parse(d.data['length_msg']) + 1;
            var time_ = time_now();
            Firestore.instance
                .collection("chat")
                .document("$chatBoxId")
                .setData({
              "length_msg": "$lN",
              "$l": "[\"$who_visiter\",\"mp4->$fNRandom\", \"$time_\"]"
            }, merge: true);
          });
        });
      });
    }

    send_record() async {
      if (recording != true) {
        await _start();
      } else {
        setState(() {
          recording = false;
          _stop();
        });
      }
    }

    if (chatBoxId == null) {
      var not_exists = true;
      Firestore.instance
          .collection('users')
          .where('user', isEqualTo: widget.visitor)
          .getDocuments()
          .then((d1) {
        Firestore.instance
            .collection('chat_')
            .document(widget.visitor)
            .snapshots()
            .listen((d) {
          if (d.exists && d.data.containsKey(widget.needuser)) {
            setState(() {
              chatBoxId = d.data["$who_sender"];
            });
            not_exists = false;
            print('Found!');
          }

          if (not_exists == true) {
            chat_systeming();
          }
        });
      });
    }
    ScrollController _scrollController = new ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return profileShow(
                  needuser: widget.needuser,
                  visitor: null,
                );
              }));
            },
            child: Text(widget.nameNeeduser)),
      ),
      body: (chatBoxId != null)
          ? StreamBuilder(
              stream: Firestore.instance.collection("chat").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return new Center(
                    child: new CircularProgressIndicator(),
                  );
                }
                List els = <Widget>[];
                var c_els = Container(
                  // padding: EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    reverse: false,
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: els,
                        ),
                        TextFormField(
                          validator: (t) => t.length > 1 ? null : null,
                          onSaved: (t) => msg = t,
                          // maxLines: null,
                          key: sendMsg,
                          // keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              fillColor: Colors.grey[100],
                              filled: true,
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: Colors.black)),
                        ),
                        Container(
                          height: 40.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                child: Icon(FontAwesomeIcons.camera,
                                    size: 18.0, color: Colors.grey[200]),
                                onPressed: get_img_from_cam,
                              ),
                              FlatButton(
                                child: Icon(FontAwesomeIcons.audioDescription,
                                    size: 18.0,
                                    color: (recording == true)
                                        ? Colors.red[200]
                                        : Colors.grey[200]),
                                onPressed: send_record,
                              ),
                              FlatButton(
                                child: Icon(FontAwesomeIcons.image,
                                    size: 18.0, color: Colors.grey[200]),
                                onPressed: get_img,
                              ),
                              FlatButton(
                                child: Icon(FontAwesomeIcons.locationArrow,
                                    size: 18.0, color: Colors.green[200]),
                                onPressed: () async {
                                  if (sendMsg.currentState.validate()) {
                                    sendMsg.currentState.save();
                                    var whoSend = widget.visitor;
                                    sendMsg.currentState.reset();
                                    await Firestore.instance
                                        .collection("chat")
                                        .document('$chatBoxId')
                                        .get()
                                        .then((d) async {
                                      print("====================");
                                      print(d.reference.path);
                                      var id_new_msg = d.data['length_msg'];
                                      var new_id_msg =
                                          int.parse(id_new_msg) + 1;
                                      var time_ = time_now();
                                      await Firestore.instance
                                          .collection("chat")
                                          .document("$chatBoxId")
                                          .setData({
                                        "$id_new_msg":
                                            "[\"$whoSend\",\"$msg\",\"$time_\"]",
                                        "length_msg": "$new_id_msg",
                                      }, merge: true);
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
                for (var i = 0; i < snapshot.data.documents.length; i++) {
                  int len_msgs =
                      int.tryParse(snapshot.data.documents[i]['length_msg']);
                  if (snapshot.data.documents[i]['key'] == chatBoxId) {
                    for (var ii = 0; ii < len_msgs; ii++) {
                      var info_msg =
                          JSON.jsonDecode(snapshot.data.documents[i]["$ii"]);
                      if (info_msg[1].split('->')[0] == "image") {
                        els.add(Container(
                          margin: (info_msg[0] == widget.visitor)
                              ? EdgeInsets.only(left: 60.0)
                              : EdgeInsets.only(right: 60.0),
                          child: Card(
                            child: Container(
                              color: (info_msg[0] != widget.visitor)
                                  ? Colors.green[200]
                                  : Colors.blue[200],
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    // leading: Icon(Icons.album),
                                    title: CachedNetworkImage(
                                      imageUrl: url +
                                          info_msg[1].split("->")[1] +
                                          media,
                                      placeholder: Container(
                                          width: 50.0,
                                          child:
                                              new CircularProgressIndicator()),
                                      errorWidget: new Icon(Icons.error),
                                    ),

                                    // style: TextStyle(color: Colors.white),

                                    subtitle: Text(info_msg[2]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
                      } else if (info_msg[1].split('->')[0] == "mp4") {
                        VideoPlayerController _controller;
                        _controller = VideoPlayerController.network(
                          url + info_msg[1].split('->')[1] + media,
                        )..setVolume(1.0);
                        videos["v$ii"] = _controller;

                        els.add(Container(
                          margin: (info_msg[0] == widget.visitor)
                              ? EdgeInsets.only(left: 60.0)
                              : EdgeInsets.only(right: 60.0),
                          child: Card(
                            child: Container(
                              color: (info_msg[0] != widget.visitor)
                                  ? Colors.green[200]
                                  : Colors.blue[200],
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    // leading: Icon(Icons.album),
                                    title: Stack(children: [
                                      Opacity(
                                        child: Container(
                                          height: 20.0,
                                          child: new AspectRatio(
                                            aspectRatio: 16.0 / 9.0,
                                            child: VideoPlayer(videos["v$ii"]),
                                          ),
                                        ),
                                        opacity: 0.0,
                                      ),
                                      Center(
                                        child: Container(
                                          child: Image.asset(
                                            'assets/loading_v.gif',
                                            height: 40.0,
                                          ),
                                        ),
                                      ),
                                    ]),
                                    subtitle: Row(
                                      children: <Widget>[
                                        InkWell(
                                          child: Icon(
                                            FontAwesomeIcons.play,
                                            color: Colors.white,
                                          ),
                                          onTap: () {
                                            videos["v$ii"].initialize();
                                            videos["v$ii"].play();
                                          },
                                        ),
                                        Text(info_msg[2]),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
                        continue;
                      } else {
                        els.add(Container(
                          margin: (info_msg[0] == widget.visitor)
                              ? EdgeInsets.only(left: 60.0)
                              : EdgeInsets.only(right: 60.0),
                          child: Card(
                            child: Container(
                              color: (info_msg[0] != widget.visitor)
                                  ? Colors.green[200]
                                  : Colors.blue[200],
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    // leading: Icon(Icons.album),
                                    title: Text(
                                      info_msg[1],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(info_msg[2]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
                      }
                    }
                  }
                }
                try {
                  Timer(Duration(milliseconds: 300), () {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 300),
                    );
                    //   _scrollController
                    //     .jumpTo(_scrollController.position.maxScrollExtent)
                  });
                } catch (e) {}

                return c_els;
              },
            )
          : Container(),
      bottomSheet: Column(
        children: <Widget>[],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.send),
      // ),
    );
  }
}
