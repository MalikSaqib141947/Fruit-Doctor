import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_doctor/Model/international_model.dart';
import 'package:flutter_doctor/Model/scraped_model.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:http/http.dart';
import 'package:flutter_doctor/Screens/scraperDetail.dart';

class ScraperScreen extends StatefulWidget {
  static const String id = 'scraper';

  @override
  _ScraperScreenState createState() => _ScraperScreenState();
}

class _ScraperScreenState extends State<ScraperScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primary_Color,
          bottom: TabBar(
            tabs: [
              Tab(child: Text("World")),
              Tab(child: Text("Pakistan")),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                child: FutureBuilder(
                  future: getJsonInternational(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                          height: 100,
                          width: 100,
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.green[900],
                          ));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ScrapperDtails(
                                            url: snapshot.data[index].link)));
                              },
                              child: Container(
                                child: Card(
                                  elevation: 10,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Image(
                                            image: NetworkImage(
                                                snapshot.data[index].img),
                                          ),
                                        ),
                                      )),
                                      Padding(
                                        padding: EdgeInsets.all(7),
                                        child: Text(
                                          snapshot.data[index].heading,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(7),
                                        child: Text(
                                          snapshot.data[index].intro,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        },
                      );
                    }
                    // return Center(
                    //   child: Text(snapshot.data.toString()),
                    // );
                  },
                ),
              ),
            ),
            Container(
              child: FutureBuilder(
                future: getJson(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                        height: 100,
                        width: 100,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.green[900],
                        ));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ScrapperDtails(
                                          url: snapshot.data[index].link)));
                            },
                            child: Container(
                              child: Card(
                                elevation: 10,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(7),
                                      child: Text(
                                        snapshot.data[index].heading,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        snapshot.data[index].intro,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      },
                    );
                  }
                  // return Center(
                  //   child: Text(snapshot.data.toString()),
                  // );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getData() async {
    String url =
        'https://fruit-doctor-python-server.herokuapp.com/get_json_file';
    Response response = await get(url);
    return response.body;
  }

  Future getJson() async {
    var data = await getData();
    var decodedData = jsonDecode(data);

    ScrapeModel scrapeModel = ScrapeModel.fromJson(decodedData);
    return scrapeModel.data;
  }

  Future getDataInternational() async {
    String url =
        'https://fruit-doctor-python-server.herokuapp.com/get_json_file_international';
    Response response = await get(url);
    return response.body;
  }

  Future getJsonInternational() async {
    var data = await getDataInternational();
    var decodedData = jsonDecode(data);

    InternationalNewsModel internationalModel =
        InternationalNewsModel.fromJson(decodedData);
    return internationalModel.data;
  }
}
