import 'dart:convert';

ForgetRequestModel loginRequestModelFromJson(String str) => ForgetRequestModel.fromJson(json.decode(str));

String loginRequestModelToJson(ForgetRequestModel data) => json.encode(data.toJson());

///忘记密码的RequestModel
class ForgetRequestModel {
    ForgetRequestModel({
        this.email,
    });

    String email;

    factory ForgetRequestModel.fromJson(Map<String, dynamic> json) => ForgetRequestModel(
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
    };
}
