// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/Components/LoginScreen/login_button.dart';
import 'package:drive_safe/Methods/loading.dart';
import 'package:drive_safe/Methods/toast.dart';
import 'package:drive_safe/cloud/cloud_data.dart';
import 'package:drive_safe/cloud/firebase_cloud_storage.dart';
import 'package:drive_safe/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VehicleRegistration extends StatefulWidget {
  final VoidCallback openDrawer;
  const VehicleRegistration({required this.openDrawer});
  @override
  State<VehicleRegistration> createState() => _VehicleRegistrationState();
}

class _VehicleRegistrationState extends State<VehicleRegistration> {
  late final TextEditingController _vehNameController;
  late final TextEditingController _vehNumController;
  late final TextEditingController _vehModelController;
  late final TextEditingController _vehTypeController;

  @override
  void initState() {
    _vehNameController = TextEditingController();
    _vehNumController = TextEditingController();
    _vehModelController = TextEditingController();
    _vehTypeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _vehNameController.dispose();
    _vehNumController.dispose();
    _vehModelController.dispose();
    _vehTypeController.dispose();
    super.dispose();
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
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(left: 30, right: 30, top: 70),
          height: defualtLoginSize,
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Register New Vehicle",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Enter the following information of your vehicle.',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: kPrimaryColor.withAlpha(50),
                  ),
                  child: TextField(
                    controller: _vehNameController,
                    cursorColor: kPrimaryColor,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        icon: Icon(Icons.directions_car, color: kPrimaryColor),
                        hintText: 'Vehicle Name',
                        border: InputBorder.none),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: kPrimaryColor.withAlpha(50),
                  ),
                  child: TextField(
                    maxLength: 4,
                    controller: _vehNumController,
                    cursorColor: kPrimaryColor,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        icon: Icon(Icons.pin, color: kPrimaryColor),
                        hintText: 'Vehicle Registration Number',
                        border: InputBorder.none,
                        counterText: ''),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: kPrimaryColor.withAlpha(50),
                  ),
                  child: TextField(
                    controller: _vehModelController,
                    maxLength: 4,
                    cursorColor: kPrimaryColor,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      icon: Icon(Icons.calendar_month, color: kPrimaryColor),
                      hintText: 'Vehicle Model',
                      border: InputBorder.none,
                      counterText: '',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: kPrimaryColor.withAlpha(50),
                  ),
                  child: TextField(
                    controller: _vehTypeController,
                    cursorColor: kPrimaryColor,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        icon: Icon(Icons.commute, color: kPrimaryColor),
                        hintText: 'Vehicle Type',
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    if (_vehModelController.text == "" ||
                        _vehNumController.text.length < 4 &&
                            _vehNameController.text == "" &&
                            _vehNumController.text == "" &&
                            _vehTypeController.text == "") {
                      ShowToast("Fill out all feilds");
                    }
                    // else if (_vehNumController.text.length < 4) {
                    //   ShowToast("Vehcie number should be atleast 4 digits");
                    // }
                    else {
                      setState(() async {
                        showLoaderDialog(context, kPrimaryColor);
                        createDoc();
                        Navigator.pop(context);
                        ShowToast("Vehicle Added");
                        _vehModelController.clear();
                        _vehNameController.clear();
                        _vehNumController.clear();
                        _vehTypeController.clear();
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    // width: size.width*0.8,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: kPrimaryColor,
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  createDoc() {
    var name = _vehNameController.text;
    var numb = _vehNumController.text;
    var model = _vehModelController.text;
    var type = _vehTypeController.text;

    DocumentReference doc =
        FirebaseFirestore.instance.collection("vehicle_data").doc();
    Map<String, dynamic> vehicles = {
      "Vehicle Name": name,
      "Vehicle Number": numb,
      "Vehicle Model": model,
      "Vehicle Type": type,
      "id": currUid,
    };
    doc.set(vehicles).whenComplete(() => null);
  }
}
