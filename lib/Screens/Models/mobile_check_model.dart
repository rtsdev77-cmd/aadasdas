// To parse this JSON data, do
//
//     final mobilecheck = mobilecheckFromJson(jsonString);

import 'dart:convert';

Mobilecheck mobilecheckFromJson(String str) => Mobilecheck.fromJson(json.decode(str));

String mobilecheckToJson(Mobilecheck data) => json.encode(data.toJson());

class Mobilecheck {
  String responseCode;
  String result;
  String responseMsg;

  Mobilecheck({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory Mobilecheck.fromJson(Map<String, dynamic> json) => Mobilecheck(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}
