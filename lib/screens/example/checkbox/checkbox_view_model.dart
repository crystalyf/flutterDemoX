
import 'package:flutter/cupertino.dart';

import 'widget/click_item_model.dart';
import 'widget/my_ideal_data.dart';


class WantToBeViewModel extends ChangeNotifier {

  int clickFeelItemIndex = -1;

  //表示を待機しているページ数のデータ
  int wantToBeTypeListIndex = 0;
  bool isActiveNextButton = false;
  MyIdealData idealDataBefore = MyIdealData();

  WantToBeViewModel() {
    getIdealData();
  }


  ///なりたい私のデータソースを取得する
  void getIdealData() {
    idealDataBefore.date = '2020.12.24';
    idealDataBefore.ankle = '99';
    idealDataBefore.arm = '45';
    idealDataBefore.chef = '35';
    idealDataBefore.chest = '43';
    idealDataBefore.hip = '32';
    idealDataBefore.leg = '56';
    idealDataBefore.duration = '2週間';
    var list = <ClickItemModel>[];
    var model1 = ClickItemModel();
    model1.isChecked = true;
    model1.position = 1;
    list.add(model1);
    var model2 = ClickItemModel();
    model2.isChecked = true;
    model2.position = 2;
    list.add(model2);
    var model3 = ClickItemModel();
    model3.isChecked = true;
    model3.position = 4;
    list.add(model3);
    idealDataBefore.wantToBeTypeList = list;
  }

  void changeClickFeelItemIndex(int index) {
    //记录点击的是哪一个
    clickFeelItemIndex = index;
    notifyListeners();
  }

  ///ボタンの状態を更新
  void refreshNextButton() {
    isActiveNextButton = true;
    notifyListeners();
  }
}
