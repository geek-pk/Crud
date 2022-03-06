import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

navigatePushReplacement(context, page) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

navigatePush(context, page) {
  return Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

showToast(String text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
