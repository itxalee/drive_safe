// ignore_for_file: prefer_const_constructors
import 'package:drive_safe/Components/Home/drawer_widget.dart';
import 'package:drive_safe/Components/LoginScreen/login_button.dart';
import 'package:drive_safe/Methods/toast.dart';
import 'package:drive_safe/Screens/login.dart';
import 'package:drive_safe/Screens/profile.dart';
import 'package:drive_safe/Screens/registered_vehicles.dart';
import 'package:drive_safe/Screens/set_speed_limit.dart';
import 'package:drive_safe/Screens/setting.dart';
import 'package:drive_safe/Screens/new_vehicle_reg.dart';
import 'package:drive_safe/Screens/summary.dart';
import 'package:drive_safe/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late double xOffSet;
  late double yOffSet;
  late double ScaleFactor;
  late bool isDrawerOpen;
  DrawerItem item = DrawerItems.home;

  void openDrawer() {
    setState(() {
      xOffSet = 230;
      yOffSet = 150;
      ScaleFactor = 0.6;
      isDrawerOpen = true;
    });
  }

  void closeDrawer() {
    setState(() {
      xOffSet = 0;
      yOffSet = 0;
      ScaleFactor = 1;
      isDrawerOpen = false;
    });
  }

  @override
  void initState() {
    super.initState();
    closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Stack(
        children: [
          buildDrawer(),
          buildPage(),
        ],
      ),
    );
  }

  Widget buildDrawer() {
    return SafeArea(
        child: SizedBox(
      width: isDrawerOpen ? xOffSet : null,
      child: DrawerWidget(
        onSelectedItem: (item) {
          setState(() {
            this.item = item;
          });
          closeDrawer();
        },
      ),
    ));
  }

  Widget buildPage() {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();
          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
        onTap: () {
          closeDrawer();
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          transform: Matrix4.translationValues(xOffSet, yOffSet, 0)
            ..scale(ScaleFactor),
          child: AbsorbPointer(
            absorbing: isDrawerOpen,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDrawerOpen ? 25 : 0),
              child: Container(
                color: isDrawerOpen ? Colors.white12 : kPrimaryColor,
                child: SwitchPages(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget SwitchPages() {
    switch (item) {
      case DrawerItems.logout:
        return Logout();
      case DrawerItems.setting:
        return Setting(openDrawer: openDrawer);
      case DrawerItems.profile:
        return Profile(openDrawer: openDrawer);
      case DrawerItems.speed_limit:
        return SetSpeedLimit(openDrawer: openDrawer);
      case DrawerItems.addNewVehicle:
        return VehicleRegistration(openDrawer: openDrawer);
      case DrawerItems.vehicle_reg:
        return RegisteredVehicles(openDrawer: openDrawer);
      case DrawerItems.summary:
        return Summary(openDrawer: openDrawer);
      case DrawerItems.home:
        return HomePage(openDrawer: openDrawer);
      default:
        return HomePage(openDrawer: openDrawer);
    }
  }

  Widget Logout() {
    Future<void> logout() async {
      try {
        await storage.delete(key: "token");
        await storage.delete(key: "userCredential");
        await storage.delete(key: "currentId");

        isLogin = true;
        currVehicleName = '';
        ShowToast('Logged Out');
        final UserCredential =
            await FirebaseAuth.instance.signOut().then((value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
              (route) => false);
        });
      } on FirebaseAuthException catch (e) {
        print(e.code);
        ShowToast(e.code);
      }
    }

    logout();
    return LoginScreen();
  }
}
