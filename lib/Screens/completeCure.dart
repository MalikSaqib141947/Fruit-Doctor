import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CompleteCureScreen extends StatefulWidget {
  static const String id = "CompleteProfileScreen";
  var diseaseData;

  CompleteCureScreen(this.diseaseData);
  @override
  _CompleteCureScreenState createState() =>
      _CompleteCureScreenState(diseaseData);
}

class _CompleteCureScreenState extends State<CompleteCureScreen> {
  var diseaseData;

  Color lightgrey = Color(0xffEAEAEA);
  _CompleteCureScreenState(this.diseaseData);

  @override
  Widget build(BuildContext context) {
    // YoutubePlayerController _controller = YoutubePlayerController(
    //   initialVideoId: YoutubePlayer.convertUrlToId(diseaseData['youtube']),
    //   flags: YoutubePlayerFlags(
    //     autoPlay: true,
    //     mute: true,
    //   ),
    // );
    return Scaffold(
        backgroundColor: lightgrey,
        appBar: AppBar(
          title: Text("Cures"),
          centerTitle: true,
          backgroundColor: appbar_Color,
        ),
        body: Container(
            padding: EdgeInsets.all(5),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: [
                ///\
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: Colors.white,
                    child: Container(
                        padding: EdgeInsets.all(10),
                        width: (MediaQuery.of(context).size.width),
                        //height: MediaQuery.of(context).size.height / 3,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  height: 200,
                                  width: (MediaQuery.of(context).size.width),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5)),
                                    child: FittedBox(
                                      child: diseaseData['picture'] != ''
                                          ? Image.network(
                                              diseaseData['picture'])
                                          : Image.asset(
                                              'assets/images/apple.jpg'),
                                      fit: BoxFit.fill,
                                    ),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                diseaseData['name'],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ]))),

                ///

                SizedBox(
                  height: 5,
                ),
                Card(
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.bug,
                              color: Colors.brown,
                              size: 30,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Causing Pest/Virus",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              diseaseData['pest'],
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ))),
                SizedBox(
                  height: 5,
                ),
                Card(
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Icon(
                              Icons.medical_services_rounded,
                              color: Colors.redAccent,
                              size: 36,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Chemical Precautions",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            for (var i in diseaseData['chemical'])
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    i['Description'],
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Chemicals',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    i['chemicals'].toString(),
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                          ],
                        ))),

                SizedBox(
                  height: 5,
                ),
                Card(
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(children: [
                          Icon(
                            FontAwesomeIcons.sun,
                            color: Colors.orangeAccent,
                            size: 40,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Biological Precautions",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          for (var i in diseaseData['biological'])
                            Text(
                              i['Description'],
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: 12),
                            ),
                        ]))),
                // YoutubePlayer(
                //   controller: _controller,
                //   liveUIColor: Colors.amber,
                // )
              ],
            )));
  }
}
