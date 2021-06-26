import 'package:flutter/material.dart';

class ModelResults with ChangeNotifier {
  String result = "Prediction";

  resultsFetch(String res) {
    result = res;
    notifyListeners();
  }
}
