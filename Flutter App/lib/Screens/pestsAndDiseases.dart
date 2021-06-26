import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_doctor/Screens/bottomnav.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:flutter_doctor/utilities/auth.dart' as auth;
import 'package:flutter_doctor/Provider/home_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_doctor/Screens/community.dart';
import 'package:intl/intl.dart';
import 'package:flutter_doctor/Services/tododb.dart';
import 'package:flutter_doctor/Model/task_model.dart';
import 'package:flutter_doctor/Screens/completeCure.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PestsAndDiseasesScreen extends StatefulWidget {
  static const String id = "CompleteProfileScreen";
  List<String> diseases;
  String fruit;
  PestsAndDiseasesScreen(this.fruit, this.diseases);
  @override
  _PestsAndDiseasesScreenState createState() =>
      _PestsAndDiseasesScreenState(fruit, diseases);
}

class _PestsAndDiseasesScreenState extends State<PestsAndDiseasesScreen> {
  List<String> diseases;
  String fruit;
  Color lightgrey = Color(0xffEAEAEA);
  _PestsAndDiseasesScreenState(this.fruit, this.diseases);

  List<int> indicesOfDetectedDiseases;
  @override
  void initState() {
    // TODO: implement initState
    if (fruit == "citrus") fruit = "orange";
  }

  getCure(fruit, disease) async {
    var data = null;

    await auth.a.getCure(fruit, disease).then((val) {
      if (val.data['success']) {
        data = val.data['data'];
      }
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightgrey,
        appBar: AppBar(
          title: Text(fruit + " Diseases"),
          centerTitle: true,
          backgroundColor: appbar_Color,
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: [
                for (var i in diseases)
                  FutureBuilder(
                      future: getCure(fruit, i),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Disease(context, snapshot.data);
                        } else {
                          return Text('Loading...');
                        }
                      }),
                GestureDetector(
                    onTap: () {
                      HomeProvider.setSelected(1);
                      Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: BottomNavigation(),
                          ));
                    },
                    child: Container(
                        padding: EdgeInsets.all(15),
                        child: Card(
                            color: Colors.blueGrey.withOpacity(1),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.commentAlt,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  Container(
                                      width: 210,
                                      child: Column(
                                        children: [
                                          Text(
                                            'None of the results above matches the damage on your fruit?',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Click here to ask the community for help!',
                                            textAlign: TextAlign.start,
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      )),
                                  Icon(
                                    FontAwesomeIcons.chevronRight,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ))))
              ],
            )));
  }
}

Widget Disease(context, diseaseInfo) {
  Color color = Colors.white;
  return Container(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: CompleteCureScreen(diseaseInfo),
                    ));
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 200,
                                width: (MediaQuery.of(context).size.width),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5)),
                                  child: FittedBox(
                                    child: diseaseInfo['picture'] != ''
                                        ? Image.network(diseaseInfo['picture'])
                                        : Image.asset(
                                            'assets/images/apple.jpg'),
                                    fit: BoxFit.fill,
                                  ),
                                )),
                            Container(
                                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        // Text(
                                        //   "Disease Name: ",
                                        //   style: TextStyle(
                                        //       fontSize: 15,
                                        //       fontWeight: FontWeight.bold),
                                        // ),
                                        Text(
                                          diseaseInfo['name'].toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Also known as: ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.italic),
                                        ),
                                        Text(
                                          diseaseInfo['genericName'].toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('Symptoms: ',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(diseaseInfo['symptoms'].toString(),
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ButtonTheme(
                                            buttonColor: secondary_Color,
                                            minWidth: 100,
                                            height: 40,
                                            child: RaisedButton(
                                                child: Row(children: [
                                                  Text(
                                                    'Show More',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  Icon(
                                                    FontAwesomeIcons
                                                        .chevronRight,
                                                    color: Colors.white,
                                                    size: 16,
                                                  )
                                                ]),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        type: PageTransitionType
                                                            .rightToLeft,
                                                        child:
                                                            CompleteCureScreen(
                                                                diseaseInfo),
                                                      ));
                                                }))
                                      ],
                                    )
                                  ],
                                ))
                          ]))))));
}
