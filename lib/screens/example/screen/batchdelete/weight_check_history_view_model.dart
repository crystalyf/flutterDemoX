import 'dart:math';

import 'package:flutter/material.dart';

import 'sleep_check_data.dart';

class WeightCheckHistoryViewModel extends ChangeNotifier {
  Map<int, PageStorageKey<String>> pageStoreList = {};

  List<SleepCheckData> sleepCheckData = [];

  var pageViewController = PageController();

  var isRightArrowVisible = false;

  var currentDateString = '';

  var isEditMode = false;

  var swipeOpenPos = -1;

  var currentPageEmpty = false;

  void setEditModel() {
    isEditMode = !isEditMode;
    swipeOpenPos = -1;
    notifyListeners();
  }

  bool checkCurrentPageEmpty(int pageIndex, bool needNotify) {
    currentPageEmpty = getListForMonth(pageIndex) == null ||
        getListForMonth(pageIndex).isEmpty;
    if (needNotify) notifyListeners();
    return currentPageEmpty;
  }

  static const String alphabetAndNum =
      'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890';

  WeightCheckHistoryViewModel() {
    for (var i = 0; i < 7; i++) {
      sleepCheckData.add(SleepCheckData(
          date: '2019.3.${i % 31}(水)',
          hours: '${i % 11}',
          minutes: '30',
          startTime: '23:50',
          endTime: '10:20',
          beautyEffectLevel: 4,
          deepSleepLevel: 4,
          shallowSleepLevel: 2,
          obesityPreventionLevel: 1,
          deepSleepRate: 78,
          awakening: 2));
    }
  }

  void setSwipeOpenPos(int cellIndex) {
    swipeOpenPos = cellIndex;
    notifyListeners();
  }

  List<SleepCheckData> getListForMonth(int pageIndex) {
    if (pageIndex > 4) {
      var list = <SleepCheckData>[];
      return list;
    }
    return sleepCheckData;
  }

  void removeCurrentData(int pageIndex, int dataIndex) {
    getListForMonth(pageIndex).removeAt(dataIndex);
    notifyListeners();
  }

  String getDeleteTitleMessage(int pageIndex, int dataIndex) {
    var date = getListForMonth(pageIndex).elementAt(dataIndex).date;
    var startTime = getListForMonth(pageIndex).elementAt(dataIndex).startTime;
    return '$date $startTime';
  }

  PageStorageKey<String> getPageState(int index) {
    var result = pageStoreList[index];
    if (result == null) {
      print('current page null ----$result----$index');
      result = PageStorageKey<String>(getRandomId());
      pageStoreList[index] = result;
    }
    print('current page ----$result----$index');
    return result;
  }

  String getCurrentDateString() {
    var dateTime = DateTime.now();
    var month = dateTime.month.toString();
    var year = dateTime.year.toString();
    if (month.length == 1) {
      month = '0$month';
    }
    if (currentDateString == '') {
      currentDateString = '$year年$month月';
    }
    return currentDateString;
  }

  void changeDateString(int index) {
    var dateTime = DateTime.now();
    var month = dateTime.month;
    var year = dateTime.year;
    var yearOffset = index ~/ 12;
    var monthOffset = index % 12;
    if (monthOffset > month) {
      yearOffset = yearOffset + 1;
      monthOffset = 12 + monthOffset - month;
    }
    var resultYear = (year - yearOffset).toString();
    var resultMonth = (month - monthOffset).toString();

    if (resultMonth.length == 1) {
      resultMonth = '0$resultMonth';
    }
    currentDateString = '$resultYear年$resultMonth月';
    notifyListeners();
  }

  void removePageState(int index, BuildContext context) {
    pageStoreList.removeWhere(
        (key, value) => (key > index + 1 || key < index - 1) && key >= 0);
  }

  void toNextPage() {
    pageViewController.previousPage(
        duration: Duration(milliseconds: 10), curve: Curves.ease);
    print('to next page');
  }

  void toFrontPage() {
    pageViewController.nextPage(
        duration: Duration(milliseconds: 10), curve: Curves.ease);
    print('to front page');
  }

  void changeRightErrorVisibility(int index) {
    isRightArrowVisible = index != 0;
    notifyListeners();
  }

  String getRandomId() {
    var stringLength = 30;
    var result = '';
    for (var i = 0; i < stringLength; i++) {
      result = result + alphabetAndNum[Random().nextInt(alphabetAndNum.length)];
    }
    return result;
  }
}
