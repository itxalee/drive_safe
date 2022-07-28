// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element, unnecessary_const

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/Components/LoginScreen/login_button.dart';
import 'package:drive_safe/Detection/camera.dart';
import 'package:drive_safe/Methods/toast.dart';
import 'package:drive_safe/Screens/profile.dart';
import 'package:drive_safe/Screens/set_speed_limit.dart';
import 'package:drive_safe/Screens/setting.dart';
import 'package:drive_safe/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:camera/camera.dart';
import 'package:drive_safe/Detection/face_detector_painter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

var Speed = '0';
bool isFloatingPressed = false;
int isDetectionStopped = 0;
String currVehicleName = '';
String currVehicleNo = '';
int sleepCounter = 0;
var startPosition = '';
var endPositin = '';
int warnningCounter = 0;

var pressed = 0;

class HomePage extends StatefulWidget {
  final VoidCallback openDrawer;
  const HomePage({required this.openDrawer});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FaceDetector faceDetector =
      GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
  ));
  late final List<Face> faces;
  bool isBusy = false;
  CustomPaint? customPaint;

  late AudioPlayer player;
  late AudioCache cache;

  bool isAlert = false;
  @override
  void initState() {
    super.initState();

    getAgeName();

    player = AudioPlayer();
    cache = AudioCache(fixedPlayer: player);
    _determinePosition();
  }

  late Timer _yawntimer;
  late Timer _blinktimer;
  int yawnTimerVal = 15;
  int blinkTimerVal = 60;

  void startTimer() {
    const yawnTimer = const Duration(minutes: 1);
    const blinkTimer = const Duration(seconds: 1);
    _yawntimer = Timer.periodic(
      yawnTimer,
      (Timer timer) {
        if (yawnTimerVal == 0) {
          setState(() {
            yawnTimerVal = 15;
            yawnWarn = 0;
          });
        } else {
          setState(() {
            yawnTimerVal--;
          });
        }
      },
    );

    _blinktimer = Timer.periodic(
      blinkTimer,
      (Timer timer) {
        if (blinkTimerVal == 0) {
          setState(() {
            blinkTimerVal = 60;
            blinksWarn = 0;
          });
        } else {
          setState(() {
            blinkTimerVal--;
          });
        }
      },
    );
  }

  //---Location Permisssions---
  var currentposition;
  var currentAddress = '';
  var currentTime = '';

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }

// -------------- GETTING SPEED------------

  Future<void> getSpeed() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    // To Get Time When location updates
    currentTime = position.timestamp!.toLocal().toString();

    setState(() {
      currentposition = position;
      //currentAddress = "${place.street},${place.subLocality},${place.locality}";
      currentAddress =
          position.latitude.toString() + ' , ' + position.longitude.toString();
      Speed = (position.speed * 3.6).toStringAsPrecision(2);
    });
    if (!isFloatingPressed) {
      startPosition = "${place.street},${place.subLocality},${place.locality}";
    }
  }

  //---ALARM ---
  // AudioPlayer audioPlayer = AudioPlayer();
  // String filePath = 'alarm.wav';
  // @override
  // void initState() {
  //   super.initState();
  //   audioPlayer = AudioPlayer();
  // }

  // /// Compulsory
  // playLocal() async {
  //   int result = await audioPlayer.play(filePath, isLocal: true);
  // }

  // /// Compulsory
  // stopMusic() async {
  //   int result = await audioPlayer.stop();
  // }

  @override
  void setState(VoidCallback fn) async {
    super.setState(fn);
    await getSpeed();
  }

  @override
  void dispose() {
    faceDetector.close();
    _blinktimer.cancel();
    _yawntimer.cancel();
    super.dispose();
    // audioPlayer.release();
    // audioPlayer.dispose();
    //super.dispose();
  }

  //END ALARM

  @override
  Widget build(BuildContext context) {
    //Future.delayed(Duration.zero, () => showAlert(context));
    Size size = MediaQuery.of(context).size;
    if (isSleep == true) {
      playMusic();
    }
    if (isAlert == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isSleep == true ? alert() : null;
        double.parse(Speed) > speedLimit ? alert() : null;
        if (yawnTimerVal > 0 && yawnWarn > 3 && yawnWarnStwich == true) {
          yawnSoundStwich == true ? playMusic() : null;
          return yawnAlert();
        } else {
          null;
        }
        if (blinkTimerVal == 0 && blinksWarn < 10 && blinkWarnSwitch == true) {
          blinSoundSwitch == true ? playMusic() : null;
          return blinkAlert();
        } else {
          null;
        }
      });
    }
    if (double.parse(Speed) > speedLimit) {
      playMusic();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Drive Safe",
            style: TextStyle(
              color: kBackgroundColor,
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Center(
            child: isFloatingPressed && currVehicleName != ''
                ? PhysicalModel(
                    elevation: 5,
                    //shadowColor: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                    color: kPrimaryColor.withOpacity(0.6),
                    child: SizedBox(
                      height: size.height / 1.8,
                      width: size.width / 1.1,
                      child: CameraView(
                        customPaint: customPaint,
                        onImage: (inputImage) {
                          processImage(inputImage);
                        },
                        initialDirection: CameraLensDirection.front,
                      ),
                    ),
                  )
                : PhysicalModel(
                    elevation: 5,
                    //shadowColor: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                    color: kPrimaryColor.withOpacity(0.5),
                    child: Container(
                      height: size.height / 1.8,
                      width: size.width / 1.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: kPrimaryColor.withOpacity(0.6),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.videocam,
                              size: 80,
                              color: Colors.white,
                            ),
                            Text(
                              "Press Start button to enable detection",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
          // Text(
          //   eyesOpenClose.toString(),
          //   style: TextStyle(color: Colors.white, fontSize: 20),
          // ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 2),
            alignment: Alignment.bottomLeft,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 90,
                      width: 130,
                      child: Card(
                        elevation: 10,
                        color: kBackgroundColor,
                        margin: EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Blinks',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            Text(
                              blink.toString(),
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 90,
                      width: 130,
                      child: Card(
                        elevation: 10,
                        color: kBackgroundColor,
                        margin: EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Yawn',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            Text(
                              yawnCounter.toString(),
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 90,
                      width: 130,
                      child: Card(
                        elevation: 10,
                        color: kBackgroundColor,
                        margin: EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Warnings',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            Text(
                              warnningCounter.toString(),
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 90,
                      width: 130,
                      child: Card(
                        elevation: 10,
                        color: kBackgroundColor,
                        margin: EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Speed',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            Text(
                              double.parse(Speed) > 10
                                  ? Speed.toString()
                                  : '0.0km/h',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      //Bottom Navigation Bar
      floatingActionButton: SizedBox(
        width: 150,
        child: FloatingActionButton(
          backgroundColor:
              isFloatingPressed == false ? Colors.green : Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          child: isFloatingPressed == false
              ? Text(
                  "Start",
                  style: TextStyle(
                    fontSize: 28,
                  ),
                )
              : Text(
                  "Stop",
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
          onPressed: () async {
            setState(() {
              if (currVehicleName != '') {
                isFloatingPressed = !isFloatingPressed;

                if (!isFloatingPressed) {
                  _yawntimer.cancel();
                  _blinktimer.cancel();
                  createDoc();
                }

                if (isFloatingPressed) {
                  startTimer();
                }

                blink = 0;
                yawnCounter = 0;
                sleepCounter = 0;
                yawnWarn = 0;
                yawnTimerVal = 15;
                warnningCounter = 0;
                blinksWarn = 0;
                blinkTimerVal = 60;
              } else {
                selectVehicle();
              }
            });
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        color: kPrimaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5),
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    dark();
                  },
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          dark();
                        },
                        icon: Icon(
                          Icons.dark_mode,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Screen Off",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          selectVehicle();
                        },
                        icon: Icon(
                          Icons.add_to_home_screen,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Select Vehicle",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = FaceDetectorPainter(
          faces,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  alert() async {
    isAlert = true;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sleep Alert"),
            content: SingleChildScrollView(
              child: Text("You Caught Sleeping, \n Take Some Rest"),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    isAlert = false;
                    stopMusic();
                    sleepCounter++;
                    warnningCounter++;
                  });

                  Navigator.of(context).pop();
                },
                child: Text("Cancle"),
              ),
            ],
          );
        });
  }

  yawnAlert() async {
    isAlert = true;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Center(
                child: Text(
              "Excessive Yawning",
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            )),
            content: SingleChildScrollView(
              child: Text(
                  "You might be feeling Sleepy, \nPlese take some Rest and drink coffee"),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    isAlert = false;
                    stopMusic();
                    yawnWarn = 0;
                    warnningCounter++;
                    yawnTimerVal = 15;
                  });

                  Navigator.of(context).pop();
                },
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 100,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: kPrimaryColor,
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  speedAlert() {
    isAlert = true;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Center(
                child: Text(
              "Overspeeding Warnning",
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            )),
            content: SingleChildScrollView(
              child: Text(
                  "Your speed is greater than the speed limit, \n Slow Down"),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    isAlert = false;
                    stopMusic();
                    warnningCounter++;
                  });

                  Navigator.of(context).pop();
                },
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 100,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: kPrimaryColor,
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  blinkAlert() {
    isAlert = true;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Center(
                child: Text(
              "Drowssy Warnning",
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            )),
            content: SingleChildScrollView(
              child: Text(
                  "You might be feeling Sleepy, \n Plese take some sest and drink coffee"),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    isAlert = false;
                    stopMusic();
                    warnningCounter++;
                    blinksWarn = 0;
                    blinkTimerVal = 60;
                  });
                  Navigator.of(context).pop();
                },
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 100,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: kPrimaryColor,
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  createDoc() {
    DocumentReference doc =
        FirebaseFirestore.instance.collection("captured_data").doc();
    Map<String, dynamic> capturedData = {
      "Name": userName,
      "Age": userAge,
      "Blinks": blink,
      "Yawn": yawnCounter,
      "Sleep": sleepCounter,
      'Vehicle Name': currVehicleName,
      'Vehicle Number': currVehicleNo,
      "Vehicle Speed": Speed,
      'Location': currentAddress,
      'Time': currentTime,
      "id": currUid,
    };
    doc.set(capturedData).whenComplete(() {
      ShowToast('Data uploaded to cloud');
    });
  }

  selectVehicle() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Center(
                child: Text(
              "Select Vehicle",
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            )),
            content: SizedBox(
              height: 250,
              width: 300,
              child: StreamBuilder<QuerySnapshot>(
                stream: db
                    .collection('vehicle_data')
                    .orderBy('Vehicle Name')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: (snapshot.data!).docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = (snapshot.data!).docs[index];
                          return Card(
                            child: currUid == ds['id']
                                ? ListTile(
                                    title: Text(ds['Vehicle Type'] +
                                        ': ' +
                                        ds['Vehicle Name']),
                                    subtitle: Text('Registration Number: ' +
                                        ds['Vehicle Number']),
                                    onTap: () {
                                      setState(() {
                                        currVehicleName = ds['Vehicle Name'];
                                        currVehicleNo =
                                            ds['Vehicle Number'].toString();
                                        print(currVehicleName);
                                        print(currVehicleNo.toString());
                                        ShowToast('Vehicle ' +
                                            ds['Vehicle Name'] +
                                            'is selected');
                                        Navigator.of(context).pop();
                                      });
                                    },
                                  )
                                : null,
                          );
                        });
                  } else if (snapshot.hasError) {
                    return CircularProgressIndicator();
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
            actions: [
              Center(
                child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: 100,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: kPrimaryColor,
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          );
        });
  }

  Future playMusic() async {
    await cache.loop('mp.mp3');
  }

  stopMusic() {
    player.stop();
  }

  dark() {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(20),
              color: Colors.black,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Exit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
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
