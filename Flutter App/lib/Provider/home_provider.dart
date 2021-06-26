import 'package:flutter/material.dart';
import 'package:flutter_doctor/Screens/community.dart';
import 'package:flutter_doctor/Screens/home.dart';
import 'package:flutter_doctor/Screens/profile.dart';
import 'package:flutter_doctor/Screens/scraper.dart';

class HomeProvider extends ChangeNotifier {
  static int _selectedPage = 0;

  static final _pageOption = [Community(), ScraperScreen(), Profile()];

  List<Widget> _temp = [];

  HomeProvider() {
    final home = Home();
    final scrapper = ScraperScreen();
    final profile = Profile();
    final community = Community();

    _temp.add(home);
    _temp.add(community);
    _temp.add(scrapper);
    _temp.add(profile);
  }

  Widget get widget => _temp[_selectedPage];
  int get selectedPage => _selectedPage;

  void setPage(int page) {
    _selectedPage = page;

    notifyListeners();
  }

  static void setSelected(int page) {
    _selectedPage = page;
  }
}
