// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/Methods/toast.dart';
import 'package:drive_safe/Screens/admin_screen/pie_chart/data/pie_data.dart';
import 'package:drive_safe/Screens/admin_screen/pie_chart/page/pie_chart_page.dart';
import 'package:drive_safe/Screens/profile.dart';
import 'package:drive_safe/constants.dart';
import 'package:flutter/material.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';

var totalUsers;
var totalVehicels;
var totalVehType = 0;
DataFromBackend obj = DataFromBackend();

class Dashboard extends StatefulWidget {
  final VoidCallback openDrawer;
  const Dashboard({required this.openDrawer});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  getData() async {
    var veh = 'a';

    try {
      await db.collection('user_info').get().then((value) {
        totalUsers = value.size;
      });
      await db.collection('vehicle_data').get().then((value) {
        totalVehicels = value.size;
      });

      await db
          .collection('vehicle_data')
          .orderBy('Vehicle Name', descending: false)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (veh == doc["Vehicle Name"].toString()) {
          } else {
            veh = doc["Vehicle Name"].toString();
            totalVehType++;
          }
        });
      });
    } on FirebaseException catch (e) {
      ShowToast(e.message.toString());
    }
  }

  @override
  void initState() {
    // WidgetsBinding.instance!.addPostFrameCallback((_) => getData());
    getData();
    obj.get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 90,
                  width: 150,
                  child: Card(
                    elevation: 10,
                    color: kBackgroundColor,
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        totalUsers == null
                            ? CircularProgressIndicator(
                                backgroundColor: kPrimaryColor,
                              )
                            : Text(
                                totalUsers.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40),
                              ),
                        Text(
                          'Registered Users',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 90,
                  width: 150,
                  child: Card(
                    elevation: 10,
                    color: kBackgroundColor,
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        totalVehicels == null
                            ? CircularProgressIndicator(
                                backgroundColor: kPrimaryColor,
                              )
                            : Text(
                                totalVehicels.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40),
                              ),
                        Text(
                          'Registered Vehicles',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
          SizedBox(
            height: 10,
          ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 90,
                  width: 150,
                  child: Card(
                    elevation: 10,
                    color: kBackgroundColor,
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        totalVehType == 0
                            ? CircularProgressIndicator(
                                backgroundColor: kPrimaryColor,
                              )
                            : Text(
                                totalVehType.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40),
                              ),
                        Text(
                          'Type of Vehicles',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 90,
                  width: 150,
                  child: Card(
                    elevation: 10,
                    color: kBackgroundColor,
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          totalVehicels.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        Text(
                          'Number of Registered Vehicles',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
//Graph
          SizedBox(
            height: 320,
            width: 300,
            child: Card(
              elevation: 10,
              color: kBackgroundColor,
              margin: EdgeInsets.all(10),
              child: PieChartPage(),
            ),
          ),

          GestureDetector(
            child: Text("TAP"),
            onTap: () {
              obj.get();
            },
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
