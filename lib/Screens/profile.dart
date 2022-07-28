// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/Components/LoginScreen/login_button.dart';
import 'package:drive_safe/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

String profilePicURL = '';
final db = FirebaseFirestore.instance;

class Profile extends StatefulWidget {
  final VoidCallback openDrawer;
  const Profile({required this.openDrawer});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _genderController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _genderController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
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
        child: Container(
          padding: EdgeInsets.only(left: 30, right: 30, top: 0),
          height: defualtLoginSize,
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Personal Profile",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 115,
                    width: 115,
                    child: Stack(
                      fit: StackFit.expand,
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(profilePicURL),
                        ),
                        Positioned(
                          right: -16,
                          bottom: 0,
                          child: SizedBox(
                            height: 46,
                            width: 46,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: BorderSide(color: Colors.white),
                                ),
                                primary: Colors.white,
                                backgroundColor: Color(0xFFF5F6F9),
                              ),
                              onPressed: () async {
                                final profileImage = await ImagePicker()
                                    .pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 75);
                                FirebaseStorage storage =
                                    FirebaseStorage.instanceFor(
                                        bucket:
                                            "gs://drivesafe-project.appspot.com/");
                                Reference ref = FirebaseStorage.instance
                                    .ref()
                                    .child("profilePic/$currUid");

                                await ref.putFile(File(profileImage!.path));

                                ref.getDownloadURL().then((value) {
                                  setState(() {
                                    profilePicURL = value;

                                    FirebaseFirestore.instance
                                        .collection("user_info")
                                        .doc(currUid)
                                        .update({'profileURL': profilePicURL});
                                  });
                                });
                              },
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 0),
                  height: defualtLoginSize,
                  width: size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: db
                        .collection('user_info')
                        .where("id", isEqualTo: currUid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: (snapshot.data!).docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds =
                                  (snapshot.data!).docs[index];

                              return Column(
                                children: [
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.account_circle,
                                        size: 40,
                                      ),
                                      subtitle: Text(
                                        ds['Name'],
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 20,
                                        ),
                                      ),
                                      title: Text(
                                        'Name',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ),
                                  Card(
                                    child: currUid == ds['id']
                                        ? ListTile(
                                            leading: Icon(
                                              Icons.email,
                                              size: 40,
                                            ),
                                            subtitle: Text(
                                              ds['Email'],
                                              style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: 20,
                                              ),
                                            ),
                                            title: Text(
                                              'Email',
                                              style: TextStyle(
                                                  color: Colors.black54),
                                            ),
                                          )
                                        : null,
                                  ),
                                  Card(
                                    child: currUid == ds['id']
                                        ? ListTile(
                                            leading: Icon(
                                              Icons.date_range,
                                              size: 40,
                                            ),
                                            subtitle: Text(
                                              ds['Age'],
                                              style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: 20,
                                              ),
                                            ),
                                            title: Text(
                                              'Age',
                                              style: TextStyle(
                                                  color: Colors.black54),
                                            ),
                                          )
                                        : null,
                                  ),
                                  Card(
                                    child: currUid == ds['id']
                                        ? ListTile(
                                            leading: Icon(
                                              Icons.supervised_user_circle,
                                              size: 40,
                                            ),
                                            subtitle: Text(
                                              ds['Gender'],
                                              style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: 20,
                                              ),
                                            ),
                                            title: Text(
                                              'Gender',
                                              style: TextStyle(
                                                  color: Colors.black54),
                                            ),
                                          )
                                        : null,
                                  ),
                                ],
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // createDoc() {
  //   var name = _nameController.text;
  //   var age = _ageController.text;
  //   var gender = _genderController.text;
  //   DocumentReference doc =
  //       FirebaseFirestore.instance.collection("user_info").doc(name);
  //   Map<String, dynamic> userInfo = {
  //     "Name": name,
  //     "Ager": age,
  //     "Gender": gender,
  //   };
  //   doc.set(userInfo).whenComplete(() => null);
  // }

  Future<String> downloadURL() async {
    String downloadURL = await FirebaseStorage.instance
        .ref("profilePic/$currUid")
        .getDownloadURL();
    return downloadURL;
  }
}
