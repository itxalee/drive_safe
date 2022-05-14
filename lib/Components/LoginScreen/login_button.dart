// ignore_for_file: prefer_const_constructors

import 'package:drive_safe/Methods/toast.dart';
import 'package:drive_safe/Screens/admin_panel.dart';
import 'package:drive_safe/Screens/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../firebase_options.dart';

class LoginButton extends StatelessWidget {
  const LoginButton(
      {Key? key,
      required this.text,
      required this.email,
      required this.password})
      : super(key: key);
  final String text;
  final email, password;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          final UserCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: email.text, password: password.text);

          if (User != null) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => MainPage()));
          }
          if (UserCredential.user!.uid == 'GbQDkozG8FREwsGbWEymYMpcb142') {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => Dashboard()));
          }
        } on FirebaseAuthException catch (e) {
          print(e.code);
          if (e.code == 'unknown') {
            ShowToast('Input feilds cannot be empty');
          }
          if (e.code == 'wrong-password') {
            ShowToast('The email or password you entered is incorect');
          }
          if (e.code == 'invalid-email') {
            ShowToast('You entered an invalid email');
          }
          if (e.code == 'user-not-found') {
            ShowToast('User does not exist');
          } else
            ShowToast(e.code);
        }

        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Dashboard()));
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
