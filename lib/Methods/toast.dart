import 'package:drive_safe/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

void ShowToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
    backgroundColor: kBackgroundColor,
    textColor: kPrimaryColor,
  );
}
