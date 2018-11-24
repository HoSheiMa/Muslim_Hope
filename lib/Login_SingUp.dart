import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:islamlearntree/_myHome.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

final log_key = GlobalKey<FormState>();
var user_n, pass_w;

class _LoginPageState extends State<LoginPage> {
  var error_widget = Container();
  var text_widget_login = Text('Log In');
  var focus_page = null;
  _submit_log() {
    if (log_key.currentState.validate()) {
      log_key.currentState.save();
      Firestore.instance.collection('users').getDocuments().then((d) {
        d.documents.forEach((snap) {
          if (snap.data['user'] == user_n) {
            if (snap.data['pass'] == pass_w) {
              setState(() {
                error_widget = Container();
              });
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return MyHomePage(title: 'Islam', activer: user_n);
              }));
            } else {
              setState(() {
                error_widget = Container(
                  child: Text(
                    'Error To log in , something be wrong!',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              });
            }
          } else {
            setState(() {
              error_widget = Container(
                child: Text(
                  'Error To log in , something be wrong!',
                  style: TextStyle(color: Colors.red),
                ),
              );
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Center(child: Text('Log In Application')),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg2.jpg'), fit: BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: log_key,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                          onSaved: (t) => user_n = t,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: TextStyle(color: Colors.black))),
                      TextFormField(
                          onSaved: (t) => pass_w = t,
                          style: TextStyle(color: Colors.black),
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.black))),
                      error_widget,
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Hero(
                              child: RaisedButton(
                                color: Color(0xFF128C7E),
                                textColor: Colors.white,
                                child: text_widget_login,
                                onPressed: () {
                                  _submit_log();
                                },
                              ),
                              tag: 'hero_login',
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("If not have email ..  ",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return SignUp();
                        }));
                        // focus_page = SignUp();
                      });
                    },
                    child: Container(
                      child: Text(
                        "Sing Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

var randomName = null;

class _SignUpState extends State<SignUp> {
  final formSingUp = GlobalKey<FormState>();
  var dropdownButton__ = [];
  var idImage = null;
  var user,
      pass,
      name,
      info,
      religion = "Muslim",
      foceDate,
      dateFoces,
      date1 = new DateTime.now();
  Future<Null> seldate(context) async {
    var datesel = await showDatePicker(
      context: context,
      initialDate: date1,
      firstDate: DateTime(1900),
      lastDate: date1,
    );
    var y = datesel.year.toString();
    var m = datesel.month.toString();
    var d = datesel.day.toString();
    var dsel = "$y-$m-$d";
    dateFoces = dsel;
  }

  var msg__ = Container();
  var file;
  @override
  Widget build(BuildContext context) {
    var type;
    var image;

    Future getImage() async {
      file = await ImagePicker.pickImage(source: ImageSource.gallery);
      randomName = "profile_image_no" + Random().nextInt(1000000000).toString();

      print(randomName);
      setState(() {
        type = file
            .toString()
            .split('.')
            .reversed
            .toSet()
            .first
            .replaceAll("'", '');
        randomName = randomName + ".$type";
        print(randomName);
        idImage = ClipRRect(
          borderRadius: new BorderRadius.circular(550.0),
          child: Image.file(
            file,
            width: 300.0,
            height: 300.0,
          ),
        );
      });
    }

    _submit() {
      var exist = true;
      if (formSingUp.currentState.validate()) {
        formSingUp.currentState.save();
        Firestore.instance.collection('users').getDocuments().then((d) {
          d.documents.forEach((snap) {
            if (user == snap.data['name']) {
              exist = false;
              setState(() {
                msg__ = Container(
                  child: Text(
                    "This Username is already exist, write new one",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                );
                return;
              });
            }
          });
          // if (idImage == null) {
          //   exist = false;
          //   setState(() {
          //     msg__ = Container(
          //       child: Text(
          //         "Most Choose Profile Image.",
          //         style: TextStyle(
          //           color: Colors.red,
          //         ),
          //       ),
          //     );
          //     return;
          //   });
          // }
          if (dateFoces == null) {
            exist = false;
            setState(() {
              msg__ = Container(
                child: Text(
                  "Choose your Date.",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              );
              return;
            });
          }
          print(randomName);
          if (exist) {
            print(file);
            setState(() {
              msg__ = Container();
            });
            var ref = FirebaseStorage.instance
                .ref()
                .child('$randomName')
                .putFile(file);

            Firestore.instance.collection('users').add({
              'user': user,
              'pass': pass,
              'name': name,
              'info': '',
              'religion': religion,
              'date': dateFoces != null ? dateFoces.toString() : 'null',
              'link_image':
                  randomName == null ? randomName.toString() : randomName,
              'chat_': '[]',
            }).then((d) {
              setState(() {
                msg__ = Container(
                  child: Text("Done!",
                      style: TextStyle(
                        color: Colors.black,
                      )),
                );

                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     '/screen4', ModalRoute.withName('/screen1'));

                Navigator.pop(context);
              });
            });
          }
        });
      }
    }

    return Scaffold(
        appBar: AppBar(
          leading: FlatButton(
            child: Icon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Center(child: Text("Create Account")),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF5F5DC),
            // image: DecorationImage(
            //   fit: BoxFit.cover,
            //   image: AssetImage('assets/moon2.png'),
            // ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(28.0),
                  child: Form(
                    key: formSingUp,
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: getImage,
                          child: Container(
                            width: 300.0,
                            height: 300.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(555.0),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                idImage == null
                                    ? ClipRRect(
                                        borderRadius:
                                            new BorderRadius.circular(550.0),
                                        child: Image.asset(
                                          'assets/user.png',
                                          width: 300.0,
                                          height: 300.0,
                                        ),
                                      )
                                    : idImage,
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 12.0),
                          child: TextFormField(
                              validator: (txt) => txt.length < 8
                                  ? "Most more than 8 letters"
                                  : null,
                              onSaved: (txt) => name = txt,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                  fillColor: Colors.grey[100],
                                  filled: true,
                                  labelText: 'Name',
                                  labelStyle: TextStyle(color: Colors.black))),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 12.0),
                          child: TextFormField(
                              validator: (txt) => txt.length < 8
                                  ? "Most more than 8 letters"
                                  : null,
                              onSaved: (txt) => user = txt,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                  fillColor: Colors.grey[100],
                                  filled: true,
                                  labelText: 'Username',
                                  labelStyle: TextStyle(color: Colors.black))),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 12.0),
                          child: TextFormField(
                              onSaved: (p) => pass = p,
                              validator: (txt) => txt.length < 8
                                  ? "Most more than 8 letters"
                                  : null,
                              obscureText: true,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                  fillColor: Colors.grey[100],
                                  filled: true,
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.black))),
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(top: 20.0),
                        //   child: TextFormField(
                        //       onSaved: (d) => info = d,
                        //       validator: (txt) => txt.length < 10
                        //           ? "Most more than 10 letters to know you !"
                        //           : null,
                        //       maxLines: null,
                        //       keyboardType: TextInputType.multiline,
                        //       style: TextStyle(
                        //         color: Colors.black,
                        //       ),
                        //       decoration: InputDecoration(
                        //           fillColor: Colors.grey[100],
                        //           filled: true,
                        //           labelText: 'Info',
                        //           labelStyle: TextStyle(color: Colors.black))),
                        // ),
                        msg__,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 10.0),
                              child: Text('Choose your religion ',
                                  style: TextStyle(
                                    color: Colors.black,
                                  )),
                            ),
                            DropdownButton(
                              iconSize: 0.0,
                              value: religion,
                              hint: Text('Muslim'),
                              items: <DropdownMenuItem>[
                                DropdownMenuItem(
                                  value: 'Muslim',
                                  child: Text('Muslim'),
                                ),
                                DropdownMenuItem(
                                  value: 'Christian',
                                  child: Text('Christian'),
                                ),
                                DropdownMenuItem(
                                  value: 'Jewish',
                                  child: Text('Jewish'),
                                ),
                                DropdownMenuItem(
                                  value: 'else',
                                  child: Text('else'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  religion = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RaisedButton(
                                child: Text('Choose Your Date'),
                                onPressed: () {
                                  seldate(context);
                                },
                              )
                            ]),
                        InkWell(
                          onTap: () {
                            _submit();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF128C7E),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 5.0,
                                      offset: Offset(
                                        0.0,
                                        3.0,
                                      ),
                                    )
                                  ],
                                  borderRadius: new BorderRadius.circular(5.0)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text(
                                      'Sing Up',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
