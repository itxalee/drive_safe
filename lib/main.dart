import 'dart:ffi';

import 'package:drive_safe/Components/LoginScreen/login_button.dart';
import 'package:drive_safe/Screens/admin_screen/admin_panel.dart';
import 'package:drive_safe/Screens/login.dart';
import 'package:drive_safe/Screens/main_page.dart';
import 'package:drive_safe/Screens/profile.dart';
import 'package:drive_safe/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';

import 'firebase_options.dart';

List<CameraDescription>? cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentScreen = LoginScreen();

  @override
  void initState() {
    checkLogedIn();

    super.initState();
  }

  Future<void> checkLogedIn() async {
    String? token = await storage.read(key: "token");
    if (token == "user") {
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if (user != null) {
          currUid = user.uid;
          profilePicURL = await FirebaseStorage.instance
              .ref("profilePic/$currUid")
              .getDownloadURL();
        }
      });
      setState(() {
        currentScreen = MainPage();
      });
    } else if (token == "admin") {
      setState(() {
        currentScreen = AdminPanel();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drive Safe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
      ),
      home: currentScreen,
    );
  }
}
