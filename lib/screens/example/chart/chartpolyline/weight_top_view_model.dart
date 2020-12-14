import 'package:flutter/cupertino.dart';
import 'package:flutter_demox/screens/example/timepicker/components/weight_data.dart';
import 'package:flutter_demox/screens/example/timepicker/components/weight_sqlite.dart';
import 'package:intl/intl.dart';

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

  WeightSqlite weightSqlite = WeightSqlite();
  List<WeightData> dataList;

  //WeightRecord
  bool isActiveRegisterButton = false;
  String birthday;
  final birthdayController = TextEditingController();

  WeightTopViewModel() {
    getData();
  }

  @override
  void dispose() {
    birthdayController.dispose();
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

  Future<void> insertData() async {
    await weightSqlite.openSqlite();
    var result = WeightData();
    result.year = 2020;
    result.month = 12;
    result.day = 11;
    result.weightValue = 65;
    await weightSqlite.insert(result);
    //切记用完就close
    await weightSqlite.close();
  }

  Future<void> getAll() async {
    await weightSqlite.openSqlite();
    dataList = await weightSqlite.queryAll();
    dataList.forEach((item) {
      print('item:' +
          item.year.toString() +
          ',' +
          item.month.toString() +
          ',' +
          item.day.toString() +
          ',' +
          item.weightValue.toString());
    });
    await weightSqlite.close();
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

  ///从这开始，都是体重记录页面用的函数：
  void onTapBirthdayForm() {
    if (birthdayController.text == '') {
      onSelectBirthdayPickerItem(DateTime.now());
    }
  }

  ///选中日期后的回调
  void onSelectBirthdayPickerItem(DateTime value) {
    birthdayController.text = _formatDate(value);
    isActiveRegisterButton = true;
    notifyListeners();
  }

  ///日期格式化
  String _formatDate(DateTime time) {
    var formatter = DateFormat('yyyy年MMMd日', 'ja_JP');
    return formatter.format(time);
  }
}
