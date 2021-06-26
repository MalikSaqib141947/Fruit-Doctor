library fruit_doctor.auth;

import 'dart:io';
import 'dart:ffi';
import 'dart:math';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:flutter_doctor/Screens/bottomnav.dart';
import 'package:flutter_doctor/Screens/welcome.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutter_doctor/Provider/home_provider.dart';
import 'package:page_transition/page_transition.dart';

Auth a = Auth.getInstance();
enum E { username, email, photoURL }

class Auth {
  String tokenn;
  Dio dio = new Dio();
  static Auth _instance;
  bool isLoggedIn = false;
  List<String> userProfile = List<String>(3);
  Map userPrf;
  static final facebookLogin = FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  static int min = 100000; //min and max values act as your 6 digit range
  static int max = 999999;
  var randomizer = Random();
  int code;
  Auth._() {}

  static Auth getInstance() {
    if (_instance == null) {
      _instance = new Auth._();
    }
    return _instance;
  }

  generateCode() {
    code = min + randomizer.nextInt(max - min);
  }

  updatePassword(email, password) async {
    try {
      return await dio.post('https://fruitdoctor.herokuapp.com/updatepassword',
          data: {"email": email, "password": password},
          options: Options(contentType: Headers.formUrlEncodedContentType));
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: e.response.data['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  sendMail(recipient, context) async {
    generateCode();

    try {
      return await dio.post('https://fruitdoctor.herokuapp.com/sendmail',
          data: {"email": recipient, "code": code},
          options: Options(contentType: Headers.formUrlEncodedContentType));
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: e.response.data['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    // final Email email = Email(
    //   body: 'Your 6-digit confirmation code: ' + code.toString(),
    //   subject: 'Confirm Email',
    //   recipients: [recipient],
    //   isHTML: true,
    // );

    // FlutterEmailSender.send(email);
  }

  loginWithLocalAccount(email, password) async {
    try {
      var result = await dio.post(
          'https://fruitdoctor.herokuapp.com/authenticate',
          data: {"email": email, "password": password},
          options: Options(contentType: Headers.formUrlEncodedContentType));
      if (result.data['success']) {
        a.isLoggedIn = true;
        var token = result.data['token'];
        tokenn = result.data['token'];
        await a.getinfo(token).then((info) async {
          a.userProfile[E.username.index] = info.data['name'];
          a.userProfile[E.email.index] = info.data['email'];
          a.userProfile[E.photoURL.index] = info.data['pictureUrl'];

          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();

          await sharedPreferences.setString('name', info.data['name']);
          await sharedPreferences.setString('email', info.data['email']);
          await sharedPreferences.setString('url', info.data['pictureUrl']);
          await sharedPreferences.setInt('rating', info.data['rating']);
          await sharedPreferences.setString('rank', info.data['rank']);
          await sharedPreferences.setBool("loggedin", true);
          await sharedPreferences.setBool('localAccount', true);
          await sharedPreferences.setString('token', tokenn);
        });
      }

      return result;
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: e.response.data['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  addNewUser(email, password, name) async {
    try {
      return await dio.post('https://fruitdoctor.herokuapp.com/adduser',
          data: {"email": email, "name": name, "password": password},
          options: Options(contentType: Headers.formUrlEncodedContentType));
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: e.response.data['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  getinfo(token) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    return await dio.get('https://fruitdoctor.herokuapp.com/getinfo');
  }

  loginWithFB(BuildContext context) async {
    final result = await facebookLogin.logInWithReadPermissions(['email']);
    //AccessToken accessToken = AccessToken.getCurrentAccessToken();
    //boolean isLoggedIn = accessToken != null && !accessToken.isExpired();
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        takeToHome(context);
        userPrf = profile;
        //setting the user data fields
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        await sharedPreferences.setString('name', userPrf['name']);
        await sharedPreferences.setString('email', userPrf['email']);
        await sharedPreferences.setString(
            'url', userPrf['picture']['data']['url']);
        await sharedPreferences.setBool('localAccount', false);

        userProfile[E.username.index] = userPrf['name'];
        userProfile[E.email.index] = userPrf['email'];
        userProfile[E.photoURL.index] = userPrf['picture']['data']['url'];

        isLoggedIn = true;
        break;

      case FacebookLoginStatus.cancelledByUser:
        isLoggedIn = false;
        break;
      case FacebookLoginStatus.error:
        isLoggedIn = false;
        break;
    }
  }

  logout(context) async {
    facebookLogin.logOut();
    _googleSignIn.signOut();
    isLoggedIn = false;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString('name', '');
    await sharedPreferences.setString('email', '');
    await sharedPreferences.setString('url', '');
    await sharedPreferences.setBool('loggedin', false);
    //HomeProvider.setPage(0);
    //userProfile = null;
    HomeProvider.setSelected(0);
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    print('logged out');
  }

  loginWithGoogle(BuildContext context) async {
    try {
      await _googleSignIn.signIn();
      userProfile[E.username.index] = _googleSignIn.currentUser.displayName;
      userProfile[E.email.index] = _googleSignIn.currentUser.email;
      userProfile[E.photoURL.index] = _googleSignIn.currentUser.photoUrl;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      await sharedPreferences.setString(
          'name', _googleSignIn.currentUser.displayName);
      await sharedPreferences.setString(
          'email', _googleSignIn.currentUser.email);
      await sharedPreferences.setString(
          'url', _googleSignIn.currentUser.photoUrl);
      await sharedPreferences.setBool('localAccount', false);

      takeToHome(context);
      isLoggedIn = true;
    } catch (err) {
      print(err);
    }
  }

  takeToHome(BuildContext context) async {
    //Popping all the previous pages because we dont want to take the user back to login page if presses the back button
    SharedPreferences sharepref = await SharedPreferences.getInstance();
    sharepref.setBool("loggedin", true);
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pop(
        context, MaterialPageRoute(builder: (context) => (Welcome())));
    Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: userProfile != null ? BottomNavigation() : () => {},
        ));
  }

  //updaing the current user's profile picture
  updateProfilePicture(File file) async {
    var imageName;
    FormData formdata;

    if (file != null) {
      imageName = file.path.split('/').last;
      final mimeTypeData =
          lookupMimeType(file.path, headerBytes: [0xFF, 0xD8]).split('/');
      formdata = new FormData();
      formdata.files.add(MapEntry(
        "picture",
        await MultipartFile.fromFile(file.path,
            filename: imageName,
            contentType: new MediaType(mimeTypeData[0], mimeTypeData[1])),
      ));
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String email = await sharedPreferences.get('email');

    var uploadedImageUrl =
        'https://www.shareicon.net/data/512x512/2016/09/01/822718_user_512x512.png';

    try {
      //uploading the image first and getting the remote URL
      Dio dio = new Dio();
      await dio
          .post('https://fruitdoctor.herokuapp.com/postimage',
              data: formdata,
              options: Options(contentType: Headers.formUrlEncodedContentType))
          .then((value) {
        if (value.data['success']) {
          uploadedImageUrl = value.data['imageData']['secure_url'];
        }
      });

      //now updating the current user's image url on the server
      return await dio.post('https://fruitdoctor.herokuapp.com/updateUser',
          data: {"email": email, "pictureUrl": uploadedImageUrl},
          options: Options(contentType: Headers.formUrlEncodedContentType));
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Something went wrong!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //Getting the cures of detected diseases
  getCure(fruit, disease) async {
    return await dio
        .get('https://fruitdoctor.herokuapp.com/getCure/$fruit/$disease');
  }
}
