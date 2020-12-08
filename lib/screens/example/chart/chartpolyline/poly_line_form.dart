import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/chart/chartpolyline/widget/poly_line_body.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';
import 'package:provider/provider.dart';

import 'weight_top_view_model.dart';

class PolyLineForm extends StatefulWidget {
  final BuildContext baseContext;

  PolyLineForm({this.baseContext});

  @override
  State<StatefulWidget> createState() {
    return _PolyLineFormState(baseContext);
  }
}

class _PolyLineFormState extends State<PolyLineForm> {
  BuildContext _baseContext;

  _PolyLineFormState(BuildContext context) {
    _baseContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            iconTheme: IconThemeData(color: BeautyColors.blue01),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              '折线图',
              style: Styles.text10.merge(TextStyle(color: BeautyColors.blue01)),
            ),
            flexibleSpace: SizedBox(
              height: 1,
            ),
            bottom: _getTabBar(context)),
        body: SingleChildScrollView(
          child: Container(
            child: PolyLineBodyWidget(
              baseContext: _baseContext,
            ),
          ),
        ),
      ),
    );
  }

  TabBar _getTabBar(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 40;
    var tabWidth = width / 3;
    var tab = [
      Container(
        height: 46,
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
        context.read<WeightTopViewModel>().changePolyText(i);
        setState(() {});
      },
    );
  }
}
