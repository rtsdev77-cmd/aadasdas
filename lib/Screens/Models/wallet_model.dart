// To parse this JSON data, do
//
//     final walletModel = walletModelFromJson(jsonString);

import 'dart:convert';

WalletModel walletModelFromJson(String str) => WalletModel.fromJson(json.decode(str));

String walletModelToJson(WalletModel data) => json.encode(data.toJson());

class WalletModel {
  List<Walletitem> walletitem;
  String wallet;
  String responseCode;
  String result;
  String responseMsg;

  WalletModel({
    required this.walletitem,
    required this.wallet,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
    walletitem: List<Walletitem>.from(json["Walletitem"].map((x) => Walletitem.fromJson(x))),
    wallet: json["wallet"],
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "Walletitem": List<dynamic>.from(walletitem.map((x) => x.toJson())),
    "wallet": wallet,
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class Walletitem {
  String message;
  String status;
  String amt;
  String tdate;

  Walletitem({
    required this.message,
    required this.status,
    required this.amt,
    required this.tdate,
  });

  factory Walletitem.fromJson(Map<String, dynamic> json) => Walletitem(
    message: json["message"],
    status: json["status"],
    amt: json["amt"],
    tdate: json["tdate"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "amt": amt,
    "tdate": tdate,
  };
}
