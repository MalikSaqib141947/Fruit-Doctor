import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:flutter_doctor/utilities/auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_doctor/Services/tododb.dart';
import 'package:flutter_doctor/Model/task_model.dart';
import 'package:flutter_doctor/Screens/add_task_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CompleteProfileScreen extends StatefulWidget {
  static const String id = "CompleteProfileScreen";
  String name;
  String email;
  String pictureUrl;
  CompleteProfileScreen(this.name, this.email, this.pictureUrl);
  @override
  _CompleteProfileScreenState createState() =>
      _CompleteProfileScreenState(name, email, pictureUrl);
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  String name;
  String email;
  String pictureUrl;
  int rating;
  String rank;
  Color lightgrey = Color(0xffEAEAEA);
  _CompleteProfileScreenState(this.name, this.email, this.pictureUrl);

  getRatings({int choice}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var localAccount = await sharedPreferences.get('localAccount');
    var token = await sharedPreferences.get('token');
    if (localAccount) {
      await auth.a.getinfo(token).then((info) async {
        await sharedPreferences.setInt('rating', info.data['rating']);
        rating = info.data['rating'];

        await sharedPreferences.setString('rank', info.data['rank']);
        rank = info.data['rank'];
      });
    }

    if (choice == 1) {
      if (localAccount) {
        return rank;
      } else {
        rank = 'BEGINNER';
        return rank;
      }
      return rank;
    } else if (choice == 2) {
      if (localAccount) {
        return rating;
      } else {
        rating = 0;
        return rating;
      }
      return rating;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightgrey,
        appBar: AppBar(
          title: Text("Profile"),
          centerTitle: true,
          backgroundColor: appbar_Color,
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: [
                Card(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(children: [
                          Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                      width: 100.0,
                                      height: 100.0,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          // boxShadow: [
                                          //   BoxShadow(
                                          //     color:
                                          //         Colors.grey.withOpacity(0.8),
                                          //     spreadRadius: 2,
                                          //     blurRadius: 10,
                                          //     offset: Offset(1,
                                          //         0), // changes position of shadow
                                          //   )
                                          // ],
                                          image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: new NetworkImage(
                                                  pictureUrl)))),
                                ],
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: primary_Color),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            email,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.black54),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ]))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                        child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('Community Rank',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    SizedBox(height: 20),
                                    Image.asset(
                                      'assets/images/rank3.png',
                                      height: 100,
                                      width: 100,
                                    ),
                                    SizedBox(height: 20),
                                    FutureBuilder(
                                        future: getRatings(choice: 1),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<dynamic> snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                                snapshot.data.toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold));
                                          } else
                                            return Text('...',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold));
                                        })
                                  ],
                                ))))),
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Card(
                        child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('Rating',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    SizedBox(height: 20),
                                    Image.asset(
                                      'assets/images/rating.png',
                                      height: 80,
                                      width: 80,
                                    ),
                                    SizedBox(height: 20),
                                    FutureBuilder(
                                        future: getRatings(choice: 2),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                                snapshot.data.toString() +
                                                    ' pts',
                                                style: TextStyle(
                                                    fontSize: 36,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w300));
                                          } else
                                            return Text('...' + ' pts',
                                                style: TextStyle(
                                                    fontSize: 36,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w300));
                                        })
                                  ],
                                )))))
              ],
            )));
  }
}
