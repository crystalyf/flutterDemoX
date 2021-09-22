import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../step_check_view_model.dart';
import 'step_check_form.dart';
import 'widget/base_background_widget.dart';

class StepCheckPage extends StatelessWidget {
  final BuildContext baseContext;
  StepCheckPage({this.baseContext});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) {
        return CheckViewModel();
      },
      child: BaseBackGroundWidget(
          child: StepCheckForm(baseContext: baseContext,)
      ),
    );
  }
}


