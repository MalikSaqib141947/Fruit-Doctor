import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_doctor/Screens/login.dart';
import 'package:flutter_doctor/Screens/loader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_doctor/utilities/auth.dart' as auth;
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:email_validator/email_validator.dart' as eValidator;
import 'package:flutter_doctor/Screens/enterPin.dart';
import 'package:page_transition/page_transition.dart';

class Signup extends StatefulWidget {
  static const String id = 'Signup';
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String name;
  String email;
  String password = '';
  String confirmPassword = '';
  bool isLoading = false;

  final _formName = GlobalKey<FormState>();
  final _formEmail = GlobalKey<FormState>();
  final _formPassword = GlobalKey<FormState>();
  final _formConfirmPassword = GlobalKey<FormState>();

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: ''),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'password must have at least one special character'),
  ]);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                            'assets/images/Components/upper-left.svg',
                            height: size.height * 0.1),
                        SizedBox(
                          width: 95,
                        ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 50),
                              Text(
                                'SIGN UP',
                                style: topHeadingStyle,
                              ),
                            ]),
                        SizedBox(
                          width: 90,
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
                                    height: size.height * 0.04),
                              )
                            ]),
                        SizedBox(height: 120),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                                'assets/images/Components/watering-the-plant.svg',
                                height: size.height * 0.23),
                          ],
                        ),
                        SizedBox(height: 25),
                        Container(
                            alignment: Alignment.centerLeft,
                            decoration: loginBoxDecorationStyle,
                            height: 45.0,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Form(
                                key: _formName,
                                autovalidate: true,
                                child: TextFormField(
                                  validator:
                                      Validators.required("Name is required"),
                                  keyboardType: TextInputType.emailAddress,
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.left,
                                  onChanged: (value) {
                                    this.name = value;
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
                                    helperStyle:
                                        TextStyle(fontSize: 0, height: 0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: placeholderColor,
                                    ),
                                    hintText: "Full Name",
                                    hintStyle: placeholderStyle,
                                  ),
                                ))),
                        SizedBox(
                          height: 12,
                        ),
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
                                  helperStyle:
                                      TextStyle(fontSize: 0, height: 0),
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
                        SizedBox(height: 12),
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
                                  helperStyle:
                                      TextStyle(fontSize: 0, height: 0),
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
                                validator: (value) => MatchValidator(
                                        errorText: 'Passwords dont match')
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
                                  helperStyle:
                                      TextStyle(fontSize: 0, height: 0),
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
                          height: 20,
                        ),
                        isLoading
                            ? CircularProgressIndicator(
                                backgroundColor: primary_Color,
                              )
                            : ButtonTheme(
                                buttonColor: secondary_Color,
                                minWidth: size.width * 0.8,
                                height: size.height * 0.05,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  onPressed: () {
                                    if (_formPassword.currentState.validate() &&
                                        _formEmail.currentState.validate() &&
                                        _formName.currentState.validate() &&
                                        _formConfirmPassword.currentState
                                            .validate()) {
                                      this.setState(() {
                                        isLoading = true;
                                      });
                                      auth.a
                                          .sendMail(email, context)
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
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: EnterPin(
                                                    email, password, name),
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
                                      if (!_formName.currentState.validate())
                                        errMsg = "Your Name is Required";
                                      else if (!_formEmail.currentState
                                          .validate())
                                        errMsg =
                                            "Please enter a valid Email Address";
                                      else if (!_formPassword.currentState
                                          .validate())
                                        errMsg =
                                            "Please enter a valid Password";
                                      else if (!_formConfirmPassword
                                          .currentState
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
                                    'SIGN UP',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                              ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: labelStyle1,
                            ),
                            GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: Login(),
                                    ))
                              },
                              child: Text("Signin!",
                                  style: TextStyle(
                                      color: primary_Color,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
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
                ))));
  }
}
