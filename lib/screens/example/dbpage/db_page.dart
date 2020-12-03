import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:provider/provider.dart';

import 'db_page_view_model.dart';

class DbPage extends StatefulWidget {
  @override
  _DbPageState createState() => _DbPageState();
}

class _DbPageState extends State<DbPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) {
      return DbPageViewModel();
    }, child: Container(
      child: Consumer<DbPageViewModel>(builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Sqlite存储',
              style: TextStyle(color: BeautyColors.blue02),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Container(
            child:     OutlineButton(
                onPressed: () {
                  context
                      .read<DbPageViewModel>().getAll();
                },
                child: Text('查找数据')),
          ),
        );
      }),
    ));
  }
}
