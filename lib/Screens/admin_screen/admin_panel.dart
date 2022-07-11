// ignore_for_file: prefer_const_constructors
import 'package:drive_safe/Methods/toast.dart';
import 'package:drive_safe/Screens/admin_screen/admin_drawer.dart';
import 'package:drive_safe/Screens/admin_screen/dashboard.dart';
import 'package:drive_safe/Screens/login.dart';
import 'package:drive_safe/Screens/profile.dart';
import 'package:drive_safe/Screens/setting.dart';
import 'package:drive_safe/Screens/summary.dart';
import 'package:drive_safe/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  late double xOffSet;
  late double yOffSet;
  late double ScaleFactor;
  late bool isDrawerOpen;
  AdminDrawerItem item = AdminDrawerItems.home;

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
      child: AdminDrawer(
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
      case AdminDrawerItems.logout:
        return LoginScreen();
      case AdminDrawerItems.setting:
        return Setting(openDrawer: openDrawer);
      case AdminDrawerItems.profile:
        return Profile(openDrawer: openDrawer);
      // case AdminDrawerItems.speed_limit:
      //   return SetSpeedLimit(openDrawer: openDrawer);
      // case AdminDrawerItems.addNewVehicle:
      //   return VehicleRegistration(openDrawer: openDrawer);
      // case AdminDrawerItems.vehicle_reg:
      //   return RegisteredVehicles(openDrawer: openDrawer);
      case AdminDrawerItems.summary:
        return Summary(openDrawer: openDrawer);
      case AdminDrawerItems.home:
        return Dashboard(openDrawer: openDrawer);
      default:
        return Dashboard(openDrawer: openDrawer);
    }
  }

  Widget Logout() {
    Future<void> logout() async {
      try {
        final UserCredential = await FirebaseAuth.instance.signOut();
        isLogin = true;

        ShowToast('Logged Out');
      } on FirebaseAuthException catch (e) {
        print(e.code);
        ShowToast(e.code);
      }
    }

    logout();
    return LoginScreen();
  }
}
