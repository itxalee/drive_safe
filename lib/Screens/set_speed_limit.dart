// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:drive_safe/Methods/toast.dart';
import 'package:drive_safe/constants.dart';
import 'package:flutter/material.dart';

int speedLimit = 1000;

class SetSpeedLimit extends StatefulWidget {
  final VoidCallback openDrawer;
  const SetSpeedLimit({required this.openDrawer});

  @override
  State<SetSpeedLimit> createState() => _SetSpeedLimitState();
}

class _SetSpeedLimitState extends State<SetSpeedLimit> {
  late final TextEditingController _speedController;

  @override
  void initState() {
    _speedController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _speedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double viewInsets = MediaQuery.of(context).viewInsets.bottom;
    double defualtLoginSize = size.height - (size.height * 0.2);
    double defualtRegisterSize = size.height - (size.height * 0.1);
    return Scaffold(
      backgroundColor: kBackgroundColor,
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
        backgroundColor: kPrimaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            widget.openDrawer();
          },
          icon: const Icon(Icons.menu),
          color: Colors.white,
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 30, right: 30, top: 70),
        height: defualtLoginSize,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Set Speed Limit",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              'This will give a warnning message when driver crosses the selected speed limit.',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: kPrimaryColor.withAlpha(50),
              ),
              child: TextField(
                controller: _speedController,
                cursorColor: kPrimaryColor,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    icon: Icon(Icons.speed, color: kPrimaryColor),
                    hintText: 'Enter Speed',
                    border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                print('Speed Lmit is -------------' +
                    _speedController.text.toString());
                setState(() {
                  speedLimit = int.parse(_speedController.text);
                  ShowToast('Speed Limit set to ' + speedLimit.toString());
                  _speedController.clear();
                });
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
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
