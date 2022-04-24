// ignore_for_file: prefer_const_constructors

import 'package:drive_safe/constants.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final VoidCallback openDrawer;
  const Profile({
    required this.openDrawer
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Drive Safe",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            openDrawer();
          },
          icon: const Icon(Icons.menu),color: Colors.white,
        ),
      ),
      body: Center(
          child: Text(
            "This is Profile Screen",
            style: TextStyle(
                fontSize: 30,
                color: Colors.white
            ),
          )
      ),
    );
  }
}

