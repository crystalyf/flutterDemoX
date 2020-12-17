import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomDoubleTextInputFormatter extends TextInputFormatter {
  static const defaultDouble = 0.001;

  ///允许的小数位数，-1代表不限制位数
  int digit = 1;

  CustomDoubleTextInputFormatter();

  static double strToFloat(String str, [double defaultValue = defaultDouble]) {
    try {
      return double.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }

  ///获取目前的小数位数
  static int getValueDigit(String value) {
    if (value.contains('.')) {
      return value.split('.')[1].length;
    } else {
      return -1;
    }
  }

  ///获取总的数字位数
  static int getValueSize(String value) {
    var result = 0;
      var list = value.split('.');
      if(list.isNotEmpty){
        list.length <2? result = list[0].length: result = list[0].length + (list[1].isNotEmpty? list[1].length: 0);
      }
      return result;
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var value = newValue.text;
    var selectionIndex = newValue.selection.end;
    if (value == '.') {
      value = '0.';
      selectionIndex++;
    } else if (value.isNotEmpty &&
            value != defaultDouble.toString() &&
            strToFloat(value, defaultDouble) == defaultDouble ||
        getValueDigit(value) > digit ||getValueSize(newValue.text)>3) {
      //若小数位大于1，不包含小数点的总的数字位数大于3，那么过滤
      value = oldValue.text;
      selectionIndex = oldValue.selection.end;
    }
    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
