// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/Methods/toast.dart';
import 'package:drive_safe/Screens/admin_screen/admin_panel.dart';
import 'package:drive_safe/Screens/main_page.dart';
import 'package:drive_safe/Screens/profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

var currUid;
var docId;
var userCredential;
var userAge;
var userName;
final storage = new FlutterSecureStorage();

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
          userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: email.text, password: password.text);
          storeTockenData(userCredential, "user");
          FirebaseAuth.instance.authStateChanges().listen((User? user) {
            if (user != null) {
              currUid = user.uid;
              getAgeName();
            }
          });

          try {
            profilePicURL = await FirebaseStorage.instance
                .ref("profilePic/$currUid")
                .getDownloadURL();
          } on FirebaseException catch (e) {
            if (e.code == 'object-not-found') {
              profilePicURL = await FirebaseStorage.instance
                  .ref("profilePic/default.jpg")
                  .getDownloadURL();
            }
          }

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => MainPage()));
          if (userCredential.user!.uid == 'qjSKPVDyCYfttsWfSpvP0ZAoZKR2') {
            storeTockenData(userCredential, "admin");
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => AdminPanel()));
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

  Future<void> storeTockenData(
      UserCredential userCredential, String token) async {
    await storage.write(key: "token", value: token);
    await storage.write(
        key: "userCredential", value: userCredential.toString());
    await storage.write(key: "currentId", value: currUid.toString());
  }

  getAgeName() async {
    CollectionReference userInfo = db.collection('user_info');
    QuerySnapshot<Object?> snapshot =
        await userInfo.where(FieldPath.documentId, isEqualTo: currUid).get();
    var data = snapshot.docs[0];
    userName = data['Name'];
    userAge = data["Age"];
  }
}
