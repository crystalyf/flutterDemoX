import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/util/utils.dart';
import 'package:flutter_demox/screens/repository/common_repository.dart';
import 'package:provider/provider.dart';

import 'forget_pwd_view_model.dart';

class ForgetPwdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          final repository = context.read<CommonRepository>();
          return ForgetPwdViewModel(repository, (error) {
            Utils.showErrorDialog(context, error, () {});
          });
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                title: new Text(
                  '忘记密码画面',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image(image: AssetImage('assets/ic_calender_back.png')),
                )),
            body: Stack(children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 32, right: 32),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    //live data 的作用，通知关闭本画面返回上一个画面
                    Consumer<ForgetPwdViewModel>(
                        builder: (context, value, child) {
                      if (context.watch<ForgetPwdViewModel>().isNeedCloseView) {
                        context
                            .watch<ForgetPwdViewModel>()
                            .revertCloseViewFlag();
                        Future(() {
                          Navigator.of(context).pop();
                        });
                        return SizedBox(height: 32);
                      } else {
                        return SizedBox(height: 32);
                      }
                    }),
                    Container(
                      child: Text('Email Address',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold)),
                      alignment: Alignment.centerLeft,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      child: _InputMail(),
                    ),
                    Container(
                        width: double.infinity,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.only(
                                    top: 64,
                                  ),
                                  child: Selector<ForgetPwdViewModel, bool>(
                                      selector: (context, viewModel) =>
                                          viewModel.isActiveNextButton,
                                      builder:
                                          (context, isActiveNextButton, child) {
                                        return SizedBox(
                                          width: double.infinity,
                                          height: 56,
                                          child: MaterialButton(
                                            color: Colors.green,
                                            disabledColor:
                                                Colors.grey.withOpacity(0.54),
                                            textColor: Colors.white,
                                            disabledTextColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide.none,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                            child: new Text('Next',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            onPressed: isActiveNextButton
                                                ? () {
                                                    //fixme:
                                                    clickNextButton(context);
                                                  }
                                                : null,
                                          ),
                                        );
                                      })),
                            ])),
                  ],
                )),
              ),
            ])));
  }

  Future<bool> showSuccessDialog(BuildContext context) {
    showDialog<AlertDialog>(
        context: context,
        barrierDismissible: false,
        builder: (contextInside) => AlertDialog(
              content: Text('API发送成功',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              actions: <Widget>[
                MaterialButton(
                  child: Text('是',
                      style: TextStyle(fontSize: 17, color: Colors.green)),
                  onPressed: () {
                    Navigator.pop(contextInside);
                    context.read<ForgetPwdViewModel>().closeViewValue();
                  },
                ),
              ],
            ));
  }

  ///[Next]按钮点击
  void clickNextButton(BuildContext context) {
    context.read<ForgetPwdViewModel>().sendForgetPwd(() {
      if (context.read<ForgetPwdViewModel>().isNeedShowSuccessDialog) {
        //发送API成功的Dialog
        context.read<ForgetPwdViewModel>().revertCloseSuccessDialogFlag();
        showSuccessDialog(context);
      }
    });
  }
}

class _InputMail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isFocus = context.select<ForgetPwdViewModel, bool>(
        (viewModel) => viewModel.isFocusAddress);
    return TextField(
      autofocus: false,
      focusNode: context.watch<ForgetPwdViewModel>().addressFocus,
      controller: context.watch<ForgetPwdViewModel>().addressController,
      keyboardType: TextInputType.emailAddress,
      onEditingComplete: () {
        context.watch<ForgetPwdViewModel>().addressFocus.unfocus();
      },
      decoration: InputDecoration(
        isDense: true,
        hintText: 'メーリルアドレス',
        hintStyle:
            TextStyle(color: Colors.black.withOpacity(0.54), fontSize: 18),
        suffixIcon: isFocus
            ? IconButton(
                onPressed: () =>
                    context.read<ForgetPwdViewModel>().clearAddress(),
                icon: Image(image: AssetImage('assets/ic_calender_back.png')),
              )
            : null,
      ),
    );
  }
}
