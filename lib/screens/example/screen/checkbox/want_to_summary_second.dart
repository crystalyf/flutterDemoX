import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/lifecycle/focus_detector.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';
import 'package:flutter_demox/screens/example/screen/timepicker/components/beauty_button_theme.dart';
import 'package:flutter_demox/screens/example/screen/timepicker/components/perferred_column.dart';
import 'package:provider/provider.dart';

import 'checkbox_view_model.dart';
import 'widget/custom_checkbox.dart';

class WantToSummarySecond extends StatefulWidget {
  WantToSummarySecond();

  @override
  State<StatefulWidget> createState() {
    return WantToSummarySecondState();
  }
}

class WantToSummarySecondState extends State<WantToSummarySecond> {
  WantToSummarySecondState();

  WantToBeViewModel viewModel;
  final _resumeDetectorKey = UniqueKey();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      key: _resumeDetectorKey,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // タッチしてキーボードを閉じます
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (context) => viewModel = WantToBeViewModel())
          ],
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_A.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                iconTheme: IconThemeData(color: BeautyColors.blue01),
                backgroundColor: Colors.transparent,
                centerTitle: true,
                elevation: 0,
                title: Text(
                  '标题',
                  style: Styles.text10
                      .merge(TextStyle(color: BeautyColors.blue01)),
                ),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image(
                    image: AssetImage('assets/ic_calender_back.png'),
                  ),
                ),
                actions: _getActionButton(),
                bottom: _getSubLayout(),
              ),
              extendBodyBehindAppBar: false,
              body: Container(
                width: double.infinity,
                color: BeautyColors.white01.withOpacity(0.4),
                child: Container(
                  child: Selector<WantToBeViewModel, int>(
                      selector: (context, viewModel) =>
                          viewModel.clickFeelItemIndex,
                      builder: (context, value, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 25),
                            Text(
                                viewModel.idealDataBefore.wantToBeTypeList[0]
                                    .getContent(viewModel.idealDataBefore
                                        .wantToBeTypeList[0].position),
                                style: Styles.text10.merge(
                                    TextStyle(color: BeautyColors.blue01))),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              width: 60,
                              height: 60,
                              child: _getContentImage(),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: CustomCheckBox(
                                itemText: '45公斤',
                                showIndex: 0,
                              ),
                            ),
                            CustomCheckBox(
                              itemText: '55公斤',
                              showIndex: 1,
                            ),
                            CustomCheckBox(
                              itemText: '65公斤',
                              showIndex: 2,
                            ),
                            CustomCheckBox(
                              itemText: '85公斤',
                              showIndex: 3,
                            ),
                            CustomCheckBox(
                              itemText: '100公斤',
                              showIndex: 4,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 35, right: 35, top: 30, bottom: 30),
                              child: Selector<WantToBeViewModel, bool>(
                                selector: (context, viewModel) =>
                                    viewModel.isActiveNextButton,
                                builder: (context, isActiveNextButton, child) {
                                  return BeautyButtonTheme(
                                    color: BeautyColors.blue01,
                                    disableColor:
                                        BeautyColors.blue05.withOpacity(0.55),
                                    text: 'OK',
                                    textStyle: Styles.text9.merge(
                                        TextStyle(color: BeautyColors.white01)),
                                    onPressed: isActiveNextButton
                                        ? () {
                                            judgeTransfer();
                                          }
                                        : null,
                                  );
                                },
                              ),
                            )
                          ],
                        );
                      }),
                ),
              ),
            ),
          ),
        ),
      ),
      onResume: () {},
    );
  }

  List<Widget> _getActionButton() {
    return <Widget>[
      InkWell(
        child: Container(
            height: 24,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(8),
            child: Text(
              '取消',
              style: Styles.text6.merge(TextStyle(color: BeautyColors.blue01)),
              maxLines: 1,
              textAlign: TextAlign.center,
            )),
        onTap: () {
          //TODO:
        },
      )
    ];
  }

  PreferredSizeColumn _getSubLayout() {
    return PreferredSizeColumn(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 30),
          child: Text(
            '您对实现此目标的努力感到满意吗？?',
            style: Styles.text8.merge(TextStyle(color: BeautyColors.blue01)),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Image _getContentImage() {
    Image image;
    var position = viewModel.idealDataBefore
        .wantToBeTypeList[viewModel.wantToBeTypeListIndex].position;
    switch (position) {
      case 0:
        image = Image(
          image: AssetImage('assets/ic_naritai_choice_01_g.png'),
        );
        break;
      case 1:
        image = Image(
          image: AssetImage('assets/ic_naritai_choice_02_g.png'),
        );
        break;
      case 2:
        image = Image(
          image: AssetImage('assets/ic_naritai_choice_03_g.png'),
        );
        break;
      case 3:
        image = Image(
          image: AssetImage('assets/ic_naritai_choice_04_g.png'),
        );
        break;
      case 4:
        image = Image(
          image: AssetImage('assets/ic_naritai_choice_05_g.png'),
        );
        break;
      case 5:
        image = Image(
          image: AssetImage('assets/ic_naritai_choice_06_g.png'),
        );
        break;
    }
    return image;
  }

  void judgeTransfer() {
    viewModel.idealDataBefore.wantToBeTypeList[viewModel.wantToBeTypeListIndex]
        .saveFeelPosition(viewModel.clickFeelItemIndex);
    if (viewModel.wantToBeTypeListIndex <
        viewModel.idealDataBefore.wantToBeTypeList.length - 1) {
      viewModel.wantToBeTypeListIndex++;
      _transferToWantToSummarySecond();
    } else {
      _transferToWantToSummaryConfirm();
    }
  }

  ///なりたい私の振り返り-01を移行する
  void _transferToWantToSummarySecond() {
    Navigator.of(context).push<void>(MaterialPageRoute(
      builder: (context1) => WantToSummarySecond(),
      settings: RouteSettings(
        arguments: {'viewModel': viewModel},
      ),
    ));
  }

  void _transferToWantToSummaryConfirm() {
    // 跳转
  }
}
