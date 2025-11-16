// To parse this JSON data, do
//
//     final homePageModel = homePageModelFromJson(jsonString);

import 'dart:convert';

HomePageModel homePageModelFromJson(String str) => HomePageModel.fromJson(json.decode(str));

String homePageModelToJson(HomePageModel data) => json.encode(data.toJson());

class HomePageModel {
  String? responseCode;
  String? result;
  String? responseMsg;
  HomeData? homeData;

  HomePageModel({
    this.responseCode,
    this.result,
    this.responseMsg,
    this.homeData,
  });

  factory HomePageModel.fromJson(Map<String, dynamic> json) => HomePageModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    homeData: json["HomeData"] == null ? null : HomeData.fromJson(json["HomeData"]),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "HomeData": homeData?.toJson(),
  };
}

class HomeData {
  List<Banner>? banner;
  List<Statelist>? statelist;
  String? currency;
  int? wallet;
  String? isVerify;
  String? topMsg;
  String? gKey;

  HomeData({
    this.banner,
    this.statelist,
    this.currency,
    this.wallet,
    this.isVerify,
    this.topMsg,
    this.gKey,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
    banner: json["Banner"] == null ? [] : List<Banner>.from(json["Banner"]!.map((x) => Banner.fromJson(x))),
    statelist: json["Statelist"] == null ? [] : List<Statelist>.from(json["Statelist"]!.map((x) => Statelist.fromJson(x))),
    currency: json["currency"],
    wallet: json["wallet"],
    isVerify: json["is_verify"],
    topMsg: json["top_msg"],
    gKey: json["g_key"],
  );

  Map<String, dynamic> toJson() => {
    "Banner": banner == null ? [] : List<dynamic>.from(banner!.map((x) => x.toJson())),
    "Statelist": statelist == null ? [] : List<dynamic>.from(statelist!.map((x) => x.toJson())),
    "currency": currency,
    "wallet": wallet,
    "is_verify": isVerify,
    "top_msg": topMsg,
    "g_key": gKey,
  };
}

class Banner {
  String? id;
  String? img;

  Banner({
    this.id,
    this.img,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    id: json["id"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "img": img,
  };
}

class Statelist {
  String? id;
  String? title;
  String? img;
  int? totalLoad;
  int? totalLorry;

  Statelist({
    this.id,
    this.title,
    this.img,
    this.totalLoad,
    this.totalLorry,
  });

  factory Statelist.fromJson(Map<String, dynamic> json) => Statelist(
    id: json["id"],
    title: json["title"],
    img: json["img"],
    totalLoad: json["total_load"],
    totalLorry: json["total_lorry"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "img": img,
    "total_load": totalLoad,
    "total_lorry": totalLorry,
  };
}
