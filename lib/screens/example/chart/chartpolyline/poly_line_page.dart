import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/chart/chartcolumn/widget/base_background_widget.dart';
import 'package:provider/provider.dart';

import 'poly_line_form.dart';
import 'weight_top_view_model.dart';

class PolyLinePage extends StatelessWidget {
  final BuildContext baseContext;

  PolyLinePage({this.baseContext});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return WeightTopViewModel();
      },
      child: BaseBackGroundWidget(
          child: PolyLineForm(
        baseContext: baseContext,
      )),
    );
  }
}
