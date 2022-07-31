// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/Components/LoginScreen/login_button.dart';
import 'package:drive_safe/constants.dart';
import 'package:flutter/material.dart';

class RegisteredVehicles extends StatefulWidget {
  final VoidCallback openDrawer;
  const RegisteredVehicles({required this.openDrawer});

  @override
  State<RegisteredVehicles> createState() => _RegisteredVehiclesState();
}

class _RegisteredVehiclesState extends State<RegisteredVehicles> {
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
                "Registered Vehicles",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Press and hold to delete vehicles",
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
                      .collection('vehicle_data')
                      .where('id', isEqualTo: currUid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: (snapshot.data!).docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = (snapshot.data!).docs[index];
                            return Card(
                              child: ListTile(
                                title: Text(ds['Vehicle Type'] +
                                    ': ' +
                                    ds['Vehicle Name']),
                                subtitle: Text('Registration Number: ' +
                                    ds['Vehicle Number']),
                                onLongPress: () {
                                  alert(ds);
                                },
                              ),
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

  alert(ds) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title: Center(
                child: Text(
                  "Delete Vehicle",
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
}
