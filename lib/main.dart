import 'package:drive_safe/Screens/login.dart';
import 'package:drive_safe/constants.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';

List<CameraDescription>? cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drive Safe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
      ),
      home: LoginScreen(),
    );
  }
}
