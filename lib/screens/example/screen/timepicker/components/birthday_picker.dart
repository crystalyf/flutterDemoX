import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';
import 'package:flutter_demox/screens/example/screen/chart/chartpolyline/weight_top_view_model.dart';
import 'package:provider/provider.dart';

class BirthdayPicker extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<WeightTopViewModel>().onTapBirthdayForm();
        _openDatePicker(context);
      },
      child: AbsorbPointer(
        child: TextField(
          controller: context.watch<WeightTopViewModel>().birthdayController,
          style: Styles.text6.merge(TextStyle(color: BeautyColors.blue01)),
          decoration: InputDecoration(
            hintText: 'hintText',
            hintStyle:
                Styles.text6.merge(TextStyle(color: BeautyColors.blue02)),
            suffixIcon: Image.asset('assets/ic_form_pulldown_green.png') ,
          ),
        ),
      ),
    );
  }

  //开启
  void _openDatePicker(BuildContext buildContext) {
    showCupertinoModalPopup<void>(
      context: buildContext,
      builder: (context) {
        return Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height / 4,
          child: CupertinoDatePicker(
            backgroundColor: Colors.white,
            initialDateTime: DateTime.now(),
            maximumYear: DateTime.now().year,
            onDateTimeChanged: (value) =>
                buildContext.read<WeightTopViewModel>().onSelectBirthdayPickerItem(value),
            mode: CupertinoDatePickerMode.date,
          ),
        );
      },
    );
  }
}
