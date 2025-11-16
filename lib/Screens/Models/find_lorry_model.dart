// To parse this JSON data, do
//
//     final findLorryModel = findLorryModelFromJson(jsonString);

import 'dart:convert';

FindLorryModel findLorryModelFromJson(String str) => FindLorryModel.fromJson(json.decode(str));

String findLorryModelToJson(FindLorryModel data) => json.encode(data.toJson());

class FindLorryModel {
  List<FindLorryDatum> findLorryData;
  String responseCode;
  String result;
  String responseMsg;

  FindLorryModel({
    required this.findLorryData,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory FindLorryModel.fromJson(Map<String, dynamic> json) => FindLorryModel(
    findLorryData: List<FindLorryDatum>.from(json["FindLorryData"].map((x) => FindLorryDatum.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "FindLorryData": List<dynamic>.from(findLorryData.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class FindLorryDatum {
  String id;
  String title;
  String minWeight;
  String maxWeight;
  List<Lorrydatum> lorrydata;

  FindLorryDatum({
    required this.id,
    required this.title,
    required this.minWeight,
    required this.maxWeight,
    required this.lorrydata,
  });

  factory FindLorryDatum.fromJson(Map<String, dynamic> json) => FindLorryDatum(
    id: json["id"],
    title: json["title"],
    minWeight: json["min_weight"],
    maxWeight: json["max_weight"],
    lorrydata: List<Lorrydatum>.from(json["lorrydata"].map((x) => Lorrydatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "min_weight": minWeight,
    "max_weight": maxWeight,
    "lorrydata": List<dynamic>.from(lorrydata.map((x) => x.toJson())),
  };
}

class Lorrydatum {
  String lorryId;
  String vehicleId;
  String lorryOwnerId;
  String lorryOwnerTitle;
  String lorryOwnerImg;
  String lorryImg;
  String lorryTitle;
  String weight;
  String review;
  String currLocation;
  int routesCount;
  String rcVerify;
  String lorryNo;

  Lorrydatum({
    required this.lorryId,
    required this.vehicleId,
    required this.lorryOwnerId,
    required this.lorryOwnerTitle,
    required this.lorryOwnerImg,
    required this.lorryImg,
    required this.lorryTitle,
    required this.weight,
    required this.review,
    required this.currLocation,
    required this.routesCount,
    required this.rcVerify,
    required this.lorryNo,
  });

  factory Lorrydatum.fromJson(Map<String, dynamic> json) => Lorrydatum(
    lorryId: json["lorry_id"],
    vehicleId: json["vehicle_id"],
    lorryOwnerId: json["lorry_owner_id"],
    lorryOwnerTitle: json["lorry_owner_title"],
    lorryOwnerImg: json["lorry_owner_img"],
    lorryImg: json["lorry_img"],
    lorryTitle: json["lorry_title"],
    weight: json["weight"],
    review: json["review"],
    currLocation: json["curr_location"],
    routesCount: json["routes_count"],
    rcVerify: json["rc_verify"],
    lorryNo: json["lorry_no"],
  );

  Map<String, dynamic> toJson() => {
    "lorry_id": lorryId,
    "vehicle_id": vehicleId,
    "lorry_owner_id": lorryOwnerId,
    "lorry_owner_title": lorryOwnerTitle,
    "lorry_owner_img": lorryOwnerImg,
    "lorry_img": lorryImg,
    "lorry_title": lorryTitle,
    "weight": weight,
    "review": review,
    "curr_location": currLocation,
    "routes_count": routesCount,
    "rc_verify": rcVerify,
    "lorry_no": lorryNo,
  };
}
