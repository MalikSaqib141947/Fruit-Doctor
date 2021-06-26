//import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_doctor/Model/note.dart';
import 'package:flutter_doctor/Provider/home_provider.dart';
import 'package:flutter_doctor/Screens/completeProfile.dart';
import 'package:flutter_doctor/Screens/scraper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_doctor/Screens/home.dart';
import 'package:flutter_doctor/Screens/profile.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_doctor/Screens/todoist.dart';
import 'package:provider/provider.dart';
import 'package:flutter_doctor/Screens/todo_list_screen.dart';
import 'package:flutter_doctor/Screens/welcome.dart';
import 'package:flutter_doctor/utilities/auth.dart' as auth;
import 'note_home.dart';
import 'package:page_transition/page_transition.dart';

class BottomNavigation extends StatefulWidget {
  Map up;
  static const String id = 'BottomNavigation';

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  static int _selectedPage = 0;
  String name;
  String email;
  String picUrl;
  int rating;
  String rank;
  bool loggingOut = false;

  final _pageOption = [
    Home(),
    Text(
      "Community",
      style: TextStyle(fontSize: 20),
    ),
    ScraperScreen(),
    Profile()
  ];

  getCredentials() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    this.setState(() {
      name = sharedPref.get('name');
      email = sharedPref.get('email');
      picUrl = sharedPref.get('url');
    });

    return 'data';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Fruit Doctor'),
            centerTitle: true,
            backgroundColor: Color(0xff27AE5A),
          ),
          drawer: Drawer(
            child: ListView(padding: EdgeInsets.all(0.0), children: <Widget>[
              FutureBuilder(
                future: getCredentials(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return UserAccountsDrawerHeader(
                      decoration: BoxDecoration(color: primary_Color),
                      currentAccountPicture: (picUrl != null && picUrl != '')
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(picUrl))
                          : SvgPicture.asset('assets/images/farmer-avatar.svg'),
                      accountName: Text(name),
                      accountEmail: Text(email),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              ListTile(
                title: Text('Notes'),
                leading: Icon(
                  FontAwesomeIcons.book,
                  size: 20,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: NoteHome(),
                      ));
                },
              ),
              ListTile(
                title: Text('To do'),
                leading: Icon(FontAwesomeIcons.thList, size: 20),
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: TodoListScreen(),
                      ));
                },
              ),
              Divider(),
              ListTile(
                title: Text('Fruit Doctor Profile'),
                leading: Icon(
                  FontAwesomeIcons.solidIdBadge,
                  size: 20,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: CompleteProfileScreen(name, email, picUrl),
                      ));
                },
              ),
              Divider(),
              ListTile(
                title: loggingOut ? Text("Logging out...") : Text('Logout'),
                leading: Icon(
                  FontAwesomeIcons.signOutAlt,
                  size: 20,
                ),
                onTap: () async {
                  this.setState(() {
                    loggingOut = true;
                  });

                  await auth.a.logout(context).then((val) {
                    this.setState(() {
                      loggingOut = false;
                    });
                    Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: Welcome(),
                        ));
                  });
                },
              ),
            ]),
          ),
          body: Consumer<HomeProvider>(
            builder: (_, value, child) {
              return value.widget;
            },
          ),
          bottomNavigationBar: Consumer<HomeProvider>(
            builder: (context, value, child) {
              return BottomNavigationBar(
                selectedItemColor: primary_Color,
                unselectedItemColor: Colors.blueGrey,
                currentIndex: value.selectedPage,
                onTap: (int index) {
                  this.setState(() {
                    _selectedPage = index;
                  });
                  context.read<HomeProvider>().setPage(_selectedPage);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.appleAlt,
                    ),
                    title: Text('Your Fruits', style: TextStyle(fontSize: 12)),
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.commentAlt),
                    title: Text("Community", style: TextStyle(fontSize: 12)),
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.globeAmericas),
                    title: Text("News", style: TextStyle(fontSize: 12)),
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.userCircle),
                    title: Text(
                      "You",
                      style: TextStyle(fontSize: 12),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
