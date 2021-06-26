import 'package:flutter/material.dart';
import 'package:flutter_doctor/Screens/calculate_fertilizer.dart';
import 'package:flutter_doctor/Screens/login_checker.dart';
import 'package:flutter_doctor/Screens/scraper.dart';
import 'package:flutter_doctor/Screens/test.dart';
import 'Screens/login.dart';
import 'Screens/signup.dart';
import 'Screens/bottomnav.dart';
import 'Screens/home.dart';
import 'Screens/weather.dart';
import 'Screens/welcome.dart';
import 'Screens/forgotPassword.dart';
import 'Screens/note_home.dart';
import 'Screens/todoist.dart';
import 'Screens/todo_list_screen.dart';
import 'Screens/add_task_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> _defaultRoute = {
    Welcome.id: (context) => Welcome(),
    Forgot_Password.id: (context) => Forgot_Password(),
    Login.id: (context) => Login(),
    Signup.id: (context) => Signup(),
    Home.id: (context) => Home(),
    Weather.id: (context) => Weather(),
    BottomNavigation.id: (context) => BottomNavigation(),
    NoteHome.id: (context) => NoteHome(),
    Todoist.id: (context) => Todoist(),
    LoginChecker.id: (context) => LoginChecker(),
    CalculateFertilizer.id: (context) => CalculateFertilizer(),
    TodoListScreen.id: (context) => TodoListScreen(),
    ScraperScreen.id: (context) => ScraperScreen(),
    Test.id: (context) => Test(),
  };

  static Map<String, WidgetBuilder> get ROUTE => _defaultRoute;
}
