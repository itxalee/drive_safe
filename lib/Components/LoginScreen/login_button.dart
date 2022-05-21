// ignore_for_file: prefer_const_constructors

import 'package:drive_safe/Methods/toast.dart';
import 'package:drive_safe/Screens/admin_panel.dart';
import 'package:drive_safe/Screens/main_page.dart';
import 'package:drive_safe/Screens/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../firebase_options.dart';

var currUid;

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

          FirebaseAuth.instance.authStateChanges().listen((User? user) {
            if (user != null) {
              currUid = user.uid;
              print(currUid);
            }
          });

          try {
            profilePicURL = await FirebaseStorage.instance
                .ref("profilePic/$currUid")
                .getDownloadURL();
          } on FirebaseException catch (e) {
            print(e.code);
            if (e.code == 'object-not-found') {
              profilePicURL = await FirebaseStorage.instance
                  .ref("profilePic/default.jpg")
                  .getDownloadURL();
            }
          }

          if (User != null) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => MainPage()));
          }
          if (UserCredential.user!.uid == 'GbQDkozG8FREwsGbWEymYMpcb142') {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => Dashboard()));
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'unknown') {
            ShowToast('Input feilds cannot be empty');
          } else if (e.code == 'wrong-password') {
            ShowToast('The email or password you entered is incorect');
          } else if (e.code == 'invalid-email') {
            ShowToast('You entered an invalid email');
          } else if (e.code == 'user-not-found') {
            ShowToast('User does not exist');
          } else {
            ShowToast(
                "Somthing went wrong, Please check your internet connection");
          }
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
