// ignore_for_file: prefer_const_constructors

import 'package:drive_safe/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

bool blinkWarnSwitch = true;
bool blinSoundSwitch = true;

bool yawnWarnStwich = true;
bool yawnSoundStwich = true;

class Setting extends StatefulWidget {
  final VoidCallback openDrawer;
  const Setting({required this.openDrawer});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

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
          onPressed: () {
            widget.openDrawer();
          },
          icon: const Icon(Icons.menu),
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Text(
                "Settings",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              //Blink Card
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: kBackgroundColor.withAlpha(50),
                    borderRadius: BorderRadius.circular(30)),
                child: Column(
                  children: [
                    Text(
                      "Blinks Setting",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Blinks Warning",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        FlutterSwitch(
                          width: 60.0,
                          height: 35.0,
                          valueFontSize: 14,
                          toggleSize: 25.0,
                          value: blinkWarnSwitch,
                          borderRadius: 30.0,
                          padding: 4.0,
                          activeColor: Colors.green,
                          showOnOff: true,
                          onToggle: (val) {
                            setState(() {
                              blinkWarnSwitch = val;
                              if (val == false) {
                                blinSoundSwitch = val;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Blinks Sound Alert",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Opacity(
                          opacity: blinkWarnSwitch == true ? 1 : 0.4,
                          child: FlutterSwitch(
                            width: 60.0,
                            height: 35.0,
                            valueFontSize: 14.0,
                            toggleSize: 25.0,
                            value: blinSoundSwitch,
                            borderRadius: 30.0,
                            padding: 4.0,
                            activeColor: Colors.green,
                            showOnOff: true,
                            onToggle: (val) {
                              if (blinkWarnSwitch == true) {
                                setState(() {
                                  blinSoundSwitch = val;
                                });
                              } else {
                                null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),

              //Yawn Card
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: kBackgroundColor.withAlpha(50),
                    borderRadius: BorderRadius.circular(30)),
                child: Column(
                  children: [
                    Text(
                      "Yawn Setting",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Yawn Warning",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        FlutterSwitch(
                          width: 60.0,
                          height: 35.0,
                          valueFontSize: 14,
                          toggleSize: 25.0,
                          value: yawnWarnStwich,
                          borderRadius: 30.0,
                          padding: 4.0,
                          activeColor: Colors.green,
                          showOnOff: true,
                          onToggle: (val) {
                            setState(() {
                              yawnWarnStwich = val;
                              if (val == false) {
                                yawnSoundStwich = val;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Yawn Sound Alert",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Opacity(
                          opacity: yawnWarnStwich == true ? 1 : 0.4,
                          child: FlutterSwitch(
                            width: 60.0,
                            height: 35.0,
                            valueFontSize: 14.0,
                            toggleSize: 25.0,
                            value: yawnSoundStwich,
                            borderRadius: 30.0,
                            padding: 4.0,
                            activeColor: Colors.green,
                            showOnOff: true,
                            onToggle: (val) {
                              if (yawnWarnStwich == true) {
                                setState(() {
                                  yawnSoundStwich = val;
                                });
                              } else {
                                null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
