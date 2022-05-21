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
                      .collection('vehicle')
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
                                      onLongPress: () {
                                        alert(ds);
                                      },
                                    )
                                  : null,
                            );
                          });
                    } else if (snapshot.hasError) {
                      return CircularProgressIndicator();
                    } else
                      return CircularProgressIndicator();
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
              title: Text("Delete Vehicle"),
              content: SingleChildScrollView(
                child: Text("Are you sure you want to delete this vehicle"),
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
}
