import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';
import 'package:provider/provider.dart';

import '../checkbox_view_model.dart';

class CustomCheckBox extends StatefulWidget {
  final String itemText;
  final int showIndex;

  CustomCheckBox({Key key, this.itemText, this.showIndex}) : super(key: key);

  @override
  CustomCheckBoxState createState() => CustomCheckBoxState();
}

class CustomCheckBoxState extends State<CustomCheckBox> {
  WantToBeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    var itemWidth = double.infinity;
    viewModel = Provider.of<WantToBeViewModel>(context);
    var _checkValue = widget.showIndex == viewModel.clickFeelItemIndex;
    return InkWell(
      onTap: () {
        viewModel.changeClickFeelItemIndex(widget.showIndex);
        viewModel.refreshNextButton();
      },
      child: Container(
        margin: EdgeInsets.only(top: 12, left: 40, right: 40),
        width: itemWidth,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          color: BeautyColors.white01,
        ),
        child: Stack(
          children: <Widget>[
            Visibility(
              visible: _checkValue,
              child: Container(
                decoration: BoxDecoration(
                    color:
                        _checkValue ? Color(0x33298eb1) : BeautyColors.white01,
                    border: Border.all(
                        color: _checkValue
                            ? BeautyColors.blue01
                            : BeautyColors.white01,
                        width: 2),
                    borderRadius: BorderRadius.circular(60)),
              ),
            ),
            Center(
              child: Text(widget.itemText,
                  style: Styles.text10
                      .merge(TextStyle(color: BeautyColors.blue01))),
            ),
            Positioned(
              left: 13,
              top: 15,
              child: InkWell(
                onTap: () {
                  setState(() {});
                },
                child: Container(
                  width: 20,
                  height: 20,
                  child: _checkValue
                      ? Image(
                          image: AssetImage('assets/Check_on.png'),
                        )
                      : Image(
                          image: AssetImage('assets/Check_empty.png'),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
