import 'package:drive_safe/Screens/admin_screen/pdf_report/model/customer.dart';
import 'package:drive_safe/Screens/admin_screen/pdf_report/model/supplier.dart';

class Invoice {
  static List<InvoiceItem> items = [];
}

// class InvoiceInfo {
//   final String description;
//   final String number;
//   final DateTime date;
//   final DateTime dueDate;

//   const InvoiceInfo({
//     required this.description,
//     required this.number,
//     required this.date,
//     required this.dueDate,
//   });
// }

class InvoiceItem {
  final String Name;
  final String date;
  final int sleep;
  final String age;
  final String vehicle;
  final String vehicle_speed;
  final int blinks;
  final int yawn;

  InvoiceItem({
    required this.Name,
    required this.date,
    required this.sleep,
    required this.age,
    required this.vehicle,
    required this.vehicle_speed,
    required this.blinks,
    required this.yawn,
  });
}
