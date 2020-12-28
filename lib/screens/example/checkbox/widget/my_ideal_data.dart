

import 'click_item_model.dart';

class MyIdealData {
  MyIdealData(
      {this.date = '',
      this.duration = '',
      this.wight = '',
      this.chest = '',
      this.stomach = '',
      this.hip = '',
      this.arm = '',
      this.leg = '',
      this.chef = '',
      this.ankle = '',
      this.wantToBeTypeList});

  List<ClickItemModel> wantToBeTypeList;

  String date;
  String duration;
  String wight;
  String chest;
  String stomach;
  String hip;
  String arm;
  String leg;
  String chef;
  String ankle;

  String get resultWeight {
    return wight.isNotEmpty ? '$wight.0' : 'ー';
  }

  String get resultChest {
    return chest.isNotEmpty ? '$chest.0' : 'ー';
  }

  String get resultStomach {
    return stomach.isNotEmpty ? '$stomach.0' : 'ー';
  }

  String get resultHip {
    return hip.isNotEmpty ? '$hip.0' : 'ー';
  }

  String get resultArm {
    return arm.isNotEmpty ? '$arm.0' : 'ー';
  }

  String get resultLeg {
    return leg.isNotEmpty ? '$leg.0' : 'ー';
  }

  String get resultChef {
    return chef.isNotEmpty ? '$chef.0' : 'ー';
  }

  String get resultAnkle {
    return ankle.isNotEmpty ? '$ankle.0' : '-';
  }
}
