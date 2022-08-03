// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../constants.dart';

class RoundedInput extends StatelessWidget {
  const RoundedInput(
      {Key? key,
      required this.icon,
      required this.hint,
      required this.controller,
      required this.inputType,
      required this.maxLen})
      : super(key: key);

  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final TextInputType inputType;
  final int maxLen;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: kPrimaryColor.withAlpha(50),
      ),
      child: TextField(
        controller: controller,
        cursorColor: kPrimaryColor,
        keyboardType: inputType,
        maxLength: maxLen,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          icon: Icon(icon, color: kPrimaryColor),
          hintText: hint,
          border: InputBorder.none,
          counterText: '',
        ),
      ),
    );
  }
}
