// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/Components/LoginScreen/login_button.dart';
import 'package:drive_safe/Components/LoginScreen/rounded_input.dart';
import 'package:drive_safe/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AdminSummary extends StatefulWidget {
  final VoidCallback openDrawer;
  const AdminSummary({required this.openDrawer});

  @override
  State<AdminSummary> createState() => _AdminSummaryState();
}

class _AdminSummaryState extends State<AdminSummary> {
  String minAge = "0";
  String maxAge = "9999999";
  String vehicleNameFilter = "";
  bool vehicleFilterApplied = false;
  bool ageFilterApplied = false;

  TextEditingController _minAgeController = TextEditingController();
  TextEditingController _maxAgeController = TextEditingController();
  TextEditingController _vehicleFilterController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;

    Size size = MediaQuery.of(context).size;
    double defualtLoginSize = size.height - (size.height * 0.2);
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Report of User",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Press and hold to delete the data",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 230, right: 25),
                  child: GestureDetector(
                      onTap: () {
                        filter();
                      },
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          // width: size.width*0.8,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: kPrimaryColor,
                          ),
                          child: Text(
                            "Apply Filters",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      )),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 0),
                  height: defualtLoginSize,
                  width: size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: ageFilterApplied == true
                        ? db
                            .collection('captured_data')
                            .where('Age', isGreaterThanOrEqualTo: minAge)
                            .where('Age', isLessThanOrEqualTo: maxAge)
                            .snapshots()
                        : vehicleFilterApplied == true
                            ? db
                                .collection('captured_data')
                                .where('Vehicle Name',
                                    isEqualTo: vehicleNameFilter)
                                .snapshots()
                            : db.collection('captured_data').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: (snapshot.data!).docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds =
                                  (snapshot.data!).docs[index];
                              return Card(
                                  child: ListTile(
                                title: Text('No. of blinks countted: ' +
                                    ds['Blinks'].toString()),
                                subtitle: Text('No. of yawn countted: ' +
                                    ds['Yawn'].toString()),
                                onLongPress: () {
                                  delAlert(ds);
                                },
                                onTap: () {
                                  docId = ds.id;
                                  summaryDetails(ds);
                                },
                              ));
                            });
                      } else if (snapshot.hasError) {
                        return SpinKitChasingDots(
                          color: kPrimaryColor,
                        );
                      } else {
                        return SpinKitChasingDots(
                          color: kPrimaryColor,
                        );
                      }
                    },
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  delAlert(ds) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title: Center(
                child: Text(
                  "Delete Record",
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
              content: SingleChildScrollView(
                child: Text("Are you sure you want to delete this record?"),
              ),
              actions: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            width: 80,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.red,
                            ),
                            child: Text(
                              "No",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        )),
                    MaterialButton(
                        onPressed: () {
                          ds.reference.delete();
                          Navigator.of(context).pop();
                        },
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            width: 80,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: kPrimaryColor,
                            ),
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ]);
        });
  }

  filter() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title: Center(
                child: Text(
                  "Apply Filters",
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Age Filter:",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: kPrimaryColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        //Min Input
                        Container(
                          width: 80,
                          margin: EdgeInsets.symmetric(vertical: 0),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kPrimaryColor.withAlpha(50),
                          ),
                          child: TextField(
                            maxLength: 2,
                            controller: _minAgeController,
                            cursorColor: kPrimaryColor,
                            keyboardType: TextInputType.number,
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (val) {
                              setState(() {
                                ageFilterApplied = true;
                                vehicleFilterApplied = false;
                                //minAge = val;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Min",
                              border: InputBorder.none,
                              counterText: '',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "-",
                          style: TextStyle(fontSize: 30),
                        ),
                        SizedBox(
                          width: 20,
                        ),

                        //Max Input
                        Container(
                          width: 80,
                          margin: EdgeInsets.symmetric(vertical: 0),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kPrimaryColor.withAlpha(50),
                          ),
                          child: TextField(
                            maxLength: 2,
                            controller: _maxAgeController,
                            cursorColor: kPrimaryColor,
                            keyboardType: TextInputType.number,
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (val) {
                              setState(() {
                                ageFilterApplied = true;
                                vehicleFilterApplied = false;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Max",
                              border: InputBorder.none,
                              counterText: '',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Vehicle Filter:",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: kPrimaryColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //Vehicle Filter
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: kPrimaryColor.withAlpha(50),
                      ),
                      child: TextField(
                        controller: _vehicleFilterController,
                        cursorColor: kPrimaryColor,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (val) {
                          setState(() {
                            vehicleFilterApplied = true;
                            ageFilterApplied = false;
                            _maxAgeController.clear();
                            _minAgeController.clear();
                            //vehicleNameFilter = val;
                          });
                        },
                        decoration: InputDecoration(
                            hintText: "Enter Vehicle Name",
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                MaterialButton(
                    onPressed: () {
                      setState(() {
                        if (ageFilterApplied == true) {
                          minAge = _minAgeController.text;
                          maxAge = _maxAgeController.text;
                        } else if (vehicleFilterApplied == true) {
                          vehicleNameFilter = _vehicleFilterController.text;
                        }
                        Navigator.of(context).pop();
                      });
                    },
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: kPrimaryColor,
                        ),
                        child: Text(
                          "Apply Filters",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )),
                MaterialButton(
                    onPressed: () {
                      setState(() {
                        minAge = "0";
                        maxAge = "999999";
                        vehicleNameFilter = "";
                        vehicleFilterApplied = false;
                        ageFilterApplied = false;
                        _minAgeController.clear();
                        _maxAgeController.clear();
                        _vehicleFilterController.clear();
                        Navigator.of(context).pop();
                      });
                    },
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        // width: size.width*0.8,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.red,
                        ),
                        child: Text(
                          "Reset All",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )),
              ]);
        });
  }

  summaryDetails(ds) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Center(
                child: Text(
              "Details",
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            )),
            content: SizedBox(
              height: 240.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: " + ds["Name"]),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Age: " + ds["Age"]),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Time: " + ds["Time"]),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Location:  " + ds["Location"]),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Vehicle Name: " + ds["Vehicle Name"]),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Vehicle Numbere: " + ds["Vehicle Number"].toString()),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Vehicle Speed: " + ds["Vehicle Speed"].toString()),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Yawn: " + ds["Yawn"].toString()),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Blinks: " + ds["Blinks"].toString()),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Sleep: " + ds["Sleep"].toString()),
                ],
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
}
