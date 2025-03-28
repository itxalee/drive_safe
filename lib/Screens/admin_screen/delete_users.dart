// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../Components/LoginScreen/login_button.dart';

class DeleteUsers extends StatefulWidget {
  final VoidCallback openDrawer;
  const DeleteUsers({required this.openDrawer});

  @override
  State<DeleteUsers> createState() => _DeleteUsersState();
}

class _DeleteUsersState extends State<DeleteUsers> {
  final TextEditingController _searchController = TextEditingController();
  var searchWord = "";
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
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Delete Users",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Press and hold to delete a user",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 0),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: kPrimaryColor.withAlpha(50),
                    ),
                    child: TextField(
                      controller: _searchController,
                      cursorColor: kPrimaryColor,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (val) {
                        setState(() {
                          searchWord = val;
                        });
                      },
                      decoration: InputDecoration(
                          icon: Icon(Icons.search, color: kPrimaryColor),
                          hintText: "Search...",
                          border: InputBorder.none),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  height: size.height / 1.3,
                  width: size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: db
                        .collection('user_info')
                        .where('Name', isGreaterThanOrEqualTo: searchWord)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: (snapshot.data!).docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds =
                                  (snapshot.data!).docs[index];
                              return Card(
                                  child: ListTile(
                                leading: ds['profileURL'] != ""
                                    ? CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(ds['profileURL']))
                                    : Icon(
                                        Icons.account_circle,
                                        size: 40,
                                        color: kPrimaryColor,
                                      ),
                                title: Text(
                                  'Name: ' + ds['Name'],
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text('Email: ' + ds['Email']),
                                onLongPress: () {
                                  delAlert(ds);
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
                  "Delete User",
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
