// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/Components/LoginScreen/login_button.dart';
import 'package:drive_safe/Methods/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton(
      {Key? key,
      required this.hint,
      required this.email,
      required this.password,
      required this.name,
      required this.conPassword,
      required this.age,
      required this.gender})
      : super(key: key);
  final String hint;
  final email, password, name, conPassword, age, gender;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (age.text == '' &&
            gender.text == '' &&
            name.text == '' &&
            email.text == '' &&
            password.text == '') {
          ShowToast("Fill out all feilds");
        } else {
          try {
            final UserCredential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: email.text, password: password.text)
                .then((value) {
              currUid = FirebaseAuth.instance.currentUser!.uid;
            });

            // FirebaseAuth.instance.authStateChanges().listen((User? user) {
            //   currUid = user!.uid;
            // });

            createDoc(email.text, name.text, age.text, gender.text, currUid);
            ShowToast("Account Created");
          } on FirebaseAuthException catch (e) {
            print(e.code);
            if (e.code == 'unknown') {
              ShowToast('Input feilds cannot be empty');
            } else {
              ShowToast(e.code);
            }
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
          hint,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  createDoc(email, name, age, gender, id) {
    DocumentReference doc =
        FirebaseFirestore.instance.collection("user_info").doc(currUid);
    Map<String, dynamic> userInfo = {
      "Name": name,
      "Email": email,
      "Age": age,
      "Gender": gender,
      "id": currUid,
    };
    doc.set(userInfo).whenComplete(() => null);
  }
}
