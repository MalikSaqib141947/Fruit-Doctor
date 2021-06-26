library fruit_doctor.forum;

import 'dart:math';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import 'package:flutter_doctor/utilities/auth.dart' as auth;
import 'dart:io' as io;

Dio dio = new Dio();

postQuery(subject, query, email, relatedFruit, io.File file) async {
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

  var uploadedImageUrl =
      'https://upload.wikimedia.org/wikipedia/commons/5/52/Apple_fruits_scab.jpg';

  try {
    //uploading the image first and getting the remote URL

    await dio
        .post('https://fruitdoctor.herokuapp.com/postimage',
            data: formdata,
            options: Options(contentType: Headers.formUrlEncodedContentType))
        .then((value) {
      if (value.data['success']) {
        uploadedImageUrl = value.data['imageData']['secure_url'];
      }
    });

    //then passing that image URL, along with other parameter to the postquery method to upload the post

    return await dio.post('https://fruitdoctor.herokuapp.com/postquery',
        data: {
          "subject": subject,
          "query": query,
          "user": email,
          "fruit": relatedFruit,
          "image": uploadedImageUrl,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType));
  } on DioError catch (e) {
    Fluttertoast.showToast(
        msg: e.response.data['msg'].toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

getQueries() async {
  try {
    return await http.get('https://fruitdoctor.herokuapp.com/getqueries');
  } catch (e) {
    Fluttertoast.showToast(
        msg: e.response.data['msg'].toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

getReplies(queryId) async {
  try {
    return await http
        .get('https://fruitdoctor.herokuapp.com/getReplies/$queryId');
  } catch (e) {
    Fluttertoast.showToast(
        msg: e.response.data['msg'].toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

String timeAgo(String s) {
  DateTime d = DateTime.parse(s);
  Duration diff = DateTime.now().difference(d);
  if (diff.inDays > 365)
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
  if (diff.inDays > 30)
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
  if (diff.inDays > 7)
    return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
  if (diff.inDays > 0)
    return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
  if (diff.inHours > 0)
    return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
  if (diff.inMinutes > 0)
    return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
  return "just now";
}

postReply(postID, replyText, replierEmail) async {
  try {
    return await dio.post('https://fruitdoctor.herokuapp.com/postreply',
        data: {
          "replyText": replyText,
          "replierEmail": replierEmail,
          "postID": postID,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType));
  } catch (e) {
    Fluttertoast.showToast(
        msg: e.response.data['msg'].toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

//Like or unlike a query
toggleQueryLike(queryId) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var currentUserToken = await sharedPreferences.get('token');
  dio.options.headers['Authorization'] = 'Bearer $currentUserToken';
  return await dio.post('https://fruitdoctor.herokuapp.com/rateQuery/$queryId');
}

//like or unlike a reply on a query
toggleReplyLike(queryId, replyId) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var currentUserToken = await sharedPreferences.get('token');
  dio.options.headers['Authorization'] = 'Bearer $currentUserToken';
  return await dio
      .post('https://fruitdoctor.herokuapp.com/rateReply/$queryId/$replyId');
}

// fruitImage(fruit){
//   String baseAddress = './assets/images/home/';
//   if(fruit == 'Apple')
//     return baseAddress + 'Apple.png';
//   else if(fruit == 'Citrus')
//     return baseAddress + 'Orange2.png';
//   else if(fruit == 'Banana')
//     return baseAddress + 'Banana.png';
//   else if(fruit == 'Mango')
//     return baseAddress + 'Mango.png';
//   else if(fruit == 'Pineapple')
//     return baseAddress + 'Pineapple.png';
//   else if(fruit == 'Citrus')
//     return baseAddress + 'Apple.png';

//   }

// }
