import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doctor/Screens/calculate_fertilizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:select_dialog/select_dialog.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:file/file.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:flutter_doctor/Screens/community.dart' as community;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_doctor/utilities/forum.dart' as forum;

class Replies extends StatefulWidget {
  static const String id = 'Replies';
  community.Query query;
  var likes;
  Replies(this.query, this.likes);
  @override
  _RepliesState createState() => _RepliesState(this.query, this.likes);
}

class _RepliesState extends State<Replies> {
  community.Query query;

  String replyText = '';
  SharedPreferences sharedPref;
  var email;
  var likes;
  bool postingReply = false;
  String currentUserPicture;
  String currentUserEmail;
  String currentUserToken;
  String currentQueryId;
  bool gotReplies = false;

  _RepliesState(this.query, this.likes);

  Color lightgrey = Color(0xffEAEAEA);
  Color darkgrey = Color(0xffa9a9a9);
  FocusNode _focusNode = new FocusNode();

  getPicture() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    currentUserToken = await sharedPreferences.get('token');
    currentUserPicture = await sharedPreferences.get('url');
    currentUserEmail = await sharedPreferences.get('email');

    return currentUserPicture;
  }

  final _controller = ScrollController();

  Future<List<community.Reply>> fetchReplies(queryId) async {
    List<community.Reply> repliesList = [];
    if (!gotReplies) {
      // this.setState(() {
      //   gotReplies = true;
      // });
      await forum.getReplies(queryId).then((repliesArray) {
        print(repliesArray.toString());
        var jsonData = jsonDecode(repliesArray.body);

        for (var v in jsonData) {
          List<community.User> replyLikers = [];
          //adding user credentials for each reply
          community.User user2 = community.User(
              v['author']['_id'],
              v['author']['name'],
              v['author']['email'],
              v['author']['pictureUrl'],
              v['author']['rating'],
              v['author']['rank']);
          var jsonData4 = v['likers'];
          for (var w in jsonData4) {
            community.User user = community.User(w['_id'], w['name'],
                w['email'], w['pictureUrl'], w['rating'], w['rank']);
            replyLikers.add(user);
          }
          community.Reply reply = community.Reply(v['_id'], v['replyText'],
              v['ratings'], user2, v['postDate'], replyLikers);

          repliesList.add(reply);
        }
      });
    }
    setState(() {
      query.replies = repliesList;
    });
    return repliesList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchReplies(query.id);
  }

  var _replyController = TextEditingController();

  final _replyKey = GlobalKey<FormState>();

  _showUserModal(context, community.User author) {
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

  contentBox(context, community.User author) {
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

  @override
  Widget build(BuildContext context) {
    // Timer(
    //   Duration(seconds: 1),
    //   () => _controller.jumpTo(_controller.position.maxScrollExtent),
    // );
    //footer: MyFooterWidget(context),
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: true,
      backgroundColor: lightgrey,
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              physics: ScrollPhysics(),
              //reverse: true,
              // child: Container(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Stack(children: [
                    Column(
                      children: [
                        Flexible(
                            flex: 3,
                            child: Container(
                              width: double.infinity,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                color: Colors.white,
                                child: Container(
                                  width: (MediaQuery.of(context).size.width),
                                  //height: MediaQuery.of(context).size.height / 3,
                                  child: Column(
                                    children: [
                                      Container(
                                          height: 200,
                                          width: (MediaQuery.of(context)
                                              .size
                                              .width),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5)),
                                            child: FittedBox(
                                              child:
                                                  Image.network(query.imageURL),
                                              fit: BoxFit.fill,
                                            ),
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                      height: 40,
                                                      width: 40,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        child: FittedBox(
                                                          child: Image.network(
                                                              query.author
                                                                  .pictureUrl),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                          width: 300,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                query.author
                                                                    .name,
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      primary_Color,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                          width: 300,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                forum.timeAgo(query
                                                                    .postDate),
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      darkgrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Image.asset(
                                                                'assets/images/home/' +
                                                                    query
                                                                        .relatedFruit +
                                                                    '.png',
                                                                height: 15,
                                                                width: 15,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                query
                                                                    .relatedFruit,
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      darkgrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 50,
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
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Divider(color: lightgrey),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    likes.toString() +
                                                        " People Like this Post",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                        Flexible(
                            flex: 3,
                            child: Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: ListView(
                                  physics: BouncingScrollPhysics(),
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: ListView(
                                        controller: _controller,
                                        physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        children: [
                                          for (community.Reply i
                                              in query.replies)
                                            Reply(
                                                i, currentUserEmail, query.id),
                                          SizedBox(
                                            height: 80,
                                          )
                                        ],
                                      ),
                                    ),
                                    // child: FutureBuilder(
                                    //   future: fetchReplies(query.id),
                                    //   builder: (BuildContext context,
                                    //       AsyncSnapshot<dynamic> snapshot) {
                                    //     if (snapshot.hasData) {
                                    //       return ListView.builder(
                                    //           physics: NeverScrollableScrollPhysics(),
                                    //           shrinkWrap: true,
                                    //           //scrollDirection: Axis.vertical,
                                    //           itemCount: snapshot.data.length,
                                    //           itemBuilder: (context, index) {
                                    //             return Reply(snapshot.data[
                                    //                 snapshot.data.length -
                                    //                     index -
                                    //                     1]);
                                    //           });
                                    //     } else {
                                    //       return Center(
                                    //           child: Column(children: [
                                    //         SizedBox(
                                    //           height: 10,
                                    //         ),
                                    //         SizedBox(
                                    //             width: 30,
                                    //             height: 30,
                                    //             child: CircularProgressIndicator(
                                    //               backgroundColor: appbar_Color,
                                    //               strokeWidth: 4,
                                    //             )),
                                    //         SizedBox(
                                    //           height: 10,
                                    //         )
                                    //       ]));
                                    //     }
                                    //   },
                                    // ),

                                    // Reply('reply'),

                                    //Positioned(bottom: 0.0, child: ),
                                  ],
                                ))),
                      ],
                    ),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    Positioned.fill(
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                height: MediaQuery.of(context).size.height,
                                alignment: Alignment.bottomCenter,
                                child: Card(
                                    //padding: EdgeInsets.only(left: 20),
                                    color: Colors.white,
                                    //width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: Row(
                                          children: [
                                            Container(
                                                height: 40,
                                                width: 40,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: FutureBuilder(
                                                        future: getPicture(),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            return FittedBox(
                                                              child:
                                                                  Image.network(
                                                                      snapshot
                                                                          .data),
                                                              fit: BoxFit.fill,
                                                            );
                                                          } else {
                                                            return Container();
                                                          }
                                                        }))),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                                child: TextFormField(
                                              controller: _replyController,
                                              key: _replyKey,
                                              validator: Validators.compose([
                                                Validators.required(
                                                    'Reply cant be empty!'),
                                              ]),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Karla',
                                              ),
                                              decoration: InputDecoration(
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                primary_Color,
                                                            width: 1.0)),
                                                hintText: 'Write your reply...',
                                                hintStyle: TextStyle(
                                                  color: Color(0xff2e3039),
                                                ),
                                              ),
                                              onChanged: (value) => {
                                                this.setState(() {
                                                  replyText = value;
                                                }),
                                              },
                                            )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                              child: postingReply
                                                  ? SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                        backgroundColor:
                                                            appbar_Color,
                                                        strokeWidth: 3,
                                                      ))
                                                  : Icon(
                                                      Icons.send,
                                                      color: primary_Color,
                                                      size: 30,
                                                    ),
                                              onTap: () async => {
                                                sharedPref =
                                                    await SharedPreferences
                                                        .getInstance(),
                                                email = sharedPref.get('email'),
                                                this.setState(() {
                                                  postingReply = true;
                                                }),
                                                if (replyText != '')
                                                  {
                                                    forum
                                                        .postReply(query.id,
                                                            replyText, email)
                                                        .then((val) async {
                                                      this.setState(() {
                                                        postingReply = false;
                                                        replyText = '';
                                                      });
                                                      if (val.data['success']) {
                                                        _replyController
                                                            .clear();
                                                        fetchReplies(query.id);
                                                        _controller.animateTo(
                                                          _controller.position
                                                              .minScrollExtent,
                                                          duration: Duration(
                                                              seconds: 1),
                                                          curve: Curves
                                                              .fastOutSlowIn,
                                                        );
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            .unfocus();
                                                        Fluttertoast.showToast(
                                                            msg: 'Reply Posted',
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            backgroundColor:
                                                                Colors.green,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0);
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg: "Reply Failed",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            backgroundColor:
                                                                Colors.green,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0);
                                                      }
                                                    })
                                                  }
                                              },
                                            )
                                          ],
                                        ))))))
                    //   ],
                    // )
                  ])))),
    );
  }

  Widget Reply(community.Reply reply, String email, queryId) {
    int likes = 0;
    bool iLiked = false;
    for (var i in reply.likers) {
      likes += 1;
      if (i.email == email) iLiked = true;
    }
    return Container(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  child: GestureDetector(
                      onTap: () {
                        _showUserModal(context, reply.author);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: FittedBox(
                          child: Image.network(reply.author.pictureUrl),
                          fit: BoxFit.fill,
                        ),
                      ))),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                      width: 300,
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                _showUserModal(context, reply.author);
                              },
                              child: Text(
                                reply.author.name,
                                style: TextStyle(
                                  color: primary_Color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ))
                        ],
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            forum.timeAgo(reply.postDate),
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            width: 100,
                          ),
                        ],
                      ))
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            reply.replyText,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(color: Colors.white),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              GestureDetector(
                  onTap: () async {
                    forum.toggleReplyLike(queryId, reply.id);
                    setState(() {});

                    //fetchReplies(queryId);
                  },
                  child: Icon(
                    Icons.thumb_up,
                    size: iLiked ? 28 : 26,
                    color: iLiked ? Colors.blue : Colors.blueGrey,
                  )),
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
          SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 2,
            color: Colors.white,
          ),
        ],
      ),
    ));
  }
}
