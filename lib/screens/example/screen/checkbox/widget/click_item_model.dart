import 'package:flutter/material.dart';

///wantToBeType item
class ClickItemModel {
  bool isChecked;

  //0-5:体重,理想体型の私,筋肉質の私,美姿勢の私,美肌の私,ストレスをコントロール できる私
  int position;
  List<String> contentList = [
    '体重',
    '理想体型の私',
    '筋肉質の私',
    '美姿勢の私',
    '美肌の私',
    'ストレスをコントロールできる私'
  ];

  int feelPosition = -1;
  List<String> feelList = ['満足', 'やや満足', '普通', 'やや不満', '不満'];

  ClickItemModel({this.isChecked = false, this.position = 0});

  String getContent(int position) {
    return contentList[position];
  }

  void saveFeelPosition(int position) {
    feelPosition = position;
  }
}

class MyIdealPurposeViewModel extends ChangeNotifier {
  List<ClickItemModel> wantToBeTypeList = List(6);

  void onClick(int position) {
    wantToBeTypeList[position] = (wantToBeTypeList
                .where((element) => element?.isChecked ?? false)
                .length <=
            2)
        ? ClickItemModel(
            position: position,
            isChecked: !((wantToBeTypeList[position]?.isChecked) ?? false))
        : ClickItemModel(position: position);

    ///select over three item

    notifyListeners();
    print('i am click$position');
  }

  bool isSelectedItemNotEmpty() {
    return wantToBeTypeList
        .where((element) => element?.isChecked ?? false)
        .toList()
        .isNotEmpty;
  }

  bool getItem(int position) {
    return wantToBeTypeList[position] != null
        ? wantToBeTypeList[position].isChecked
        : false;
  }

  MyIdealPurposeViewModel();

  @override
  void dispose() {
    wantToBeTypeList.clear();
    super.dispose();
  }
}
