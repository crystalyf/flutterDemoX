import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';

import 'components/feel_type_dialog.dart';

class DialogPage extends StatefulWidget {
  DialogPage();

  @override
  State<StatefulWidget> createState() {
    return DialogPageState();
  }
}

class DialogPageState extends State<DialogPage> {
  DialogPageState() {
    //接口回调
    onSelectCallback = (content) {
      searchStr = content;
      setState(() {});
    };
  }

  Function(String) onSelectCallback;
  String searchStr = '请选择种类';

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg_A.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Dialog',
            //设置appBar的文本样式
            style: Styles.text10.merge(
              TextStyle(color: BeautyColors.blue01),
            ),
          ),
          leading: Container(
              child: IconButton(
            icon: Image(image: AssetImage('assets/ic_calender_back.png')),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
          actions: <Widget>[
            IconButton(
              icon: Image(image: AssetImage('assets/btn_navi_help.png')),
              onPressed: () {
                print('btnNaviHelp');
              },
            ),
          ],
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0, //阴影为0
        ),
        body: Container(
          margin: EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => {
                  // 打开对话框
                  showDialog<void>(
                      context: context,
                      builder: (context) {
                        return FeelTypeDialog(onSelectCallback);
                      })
                },
                child: Container(
                  width: 345,
                  height: 40,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/bg_search_text.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: Text(
                      searchStr,
                      style: Styles.text7.merge(
                        TextStyle(color: BeautyColors.blue01),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
