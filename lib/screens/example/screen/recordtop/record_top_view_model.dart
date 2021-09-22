import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordTopViewModel extends ChangeNotifier {
  bool isHaveEatData = true;
  bool isHaveStepData = false;
  bool isHaveWeightData = false;
  bool isHaveFeelData = false;
  bool isHaveSleepData = false;
  bool isHaveHealthAgeData = false;
  bool isHaveHealthDiagnosisData = false;

  var stepCount = 1000002;
  var weightNumber = 200;
  var healthAge = 39.5;
  var healthDiagnosisAge = 41;
  var feelHour = 74;
  var feelMinute = 26;
  var sleepHour = 10;
  var sleepMinute = 30;
  var currentDate = '2019.4.8(日)';
  var diagnosisDate = '2018.3.12';
  var totalKCal = 1800;

  RecordTopViewModel();

  void getStep() {}

  void getEatData() {}

  void getWeightData() {}

  void getFeelData() {}

  void getSleepData() {}

  void getHealthAge() {}

  void getHealthDiagnosisData() {}

  ///カンマで区切られた数千
  String getFormatStepCount() {
    var format = NumberFormat('0,000');
    return format.format(stepCount);
  }
}
