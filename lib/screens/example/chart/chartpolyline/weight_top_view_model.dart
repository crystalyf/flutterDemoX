import 'package:flutter/cupertino.dart';

import 'widget/poly_line_data.dart';
import 'widget/poly_type_enum.dart';

class WeightTopViewModel extends ChangeNotifier {
  var currentTimeDurationDays = 0;
  var hasNextButton = false;
  var hasBackButton = true;
  var hasPermission = true;

  DateTime weightSundayDateTime;

  //ポリラインドットデータソース
  List<PolyLineData> polyPointList = [];

  PolyLayoutType polyType = PolyLayoutType.week;
  bool polyRefreshFlag = false;
  TapDownDetails details;

  WeightTopViewModel() {
    getData();
  }

  void getData() {
    var current = DateTime.now();
    var start = DateTime(current.year, current.month, current.day, 0, 0);
    DateTime startTime;
    DateTime endTime;
    switch (polyType) {
      case PolyLayoutType.week:
        var monday = start.subtract(Duration(days: start.weekday));
        startTime =
            monday.subtract(Duration(days: 7 * currentTimeDurationDays));
        endTime = startTime.subtract(Duration(days: -7));
        //TODO: false data
        polyPointList.clear();
        var data11 = PolyLineData(mount: 65.0, date: '12.6');
        polyPointList.add(data11);
        var data22 = PolyLineData(mount: 73.0, date: '12.9');
        polyPointList.add(data22);
        var data33 = PolyLineData(mount: 68.0, date: '12.10');
        polyPointList.add(data33);
        var data44 = PolyLineData(mount: 76.0, date: '12.11');
        polyPointList.add(data44);
        break;
      case PolyLayoutType.month:
        startTime = DateTime(
            current.year, current.month - currentTimeDurationDays, 1, 0, 0);
        endTime = DateTime(startTime.year, startTime.month + 1, 1, 0, 0);
        //TODO: false data
        polyPointList.clear();
        var data11 = PolyLineData(mount: 65.0, date: '12.6');
        polyPointList.add(data11);
        var data22 = PolyLineData(mount: 73.0, date: '12.9');
        polyPointList.add(data22);
        var data33 = PolyLineData(mount: 68.0, date: '12.10');
        polyPointList.add(data33);
        var data44 = PolyLineData(mount: 76.0, date: '12.11');
        polyPointList.add(data44);
        break;
      case PolyLayoutType.year:
        startTime = DateTime(current.year, 1, 1, 0, 0);
        endTime = DateTime(current.year + 1, 1, 1, 0, 0);
        //TODO: false data
        polyPointList.clear();
        var data11 = PolyLineData(mount: 282.0, date: '12.3');
        polyPointList.add(data11);
        var data22 = PolyLineData(mount: 254.0, date: '12.4');
        polyPointList.add(data22);
        var data33 = PolyLineData(mount: 231.0, date: '12.6');
        polyPointList.add(data33);
        break;
    }
    //data = _repository.getStepData(type, startTime, endTime);
  }

  void changeDuration(bool isForward) {
    if (isForward) {
      currentTimeDurationDays--;
    } else {
      currentTimeDurationDays++;
    }
    if (currentTimeDurationDays <= 0) {
      hasNextButton = false;
    } else {
      hasNextButton = true;
    }
    if (currentTimeDurationDays > 10) {
      hasBackButton = false;
    } else {
      hasBackButton = true;
    }
    refreshPoly();
  }

  void changePolyText(int i) {
    switch (i) {
      case 0:
        {
          polyType = PolyLayoutType.week;
          break;
        }
      case 1:
        {
          polyType = PolyLayoutType.month;
          break;
        }
      case 2:
        {
          polyType = PolyLayoutType.year;
          break;
        }
    }
    currentTimeDurationDays = 0;
    hasNextButton = false;
    hasBackButton = true;
    refreshPoly();
  }

  void refreshPoly() {
    getData();
    polyRefreshFlag = !polyRefreshFlag;
    details = null;
    notifyListeners();
  }
}
