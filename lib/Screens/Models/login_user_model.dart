// To parse this JSON data, do
//
//     final loginUser = loginUserFromJson(jsonString);

import 'dart:convert';

LoginUser loginUserFromJson(String str) => LoginUser.fromJson(json.decode(str));

String loginUserToJson(LoginUser data) => json.encode(data.toJson());

class LoginUser {
  UserLogin userLogin;
  String responseCode;
  String result;
  String responseMsg;

  LoginUser({
    required this.userLogin,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) => LoginUser(
    userLogin: UserLogin.fromJson(json["UserLogin"]),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "UserLogin": userLogin.toJson(),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class UserLogin {
  String id;
  String name;
  String email;
  String mobile;
  String password;
  DateTime rdate;
  String status;
  String ccode;
  String code;
  dynamic refercode;
  String wallet;
  String proPic;
  dynamic identityDocument;
  dynamic selfie;
  String isVerify;
  dynamic rejectComment;

  UserLogin({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.password,
    required this.rdate,
    required this.status,
    required this.ccode,
    required this.code,
    this.refercode,
    required this.wallet,
    required this.proPic,
    this.identityDocument,
    this.selfie,
    required this.isVerify,
    this.rejectComment,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    password: json["password"],
    rdate: DateTime.parse(json["rdate"]),
    status: json["status"],
    ccode: json["ccode"],
    code: json["code"],
    refercode: json["refercode"],
    wallet: json["wallet"],
    proPic: json["pro_pic"] ?? "",
    identityDocument: json["identity_document"],
    selfie: json["selfie"],
    isVerify: json["is_verify"],
    rejectComment: json["reject_comment"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile": mobile,
    "password": password,
    "rdate": rdate.toIso8601String(),
    "status": status,
    "ccode": ccode,
    "code": code,
    "refercode": refercode,
    "wallet": wallet,
    "pro_pic": proPic,
    "identity_document": identityDocument,
    "selfie": selfie,
    "is_verify": isVerify,
    "reject_comment": rejectComment,
  };
}
