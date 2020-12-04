import 'package:flutter/cupertino.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';
import 'package:provider/provider.dart';

import '../../step_check_view_model.dart';
import '../Utils.dart';
import 'chart_widget.dart';

class AverageStepWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AverageStepState();
  }
}

class AverageStepState extends State<AverageStepWidget> {
  @override
  Widget build(BuildContext context) {
    var total =
        context.select<CheckViewModel, int>((viewModel) => viewModel.totalStep);
    var type = context
        .select<CheckViewModel, ChartLayoutType>((viewModel) => viewModel.type);
    if (total < 0) {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: Text(
          '没权限',
          style: Styles.text7.merge(TextStyle(color: BeautyColors.gray02)),
        ),
      );
    }
    if (type == ChartLayoutType.day) {
      return Container();
    } else {
      var average = 0;
      switch (type) {
        case ChartLayoutType.week:
          {
            average = total ~/ 7;
            break;
          }
        case ChartLayoutType.month:
          {
            average = total ~/ 30;
            break;
          }
        case ChartLayoutType.year:
          {
            average = total ~/ 12;
            break;
          }
        case ChartLayoutType.day:
          break;
      }

      return Container(
        child: Row(
          children: [
            Expanded(
              child: Container(),
              flex: 1,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 5),
              child: Text('resource.stepCheckAverageCount',
                  style: Styles.text9
                      .merge(TextStyle(color: BeautyColors.gray02))),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(Utils.formatNum(average),
                  style: TextStyle(fontSize: 26, color: BeautyColors.gray02)),
            ),
            Container(
              margin: EdgeInsets.only(left: 5, top: 5),
              child: Text('resource.stepCheckStepUnit',
                  style: Styles.text9
                      .merge(TextStyle(color: BeautyColors.gray02))),
            ),
            Expanded(
              child: Container(),
              flex: 1,
            ),
          ],
        ),
      );
    }
  }
}
