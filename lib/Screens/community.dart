import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doctor/Screens/query_and_replies.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_doctor/Screens/loader.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:select_dialog/select_dialog.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file/file.dart';

import 'package:image_picker/image_picker.dart';

import 'package:flutter_doctor/utilities/forum.dart' as forum;

import 'package:flutter_doctor/utilities/auth.dart' as auth;

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' as io;

class User {
  String id;
  String name;
  String email;
  String pictureUrl;
  int rating;
  String rank;

  User(this.id, this.name, this.email, this.pictureUrl, this.rating, this.rank);
}

class Reply {
  String id;
  String replyText;
  int rating;
  User author;
  String postDate;
  List<User> likers;

  Reply(this.id, this.replyText, this.rating, this.author, this.postDate,
      this.likers);
}

class Query {
  String id;
  String imageURL;
  User author;
  String authorImage;
  String postDate;
  String relatedFruit;
  String subject;
  String query;
  List<Reply> replies;
  List<User> likers;

  Query(this.id, this.imageURL, this.author, this.authorImage, this.postDate,
      this.relatedFruit, this.subject, this.query, this.replies, this.likers);
}

class Community extends StatefulWidget {
  static const String id = 'Community';
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  bool queriesLoading = true;
  var queries;
  var totalQueries = 0;
  bool postingQuery = false;
  String currentUserEmail;

  _CommunityState() {
    initState() async {}
  }

  Future<List<Query>> fetchQueries() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    currentUserEmail = sharedPref.get('email');
    List<Query> queriesList = [];

    await forum.getQueries().then((queryArray) {
      print(queryArray);
      var jsonData = jsonDecode(queryArray.body);

      for (var u in jsonData) {
        List<Reply> replies = [];
        List<User> likers = [];
        //Adding the user credentials who uploaded the post
        User user = User(
            u['author']['_id'],
            u['author']['name'],
            u['author']['email'],
            u['author']['pictureUrl'],
            u['author']['rating'],
            u['author']['rank']);

        //adding replies in each post
        var jsonData2 = u['replies'];
        for (var v in jsonData2) {
          List<User> replyLikers = [];
          //adding user credentials for each reply
          User user2 = User(
              v['author']['_id'],
              v['author']['name'],
              v['author']['email'],
              v['author']['pictureUrl'],
              v['author']['rating'],
              v['author']['rank']);
          var jsonData4 = v['likers'];
          for (var w in jsonData4) {
            User user = User(w['_id'], w['name'], w['email'], w['pictureUrl'],
                w['rating'], w['rank']);
            replyLikers.add(user);
          }

          Reply reply = Reply(v['_id'], v['replyText'], v['ratings'], user2,
              v['postDate'], replyLikers);

          replies.add(reply);
        }
        var jsonData3 = u['likers'];
        for (var w in jsonData3) {
          User user = User(w['_id'], w['name'], w['email'], w['pictureUrl'],
              w['rating'], w['rank']);
          likers.add(user);
        }

        Query query = Query(
            u['_id'],
            u['imageURL'],
            user,
            u['imageURL'],
            u['postDate'],
            u['relatedFruit'],
            u['subject'],
            u['query'],
            replies,
            likers);

        bool matchesFilter = false;
        bool filterSelected = false;
        if (selectedFilterTags.length != 1) {
          filterSelected = true;
          for (var i in selectedFilterTags) {
            if (i != "Popular" && i == query.relatedFruit) {
              matchesFilter = true;
            }
          }
        }

        if ((filterSelected && matchesFilter) || !filterSelected) {
          queriesList.add(query);
        }
      }
      queriesLoading = false;
      totalQueries = queriesList.length;
      print(totalQueries);
    });
    return queriesList;
  }

  Color lightgrey = Color(0xffEAEAEA);
  Color darkgrey = Color(0xffa9a9a9);
  List<String> filterTags = [
    'Apple',
    'Banana',
    'Citrus',
    'corn',
    'Papaya',
    'Strawberry'
  ];
  List<String> selectedFilterTags = ['Popular'];

  Color penColor = Colors.blueGrey;

  List<String> fruits = [
    'Apple',
    'Banana',
    'Citrus',
    'corn',
    'Papaya',
    'Strawberry'
  ];
  String queryFruit = 'Apple';
  final List<Map<String, dynamic>> _items = [
    {'label': 'Apple'},
    {'label': 'Banana'},
    {'label': 'Citrus'},
    {'label': 'corn'},
    {'label': 'Papaya'},
    {'label': 'Strawberry'},
  ];

  String upvoteText = "Upvoted", downvoteText = "Downvoted";

  io.File _image;
  bool picLoading = false;

  _imgFromCamera() async {
    io.File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
      picLoading = false;
    });
  }

  _imgFromGallery() async {
    io.File image = await ImagePicker.pickImage(
            source: ImageSource.gallery, imageQuality: 50)
        .then((image) {
      setState(() {
        _image = image;
        picLoading = false;
      });
    });
  }

  _showUserModal(context, User author) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: contentBox(context, author),
            );
          });
        });
  }

  contentBox(context, User author) {
    return Stack(
      children: <Widget>[
        Container(
          padding:
              EdgeInsets.only(left: 50, top: 30.0 + 10, right: 50, bottom: 20),
          margin: EdgeInsets.only(top: 50),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(author.name,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: primary_Color)),
              SizedBox(
                height: 2,
              ),
              Text(
                author.email,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Icon(FontAwesomeIcons.trophy,
                  size: 60, color: Colors.orangeAccent),
              SizedBox(
                height: 10,
              ),
              Text(
                "  " + author.rank,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                " " + author.rating.toString() + " PTS",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
        Positioned(
          left: 30,
          right: 30,
          top: 0,
          child: Container(
              height: 80,
              width: 80,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 40,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    child: Image.network(
                      author.pictureUrl,
                      height: 80,
                      width: 80,
                    )),
              )),
        ),
      ],
    );
  }

  _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(builder: (context, setState) {
            return SafeArea(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.photo_library),
                        title: new Text('Photo Library'),
                        onTap: () async {
                          await _imgFromGallery();
                          Navigator.of(context).pop();
                        }),
                    new ListTile(
                      leading: new Icon(Icons.photo_camera),
                      title: new Text('Camera'),
                      onTap: () async {
                        await _imgFromCamera();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  String _fruit = '';
  String _subject = '';
  String _query = '';

  final _queryForm = GlobalKey<FormState>();
  final _formFruit = GlobalKey<FormState>();
  final _formSubject = GlobalKey<FormState>();
  final _formQuery = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightgrey,
      body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.filter_list,
                                            color: Colors.blueGrey,
                                            size: 28,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Filter by',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                            child: Icon(
                                              Icons.edit,
                                              color: penColor,
                                              size: 20,
                                            ),
                                            onTap: () => {
                                              SelectDialog.showModal<String>(
                                                context,
                                                label: "Filter Forum",
                                                multipleSelectedValues:
                                                    selectedFilterTags,
                                                items: filterTags,
                                                onMultipleItemsChange:
                                                    (List<String> selected) {
                                                  setState(() {
                                                    selectedFilterTags =
                                                        selected;
                                                    print(selectedFilterTags);
                                                  });
                                                },
                                              )
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  height: 40,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      for (var i in selectedFilterTags)
                                        Tag(i.toString())
                                    ],
                                  ))
                            ],
                          )))),
              FutureBuilder(
                future: fetchQueries(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        //scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Post(
                              context,
                              Colors.white,
                              snapshot.data[snapshot.data.length - index - 1],
                              currentUserEmail);
                        });
                  } else {
                    return Center(
                        child: Column(children: [
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            backgroundColor: appbar_Color,
                            strokeWidth: 4,
                          )),
                      SizedBox(
                        height: 10,
                      )
                    ]));
                  }
                },
              ),
            ],
          )),
      floatingActionButton: postingQuery
          ? SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                backgroundColor: appbar_Color,
                strokeWidth: 6,
              ))
          : FloatingActionButton.extended(
              backgroundColor: appbar_Color,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          scrollable: true,
                          content: Stack(
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Positioned(
                                right: -10.0,
                                top: -10.0,
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: CircleAvatar(
                                    child: Icon(Icons.close),
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ),
                              Form(
                                key: _queryForm,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            5.0, 5.0, 5.0, 0),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.question_answer,
                                              size: 30,
                                              //color: primary_Color //Colors.blue,
                                            ),
                                            Icon(
                                              Icons.people,
                                              size: 60,
                                              //color: primary_Color //Colors.blue,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            )
                                          ],
                                        )),
                                    Text('Upload a Picture',
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                            fontSize: 12)),
                                    SizedBox(height: 5),
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          picLoading = true;
                                        });
                                        await _showPicker(context);
                                        //while (_image == null) {}
                                        setState(() {
                                          _image = _image;
                                        });
                                      },
                                      child: _image != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.file(
                                                _image,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    100,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    200,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  100,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  200,
                                              child: Icon(
                                                Icons.camera_alt,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                    ),

                                    SizedBox(height: 10),
                                    Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: DropdownButton<String>(
                                          key: _formFruit,
                                          //value: '',
                                          hint: new Text(queryFruit),
                                          isExpanded: true,
                                          icon: Icon(Icons.arrow_downward),
                                          iconSize: 24,
                                          elevation: 16,
                                          style:
                                              TextStyle(color: primary_Color),
                                          underline: Container(
                                            height: 2,
                                            color: primary_Color,
                                          ),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              queryFruit = newValue;
                                              _fruit = newValue;
                                            });
                                          },
                                          items: fruits
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        )),
                                    Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: TextFormField(
                                        key: _formSubject,
                                        validator: Validators.required(
                                            'Subject is required'),
                                        initialValue: '',
                                        style: new TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                            fontSize: 14),
                                        decoration: InputDecoration(
                                          hintText: 'Your Question',
                                        ),
                                        onChanged: (value) {
                                          this._subject = value;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: TextFormField(
                                        key: _formQuery,
                                        validator: Validators.required(
                                            'Problem description is required'),
                                        initialValue: '',
                                        style: new TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                            fontSize: 14),
                                        decoration: InputDecoration(
                                          hintText: 'Problem Description',
                                        ),
                                        onChanged: (value) {
                                          this._query = value;
                                        },
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: EdgeInsets.all(8.0),
                                    //   child: TextFormField(
                                    //       initialValue: 'Problem description'),
                                    // ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: RaisedButton(
                                        color: primary_Color,
                                        textColor: Colors.white,
                                        child: Text("Post Query"),
                                        onPressed: () async {
                                          if (_queryForm.currentState
                                              .validate()) {
                                            this.setState(() {
                                              postingQuery = true;
                                              isLoading = true;
                                            });
                                            Navigator.of(context).pop();
                                            SharedPreferences sharedPref =
                                                await SharedPreferences
                                                    .getInstance();
                                            var email = sharedPref.get('email');
                                            if (_image != null)
                                              forum
                                                  .postQuery(_subject, _query,
                                                      email, _fruit, _image)
                                                  .then((val) async {
                                                this.setState(() {
                                                  isLoading = false;
                                                  _image = null;
                                                  postingQuery = false;
                                                });
                                                if (val.data['success']) {
                                                  Fluttertoast.showToast(
                                                      msg: 'Query Posted',
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      backgroundColor:
                                                          Colors.green,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: val.data['msg'],
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      backgroundColor:
                                                          Colors.red,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                }
                                              });
                                            else {
                                              this.setState(() {
                                                isLoading = false;
                                                _image = null;
                                                postingQuery = false;
                                              });
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Please select an image too! and try again",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            }
                                          } else {
                                            var errMsg;
                                            if (!_formSubject.currentState
                                                .validate())
                                              errMsg =
                                                  "Please enter your subject";
                                            else
                                              errMsg =
                                                  "Please describe your query";
                                            Fluttertoast.showToast(
                                                msg: errMsg,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    });
                //   Navigator.push(
                //       context,
                //       CupertinoPageRoute(
                //           builder: (_) => AddTaskSreen(
                //                 updateTaskList: _updateTaskList,
                //               )));
              },
              icon: Icon(Icons.edit),
              label: Text('Ask Community'),
            ),
    );
  }

  ////

  Widget Post(context, Color color, Query query, String email) {
    int likes = 0;
    bool iLiked = false;
    for (var i in query.likers) {
      likes += 1;
      if (i.email == email) iLiked = true;
    }

    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Replies(query, likes)));
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            color: color,
            child: Container(
              width: (MediaQuery.of(context).size.width),
              //height: MediaQuery.of(context).size.height / 3,
              child: Column(
                children: [
                  Container(
                      height: 200,
                      width: (MediaQuery.of(context).size.width),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        child: FittedBox(
                          child: query.imageURL != ''
                              ? Image.network(query.imageURL)
                              : Image.asset('assets/images/apple.jpg'),
                          fit: BoxFit.fill,
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      height: 40,
                                      width: 40,
                                      child: GestureDetector(
                                          onTap: () {
                                            _showUserModal(
                                                context, query.author);
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: FittedBox(
                                              child: query.author.pictureUrl !=
                                                      ''
                                                  ? Image.network(
                                                      query.author.pictureUrl)
                                                  : SvgPicture.asset(
                                                      'assets/images/farmer-avatar.svg',
                                                    ),
                                              fit: BoxFit.fill,
                                            ),
                                          ))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    //mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          alignment: Alignment.topLeft,
                                          width: 300,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                  onTap: () {
                                                    _showUserModal(
                                                        context, query.author);
                                                  },
                                                  child: Text(
                                                    query.author.name,
                                                    style: TextStyle(
                                                      color: primary_Color,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  )),
                                            ],
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                          alignment: Alignment.topLeft,
                                          width: 300,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                forum.timeAgo(query.postDate),
                                                style: TextStyle(
                                                  color: darkgrey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Image(
                                                image: AssetImage(
                                                  'assets/images/home/' +
                                                      query.relatedFruit +
                                                      '.png',
                                                ),
                                                height: 15,
                                                width: 15,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                query.relatedFruit,
                                                style: TextStyle(
                                                  color: darkgrey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                query.subject,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                query.query,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: secondary_Color),
                                    child: Text(
                                      query.replies.length.toString() +
                                          " REPLIES",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(color: lightgrey),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            forum.toggleQueryLike(query.id);
                                            setState(() {
                                              filterTags = filterTags;
                                            });
                                          },
                                          child: Icon(Icons.thumb_up,
                                              size: iLiked ? 28 : 26,
                                              color: iLiked
                                                  ? Colors.blue
                                                  : Colors.blueGrey)),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        likes.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Reply',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Replies(
                                                              query, likes)));
                                            },
                                            child: Icon(
                                              Icons.reply,
                                              color: primary_Color,
                                              size: 40,
                                            ),
                                          )
                                        ],
                                      ),
                                      // SizedBox(
                                      //   height: 5,
                                      // ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ))),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget Tag(text) {
  return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
              color: Color(0xffEAEAEA),
              child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Text(text, style: TextStyle())))));
}
