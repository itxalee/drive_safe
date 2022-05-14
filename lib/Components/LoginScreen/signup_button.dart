// ignore_for_file: prefer_const_constructors

import 'package:drive_safe/Methods/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../firebase_options.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton(
      {Key? key,
      required this.hint,
      required this.email,
      required this.password})
      : super(key: key);
  final String hint;
  final email, password;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          final UserCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: email.text, password: password.text);
        } on FirebaseAuthException catch (e) {
          print(e.code);
          if (e.code == 'unknown') {
            ShowToast('Input feilds cannot be empty');
          } else
            ShowToast(e.code);
        }
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
          hint,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
