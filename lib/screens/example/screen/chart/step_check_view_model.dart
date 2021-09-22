import 'package:flutter/cupertino.dart';

import 'chartcolumn/widget/chart_widget.dart';

class CheckViewModel extends ChangeNotifier {
  var currentTimeDurationDays = 0;
  var hasNextButton = false;
  var hasBackButton = true;
  var hasPermission = true;

  List<ColumnData> doubleList;
  var totalStep = 0;

  ChartLayoutType type = ChartLayoutType.day;

  CheckViewModel() {
    getData();
  }

  void getData() {
    var current = DateTime.now();
    var start = DateTime(current.year, current.month, current.day, 0, 0);
    DateTime startTime;
    DateTime endTime;
    doubleList = [];
    switch (type) {
      case ChartLayoutType.day:
        startTime = start.subtract(Duration(days: currentTimeDurationDays));
        endTime = startTime.subtract(Duration(hours: -24));
        //TODO: 造数据
        doubleList.clear();
        var data1 = ColumnData(mount: 100, date: 'aaaaaa');
        doubleList.add(data1);
        var data2 = ColumnData(mount: 170, date: 'bbbb');
        doubleList.add(data2);
        var data3 = ColumnData(mount: 230, date: 'ccc');
        doubleList.add(data3);
        break;
      case ChartLayoutType.week:
        var monday = start.subtract(Duration(days: start.weekday));
        startTime =
            monday.subtract(Duration(days: 7 * currentTimeDurationDays));
        endTime = startTime.subtract(Duration(days: -7));
        //TODO: 造数据
        doubleList.clear();
        var data1 = ColumnData(mount: 140, date: '140步');
        doubleList.add(data1);
        var data2 = ColumnData(mount: 80, date: '80步');
        doubleList.add(data2);
        var data3 = ColumnData(mount: 10, date: '10步');
        doubleList.add(data3);
        break;
      case ChartLayoutType.month:
        startTime = DateTime(
            current.year, current.month - currentTimeDurationDays, 1, 0, 0);
        endTime = DateTime(startTime.year, startTime.month + 1, 1, 0, 0);
        //TODO: 造数据
        doubleList.clear();
        var data1 = ColumnData(mount: 60, date: 'aaaaaa');
        doubleList.add(data1);
        var data2 = ColumnData(mount: 170, date: 'bbbb');
        doubleList.add(data2);
        var data3 = ColumnData(mount: 240, date: 'ccc');
        doubleList.add(data3);
        break;
      case ChartLayoutType.year:
        startTime = DateTime(current.year, 1, 1, 0, 0);
        endTime = DateTime(current.year + 1, 1, 1, 0, 0);
        //TODO: 造数据
        doubleList.clear();
        var data1 = ColumnData(mount: 300, date: 'aaaaaa');
        doubleList.add(data1);
        var data2 = ColumnData(mount: 400, date: 'bbbb');
        doubleList.add(data2);
        var data3 = ColumnData(mount: 500, date: 'ccc');
        doubleList.add(data3);
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
    getData();
  }

  void changeText(int i) {
    switch (i) {
      case 0:
        {
          type = ChartLayoutType.day;
          break;
        }
      case 1:
        {
          type = ChartLayoutType.week;
          break;
        }
      case 2:
        {
          type = ChartLayoutType.month;
          break;
        }
      case 3:
        {
          type = ChartLayoutType.year;
          break;
        }
    }
    currentTimeDurationDays = 0;
    hasNextButton = false;
    hasBackButton = true;
    getData();
  }
}
