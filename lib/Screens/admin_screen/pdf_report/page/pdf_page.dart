// ignore_for_file: prefer_const_constructors, avoid_function_literals_in_foreach_calls, avoid_single_cascade_in_expression_statements

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/Screens/profile.dart';
import 'package:drive_safe/constants.dart';
import 'package:flutter/material.dart';
import '../api/pdf_api.dart';
import '../api/pdf_invoice_api.dart';
import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';
import '../widget/button_widget.dart';
import '../widget/title_widget.dart';

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TitleWidget(
                icon: Icons.picture_as_pdf,
                text: 'Generate Report',
              ),
              const SizedBox(height: 48),
              ButtonWidget(
                text: 'Generate Report',
                onClicked: () async {
                  var i = 0;

                  Invoice.items = [];
                  db
                    ..collection('captured_data')
                        .orderBy("Name")
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
                          final pdfFile = await PdfInvoiceApi.generate(invoice);

                          PdfApi.openFile(pdfFile);
                        }
                      });
                    });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
