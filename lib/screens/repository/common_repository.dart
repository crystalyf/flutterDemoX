

import 'package:flutter_demox/screens/model/BaseResponseModel.dart';
import 'package:flutter_demox/screens/model/ForgetRequestModel.dart';
import 'package:flutter_demox/screens/model/ForgetResponseModel.dart';
import 'package:flutter_demox/screens/remote/DioUtils.dart';

class CommonRepository {

  ///发送forget api
  void doForget(
      ForgetRequestModel requestModel,
      Function(ForgetResponseModel t) onApiSuccess,
      Function(String error) onError) {
      DioUtils.request(
      DioUtils.BASE_URL + DioUtils.forget,
      method: DioUtils.POST,
      headers: {"content-type": "application/json"},
      parameters: requestModel.toJson(),
      onSuccess: (response) {
        var model = forgetResponseFromJson(response);
        print('api---success----$response}');
        if (model is BaseResponseModel) {
          if (model.getRet() == "0" && model.getErr() == "000") {
            onApiSuccess(model);
          } else {
            if (onError != null) {
              onError("common error");
            }
          }
        }
      },
      onError: (error) {
        onError("${error.toString()}");
        print('api---onError----' + error.toString());
      },
    );
  }

}
