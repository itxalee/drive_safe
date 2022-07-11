// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/Components/LoginScreen/login_button.dart';
import 'package:drive_safe/constants.dart';
import 'package:flutter/material.dart';

class Summary extends StatefulWidget {
  final VoidCallback openDrawer;
  const Summary({required this.openDrawer});

  @override
  State<Summary> createState() => _RegisteredVehiclesState();
}

class _RegisteredVehiclesState extends State<Summary> {
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
              Container(
                padding: EdgeInsets.only(left: 30, right: 30, top: 0),
                height: defualtLoginSize,
                width: size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: db
                      .collection('captured_data')
                      .orderBy('Time')
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
            ]),
      ),
    );
  }

  delAlert(ds) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Delete Record"),
              content: SingleChildScrollView(
                child: Text("Are you sure you want to delete this record?"),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
                MaterialButton(
                  onPressed: () {
                    ds.reference.delete();
                    Navigator.of(context).pop();
                  },
                  child: Text("Yes"),
                ),
              ]);
        });
  }

  summaryDetails(ds) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Details"),
            content: SizedBox(
              height: 200.0,
              width: 300.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancle"),
              ),
            ],
          );
        });
  }
}
