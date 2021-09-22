import 'package:intl/intl.dart';

class Utils {
  static String formatNum(int num, {int point = 3}) {
    if (num < 0) {
      return '---';
    }
    var str = num.toString();
    var result = '';
    var temp = '';
    var index = 0;
    for (var i = str.length-1; i>=0; i--) {
      if (index == 3) {
        temp = temp + ',';
        index = 0;
      }
      index ++;
      temp = temp + str[i];
    }
    for (var i = temp.length-1; i>=0; i--) {
      result = result + temp[i];
    }

    return result;
  }
  static String getFormatStepCount(int stepCount) {
    var format = NumberFormat('0,000');
    return format.format(stepCount);
  }
}