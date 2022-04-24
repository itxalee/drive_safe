
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../constants.dart';

class RoundedPassword extends StatelessWidget {
  const RoundedPassword({
    Key? key,
    required this.text
  }) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: kPrimaryColor.withAlpha(50),
      ),
      child: TextField(
        cursorColor: kPrimaryColor,
        obscureText: true,
        decoration: InputDecoration(
            icon: Icon(Icons.lock,color: kPrimaryColor),
            hintText: text,
            border: InputBorder.none
        ),
      ),
    );
  }
}