// ignore_for_file: avoid_single_cascade_in_expression_statements

import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/Screens/profile.dart';
import 'package:drive_safe/constants.dart';
import 'package:flutter/material.dart';

class PieData {
  static List<Data> data = [
    // Data(name: '18-30', percent: 80, color: kPrimaryColor),
    // Data(name: '31-40', percent: 30, color: const Color(0xfff8b250)),
    // Data(name: '41-50', percent: 15, color: Colors.teal),
    // Data(name: '51+', percent: 15, color: const Color(0xff13d38e)),
  ];
}

class Data {
  final String age;

  final double sleep;

  final Color color;
  Data({required this.age, required this.sleep, required this.color});
}

class DataFromBackend {
  void get() async {
    // var x = 0;
    // var age = 0;
    // var cat = 0;
    // await FirebaseFirestore.instance
    //     .collection('captured_data')
    //     .orderBy('Age', descending: false)
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     //print(doc["Sleep"].toString() + doc["Age"].toString());
    //     if (age == int.parse(doc["Age"])) {
    //     } else {
    //       age = int.parse(doc["Age"]);
    //       cat++;
    //     }
    //   });
    // });
    // print(cat++);

    var age = 0;
    var ageCatOne = 0;
    var ageCatTwo = 0;
    var ageCatThree = 0;
    var ageCatFour = 0;
    var sleep;
    var i = 10;
    await db
      ..collection('captured_data')
          .orderBy('Age', descending: false)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (age == int.parse(doc["Age"])) {
            PieData.data.add(Data(
                age: 0.toString(),
                sleep: doc["Sleep"].toDouble(),
                color: kPrimaryColor));
          } else if (int.parse(doc["Age"]) > 17 && int.parse(doc["Age"]) < 26) {
            age = int.parse(doc["Age"]);
            PieData.data.add(Data(
                age: doc["Age"].toString(),
                sleep: doc["Sleep"].toDouble(),
                color: kPrimaryColor));
          }
        });
      });
  }
}

// if (age == int.parse(doc["Age"])) {
//             PieData.data.add(Data(
//                 age: 0.toString(),
//                 sleep: doc["Sleep"].toDouble(),
//                 color: kPrimaryColor));
//           } else {
//             age = int.parse(doc["Age"]);
//             PieData.data.add(Data(
//                 age: doc["Age"].toString(),
//                 sleep: doc["Sleep"].toDouble(),
//                 color: kPrimaryColor));
//           }
