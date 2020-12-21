import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';
import 'package:provider/provider.dart';

import 'weight_check_history_view_model.dart';
import 'widget/weight_check_history_list.dart';
import 'widget/weight_check_history_top.dart';

class WeightCheckHistory extends StatefulWidget {
  @override
  _WeightCheckHistoryState createState() => _WeightCheckHistoryState();
}

class _WeightCheckHistoryState extends State<WeightCheckHistory> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) {
      return WeightCheckHistoryViewModel();
    }, child: Consumer<WeightCheckHistoryViewModel>(
        builder: (context, viewModel, child) {
      return Scaffold(
        appBar: AppBar(
          leading: viewModel.isEditMode
              ? null
              : GestureDetector(
                  onTapDown: (detail) {
                    Navigator.pop(context);
                  },
                  child: Image(
                    image: AssetImage('assets/ic_calender_back.png'),
                  ),
                ),
          backgroundColor: Colors.white.withOpacity(0),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: !viewModel.isEditMode,
          actions: _getActionButton(viewModel),
          title: Text('体重记录履历',
              style:
                  Styles.text12.merge(TextStyle(color: BeautyColors.blue01))),
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg_A.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Column(children: [
                WeightCheckHistoryTopPart(),
                WeightCheckHistoryListPart()
              ]),
            ),
            Visibility(
              visible: viewModel.isEditMode,
              child: Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: BeautyColors.white01.withOpacity(0.9)),
                  child: Container(
                    height: 50,
                    child: FlatButton(
                        color: BeautyColors.blue01.withOpacity(0.86),
                        splashColor: BeautyColors.blue05,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        onPressed: () => viewModel.setEditModel(),
                        child: Text('完成',
                            style: Styles.text9.merge(
                                TextStyle(color: BeautyColors.white01)))),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }));
  }

//右上角的删除按钮逻辑，根据需求来使用。
  List<Widget> _getActionButton(WeightCheckHistoryViewModel viewModel) {
    if (viewModel.currentPageEmpty) {
      return <Widget>[];
    } else if (viewModel.isEditMode) {
      return <Widget>[
        InkWell(
          child: Container(
              height: 24,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(8),
              child: Text(
                "",
                style:
                    Styles.text6.merge(TextStyle(color: BeautyColors.blue01)),
                maxLines: 1,
                textAlign: TextAlign.center,
              )),
          onTap: () {
            viewModel.setEditModel();
          },
        )
      ];
    } else {
      return <Widget>[
        IconButton(
          icon: ImageIcon(
            AssetImage('assets/navi_trush.png'),
            color: BeautyColors.blue01,
          ),
          onPressed: () {
            viewModel.setEditModel();
          },
        )
      ];
    }
  }
}
