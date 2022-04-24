// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:audioplayers/audioplayers.dart';
import 'package:drive_safe/Detection/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:camera/camera.dart';
import 'package:drive_safe/Detection/face_detector_painter.dart';
import '../Methods/speed.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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
    player = AudioPlayer();
    cache = AudioCache(fixedPlayer: player);
  }

  //---L0cation Permisssions---
  var currentposition;
  var currentAddress = '';
  var Speed = '0.0';
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
    // List<Placemark> placemarks =
    //     await placemarkFromCoordinates(position.latitude, position.longitude);

    // Placemark place = placemarks[0];

    // To Get Time When location updates
    currentTime = position.timestamp!.toLocal().toString();

    setState(() {
      currentposition = position;
      // currentAddress = "${place.street},${place.subLocality},${place.locality}";
      currentAddress =
          position.latitude.toString() + ' , ' + position.longitude.toString();
      Speed = position.speed.toStringAsPrecision(2);
    });
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
    super.dispose();
    // audioPlayer.release();
    // audioPlayer.dispose();
    //super.dispose();
  }

  //END ALARM

  bool isFloatingPressed = false;
  @override
  Widget build(BuildContext context) {
    //Future.delayed(Duration.zero, () => showAlert(context));
    Size size = MediaQuery.of(context).size;
    if (isSleep == true) {
      playMusic();
    }
    if (isAlert == false) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        isSleep == true ? alert() : null;
      });
    }
    // isAlert == false
    //     ? WidgetsBinding.instance!.addPostFrameCallback((_) {
    //         isSleep == true ? alert() : null;
    //       })
    //     : null;

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: isFloatingPressed
                ? CameraView(
                    customPaint: customPaint,
                    onImage: (inputImage) {
                      processImage(inputImage);
                    },
                    initialDirection: CameraLensDirection.front,
                  )
                : Container(
                    height: size.height / 1.5,
                    width: size.width / 1.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black26,
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
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          // Text(
          //   eyesOpenClose.toString(),
          //   style: TextStyle(color: Colors.white, fontSize: 20),
          // ),

          Text(
            "You Blinked " + blink.toString() + " Times",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            "yawn: " + yawnCounter.toString(),
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            'Speed: ' + Speed,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            // isSleep.toString(),
            'Location: ' + currentAddress,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            'Time : ' + currentTime,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),

      //Bottom Navigation Bar
      floatingActionButton: Container(
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
          onPressed: () {
            setState(() {
              isFloatingPressed = !isFloatingPressed;
              blink = 0;
              yawnCounter = 0;
              _determinePosition();
            });
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        color: Colors.black26,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5),
          child: Container(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Preview",
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
                        onPressed: () {},
                        icon: Icon(
                          Icons.add_to_home_screen,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Pop Up",
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
                  Navigator.of(context).pop();
                  isAlert = false;
                  stopMusic();
                },
                child: Text("Cancle"),
              ),
            ],
          );
        });
  }

  Future playMusic() async {
    //cache.play('mp.mp3');
    await cache.loop('mp.mp3');
  }

  stopMusic() {
    player.pause();
  }
}
