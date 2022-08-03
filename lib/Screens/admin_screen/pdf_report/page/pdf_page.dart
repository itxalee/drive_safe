// ignore_for_file: prefer_const_constructors, avoid_function_literals_in_foreach_calls, avoid_single_cascade_in_expression_statements

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/Methods/toast.dart';

import 'package:drive_safe/constants.dart';
import 'package:flutter/material.dart';
import '../api/pdf_api.dart';
import '../api/pdf_invoice_api.dart';
import '../model/invoice.dart';

String minAge = "0";
String maxAge = "9999999";
String vehicleNameFilter = "";

bool vehicleFilterApplied = false;
bool ageFilterApplied = false;
bool genderFilterApplied = false;

TextEditingController _minAgeController = TextEditingController();
TextEditingController _maxAgeController = TextEditingController();
TextEditingController _vehicleFilterController = TextEditingController();

class PdfPage extends StatefulWidget {
  final VoidCallback openDrawer;
  const PdfPage({required this.openDrawer});
  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;

    var invoice = Invoice();

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
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    "Genarate Pdf Report",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Enter the feilds to filter the report or press Generate Report",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 30),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Min Input
                    Container(
                      width: 80,
                      margin: EdgeInsets.symmetric(vertical: 0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: kPrimaryColor.withAlpha(50),
                      ),
                      child: TextField(
                        controller: _minAgeController,
                        cursorColor: kPrimaryColor,
                        keyboardType: TextInputType.number,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (val) {
                          setState(() {
                            ageFilterApplied = true;
                            vehicleFilterApplied = false;

                            minAge = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Min",
                          border: InputBorder.none,
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
                          EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: kPrimaryColor.withAlpha(50),
                      ),
                      child: TextField(
                        controller: _maxAgeController,
                        cursorColor: kPrimaryColor,
                        keyboardType: TextInputType.number,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (val) {
                          setState(() {
                            ageFilterApplied = true;
                            vehicleFilterApplied = false;

                            maxAge = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Max",
                          border: InputBorder.none,
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
                Center(
                  child: Container(
                    width: 280,
                    margin: EdgeInsets.symmetric(vertical: 0),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
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
                          vehicleNameFilter = val;
                        });
                      },
                      decoration: InputDecoration(
                          hintText: "Enter Vehicle Name",
                          border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                SizedBox(
                  height: 30,
                ),
                MaterialButton(
                    onPressed: () async {
                      var i = 0;
                      Invoice.items = [];

                      print("Age " + ageFilterApplied.toString());
                      print("Vehicel " + vehicleFilterApplied.toString());

                      if (ageFilterApplied == true) {
                        db
                            .collection('captured_data')
                            .where('Age', isGreaterThanOrEqualTo: minAge)
                            .where('Age', isLessThanOrEqualTo: maxAge)
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) async {
                            i++;
                            Invoice.items.add(
                              InvoiceItem(
                                  Name: doc["Name"],
                                  date: doc["Time"],
                                  sleep: doc["Sleep"],
                                  vehicle: doc["Vehicle Name"],
                                  age: doc["Age"],
                                  blinks: doc["Blinks"],
                                  vehicle_speed: doc["Vehicle Speed"],
                                  yawn: doc["Yawn"]),
                            );

                            if (i == querySnapshot.size) {
                              final pdfFile =
                                  await PdfInvoiceApi.generate(invoice);

                              PdfApi.openFile(pdfFile);
                            }
                          });
                        });
                      } else if (vehicleFilterApplied == true) {
                        db
                            .collection('captured_data')
                            .where('Vehicle Name', isEqualTo: vehicleNameFilter)
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) async {
                            i++;
                            Invoice.items.add(
                              InvoiceItem(
                                  Name: doc["Name"],
                                  date: doc["Time"],
                                  sleep: doc["Sleep"],
                                  vehicle: doc["Vehicle Name"],
                                  age: doc["Age"],
                                  blinks: doc["Blinks"],
                                  vehicle_speed: doc["Vehicle Speed"],
                                  yawn: doc["Yawn"]),
                            );

                            if (i == querySnapshot.size) {
                              final pdfFile =
                                  await PdfInvoiceApi.generate(invoice);

                              PdfApi.openFile(pdfFile);
                            }
                          });
                        });
                      } else {
                        await db
                            .collection('captured_data')
                            .orderBy('Name')
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) async {
                            i++;
                            Invoice.items.add(
                              InvoiceItem(
                                  Name: doc["Name"],
                                  date: doc["Time"],
                                  sleep: doc["Sleep"],
                                  vehicle: doc["Vehicle Name"],
                                  age: doc["Age"],
                                  blinks: doc["Blinks"],
                                  vehicle_speed: doc["Vehicle Speed"],
                                  yawn: doc["Yawn"]),
                            );

                            if (i == querySnapshot.size) {
                              final pdfFile =
                                  await PdfInvoiceApi.generate(invoice);

                              PdfApi.openFile(pdfFile);
                            }
                          });
                        });
                      }
                    },
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: kPrimaryColor,
                        ),
                        child: Text(
                          "Generate Report",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                    onPressed: () {
                      setState(() {
                        minAge = "0";
                        maxAge = "999999";
                        vehicleNameFilter = "";

                        genderFilterApplied = false;
                        vehicleFilterApplied = false;
                        ageFilterApplied = false;
                        _minAgeController.clear();
                        _maxAgeController.clear();
                        _vehicleFilterController.clear();
                        ShowToast("Filters are removed");
                      });
                    },
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        // width: size.width*0.8,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.red,
                        ),
                        child: Text(
                          "Reset All Filters",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
