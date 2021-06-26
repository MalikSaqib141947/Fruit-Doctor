import 'package:flutter/material.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white.withOpacity(1),
        body: SpinKitRing(
          color: primary_Color,
          size: 80.0,
        ));
  }
}
