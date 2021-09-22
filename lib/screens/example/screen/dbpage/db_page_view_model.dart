import 'dart:math';

import 'package:flutter/material.dart';

import 'components/feel_check_data.dart';
import 'components/feel_check_sqlite.dart';
import 'components/feel_check_tag_enum.dart';
import 'components/feel_check_time_tag_enum.dart';

class DbPageViewModel extends ChangeNotifier {

  FeelCheckSqlite feelCheckSqlite = new FeelCheckSqlite();
  List<FeelCheckData> datalist ;

  var sceneTypeList = <FeelCheckTag>[
    FeelCheckTag.beforeSleeping,
    FeelCheckTag.wakeUp,
    FeelCheckTag.workHomework,
    FeelCheckTag.physicalEducation,
    FeelCheckTag.hobbiesEntertainment,
    FeelCheckTag.others
  ];
  var timeTypeList = <FeelCheckTimeTag>[
    FeelCheckTimeTag.morning,
    FeelCheckTimeTag.noon,
    FeelCheckTimeTag.afternoon,
    FeelCheckTimeTag.evening
  ];

  DbPageViewModel(){
    insertData();
  }


  void insertData() async{
    await feelCheckSqlite.openSqlite();
    var result = FeelCheckData();
    var rng = Random();
    result.tag =  sceneTypeList[rng.nextInt(6)];
    result.timeType = timeTypeList[rng.nextInt(4)];
    String dateStr;
    DateTime dateTime = DateTime.now();
    if (dateTime.month >= 10) {
      dateStr = dateTime.year.toString() + '-' + dateTime.month.toString();
    } else {
      dateStr = dateTime.year.toString() + '-0' + dateTime.month.toString();
    }
    if (dateTime.day >= 10) {
      dateStr += '-' + rng.nextInt(30).toString() + ',' + '14:36:27';
    } else {
      dateStr += '-0' + rng.nextInt(30).toString() + ',' + '14:36:27';
    }
    result.dateTime = dateStr;
    result.active = rng.nextInt(100);
    result.relax = 100 - result.active;
    result.heartRate = 128;
    await feelCheckSqlite.insert(result);
    //切记用完就close
    await feelCheckSqlite.close();
  }


  void getAll() async{
    await feelCheckSqlite.openSqlite();
    datalist = await feelCheckSqlite.queryAll();
    datalist.forEach((item) {
      print('item:'+item.active.toString()+','+item.relax.toString()+','+item.heartRate.toString()+','+item.dateTime.toString()+', timeType'+item.timeType.toString());
    });
    await feelCheckSqlite.close();
  }





}
