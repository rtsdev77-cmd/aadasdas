// To parse this JSON data, do
//
//     final bookedLoadsModel = bookedLoadsModelFromJson(jsonString);

import 'dart:convert';

BookedLoadsModel bookedLoadsModelFromJson(String str) => BookedLoadsModel.fromJson(json.decode(str));

String bookedLoadsModelToJson(BookedLoadsModel data) => json.encode(data.toJson());

class BookedLoadsModel {
  List<BookHistory> bookHistory;
  String responseCode;
  String result;
  String responseMsg;

  BookedLoadsModel({
    required this.bookHistory,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory BookedLoadsModel.fromJson(Map<String, dynamic> json) => BookedLoadsModel(
    bookHistory: List<BookHistory>.from(json["BookHistory"].map((x) => BookHistory.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "BookHistory": List<dynamic>.from(bookHistory.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class BookHistory {
  String lorryId;
  String vehicleId;
  String lorryOwnerId;
  String lorryOwnerTitle;
  String lorryOwnerImg;
  String lorryImg;
  String lorryTitle;
  String weight;
  String currLocation;
  int routesCount;
  String rcVerify;
  String lorryNo;
  String review;
  String loadDistance;

  BookHistory({
    required this.lorryId,
    required this.vehicleId,
    required this.lorryOwnerId,
    required this.lorryOwnerTitle,
    required this.lorryOwnerImg,
    required this.lorryImg,
    required this.lorryTitle,
    required this.weight,
    required this.currLocation,
    required this.routesCount,
    required this.rcVerify,
    required this.lorryNo,
    required this.review,
    required this.loadDistance,
  });

  factory BookHistory.fromJson(Map<String, dynamic> json) => BookHistory(
    lorryId: json["lorry_id"],
    vehicleId: json["vehicle_id"],
    lorryOwnerId: json["lorry_owner_id"],
    lorryOwnerTitle: json["lorry_owner_title"],
    lorryOwnerImg: json["lorry_owner_img"],
    lorryImg: json["lorry_img"],
    lorryTitle: json["lorry_title"],
    weight: json["weight"],
    currLocation: json["curr_location"],
    routesCount: json["routes_count"],
    rcVerify: json["rc_verify"],
    lorryNo: json["lorry_no"],
    review: json["review"],
    loadDistance: json["load_distance"],
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
    "curr_location": currLocation,
    "routes_count": routesCount,
    "rc_verify": rcVerify,
    "lorry_no": lorryNo,
    "review": review,
    "load_distance": loadDistance,
  };
}
