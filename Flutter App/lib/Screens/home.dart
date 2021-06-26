import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_doctor/Screens/calculate_fertilizer.dart';
import 'package:flutter_doctor/Screens/pestsAndDiseases.dart';
import 'package:flutter_doctor/Screens/camera_screen.dart';
import 'package:flutter_doctor/Screens/gallery_screen.dart';
import 'package:flutter_doctor/Screens/todoist.dart';
import 'package:flutter_doctor/Screens/grading.dart';
import 'package:flutter_doctor/Screens/weather.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'grading.dart';
import 'weather.dart';
import 'note_home.dart';

class Home extends StatefulWidget {
  static const String id = 'Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  GlobalKey _bottomNavigationKey = GlobalKey();

  //location code
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;
  TabController _controller;
  int _selectedIndex = 0;
  List<String> _fruits = [
    "apple",
    "banana",
    "strawberry",
    "corn",
    "citrus",
    "papaya"
  ];
  List<String> _diseaseEndpoints = [
    "predictAppleDisease",
    "predictAppleDisease",
    "predictStrawberryDisease",
    "predictCornDisease",
    "predictAppleDisease",
    "predictPapayaDisease"
  ];
  List<Widget> list = [
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 10,
          ),
          Container(
              height: 150,
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  //backgroundImage: AssetImage('assets/images/home/Apple.png'),
                  radius: 30,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/home/Apple.png',
                      height: 35,
                    ),
                  ))),
          // Image(
          //   image: AssetImage('assets/images/home/apple1.png'),
          // ),
          SizedBox(
            width: 10,
          )
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 10,
          ),
          CircleAvatar(
              backgroundColor: Colors.white,
              //backgroundImage: AssetImage('assets/images/home/Apple.png'),
              radius: 30,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/home/Banana.png',
                  height: 35,
                  width: 40,
                ),
              )),
          SizedBox(
            width: 10,
          )
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 10,
          ),
          CircleAvatar(
              backgroundColor: Colors.white,
              //backgroundImage: AssetImage('assets/images/home/Apple.png'),
              radius: 30,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/home/Strawberry.png',
                  height: 35,
                ),
              )),
          SizedBox(
            width: 10,
          )
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 10,
          ),
          CircleAvatar(
              backgroundColor: Colors.white,
              //backgroundImage: AssetImage('assets/images/home/Apple.png'),
              radius: 30,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/home/corn.png',
                  height: 35,
                ),
              )),
          SizedBox(
            width: 10,
          )
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 10,
          ),
          CircleAvatar(
              backgroundColor: Colors.white,
              //backgroundImage: AssetImage('assets/images/home/Apple.png'),
              radius: 30,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/home/Citrus.png',
                  height: 35,
                ),
              )),
          SizedBox(
            width: 10,
          )
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 10,
          ),
          CircleAvatar(
              backgroundColor: Colors.white,
              //backgroundImage: AssetImage('assets/images/home/Apple.png'),
              radius: 30,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/home/Papaya.jpg',
                  height: 35,
                ),
              )),
          SizedBox(
            width: 10,
          )
        ],
      ),
    ),
  ];

  List<Color> colors = [
    Colors.redAccent,
    Color(0xffDEC10F),
    Colors.red,
    appbar_Color,
    Colors.deepOrangeAccent,
    Color(0xff497D2A),
  ];

  Color _selectedTabColor = Colors.redAccent;

  @override
  void initState() {
    super.initState();
    diseases = appleDiseases;
    _getCurrentLocation();
    this.getWeatherInfo();

    // TODO: implement initState
    super.initState();
    // Create TabController for getting the index of current tab
    _controller = TabController(length: list.length, vsync: this);

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
        if (_fruits[_selectedIndex] == 'apple')
          diseases = appleDiseases;
        else if (_fruits[_selectedIndex] == 'citrus')
          diseases = citrusDiseases;
        else if (_fruits[_selectedIndex] == 'banana')
          diseases = bananaDiseases;
        else if (_fruits[_selectedIndex] == 'papaya')
          diseases = papayaDiseases;
        else if (_fruits[_selectedIndex] == 'strawberry')
          diseases = strawberryDiseases;
        else if (_fruits[_selectedIndex] == 'corn') diseases = cornDiseases;
      });

      print("Selected Index: " + _controller.index.toString());
    });
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress = " ${place.subAdministrativeArea}";
      });
    } catch (e) {
      print(e);
    }
  }
  //weather code

  var temp;
  var description;
  var _currentSunset;
  var _currentChanceOfRain;
  bool _showDiseaseDetector = true;
  bool _showQualityGrader = false;
  String weatherIconUrl;
  String fruit1 = "Apple";
  String fruit2 = "Citrus";
  String fruit3 = "Pomegranate";
  String fruit4 = "Water Mellon";

  Future getWeatherInfo() async {
    http.Response response = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?q=Islamabad&units=metric&appid=0437d87a63a252bcfeadc3cb929537f4');
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.weatherIconUrl = "http://openweathermap.org/img/w/" +
          results["weather"][0]["icon"] +
          ".png";
      this._currentSunset = results['sys']['sunset'];
      this._currentChanceOfRain = results['clouds']['all'];
      //this.weatherIcon = IconData(results['weather'][0]['icon']);
    });
  }

  String getClockInUtcPlus5Hours(int timeSinceEpochInSec) {
    final time = DateTime.fromMillisecondsSinceEpoch(timeSinceEpochInSec * 1000,
            isUtc: true)
        .add(const Duration(hours: 5));
    return '${time.hour}:${time.minute}';
  }

  // date code
  static final DateTime now = DateTime.now();
  List months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'JunE',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<String> papayaDiseases = [
    "Anthracnose",
    "Black Spot",
    'Phythophthora',
    "Powdery Mildew",
    "Ring Spot"
  ];
  List<String> cornDiseases = [
    "Grey Leaf Spot",
    "Common Rust",
    "Northern Leaf Blight"
  ];
  List<String> appleDiseases = ["Apple Scab", "Black Rot", "Cedar Apple Rust"];
  List<String> strawberryDiseases = ["Leaf Scrotch"];
  List<String> bananaDiseases = ["Anthracnose", "Black Sigatoka"];
  List<String> citrusDiseases = ["Anthracnose", "Brown Rot", "Citrus Canker"];
  List<String> diseases;
  var current_mon = now.month;
  var date = now.day;
  var time = now.hour;

  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.withOpacity(0.05), //(0xffEAEAEA),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 1,
          ),
          Flexible(
            flex: 1,
            child: SizedBox(
              //height: MediaQuery.of(context).size.height / 4,
              child: DefaultTabController(
                length: list.length,
                child: Column(
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints.expand(height: 60),
                      child: TabBar(
                        controller: _controller,
                        onTap: (index) {
                          this.setState(() {
                            _selectedIndex = index;
                            if (_fruits[_selectedIndex] == 'apple')
                              diseases = appleDiseases;
                            else if (_fruits[_selectedIndex] == 'citrus')
                              diseases = citrusDiseases;
                            else if (_fruits[_selectedIndex] == 'banana')
                              diseases = bananaDiseases;
                            else if (_fruits[_selectedIndex] == 'papaya')
                              diseases = papayaDiseases;
                            else if (_fruits[_selectedIndex] == 'strawberry')
                              diseases = strawberryDiseases;
                            else if (_fruits[_selectedIndex] == 'corn')
                              diseases = cornDiseases;
                          });
                        },
                        indicator: BoxDecoration(
                            color: colors[_selectedIndex].withOpacity(0.8),
                            borderRadius: BorderRadius.only(
                              topRight: _selectedIndex == list.length - 1
                                  ? Radius.circular(0)
                                  : Radius.circular(25),
                              topLeft: _selectedIndex == 0
                                  ? Radius.circular(0)
                                  : Radius.circular(25),
                            )),
                        indicatorColor: primary_Color,
                        isScrollable: true,
                        tabs: list,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: TabBarView(controller: _controller, children: [
                          homeTop(
                              context,
                              colors[0],
                              CalculateFertilizer(
                                fruit: fruit1,
                              ),
                              PestsAndDiseasesScreen(
                                  _fruits[_selectedIndex], diseases)),
                          homeTop(
                              context,
                              colors[1],
                              CalculateFertilizer(
                                fruit: fruit2,
                              ),
                              PestsAndDiseasesScreen(
                                  _fruits[_selectedIndex], diseases)),
                          homeTop(
                              context,
                              colors[2],
                              CalculateFertilizer(
                                fruit: fruit3,
                              ),
                              PestsAndDiseasesScreen(
                                  _fruits[_selectedIndex], diseases)),
                          homeTop(
                              context,
                              colors[3],
                              CalculateFertilizer(
                                fruit: fruit4,
                              ),
                              PestsAndDiseasesScreen(
                                  _fruits[_selectedIndex], diseases)),
                          homeTop(
                              context,
                              colors[4],
                              CalculateFertilizer(
                                fruit: fruit4,
                              ),
                              PestsAndDiseasesScreen(
                                  _fruits[_selectedIndex], diseases)),
                          homeTop(
                              context,
                              colors[5],
                              CalculateFertilizer(
                                fruit: fruit4,
                              ),
                              PestsAndDiseasesScreen(
                                  _fruits[_selectedIndex], diseases)),
                        ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
                // height: ((MediaQuery.of(context).size.height)),
                child: ListView(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 10, 5, 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Card(
                          elevation: 2,
                          child: Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "HEAL YOUR FRUITS",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color:
                                              // _showDiseaseDetector
                                              //     ? primary_Color:
                                              Colors.black,
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() => {
                                                  _showDiseaseDetector =
                                                      !_showDiseaseDetector,
                                                });
                                          },
                                          child: Icon(
                                            _showDiseaseDetector
                                                ? Icons.arrow_drop_up_rounded
                                                : Icons.arrow_drop_down_rounded,
                                            size: 35,
                                            color:
                                                // _showDiseaseDetector
                                                //     ? primary_Color
                                                //     :
                                                Colors.black,
                                          ))
                                    ],
                                  ),
                                ),
                                _showDiseaseDetector
                                    ? Column(
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                7,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.25,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                // Image(
                                                //   image: AssetImage(
                                                //       'assets/images/home/ins.png'),
                                                //   height: MediaQuery.of(context)
                                                //           .size
                                                //           .height /
                                                //       7.5,
                                                //   width: MediaQuery.of(context)
                                                //           .size
                                                //           .width /
                                                //       1.5,
                                                // ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.camera,
                                                      size: 50,
                                                      color: Colors.brown,
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                      'Take a Picture',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .arrow_forward_ios_rounded,
                                                        size: 30,
                                                        color: Colors.grey),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                        FontAwesomeIcons
                                                            .mobileAlt,
                                                        size: 50,
                                                        color: Colors
                                                            .lightBlueAccent),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                      'See Diagnosis',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .arrow_forward_ios_rounded,
                                                        size: 30,
                                                        color: Colors.grey),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .medical_services_outlined,
                                                        size: 50,
                                                        color:
                                                            Colors.redAccent),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                      'Get Medicine',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // ButtonTheme(
                                                //   buttonColor: secondary_Color,
                                                //   minWidth: 100,
                                                //   child: RaisedButton(
                                                //     shape: RoundedRectangleBorder(
                                                //         borderRadius: BorderRadius.circular(15)),
                                                //     onPressed: () async {
                                                //       //Navigator.push(context, MaterialPageRoute());

                                                //       final cameras = await availableCameras();

                                                //       Navigator.push(
                                                //           context,
                                                //           MaterialPageRoute(
                                                //               builder: (context) =>
                                                //                   CameraScreen(cam: cameras[0])));
                                                //     },
                                                //     child: Row(
                                                //       children: <Widget>[
                                                //         Padding(
                                                //           padding: const EdgeInsets.all(5.0),
                                                //           child: Icon(
                                                //             FontAwesomeIcons.camera,
                                                //             color: Colors.white,
                                                //           ),
                                                //         ),
                                                //         SizedBox(
                                                //           width: 10,
                                                //         ),
                                                //         Text(
                                                //           'CAMERA',
                                                //           style: TextStyle(
                                                //               color: Colors.white, fontSize: 16),
                                                //         ),
                                                //       ],
                                                //     ),
                                                //   ),
                                                // ),
                                                // SizedBox(
                                                //   width: 16,
                                                // ),
                                                ButtonTheme(
                                                  buttonColor: primary_Color,
                                                  minWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          1.3,
                                                  child: RaisedButton(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                    onPressed: () async {
                                                      //Navigator.push(context, MaterialPageRoute());

                                                      //final cameras = await availableCameras();

                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => GalleryScreen(
                                                                  _diseaseEndpoints[
                                                                      _selectedIndex],
                                                                  _fruits[
                                                                      _selectedIndex],
                                                                  "Diagnose")));
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Icon(
                                                              FontAwesomeIcons
                                                                  .camera,
                                                              color:
                                                                  Colors.white,
                                                              size: 20),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          'Take a Picture',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ])
                                        ],
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 5.0,
                      // ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Card(
                          elevation: 2,
                          child: Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "GRADE YOUR FRUITS",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color:
                                              // _showQualityGrader
                                              //     ? primary_Color
                                              //     :
                                              Colors.black,
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() => {
                                                  _showQualityGrader =
                                                      !_showQualityGrader
                                                });
                                          },
                                          child: Icon(
                                            _showQualityGrader
                                                ? Icons.arrow_drop_up_rounded
                                                : Icons.arrow_drop_down_rounded,
                                            size: 35,
                                            color:
                                                // _showQualityGrader
                                                //     ? primary_Color
                                                //     :
                                                Colors.black,
                                          ))
                                    ],
                                  ),
                                ),
                                _showQualityGrader
                                    ? Column(
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                7,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image(
                                                      image: AssetImage(
                                                          'assets/images/home/orange3.jpg'),
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              15,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              5,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text('A')
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image(
                                                      image: AssetImage(
                                                          'assets/images/home/orange2.jpg'),
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              15,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              5,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text('B')
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image(
                                                      image: AssetImage(
                                                          'assets/images/home/orange1.jpg'),
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              15,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              5,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text('C')
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image(
                                                      image: AssetImage(
                                                          'assets/images/home/orange0.jpg'),
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              15,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              5,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text('D')
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // ButtonTheme(
                                                //   buttonColor: secondary_Color,
                                                //   minWidth: 100,
                                                //   child: RaisedButton(
                                                //     shape: RoundedRectangleBorder(
                                                //         borderRadius: BorderRadius.circular(15)),
                                                //     onPressed: () async {
                                                //       //Navigator.push(context, MaterialPageRoute());

                                                //       final cameras = await availableCameras();

                                                //       Navigator.push(
                                                //           context,
                                                //           MaterialPageRoute(
                                                //               builder: (context) =>
                                                //                   CameraScreen(cam: cameras[0])));
                                                //     },
                                                //     child: Row(
                                                //       children: <Widget>[
                                                //         Padding(
                                                //           padding: const EdgeInsets.all(5.0),
                                                //           child: Icon(
                                                //             FontAwesomeIcons.camera,
                                                //             color: Colors.white,
                                                //           ),
                                                //         ),
                                                //         SizedBox(
                                                //           width: 10,
                                                //         ),
                                                //         Text(
                                                //           'CAMERA',
                                                //           style: TextStyle(
                                                //               color: Colors.white, fontSize: 16),
                                                //         ),
                                                //       ],
                                                //     ),
                                                //   ),
                                                // ),
                                                // SizedBox(
                                                //   width: 16,
                                                // ),
                                                ButtonTheme(
                                                  buttonColor: primary_Color,
                                                  minWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          1.3,
                                                  child: RaisedButton(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                    onPressed: () async {
                                                      //Navigator.push(context, MaterialPageRoute());

                                                      //final cameras = await availableCameras();

                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  GalleryScreen(
                                                                      "grading_model",
                                                                      _fruits[
                                                                          _selectedIndex],
                                                                      "Find Grade")));
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Icon(
                                                            FontAwesomeIcons
                                                                .camera,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          'Take a Picture',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ])
                                        ],
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Weather()));
                        },
                        child: Card(
                          elevation: 2,
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                  child: Row(
                                    children: [
                                      Text(
                                        _currentAddress != null &&
                                                _currentPosition != null
                                            ? _currentAddress + ","
                                            : "Loading...",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        months[current_mon - 1].toString() +
                                            " " +
                                            date.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        temp != null
                                            ? temp.toString() + "\u00B0" + "C"
                                            : "Loading...",
                                        style: TextStyle(
                                            fontSize: 36,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Image.network(
                                          weatherIconUrl != null
                                              ? this.weatherIconUrl
                                              : "https://i.pinimg.com/originals/77/0b/80/770b805d5c99c7931366c2e84e88f251.png",
                                          height: 50,
                                          fit: BoxFit.fill
                                          //size: 30,
                                          ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Sunset ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                            color: Colors.blueGrey),
                                      ),
                                      Text(
                                        _currentSunset != null
                                            ? getClockInUtcPlus5Hours(
                                                _currentSunset)
                                            : "Loading...",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                            color: Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.blueGrey,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 5, 5),
                                      child: Text(
                                        description != null
                                            ? description.toString()
                                            : "Loading",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 10, 10),
                                        child: Row(children: [
                                          Icon(FontAwesomeIcons.cloudRain,
                                              size: 16, color: Colors.blueGrey),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(this._currentChanceOfRain != null
                                              ? _currentChanceOfRain
                                                      .toString() +
                                                  '%'
                                              : '20%')
                                        ])),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
          ),

          // Container(
          //   constraints: BoxConstraints.expand(height: 50),
          //   child: TabBar(
          //     indicatorColor: primary_Color,
          //     isScrollable: true,
          //     tabs: [
          //       Tab(
          //         child: Row(children: [
          //           Text(
          //               "HEAL",
          //               style: TextStyle(
          //                   fontSize: 16, fontWeight: FontWeight.w900),
          //             ),
          //         ],),
          //       ),
          //       Tab(
          //         child: Row(
          //           children: [
          //             Text(
          //               "GRADE",
          //               style: TextStyle(
          //                   fontSize: 16, fontWeight: FontWeight.w900),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],

          //   ),

          // ),
          // Expanded(child:),
        ],
      ),
    );
  }

  Widget homeTop(context, Color color, route1, route2) {
    color = color.withOpacity(0.8);
    return Container(
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => route1));
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Container(
                      width: (MediaQuery.of(context).size.width / 3) + 30,
                      height: MediaQuery.of(context).size.height / 8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: color,
                                child: Icon(
                                  FontAwesomeIcons.calculator,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Calculate Fertilizer",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => route2));
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Container(
                      width: (MediaQuery.of(context).size.width / 3) + 30,
                      height: MediaQuery.of(context).size.height / 8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: color,
                                child: Icon(
                                  FontAwesomeIcons.bug,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Pests and Diseases ",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
