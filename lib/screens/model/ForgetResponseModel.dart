import 'dart:convert';

import 'BaseResponseModel.dart';

ForgetResponseModel forgetResponseFromJson(String str) => ForgetResponseModel.fromJson(json.decode(str));

String forgetResponseToJson(ForgetResponseModel data) => json.encode(data.toJson());

///忘记密码的ResponseModel
class ForgetResponseModel implements BaseResponseModel {
  ForgetResponseModel({
    this.ret,
    this.err,
    this.detail,
  });

  String ret;
  String err;
  ForgetDetail detail;

  factory ForgetResponseModel.fromJson(Map<String, dynamic> json) => ForgetResponseModel(
    ret: json["ret"],
    err: json["err"],
    detail: ForgetDetail.fromJson(json["detail"]),
  );

  Map<String, dynamic> toJson() => {
    "ret": ret,
    "err": err,
    "detail": detail.toJson(),
  };

  @override
  String getErr() {
    return err;
  }

  @override
  String getRet() {
    return ret;
  }
}

class ForgetDetail {
  ForgetDetail({
    this.message,
  });

  String message;

  factory ForgetDetail.fromJson(Map<String, dynamic> json) => ForgetDetail(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
