import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  ToastUtils._();

  static Future<bool?> show({required String msg, bool bgRed = false}) {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: bgRed ? Colors.red : Colors.green,
      // TODO:
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static Future<bool?> error(String msg) => show(msg: msg, bgRed: true);
}
