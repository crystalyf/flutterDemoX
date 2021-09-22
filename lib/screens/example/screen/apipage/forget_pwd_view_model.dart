import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/model/ForgetRequestModel.dart';
import 'package:flutter_demox/screens/repository/common_repository.dart';

class ForgetPwdViewModel extends ChangeNotifier {
  bool isFocusAddress = false;
  bool isActiveNextButton = false;
  final addressController = TextEditingController();
  final addressFocus = FocusNode();

  //是否需要关闭画面
  bool isNeedCloseView = false;

  //是否显示API成功发信的dialog
  bool isNeedShowSuccessDialog = false;

  final CommonRepository _userRepository;
  Function(String error) onErrorDialog;

  ForgetPwdViewModel(this._userRepository, this.onErrorDialog) {
    _addAddressFocusListener();
    _addTextFieldListener();
  }

  void _addAddressFocusListener() {
    addressFocus.addListener(() {
      isFocusAddress = addressFocus.hasFocus;
      notifyListeners();
    });
  }

  void _addTextFieldListener() {
    addressController.addListener(() => _formValidate());
  }

  void _formValidate() {
    isActiveNextButton = addressController.text.isNotEmpty;
    notifyListeners();
  }

  void closeViewValue(){
    isNeedCloseView = true;
    notifyListeners();
  }

  void clearAddress() {
    addressController.text = '';
  }

  void revertCloseViewFlag(){
    isNeedCloseView = !isNeedCloseView;
  }

  void revertCloseSuccessDialogFlag(){
    isNeedShowSuccessDialog = !isNeedShowSuccessDialog;
  }


  ///发送忘记密码API
  void sendForgetPwd(Function() onSuccessDialog){
    String email = addressController.text;
    var requestModel = ForgetRequestModel(email: email);
    _userRepository.doForget(requestModel, (response) {
      isNeedShowSuccessDialog = true;
      onSuccessDialog();
    }, onErrorDialog);
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }
}
