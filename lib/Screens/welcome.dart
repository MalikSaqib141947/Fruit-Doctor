import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_doctor/Screens/signup.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:flutter_doctor/utilities/auth.dart' as auth;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_doctor/Screens/login.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:page_transition/page_transition.dart';

class Welcome extends StatefulWidget {
  static const String id = 'Welcome';
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Size socialLogin = MediaQuery.of(context).size;
    Color c = Colors.blue;
    return SafeArea(
        child: Scaffold(
            body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(children: [
                  Column(children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                            'assets/images/Components/upper-left.svg',
                            //color: Color(0xffB6ED96),
                            height: size.height * 0.11),
                        SizedBox(
                          width: 85,
                        ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 50),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'WELCOME',
                                    style: topHeadingStyle,
                                  ),
                                ],
                              ),
                            ]),
                        SizedBox(
                          width: 80,
                        ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 50),
                              RotationAnimatedWidget.tween(
                                duration: Duration(minutes: 3),
                                delay: Duration(milliseconds: 500),
                                enabled: true,
                                rotationDisabled: Rotation.deg(z: -3600),
                                rotationEnabled: Rotation.deg(z: 0),
                                child: SvgPicture.asset(
                                    'assets/images/Components/upper-right.svg',
                                    height: size.height * 0.035),
                              )
                            ]),
                        SizedBox(height: 160),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          //color: primary_Color.withOpacity(0.3),
                          //margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                          //padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Image.asset('assets/images/man-with-plant.gif',
                              //height: size.height * 0.3),
                              SvgPicture.asset(
                                  'assets/images/Components/man-with-plant.svg',
                                  height: size.height * 0.28),
                              SizedBox(
                                width: 40,
                              )
                            ],
                          ),
                        ),

                        SizedBox(height: 80),
                        ButtonTheme(
                          buttonColor: primary_Color,
                          minWidth: size.width * 0.8,
                          height: size.height * 0.05,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: Login(),
                                  ));
                            },
                            child: Text(
                              'LOGIN',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ButtonTheme(
                          buttonColor: secondary_Color,
                          minWidth: size.width * 0.8,
                          height: size.height * 0.05,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: Signup(),
                                  ));
                            },
                            child: Text(
                              'SIGNUP',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                        OrDivider(),
                        SizedBox(height: 0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => {
                                this.setState(() {
                                  auth.a.loginWithFB(context);
                                })
                              },
                              child: SvgPicture.asset(
                                  'assets/images/Components/with-fb.svg',
                                  //color: Color(0xff3b5998),
                                  height: socialLogin.height * 0.065),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () => {auth.a.loginWithGoogle(context)},
                              child: SvgPicture.asset(
                                  'assets/images/Components/with-google.svg',
                                  //color: Color(0xffDB4437),
                                  height: size.height * 0.065),
                            ),
                          ],
                        ),
                        //Row(
                        //children: [

                        //],
                        //)
                      ],
                    ),
                  ]),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: SvgPicture.asset(
                        'assets/images/Components/bottom-left1.svg',
                        color: secondary_Color.withOpacity(0.6),
                        height: size.height * 0.15),
                  ),
                ]))));
  }
}

class OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.symmetric(vertical: size.height * 0.03),
        width: size.width * 0.8,
        child: Row(
          children: <Widget>[
            buildDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('OR Authenticate with', style: labelStyle1),
            ),
            buildDivider(),
          ],
        ));
  }
}

Expanded buildDivider() {
  return Expanded(
      child: Divider(
    color: primary_Color,
    height: 1.5,
  ));
}
