
import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';
import 'package:flutter_demox/screens/example/timepicker/components/perferred_column.dart';

class WantToBeInit extends StatefulWidget {
  WantToBeInit();

  @override
  _WantToBeInitState createState() => _WantToBeInitState();
}

class _WantToBeInitState extends State<WantToBeInit> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/bg_A.png'),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(color: BeautyColors.blue01),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          title: Text(
           ' resource.homeMe',
            style: Styles.text10.merge(TextStyle(color: BeautyColors.blue01)),
          ),
          flexibleSpace: SizedBox(
            height: 1,
          ),
          bottom: _getSubLayout(),
        ),
        body: Container(
          child: Stack(
            children: [],
          ),
        ),
      ),
    );
  }

  PreferredSizeColumn _getSubLayout() {
    return PreferredSizeColumn(
      // crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          color: BeautyColors.white01,
          margin: EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width: 24,
                    height: 24,
                    child: Image(image: AssetImage('assets/ic_drawer_oshirase.png'),),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: 10, top: 10.0, bottom: 10, right: 10),
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                       ' resource.wantToBeInitMaintenanceNoticeText',
                                        style: Styles.text3.merge(
                                          TextStyle(color: BeautyColors.gray02),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10.0, left: 0.0),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      '2020.12.17',
                                      style: Styles.text3.merge(
                                        TextStyle(color: BeautyColors.gray06),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 4.0, right: 12.0),
                    width: 12,
                    height: 24,
                    child: Image(image: AssetImage('assets/ic_cheveron.png'),),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
