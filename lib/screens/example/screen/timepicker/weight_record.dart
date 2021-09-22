import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';
import 'package:flutter_demox/screens/example/screen/chart/chartpolyline/weight_top_view_model.dart';
import 'package:provider/provider.dart';

import 'components/beauty_button_theme.dart';
import 'components/birthday_picker.dart';
import 'components/perferred_column.dart';

class WeightRecord extends StatefulWidget {
  WeightRecord();

  @override
  State<StatefulWidget> createState() {
    return WeightRecordState();
  }
}

class WeightRecordState extends State<WeightRecord> {
  WeightRecordState();

  BuildContext baseContext;
  WeightTopViewModel viewModel;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    baseContext = context;
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel = WeightTopViewModel();
      },
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
                '体重记录',
                style:
                    Styles.text10.merge(TextStyle(color: BeautyColors.blue01)),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image(image: AssetImage('assets/ic_calender_back.png')),
              ),
              bottom: _getSubLayout(),
            ),
            body: Container(
                color: BeautyColors.white01.withOpacity(0.4),
                margin: EdgeInsets.only(bottom: 30),
                child: Stack(
                  children: [
                    //日期选择器
                    Container(
                      margin: EdgeInsets.only(left: 40,right: 40,top: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '日付',
                            style: Styles.text7.merge(
                              TextStyle(color: BeautyColors.blue01),
                            ),
                          ),
                          BirthdayPicker(),
                        ],
                      ),
                    )
                    ,
                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Selector<WeightTopViewModel, bool>(
                            selector: (context, viewModel) =>
                                viewModel.isActiveRegisterButton,
                            builder: (context, isActiveRegisterButton, child) {
                              return Container(
                                margin: EdgeInsets.only(
                                    left: 25, right: 25, bottom: 30),
                                child: BeautyButtonTheme(
                                  color: BeautyColors.blue01,
                                  disableColor:
                                      BeautyColors.blue05.withOpacity(0.55),
                                  text: '记录',
                                  textStyle: Styles.text9.merge(
                                      TextStyle(color: BeautyColors.white01)),
                                  onPressed: isActiveRegisterButton
                                      ? () {
                                          viewModel.insertData().whenComplete(
                                              () => Navigator.pop(context));
                                        }
                                      : null,
                                ),
                              );
                            }))
                  ],
                ))),
      ),
    );
  }

  PreferredSizeColumn _getSubLayout() {
    return PreferredSizeColumn(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 30),
          child: Text(
            '请选择日期',
            style: Styles.text8.merge(TextStyle(color: BeautyColors.blue01)),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
