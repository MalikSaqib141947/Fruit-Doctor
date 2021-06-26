import 'package:flutter/material.dart';
import 'package:flutter_doctor/Provider/home_provider.dart';
import 'package:flutter_doctor/Provider/modelResult.dart';
import 'package:flutter_doctor/Screens/bottomnav.dart';
import 'package:flutter_doctor/Screens/calculate_fertilizer.dart';
import 'package:flutter_doctor/Screens/loader.dart';
import 'package:flutter_doctor/Screens/login.dart';
import 'package:flutter_doctor/Screens/login_checker.dart';
import 'package:flutter_doctor/Screens/note_home.dart';
import 'package:flutter_doctor/Screens/scraper.dart';
import 'package:flutter_doctor/Screens/signup.dart';
import 'package:flutter_doctor/Screens/todoist.dart';
import 'package:flutter_doctor/Screens/welcome.dart';
import 'package:flutter_doctor/Screens/home.dart';
import 'package:flutter_doctor/Screens/weather.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:flutter_doctor/utilities/auth.dart' as auth;
import 'package:provider/provider.dart';
import 'Screens/test.dart';
import 'routes.dart';
import 'package:flutter_doctor/Provider/calculator.dart';

void main() {
  runApp(FruitDoctor());
}

class FruitDoctor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Calculator()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ModelResults())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fruit Doctor',
        theme: fruitDoctorThemeData,
        initialRoute: LoginChecker.id,
        routes: Routes.ROUTE,
      ),
    );
  }
}
