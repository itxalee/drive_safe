// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  final VoidCallback openDrawer;
  const Setting({
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
            "This is Setting Screen",
            style: TextStyle(
                fontSize: 30,
                color: Colors.white
            ),
          )
      ),
    );
  }
}

