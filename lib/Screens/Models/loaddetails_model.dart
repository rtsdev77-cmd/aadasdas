// To parse this JSON data, do
//
//     final loadsDetils = loadsDetilsFromJson(jsonString);

import 'dart:convert';

LoadsDetils loadsDetilsFromJson(String str) => LoadsDetils.fromJson(json.decode(str));

String loadsDetilsToJson(LoadsDetils data) => json.encode(data.toJson());

class LoadsDetils {
  LoadDetails loadDetails;
  String responseCode;
  String result;
  String responseMsg;

  LoadsDetils({
    required this.loadDetails,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory LoadsDetils.fromJson(Map<String, dynamic> json) => LoadsDetils(
    loadDetails: LoadDetails.fromJson(json["LoadDetails"]),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "LoadDetails": loadDetails.toJson(),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class LoadDetails {
  String bidderId;
  String lorryId;
  String bidderName;
  String bidderImg;
  String lorryNumber;
  String bidderMobile;
  String subdriverMobile;
  String subdriverName;
  String rate;
  String id;
  String vehicleTitle;
  String vehicleImg;
  String pickupPoint;
  String dropPoint;
  String pMethodName;
  String orderTransactionId;
  String walAmt;
  String description;
  String pickLat;
  String pickLng;
  String dropLat;
  String dropLng;
  String pickName;
  String pickMobile;
  String dropName;
  String dropMobile;
  String dropStateId;
  String visibleHours;
  String pickStateId;
  String pickupState;
  String dropState;
  String isRate;
  String amount;
  String amtType;
  String totalAmt;
  String flowId;
  String message;
  DateTime postDate;
  int svisibleHours;
  String hoursType;
  String materialName;
  String weight;
  String loadStatus;
  List<dynamic> bidStatus;

  LoadDetails({
    required this.bidderId,
    required this.lorryId,
    required this.bidderName,
    required this.bidderImg,
    required this.lorryNumber,
    required this.bidderMobile,
    required this.subdriverMobile,
    required this.subdriverName,
    required this.rate,
    required this.id,
    required this.vehicleTitle,
    required this.vehicleImg,
    required this.pickupPoint,
    required this.dropPoint,
    required this.pMethodName,
    required this.orderTransactionId,
    required this.walAmt,
    required this.description,
    required this.pickLat,
    required this.pickLng,
    required this.dropLat,
    required this.dropLng,
    required this.pickName,
    required this.pickMobile,
    required this.dropName,
    required this.dropMobile,
    required this.dropStateId,
    required this.visibleHours,
    required this.pickStateId,
    required this.pickupState,
    required this.dropState,
    required this.isRate,
    required this.amount,
    required this.amtType,
    required this.totalAmt,
    required this.flowId,
    required this.message,
    required this.postDate,
    required this.svisibleHours,
    required this.hoursType,
    required this.materialName,
    required this.weight,
    required this.loadStatus,
    required this.bidStatus,
  });

  factory LoadDetails.fromJson(Map<String, dynamic> json) => LoadDetails(
    bidderId: json["bidder_id"],
    lorryId: json["lorry_id"],
    bidderName: json["bidder_name"],
    bidderImg: json["bidder_img"],
    lorryNumber: json["lorry_number"],
    bidderMobile: json["bidder_mobile"],
    subdriverMobile: json["subdriver_mobile"],
    subdriverName: json["subdriver_name"],
    rate: json["rate"],
    id: json["id"],
    vehicleTitle: json["vehicle_title"],
    vehicleImg: json["vehicle_img"],
    pickupPoint: json["pickup_point"],
    dropPoint: json["drop_point"],
    pMethodName: json["p_method_name"],
    orderTransactionId: json["Order_Transaction_id"],
    walAmt: json["wal_amt"],
    description: json["description"],
    pickLat: json["pick_lat"],
    pickLng: json["pick_lng"],
    dropLat: json["drop_lat"],
    dropLng: json["drop_lng"],
    pickName: json["pick_name"],
    pickMobile: json["pick_mobile"],
    dropName: json["drop_name"],
    dropMobile: json["drop_mobile"],
    dropStateId: json["drop_state_id"],
    visibleHours: json["visible_hours"],
    pickStateId: json["pick_state_id"],
    pickupState: json["pickup_state"],
    dropState: json["drop_state"],
    isRate: json["is_rate"],
    amount: json["amount"],
    amtType: json["amt_type"],
    totalAmt: json["total_amt"],
    flowId: json["flow_id"],
    message: json["message"],
    postDate: DateTime.parse(json["post_date"]),
    svisibleHours: json["svisible_hours"],
    hoursType: json["hours_type"],
    materialName: json["material_name"],
    weight: json["weight"],
    loadStatus: json["load_status"],
    bidStatus: List<dynamic>.from(json["bid_status"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "bidder_id": bidderId,
    "lorry_id": lorryId,
    "bidder_name": bidderName,
    "bidder_img": bidderImg,
    "lorry_number": lorryNumber,
    "bidder_mobile": bidderMobile,
    "subdriver_mobile": subdriverMobile,
    "subdriver_name": subdriverName,
    "rate": rate,
    "id": id,
    "vehicle_title": vehicleTitle,
    "vehicle_img": vehicleImg,
    "pickup_point": pickupPoint,
    "drop_point": dropPoint,
    "p_method_name": pMethodName,
    "Order_Transaction_id": orderTransactionId,
    "wal_amt": walAmt,
    "description": description,
    "pick_lat": pickLat,
    "pick_lng": pickLng,
    "drop_lat": dropLat,
    "drop_lng": dropLng,
    "pick_name": pickName,
    "pick_mobile": pickMobile,
    "drop_name": dropName,
    "drop_mobile": dropMobile,
    "drop_state_id": dropStateId,
    "visible_hours": visibleHours,
    "pick_state_id": pickStateId,
    "pickup_state": pickupState,
    "drop_state": dropState,
    "is_rate": isRate,
    "amount": amount,
    "amt_type": amtType,
    "total_amt": totalAmt,
    "flow_id": flowId,
    "message": message,
    "post_date": postDate.toIso8601String(),
    "svisible_hours": svisibleHours,
    "hours_type": hoursType,
    "material_name": materialName,
    "weight": weight,
    "load_status": loadStatus,
    "bid_status": List<dynamic>.from(bidStatus.map((x) => x)),
  };
}
