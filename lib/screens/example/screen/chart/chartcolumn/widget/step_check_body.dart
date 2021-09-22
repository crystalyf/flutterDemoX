import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:provider/provider.dart';

import '../../step_check_view_model.dart';
import 'ImageLoader.dart';
import 'arrow_button.dart';
import 'chart_widget.dart';
import 'time_display_widget.dart';

class StepPageBodyWidget extends StatefulWidget {
  final BuildContext baseContext;

  StepPageBodyWidget({this.baseContext});

  @override
  State<StatefulWidget> createState() {
    return StepPageBodyWidgetState(baseContext: baseContext);
  }
}

class StepPageBodyWidgetState extends State<StepPageBodyWidget> {
  TapDownDetails details;
  final BuildContext baseContext;

  StepPageBodyWidgetState({this.baseContext});

  @override
  void initState() {
    super.initState();
    ImageLoader.getInstance().preCacheImage();
  }

  @override
  Widget build(BuildContext context) {
    var total =
        context.select<CheckViewModel, int>((viewModel) => viewModel.totalStep);
    var type = context
        .select<CheckViewModel, ChartLayoutType>((viewModel) => viewModel.type);

    var doubleList = context.select<CheckViewModel, List<ColumnData>>(
        (viewModel) => viewModel.doubleList);
    return Column(
      children: [
        Container(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 40,
                  color: BeautyColors.blue04,
                  child: Row(
                    children: [
                      SizedBox(width: 32),
                      Container(
                          width: 32, child: ArrowButton(isNextButton: false)),
                      Expanded(
                        child: Center(
                          child: TimeDisplayWidget(),
                        ),
                        flex: 1,
                      ),
                      Container(
                          width: 32, child: ArrowButton(isNextButton: true)),
                      SizedBox(width: 32),
                    ],
                  ),
                ),
                SizedBox(
                  child: Stack(
                    children: [
                      Container(
                        height: 360,
                        padding: EdgeInsets.only(
                            left: 16, right: 16, bottom: 30, top: 10),
                        child: SizedBox(
                            width: double.infinity,
                            child: GestureDetector(
                              onTapDown: (detail) {
                                setState(() {
                                  details = detail;
                                });
                              },
                              child: Container(
                                child: CustomPaint(
                                  painter: CustomChartPaint(context, doubleList,
                                      currentChartLayoutType: type,
                                      tabDownloadDetails: details),
                                ),
                              ),
                            )),
                      ),
                      // HealthCareButton(
                      //   baseContext: baseContext,
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          // height: 100,
          color: Colors.transparent,
        ),
      ],
    );
  }
}
