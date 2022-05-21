// ignore_for_file: prefer_const_constructors, unused_element, avoid_print, dead_code, unnecessary_const

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/Components/LoginScreen/login_button.dart';
import 'package:drive_safe/Screens/profile.dart';
import 'package:drive_safe/constants.dart';
import 'package:flutter/material.dart';

String name = '';

class DrawerWidget extends StatelessWidget {
  final ValueChanged<DrawerItem> onSelectedItem;
  const DrawerWidget({required this.onSelectedItem});

  @override
  Widget build(BuildContext context) {
    getName();
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 10, right: 0),
          child: Container(
            width: 220,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(profilePicURL),
                  radius: 70,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: SizedBox(
                      height: 1,
                      width: size.width,
                      child: const DecoratedBox(
                          decoration: BoxDecoration(
                        color: Colors.white,
                      ))),
                ),
                buildDrawerItems(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getName() async {
    CollectionReference user_info = db.collection('user_info');
    QuerySnapshot<Object?> snapshot =
        await user_info.where(FieldPath.documentId, isEqualTo: currUid).get();
    var data = snapshot.docs[0];
    name = data['Name'];

    // return Text(name);
  }

  Widget buildDrawerItems(BuildContext context) {
    return Column(
      children: DrawerItems.all
          .map(
            (item) => ListTile(
              contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 5),
              leading: Icon(item.icon, color: Colors.white, size: 30),
              title: Text(
                item.title,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                onSelectedItem(item);
              },
            ),
          )
          .toList(),
    );
  }
}

class DrawerItem {
  final String title;
  final IconData icon;
  const DrawerItem({required this.title, required this.icon});
}

class DrawerItems {
  static const home = DrawerItem(title: "Home", icon: Icons.home);
  static const profile =
      DrawerItem(title: "Profile", icon: Icons.account_circle);
  static const vehicle_reg =
      DrawerItem(title: "Registred Vehicles", icon: Icons.commute);
  static const addNewVehicle =
      DrawerItem(title: "Add New  Vehicle", icon: Icons.commute);
  static const speed_limit =
      DrawerItem(title: "Set Speed Limit", icon: Icons.speed);
  static const summary = DrawerItem(title: "Summary", icon: Icons.summarize);
  static const externalCamera =
      DrawerItem(title: "External Camera", icon: Icons.videocam);
  static const setting = DrawerItem(title: "Setting", icon: Icons.settings);
  static const logout = DrawerItem(title: "Log Out", icon: Icons.logout);

  static final List<DrawerItem> all = [
    home,
    profile,
    vehicle_reg,
    addNewVehicle,
    speed_limit,
    summary,
    externalCamera,
    setting,
    logout,
  ];
}
