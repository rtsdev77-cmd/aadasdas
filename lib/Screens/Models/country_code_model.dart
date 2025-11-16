// To parse this JSON data, do
//
//     final countryCode = countryCodeFromJson(jsonString);

import 'dart:convert';

CountryCode countryCodeFromJson(String str) => CountryCode.fromJson(json.decode(str));

String countryCodeToJson(CountryCode data) => json.encode(data.toJson());

class CountryCode {
  List<CountryCodeElement> countryCode;
  String responseCode;
  String result;
  String responseMsg;

  CountryCode({
    required this.countryCode,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory CountryCode.fromJson(Map<String, dynamic> json) => CountryCode(
    countryCode: List<CountryCodeElement>.from(json["CountryCode"].map((x) => CountryCodeElement.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "CountryCode": List<dynamic>.from(countryCode.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class CountryCodeElement {
  String id;
  String ccode;
  String status;

  CountryCodeElement({
    required this.id,
    required this.ccode,
    required this.status,
  });

  factory CountryCodeElement.fromJson(Map<String, dynamic> json) => CountryCodeElement(
    id: json["id"],
    ccode: json["ccode"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ccode": ccode,
    "status": status,
  };
}
