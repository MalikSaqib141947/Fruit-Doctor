import 'package:flutter/material.dart';
import 'package:flutter_doctor/Provider/get_User_auth.dart';
import 'package:flutter_doctor/Screens/login.dart';
import 'package:flutter_doctor/Screens/welcome.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_doctor/Screens/loader.dart';
import 'bottomnav.dart';
import 'package:page_transition/page_transition.dart';

class LoginChecker extends StatefulWidget {
  static const String id = "LoginChecker";
  @override
  _LoginCheckerState createState() => _LoginCheckerState();
}

@override
class _LoginCheckerState extends State<LoginChecker> {
  bool isLoading = false;
  void goToIntialScreen() async {
    SharedPreferences sharedpref = await SharedPreferences.getInstance();

    bool logedin = await sharedpref.getBool("loggedin");
    if (logedin == null || logedin == false) {
      // this.setState(() {
      //   isLoading = false;
      // });
      Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: Welcome(),
          ));
    } else {
      // this.setState(() {
      //   isLoading = false;
      // });

      Navigator.of(context).pushReplacement(PageTransition(
        type: PageTransitionType.rightToLeft,
        child: BottomNavigation(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    this.setState(() {
      isLoading = true;
      goToIntialScreen();
    });
    return isLoading ? Loader() : Scaffold();
  }
}
