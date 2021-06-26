import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_doctor/Screens/signup.dart';
import 'package:flutter_doctor/Screens/loader.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:flutter_doctor/utilities/auth.dart' as auth;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_doctor/Screens/login.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:page_transition/page_transition.dart';

class EnterPin extends StatefulWidget {
  static const String id = 'EnterPin';
  var _email;
  var _password;
  var _name;

  EnterPin(e, p, n) {
    this._email = e;
    this._password = p;
    this._name = n;
  }
  @override
  _EnterPinState createState() => _EnterPinState(_email, _password, _name);
}

class _EnterPinState extends State<EnterPin> {
  var _email;
  var _password;
  var _name;
  bool isLoading = false;

  _EnterPinState(e, p, n) {
    this._email = e;
    this._password = p;
    this._name = n;
  }
/////

/////
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Size socialLogin = MediaQuery.of(context).size;
    Color c = Colors.blue;
    if (isLoading) {
      return Loader();
    } else
      return SafeArea(
          child: Scaffold(
              body: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 100),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(400),
                            child: Image(
                              height: 200,
                              image: AssetImage(
                                  "assets/images/email_sent_animation3.gif"),
                            ),
                          ),
                          SizedBox(height: 50),
                          Text("Enter the 6 digit pin sent to your email!",
                              style: TextStyle(
                                color: primary_Color,
                              )),
                          SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              PinEntryTextField(
                                fields: 6,
                                showFieldAsBox: true,
                                onSubmit: (String pin) {
                                  if (pin.toString() ==
                                      auth.a.code.toString()) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Verification Successful, Signing Up...",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    this.setState(() {
                                      isLoading = true;
                                    });
                                    //signing up the user and taking him to login page
                                    auth.a
                                        .addNewUser(_email, _password, _name)
                                        .then((val) {
                                      if (val.data['success']) {
                                        this.setState(() {
                                          isLoading = false;
                                        });
                                        Fluttertoast.showToast(
                                            msg: 'Signed Up Successfully!',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              child: Login(),
                                            ));
                                      } else {
                                        this.setState(() {
                                          isLoading = false;
                                        });
                                        Fluttertoast.showToast(
                                            msg: val.data['msg'],
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    });
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Verification Failed",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Did not receive the code? ",
                                style: labelStyle1,
                              ),
                              GestureDetector(
                                onTap: () => {
                                  auth.a.sendMail(_email, context).then((val) {
                                    if (val.data['success']) {
                                      Fluttertoast.showToast(
                                          msg: val.data['msg'],
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  })
                                },
                                child: Text("Resend Email",
                                    style: TextStyle(
                                        color: primary_Color,
                                        fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ]))));
  }
}
