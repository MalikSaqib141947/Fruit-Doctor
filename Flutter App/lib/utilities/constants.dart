import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//Yet to use colors
final kScaffoldBackgroundColor = Color(0xFFedf5f4);
final kLightTealColor = Color(0xffE9F2F1);
final kTealColor = Color(0xff45736A);
final kAmberColor = Color(0xffF2B035);
final kLightAmberColor = Color(0xffF2CA7E);
final kPeachColor = Color(0xffF2AA80);
final kMapsGreyColor = Color(0xFFf5f5f5);

//Theme Colors
final background_Color = Color(0xffffffff);
final primary_Color = Color(0xff27AE5A);
final appbar_Color = Color(0xff27AE5A);
final secondary_Color = Colors.deepOrangeAccent;
final tertiary_Color = Colors.black.withOpacity(0.6);
final placeholderColor = Color(0xffffffff);
final textfieldbackgroundColor = Color(0xff000000);

//Theme Fonts
final splashHeaderFont = 'Showcard Gothic';
final splashtaglineFont = 'Monotype Corsiva';
final normalTextFont = 'CM Sans Serif';

//Theme
final fruitDoctorThemeData = ThemeData(
  backgroundColor: background_Color,
  dialogBackgroundColor: background_Color,
  scaffoldBackgroundColor: background_Color,
  primaryColor: primary_Color,
  secondaryHeaderColor: secondary_Color,
);

//Entry fields decoration style
final loginBoxDecorationStyle = BoxDecoration(
  color: textfieldbackgroundColor.withOpacity(0.5),
  borderRadius: BorderRadius.circular(30.0),
  border: Border.all(color: Colors.white),
  /*
  boxShadow: [
    BoxShadow(
      color: textfieldbackgroundColor.withOpacity(0.6),
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],*/
);

//Textfields placehoder style
final placeholderStyle = TextStyle(
  color: placeholderColor,
  fontFamily: 'CM Sans Serif',
);

//Label Style 1
final labelStyle1 = TextStyle(
  color: primary_Color,
  fontWeight: FontWeight.w600,
  fontFamily: 'CM Sans Serif',
);

//Label style 2
final labelStyle2 = TextStyle(
  fontSize: 13,
  fontStyle: FontStyle.italic,
  color: secondary_Color,
  fontWeight: FontWeight.w600,
  fontFamily: 'CM Sans Serif',
);

//Navigation Bar Text Style
final zBottomNavBarTextStyle = TextStyle(
  fontSize: 22.0,
  color: Colors.white,
  fontFamily: 'CM Sans Serif',
);

//Splash screen project name style
final splashHeaderStyle = TextStyle(
    fontSize: 22.0, color: primary_Color, fontFamily: 'Showcard Gothic');

//Splash screen project tag line style
final splashTaglineStyle = TextStyle(
    fontSize: 14.0, color: primary_Color, fontFamily: 'Monotype Corsiva');

//Top heading style
final topHeadingStyle = TextStyle(
  fontSize: 16.0,
  color: primary_Color,
  fontWeight: FontWeight.bold,
  fontFamily: 'CM Sans Serif',
);
