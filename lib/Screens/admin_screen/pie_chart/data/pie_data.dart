// ignore_for_file: avoid_single_cascade_in_expression_statements

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/Screens/profile.dart';
import 'package:drive_safe/constants.dart';
import 'package:flutter/material.dart';

class PieData {
  static List<Data> data = [];
}

class Data {
  final String age;
  final double sleep;
  final Color color;
  Data({required this.age, required this.sleep, required this.color});
}

class DataFromBackend {
  void get() {
    PieData.data = [];
    var i = 0;
    var catg1 = 0;
    var catg2 = 0;
    var catg3 = 0;
    var catg4 = 0;
    var catg5 = 0;
    db
      ..collection('captured_data')
          .orderBy('Age', descending: false)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (int.parse(doc["Age"]) >= 18 && int.parse(doc["Age"]) <= 30) {
            catg1 = (catg1 + doc["Sleep"]) as int;
          } else if (int.parse(doc["Age"]) >= 31 &&
              int.parse(doc["Age"]) <= 40) {
            catg2 = (catg2 + doc["Sleep"]) as int;
          } else if (int.parse(doc["Age"]) >= 41 &&
              int.parse(doc["Age"]) <= 50) {
            catg3 = (catg3 + doc["Sleep"]) as int;
          } else if (int.parse(doc["Age"]) >= 51 &&
              int.parse(doc["Age"]) <= 60) {
            catg4 = (catg4 + doc["Sleep"]) as int;
          } else if (int.parse(doc["Age"]) > 60) {
            catg5 = (catg5 + doc["Sleep"]) as int;
          }
          i++;
          if (i == querySnapshot.size) {
            PieData.data.add(Data(
                age: "18-30", sleep: catg1.toDouble(), color: kPrimaryColor));
            PieData.data.add(Data(
                age: "31-40", sleep: catg2.toDouble(), color: Colors.teal));
            PieData.data.add(Data(
                age: "41-50",
                sleep: catg3.toDouble(),
                color: const Color(0xff13d38e)));
            PieData.data.add(Data(
                age: "51-60", sleep: catg4.toDouble(), color: Colors.cyan));
            PieData.data.add(Data(
                age: "60+",
                sleep: catg5.toDouble(),
                color: const Color(0xfff8b250)));
          }
        });
      });
  }
}
