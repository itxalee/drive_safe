// ignore_for_file: prefer_const_constructors

import 'package:drive_safe/Screens/main_page.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';


class LoginButton extends StatelessWidget {
  const LoginButton({
    Key? key,
    required this.text
  }) : super(key: key);
 final String text;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> MainPage()));
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        // width: size.width*0.8,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: kPrimaryColor,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}