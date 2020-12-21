import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';

class SleepCheckDialog extends StatelessWidget {

  SleepCheckDialog();

  @override
  Widget build(BuildContext context) {
    var dialogSmallTextStyle =
        TextStyle(fontSize: 13, color: BeautyColors.gray02, height: 1);
    var dialogBigTextStyle = TextStyle(
        fontSize: 13,
        color: BeautyColors.gray02,
        fontWeight: FontWeight.bold,
        height: 1);
    BuildContext dialogContext;
    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.9),
      title: Center(
        child: Text(
          'resource.sleepCheckDialogTitle',
          style: TextStyle(
              fontSize: 17,
              color: Color(0xFF545454),
              fontWeight: FontWeight.w600),
        ),
      ),
      insetPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3.0))),
      content: Builder(builder: (context) {
        dialogContext = context;
        return Container(
            width: MediaQuery.of(context).size.width,
            child: Row(children: [
              SizedBox(width: 20),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 1,
                      decoration: BoxDecoration(color: Color(0xFF298EB1)),
                    ),
                    SizedBox(height: 15),
                    Text('resource.sleepCheckDialogText1',
                        style: dialogSmallTextStyle),
                    Text('resource.sleepCheckDialogText2',
                        style: dialogBigTextStyle),
                    Text('resource.sleepCheckDialogText3',
                        style: dialogSmallTextStyle),
                    Text('resource.sleepCheckDialogText4',
                        style: dialogBigTextStyle),
                    Text('resource.sleepCheckDialogText5',
                        style: dialogSmallTextStyle),
                    Text('resource.sleepCheckDialogText6',
                        style: dialogBigTextStyle),
                    Text('resource.sleepCheckDialogText7',
                        style: dialogSmallTextStyle),
                    Text('resource.sleepCheckDialogText8',
                        style: dialogBigTextStyle),
                    Text('resource.sleepCheckDialogText9',
                        style: dialogSmallTextStyle),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 50,
                        width: 285,
                        child: FlatButton(
                            color: BeautyColors.blue01.withOpacity(0.86),
                            splashColor: BeautyColors.blue05,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0))),
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            child: Text('resource.stepTutorialSkipButtonClose',
                                style: Styles.text9.merge(
                                    TextStyle(color: BeautyColors.white01)))),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 20)
            ]));
      }),
    );
  }
}
