import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';
import 'package:provider/provider.dart';

import '../step_check_view_model.dart';
import 'widget/step_check_body.dart';

class StepCheckForm extends StatefulWidget {
  final BuildContext baseContext;

  StepCheckForm({this.baseContext});

  @override
  State<StatefulWidget> createState() {
    return _StepCheckFormState(baseContext);
  }
}

class _StepCheckFormState extends State<StepCheckForm> {
  BuildContext _baseContext;

  _StepCheckFormState(BuildContext context) {
    _baseContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            iconTheme: IconThemeData(color: BeautyColors.blue01),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              '饼状图',
              style: Styles.text10.merge(TextStyle(color: BeautyColors.blue01)),
            ),
            flexibleSpace: SizedBox(
              height: 1,
            ),
            bottom: _getTabBar(context)),
        body: SingleChildScrollView(
          child: Container(
            child: StepPageBodyWidget(
              baseContext: _baseContext,
            ),
          ),
        ),
      ),
    );
  }

  TabBar _getTabBar(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 40;
    var tabWidth = width / 4;
    var tab = [
      Container(
        width: tabWidth,
        height: 46,
        child: Tab(
          text: '日',
        ),
      ),
      Container(
        width: tabWidth,
        child: Tab(
          text: '周',
        ),
      ),
      Container(
        width: tabWidth,
        child: Tab(
          text: '月',
        ),
      ),
      Container(
        width: tabWidth,
        child: Tab(
          text: '年',
        ),
      ),
    ];

    return TabBar(
      isScrollable: true,
      tabs: tab,
      labelColor: BeautyColors.blue01,
      labelStyle: Styles.text8,
      unselectedLabelStyle: Styles.text9,
      unselectedLabelColor: BeautyColors.gray02,
      labelPadding: EdgeInsets.zero,
      indicatorColor: BeautyColors.blue01,
      onTap: (i) {
        context.read<CheckViewModel>().changeText(i);
      },
    );
  }
}
