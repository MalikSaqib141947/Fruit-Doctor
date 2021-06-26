import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_doctor/Screens/scraper.dart';
import 'package:flutter_doctor/Screens/todo_list_screen.dart';
import 'package:flutter_doctor/Screens/completeProfile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_doctor/Screens/welcome.dart';
import 'note_home.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_doctor/utilities/auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  static const String id = 'Profile';
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _image;
  String name = "anonumus";
  String email = "somewhere.com";
  String url =
      "https://p.kindpng.com/picc/s/78-786207_user-avatar-png-user-avatar-icon-png-transparent.png";
  bool pictureUploading = false;

  getUserCred({int choice}) async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if (choice == 1) {
      name = sharedPref.get('name');
      if (name == null) return 'Anonymous';
      return name;
    } else if (choice == 2) {
      email = sharedPref.get('email');
      if (email == null) return 'sample@email.com';
      return email;
    } else if (choice == 3) {
      url = sharedPref.get('url');
      return url;
    } else if (choice == 4) {
      bool localAccount = sharedPref.get('localAccount');
      return localAccount;
    }
  }

  /*getUserCresentials() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.getString('name') != null
        ? name = sharedPref.getString('name')
        : name = "Anonymous";
    sharedPref.getString('email') != null
        ? email = sharedPref.getString('email')
        : email = "sample@email.com";
    sharedPref.getString('url') != null
        ? url = sharedPref.getString('url')
        : url = "";
  }*/

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });

    _updateProfilePicture();
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });

    _updateProfilePicture();
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _updateProfilePicture() {
    if (_image != null) {
      this.setState(() {
        pictureUploading = true;
      });
      auth.a.updateProfilePicture(_image).then((val) async {
        if (val.data['success']) {
          Fluttertoast.showToast(
              msg: val.data['msg'].toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          var token = await sharedPreferences.get('token');

          await auth.a.getinfo(token).then((info) async {
            auth.a.userProfile[auth.E.username.index] = info.data['name'];
            auth.a.userProfile[auth.E.email.index] = info.data['email'];
            auth.a.userProfile[auth.E.photoURL.index] = info.data['pictureUrl'];

            await sharedPreferences.setString('name', info.data['name']);
            await sharedPreferences.setString('email', info.data['email']);
            await sharedPreferences.setString('url', info.data['pictureUrl']);
            await sharedPreferences.setInt('rating', info.data['rating']);
            await sharedPreferences.setString('rank', info.data['rank']);
          });
        } else {
          Fluttertoast.showToast(
              msg: val.data['msg'].toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        this.setState(() {
          pictureUploading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //getUserCresentials();
    return SafeArea(
        child: Scaffold(
            body: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment
                                    .bottomCenter, // 10% of the width, so there are ten blinds.
                                colors: <Color>[
                                  primary_Color.withOpacity(0.9),
                                  primary_Color.withOpacity(0.9)
                                ], // red to yellow
                                tileMode: TileMode
                                    .repeated, // repeats the gradient over the canvas
                              ),
                            ),
                            padding: EdgeInsets.all(10),
                            //color: primary_Color.withOpacity(0.9),
                            //height: MediaQuery.of(context).size.height / 3.3,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder(
                                  future: getUserCred(choice: 3),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null &&
                                        snapshot.data != '') {
                                      return Padding(
                                          padding: EdgeInsets.only(top: 30),
                                          child: Container(
                                              height: 100,
                                              width: 100,
                                              child: Stack(children: [
                                                Container(
                                                    width: 100,
                                                    height: 100,
                                                    child: pictureUploading
                                                        ? CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            radius: 50,
                                                            child:
                                                                CircularProgressIndicator())
                                                        : CircleAvatar(
                                                            radius: 50,
                                                            backgroundColor:
                                                                Colors.white,
                                                            backgroundImage:
                                                                NetworkImage(
                                                              snapshot.data,
                                                            ),
                                                          )),
                                                FutureBuilder(
                                                    future:
                                                        getUserCred(choice: 4),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<dynamic>
                                                            snapshot) {
                                                      if (snapshot.hasData) {
                                                        if (snapshot.data ==
                                                            true)
                                                          return Align(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: GestureDetector(
                                                                onTap: () {
                                                                  _showPicker(
                                                                      context);
                                                                },
                                                                child: CircleAvatar(
                                                                    backgroundColor: Colors.blue.withOpacity(1),
                                                                    radius: 13,
                                                                    child: Icon(
                                                                      Icons
                                                                          .edit,
                                                                      size: 13,
                                                                      color: Colors
                                                                          .white,
                                                                    ))),
                                                          );
                                                        else
                                                          return Container();
                                                      } else
                                                        return Container();
                                                    }),
                                              ])));
                                    } else {
                                      return Padding(
                                          padding: EdgeInsets.only(top: 30),
                                          child: Container(
                                              height: 100,
                                              width: 100,
                                              child: Stack(children: [
                                                Container(
                                                    width: 100,
                                                    height: 100,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.white,
                                                      radius: 50,
                                                      child: pictureUploading
                                                          ? CircularProgressIndicator()
                                                          : SvgPicture.asset(
                                                              'assets/images/farmer-avatar.svg',
                                                              height: 100,
                                                              width: 100),
                                                    )),
                                                FutureBuilder(
                                                    future:
                                                        getUserCred(choice: 4),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<dynamic>
                                                            snapshot) {
                                                      if (snapshot.hasData) {
                                                        if (snapshot.data ==
                                                            true)
                                                          return Align(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: GestureDetector(
                                                                onTap: () {
                                                                  _showPicker(
                                                                      context);
                                                                },
                                                                child: CircleAvatar(
                                                                    backgroundColor: Colors.blue.withOpacity(1),
                                                                    radius: 13,
                                                                    child: Icon(
                                                                      Icons
                                                                          .edit,
                                                                      size: 13,
                                                                      color: Colors
                                                                          .white,
                                                                    ))),
                                                          );
                                                        else
                                                          return Container();
                                                      } else
                                                        return Container();
                                                    })
                                              ])));
                                    }
                                  },
                                ),
                                SizedBox(height: 20),
                                FutureBuilder(
                                  future: getUserCred(choice: 1),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                          /*auth.a.isLoggedIn
                              ? auth.a.userProfile[auth.E.username.index]
                              : 'Anonymous',*/
                                          snapshot.data,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                              color: Colors.white));
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                ),
                                SizedBox(height: 5),
                                FutureBuilder(
                                  future: getUserCred(choice: 2),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                          /*auth.a.isLoggedIn
                              ? auth.a.userProfile[auth.E.username.index]
                              : 'Anonymous',*/
                                          snapshot.data,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Colors.white));
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                ),
                                SizedBox(height: 10)
                              ],
                            )),
                      ),

                      // Divider(
                      //   color: Colors.grey[700],
                      //   height: MediaQuery.of(context).size.height / 25,
                      // ),
                      Flexible(
                        flex: 3,
                        child: ListView(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                                child: Text(
                                  'My Data',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                            Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              child: NoteHome(),
                                            ));
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 1, //Colors.blue[300],
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: FaIcon(
                                                FontAwesomeIcons.book,
                                                color: Colors.blueGrey,
                                                size: 18,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 30,
                                                  top: 15,
                                                  bottom: 15),
                                              child: Text("Notes",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              child: TodoListScreen(),
                                            ));
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: FaIcon(
                                                FontAwesomeIcons.solidListAlt,
                                                color: Colors.blueGrey,
                                                size: 18,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 30,
                                                  top: 15,
                                                  bottom: 15),
                                              child: Text("To do",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                                child: Text(
                                  'General',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                            Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Column(children: [
                                  GestureDetector(
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              child: CompleteProfileScreen(
                                                  name, email, url)));
                                    },
                                    child: Card(
                                      color: Colors.white,
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(left: 20),
                                            child: FaIcon(
                                              FontAwesomeIcons.solidIdBadge,
                                              color: Colors.blueGrey,
                                              size: 20,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 30, top: 15, bottom: 15),
                                            child: Text("Fruit Doctor Profile",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ])),
                          ],
                        ),
                      ),
                    ]))));
  }
}
