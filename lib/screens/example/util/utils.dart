import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils {

  ///邮箱的正则判断
  static bool isEmail(String input) {
    String regexEmail =
        "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}\$";
    if (input == null || input.isEmpty) return false;
    return new RegExp(regexEmail).hasMatch(input);
  }

  ///显示错误共通处理Dialog
  static void showErrorDialog(
      BuildContext context, String errMessage, VoidCallback onPressed) {
    showDialog<AlertDialog>(
        context: context,
        barrierDismissible: false,
        builder: (contextInside) => AlertDialog(
              content: Text(errMessage),
              actions: <Widget>[
                MaterialButton(
                  child: Text('はい'),
                  onPressed: () {
                    onPressed.call();
                    Navigator.pop(contextInside);
                  },
                ),
              ],
            ));
  }

}
