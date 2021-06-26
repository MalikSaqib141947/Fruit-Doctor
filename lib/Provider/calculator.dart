import 'dart:convert';

import 'package:flutter/material.dart';

class Calculator with ChangeNotifier {
  double val1 = 0;
  bool pressed = false;
  double dap = 0.0;
  double mop1 = 0.0;
  double urea1 = 0.0;
  double mop2 = 0.0;
  double urea2 = 0.0;
  double fert10 = 0.0;

  double elevationcard = 0;

  Calculator() {
    val1 = 0;
  }

  String get value => val1.toString();
  TextEditingValue get textValue => TextEditingValue(text: val1.toString());

  void converterStringAdd() {
    val1 += 0.5;
    notifyListeners();
  }

  converterStringSub() {
    if (val1 != 0) {
      val1 = val1 - 0.5;
    }
    notifyListeners();
  }

  buttonPressed(double value, String fruit) {
    pressed = true;
    val1 = value;
    switch (fruit) {
      case "Apple":
        {
          dap = (435 * value) / 1000;
          mop1 = (667 * value) / 1000;
          urea1 = (699 * value) / 1000;
          mop2 = (333 * value) / 1000;
          urea2 = (702 * value) / 1000;
          fert10 = (769 * value) / 1000;

          print("apple");
        }
        break;

      case "Citrus":
        {
          dap = (625 * value) / 1000;
          mop1 = (1000 * value) / 1000;
          urea1 = (1000 * value) / 1000;
          mop2 = (500 * value) / 1000;
          urea2 = (1100 * value) / 1000;
          fert10 = (1200 * value) / 1000;

          print("Citus");
        }
        break;

      case "Pomegranate":
        {
          print("Pomegranate");
        }
        break;

      case "Water Mellon":
        {
          print("Water Mellon");
        }
        break;
    }

    notifyListeners();
  }

  buttonClear() {
    val1 = 0;
    pressed = false;
    dap = 0.0;
    mop1 = 0.0;
    urea1 = 0.0;
    mop2 = 0.0;
    urea2 = 0.0;
    fert10 = 0.0;
    notifyListeners();
  }
}
