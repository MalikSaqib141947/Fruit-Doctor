import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_doctor/Screens/forgotPassword2.dart';
import 'package:flutter_doctor/Screens/loader.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:email_validator/email_validator.dart' as eValidator;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_doctor/utilities/auth.dart' as auth;

class Forgot_Password extends StatefulWidget {
  static const String id = 'Forgot_Password';

  @override
  _Forgot_PasswordState createState() => _Forgot_PasswordState();
}

class _Forgot_PasswordState extends State<Forgot_Password> {
  String email;
  final _formEmail = GlobalKey<FormState>();
  bool isLoading = false;
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
                        key: _formEmail,
                        autovalidate: true,
                        child: TextFormField(
                          validator: Validators.compose([
                            Validators.required('Email is required'),
                            Validators.email('Invalid email address'),
                          ]),
                          keyboardType: TextInputType.emailAddress,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.left,
                          onChanged: (value) {
                            this.email = value;
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
                              Icons.alternate_email,
                              color: placeholderColor,
                            ),
                            hintText: 'Email Address',
                            hintStyle: placeholderStyle,
                          ),
                        )),
                  ),
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
                            onPressed: () async {
                              this.setState(() {
                                isLoading = true;
                              });
                              if (!_formEmail.currentState.validate()) {
                                Fluttertoast.showToast(
                                    msg: "Please Enter a valid Email",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                await auth.a
                                    .sendMail(email, context)
                                    .then((val) {
                                  this.setState(() {
                                    isLoading = false;
                                  });
                                  if (val.data['success']) {
                                    Fluttertoast.showToast(
                                        msg: val.data['msg'],
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0);

                                    Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: ForgotPassword2(email),
                                        ));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: val.data['msg'],
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                });
                              }
                            },
                            child: Text(
                              'Continue',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                  SizedBox(height: 80),
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
