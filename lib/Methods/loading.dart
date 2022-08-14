import 'package:drive_safe/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

showLoaderDialog(BuildContext context, Color color) {
  Container alert = Container(
    height: 300,
    child: SpinKitChasingDots(
      color: color,
      size: 60,
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
