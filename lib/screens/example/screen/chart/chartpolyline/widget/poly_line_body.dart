import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/screen/chart/chartcolumn/widget/ImageLoader.dart';
import 'package:provider/provider.dart';

import '../weight_top_view_model.dart';
import 'arrow_button.dart';
import 'poly_line_data.dart';
import 'poly_type_enum.dart';
import 'poly_widget_painter.dart';
import 'time_display_widget.dart';

class PolyLineBodyWidget extends StatefulWidget {
  final BuildContext baseContext;

  PolyLineBodyWidget({this.baseContext});

  @override
  State<StatefulWidget> createState() {
    return PolyLineBodyWidgetState(baseContext: baseContext);
  }
}

class PolyLineBodyWidgetState extends State<PolyLineBodyWidget> {
  final BuildContext baseContext;
  WeightTopViewModel viewModel;

  PolyLineBodyWidgetState({this.baseContext});

  @override
  void initState() {
    super.initState();
    ImageLoader.getInstance().preCacheImage();
  }

  @override
  Widget build(BuildContext context) {
    var type = context.select<WeightTopViewModel, PolyLayoutType>(
        (viewModel) => viewModel.polyType);

    var polyPointList = context.select<WeightTopViewModel, List<PolyLineData>>(
        (viewModel) => viewModel.polyPointList);
    return Container(
      child: Selector<WeightTopViewModel, bool>(
          selector: (context, viewModel) => viewModel.polyRefreshFlag,
          builder: (context, value, child) {
            viewModel = Provider.of<WeightTopViewModel>(context);
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
                                  width: 32,
                                  child: ArrowButton(isNextButton: false)),
                              Expanded(
                                child: Center(
                                  child: TimeDisplayWidget(),
                                ),
                                flex: 1,
                              ),
                              Container(
                                  width: 32,
                                  child: ArrowButton(isNextButton: true)),
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
                                          //点击canvas的点击
                                          viewModel.details = detail;
                                        });
                                      },
                                      child: Container(
                                        child: CustomPaint(
                                          painter: PolyWidgetPainter(
                                              context, polyPointList,
                                              currentPolyLayoutType: type,
                                              tapDownDetails: viewModel.details,
                                              weightTopViewModel: Provider.of<
                                                  WeightTopViewModel>(context)),
                                          // painter: PolyLinePainter(),
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
          }),
    );
  }
}
