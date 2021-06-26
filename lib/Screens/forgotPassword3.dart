import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_doctor/Screens/login.dart';
import 'package:flutter_doctor/Screens/loader.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:email_validator/email_validator.dart' as eValidator;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_doctor/utilities/auth.dart' as auth;
import 'package:page_transition/page_transition.dart';

class Forgot_Password3 extends StatefulWidget {
  static const String id = 'Forgot_Password3';
  var _email;
  Forgot_Password3(e) {
    this._email = e;
  }

  @override
  _Forgot_Password3State createState() => _Forgot_Password3State(_email);
}

class _Forgot_Password3State extends State<Forgot_Password3> {
  String password = '';
  String confirmPassword = '';
  bool isLoading = false;

  final _formPassword = GlobalKey<FormState>();
  final _formConfirmPassword = GlobalKey<FormState>();

  var _email;

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: ''),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'password must have at least one special character'),
  ]);

  _Forgot_Password3State(e) {
    this._email = e;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/images/Components/upper-left.svg',
                      height: size.height * 0.1),
                  SizedBox(
                    width: 55,
                  ),
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    SizedBox(height: 50),
                    Text(
                      'FORGOT PASSWORD',
                      style: topHeadingStyle,
                    ),
                  ]),
                  SizedBox(
                    width: 50,
                  ),
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    SizedBox(height: 50),
                    RotationAnimatedWidget.tween(
                      duration: Duration(minutes: 3),
                      delay: Duration(milliseconds: 500),
                      enabled: true,
                      rotationDisabled: Rotation.deg(z: -3600),
                      rotationEnabled: Rotation.deg(z: 0),
                      child: SvgPicture.asset(
                          'assets/images/Components/upper-right.svg',
                          height: size.height * 0.04),
                    )
                  ]),
                  SizedBox(height: 120),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                          'assets/images/Components/forgot-password.svg',
                          height: size.height * 0.27),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Don't Worry, You can easily reset it!",
                    style: labelStyle1,
                  ),
                  SizedBox(height: 40),
                  Container(
                      alignment: Alignment.centerLeft,
                      decoration: loginBoxDecorationStyle,
                      height: 45.0,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Form(
                        key: _formPassword,
                        autovalidate: true,
                        child: TextFormField(
                          validator: passwordValidator,
                          textAlignVertical: TextAlignVertical.center,
                          obscureText: true,
                          onChanged: (value) {
                            this.password = value;
                          },
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'CM Sans Serif',
                          ),
                          decoration: InputDecoration(
                            errorMaxLines: 1,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            errorStyle: TextStyle(
                                backgroundColor: Colors.red,
                                color: Colors.white,
                                height: 0,
                                decorationColor: Colors.green),
                            helperText: '  ',
                            helperStyle: TextStyle(fontSize: 0, height: 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: placeholderColor,
                            ),
                            hintText: 'Password',
                            hintStyle: placeholderStyle,
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      decoration: loginBoxDecorationStyle,
                      height: 45.0,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Form(
                        key: _formConfirmPassword,
                        autovalidate: true,
                        child: TextFormField(
                          validator: (value) =>
                              MatchValidator(errorText: 'Passwords dont match')
                                  .validateMatch(value, password),
                          textAlignVertical: TextAlignVertical.center,
                          obscureText: true,
                          onChanged: (value) {
                            this.confirmPassword = value;
                          },
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'CM Sans Serif',
                          ),
                          decoration: InputDecoration(
                            errorMaxLines: 1,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            errorStyle: TextStyle(
                              backgroundColor: Colors.red,
                              color: Colors.white,
                              height: 0,
                            ),
                            helperText: '  ',
                            helperStyle: TextStyle(fontSize: 0, height: 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: placeholderColor,
                            ),
                            hintText: 'Confirm Password',
                            hintStyle: placeholderStyle,
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  isLoading
                      ? CircularProgressIndicator(
                          backgroundColor: primary_Color,
                        )
                      : ButtonTheme(
                          buttonColor: primary_Color,
                          minWidth: size.width * 0.8,
                          height: size.height * 0.05,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () {
                              if (_formPassword.currentState.validate() &&
                                  _formConfirmPassword.currentState
                                      .validate()) {
                                this.setState(() {
                                  isLoading = true;
                                });
                                auth.a
                                    .updatePassword(_email, password)
                                    .then((val) {
                                  if (val.data['success']) {
                                    Fluttertoast.showToast(
                                        msg: val.data['msg'],
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    this.setState(() {
                                      isLoading = false;
                                    });
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.rightToLeft,
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
                                var errMsg;
                                if (!_formPassword.currentState.validate())
                                  errMsg = "Please enter a valid Password";
                                else if (!_formConfirmPassword.currentState
                                    .validate())
                                  errMsg = "Please confirm your password";
                                Fluttertoast.showToast(
                                    msg: errMsg,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                            child: Text(
                              'Update Password',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      SvgPicture.asset(
                          'assets/images/Components/bottom-left.svg',
                          height: size.height * 0.15),
                    ],
                  )
                ],
              )
            ]),
          )),
    ));
  }
}
