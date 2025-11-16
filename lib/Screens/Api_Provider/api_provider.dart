import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'imageupload_api.dart';
import 'dio_api.dart';
import '../Models/faq_model.dart';
import '../Models/loaddetails_model.dart';
import '../Models/my_loads_model.dart';
import '../Models/notification_model.dart';
import '../Models/payment_method_model.dart';
import '../Models/privacy_policy_model.dart';
import '../Models/review_model.dart';
import '../Models/wallet_model.dart';
import '../Models/booked_history_model.dart';
import '../Models/booked_loads_model.dart';
import '../Models/country_code_model.dart';
import '../Models/profile_detils_model.dart';
 


class ApiProvider {
  final api = Api();
  String basUrlApi = "${basUrl}api";

//!- - - - - country_code - - - - - !//
  Future<List<CountryCodeElement>> getCountryCode() async {
    final response = await api.sendRequest.get("$basUrlApi/country_code.php");
    var data = CountryCode.fromJson(response.data);
    return data.countryCode;
  }

//?- - - - - MobileCheck - - - - - !//
  Future checkMobileNumber({required String number, required String code}) async {
    Map body = {"mobile": number, "ccode": code};
    final response = await api.sendRequest.post(
      "$basUrlApi/mobile_check.php",
      data: jsonEncode(body),
    );
    debugPrint("============ sendOtp body ========= $body");
    debugPrint("========== sendOtp response ======= ${response.data}");
    
    var datas = response.data;

    return datas;
  }

//?- - - - - send otp - - - - - !//
  Future sendOtp({required String number/*, required String code*/}) async {
    Map body = {"mobile": number};
    final response = await api.sendRequest.post(
      "${basUrlApi}/send_otp.php",
      data: body,
    );

    debugPrint("============ sendOtp body ========= $body");
    debugPrint("========== sendOtp response ======= ${response.data}");
    var datas = response.data;
    return datas;
  }

//!- - - - - ForgotPass - - - - - !//
  Future forgetPassword(
      {required String mobile,
      required String password,
      required String ccode}) async {
    Map body = {"mobile": mobile, "password": password, "ccode": ccode};
    log("Api-------$body");
    var response = await api.sendRequest.post(
      "$basUrlApi/forget_password.php",
      data: jsonEncode(body),
    );

    return response.data;
  }

//?- - - - - LoginUser - - - - - !//
  Future loginUser(
      {required String number,
      required String code,
      required String password}) async {
    Map body = {"mobile": number, "ccode": code, "password": password};

    var response = await api.sendRequest.post(
      "$basUrlApi/login_user.php",
      data: jsonEncode(body),
    );
    return response.data;
  }

//!- - - - - RegisterUser - - - - - !//
  Future registerUser(
      {required String name,
      required String mobile,
      required String cCode,
      required String email,
      required String password,
      required String referCode}) async {
    Map body = {
      "name": name,
      "mobile": mobile,
      "ccode": cCode,
      "email": email,
      "password": password,
      "refercode": referCode
    };

    var respons = await api.sendRequest.post(
      "$basUrlApi/reg_user.php",
      data: jsonEncode(body),
    );

    return respons.data;
  }

//?- - - - - HomePageApi - - - - - !//
  Future homePageData({required String uid}) async {
    var respons = await api.sendRequest.post(
      "$basUrlApi/home_page.php",
      data: jsonEncode({"uid": uid}),
    );

    return respons.data;
  }

//!- - - - - EditProfile - - - - - !//
  Future editProfile(
      {required String name, required String pass, required String uid}) async {
    Map body = {"name": name, "password": pass, "uid": uid};
    var response = await api.sendRequest.post(
      "$basUrlApi/profile_edit.php",
      data: jsonEncode(body),
    );

    return response.data;
  }

//?- - - - - VehicleList - - - - - !//
  Future getVehicleList({required String uid}) async {
    var respons = await api.sendRequest.post(
      "$basUrlApi/vehicle_list.php",
      data: jsonEncode({
        "uid": uid,
      }),
    );
    return respons.data;
  }

//!- - - - - CheckState - - - - - !//
  Future checkStat(
      {required String pickUpName, required String dropStateName}) async {
    Map body = {
      "pick_state_name": pickUpName,
      "drop_state_name": dropStateName
    };

    var respons = await api.sendRequest.post(
      "$basUrlApi/getstateid.php",
      data: jsonEncode(body),
    );

    return respons.data;
  }

//?- - - - - PostLoads - - - - - !//
  Future postLoads({
    required String uid,
    required String pickupPoint,
    required String dropPoint,
    required String materialName,
    required String weight,
    required String description,
    required String vehicleId,
    required String amount,
    required String amtType,
    required String visibleHours,
    required String totalAmt,
    required String pickLat,
    required String pickLng,
    required String dropLat,
    required String dropLng,
    required String pickStateId,
    required String dropStateId,
    required String dropMobile,
    required String dropName,
    required String pickMobile,
    required String pickName,
  }) async {
    Map body = {
      "uid": uid,
      "pickup_point": pickupPoint,
      "drop_point": dropPoint,
      "material_name": materialName,
      "weight": weight,
      "description": description,
      "vehicle_id": vehicleId,
      "amount": amount,
      "amt_type": amtType,
      "visible_hours": visibleHours,
      "total_amt": totalAmt,
      "pick_lat": pickLat,
      "pick_lng": pickLng,
      "drop_lat": dropLat,
      "drop_lng": dropLng,
      "pick_state_id": pickStateId,
      "drop_state_id": dropStateId,
      "drop_mobile": dropMobile,
      "drop_name": dropName.replaceAll(")", ""),
      "pick_mobile": pickMobile,
      "pick_name": pickName.replaceAll(")", "")
    };
    log("$body");
    var respons = await api.sendRequest.post(
      "$basUrlApi/post_load.php",
      data: jsonEncode(body),
    );

    return respons.data;
  }

//!- - - - - FindLorry - - - - - !//
  Future findLorry({
    required String uid,
    required String pickStateId,
    required String dropStateId,
  }) async {
    Map body = {
      "uid": uid,
      "pick_state_id": pickStateId,
      "drop_state_id": dropStateId
    };

    var respons = await api.sendRequest.post(
      "$basUrlApi/find_lorry.php",
      data: jsonEncode(body),
    );

    return respons.data;
  }

//?- - - - - PostLoadRequest - - - - - !//
  Future postLoadRequest(
      {required String uid,
      required String pickupPoint,
      required String dropPoint,
      required String materialName,
      required String weight,
      required String description,
      required String vehicleId,
      required String amount,
      required String amtType,
      required String visibleHours,
      required String totalAmt,
      required String pickLat,
      required String pickLng,
      required String dropLat,
      required String dropLng,
      required String pickStateId,
      required String dropStateId,
      required String dropMobile,
      required String dropName,
      required String pickMobile,
      required String pickName,
      required String lorryId,
      required String lorryOwnerId}) async {
    Map body = {
      "uid": uid,
      "pickup_point": pickupPoint,
      "drop_point": dropPoint,
      "material_name": materialName,
      "weight": weight,
      "description": description,
      "vehicle_id": vehicleId,
      "amount": amount,
      "amt_type": amtType,
      "visible_hours": visibleHours,
      "total_amt": totalAmt,
      "pick_lat": pickLat,
      "pick_lng": pickLng,
      "drop_lat": dropLat,
      "drop_lng": dropLng,
      "pick_state_id": pickStateId,
      "lorry_id": lorryId,
      "lorry_owner_id": lorryOwnerId,
      "drop_state_id": dropStateId,
      "pick_name": pickName.replaceAll(")", ""),
      "pick_mobile": pickMobile,
      "drop_name": dropName.replaceAll(")", ""),
      "drop_mobile": dropMobile
    };
    log("$body");

    var respons = await api.sendRequest.post("$basUrlApi/book_lorry.php", data: jsonEncode(body));
    return respons.data;
  }

//!- - - - - MyLoadsData - - - - - !//
  Future<MyLoadsModel> myLoadsData(
      {required String uid, required String status}) async {
    Map body = {"uid": uid, "status": status};

    var respons = await api.sendRequest.post(
      "$basUrlApi/load_history.php",
      data: jsonEncode(body),
    );
    return MyLoadsModel.fromJson(respons.data);
  }

//?- - - - - Loadsderils - - - - - !//
  Future<LoadsDetils> loadsDetils(
      {required String uid, required String loadId}) async {
    Map body = {"uid": uid, "load_id": loadId};
    var respons = await api.sendRequest.post(
      "$basUrlApi/load_details.php",
      data: jsonEncode(body),
    );

    return LoadsDetils.fromJson(respons.data);
  }

//!- - - - - DeleteLoads - - - - - !//
  Future deleteLoads({required String uid, required String recordId}) async {
    Map body = {"uid": uid, "record_id": recordId};
    var respons = await api.sendRequest
        .post("$basUrlApi/delete_load.php", data: jsonEncode(body));
    return respons.data;
  }

//?- - - - - PaymentMethod - - - - - !//
  Future<PaymentGateway> paymentMethodData() async {
    var response = await api.sendRequest.get('$basUrlApi/paymentgateway.php');

    return PaymentGateway.fromJson(response.data);
  }

//!- - - - - MakeDecision - - - - - !//
  Future makeDecision(
      {required String uid,
      required String status,
      required String loadId,
      required String ownerId,
      required String lorryId,
      required String amount,
      required String amtType,
      required String totalAmt,
      required String walAmt,
      required String pMethodId,
      required String transId,
      required String description}) async {
    Map body = {
      "uid": uid,
      "status": status,
      "load_id": loadId,
      "owner_id": ownerId,
      "lorry_id": lorryId,
      "amount": amount,
      "amt_type": amtType,
      "total_amt": totalAmt,
      "wal_amt": walAmt,
      "p_method_id": pMethodId,
      "trans_id": transId,
      "description": description
    };

    var response = await api.sendRequest.post(
      "$basUrlApi/make_decision.php",
      data: jsonEncode(body),
    );

    return response.data;
  }

//?- - - - - Rating - - - - - !//
  Future rating(
      {required String uid,
      required String totalRate,
      required String rateText,
      required String loadId}) async {
    Map body = {
      "uid": uid,
      "total_trate": totalRate,
      "rate_ttext": rateText,
      "load_id": loadId
    };

    log("++++++++++++++$body");
    var response = await api.sendRequest.post(
      "$basUrlApi/rate_update.php",
      data: jsonEncode(body),
    );
    return response.data;
  }

//!- - - - - MobileCheck - - - - - !//
  Future editeLoad(
      {required String uid,
      required String pickupPoint,
      required String dropPoint,
      required String materialName,
      required String weight,
      required String description,
      required String vehicleId,
      required String amount,
      required String amtType,
      required String visibleHours,
      required String totalAmt,
      required String pickLat,
      required String pickLng,
      required String dropLat,
      required String dropLng,
      required String pickStateId,
      required String dropStateId,
      required String loadId}) async {
    Map body = {
      "uid": uid,
      "pickup_point": pickupPoint,
      "drop_point": dropPoint,
      "material_name": materialName,
      "weight": weight,
      "description": description,
      "vehicle_id": vehicleId,
      "amount": amount,
      "amt_type": amtType,
      "visible_hours": visibleHours,
      "total_amt": totalAmt,
      "pick_lat": pickLat,
      "pick_lng": pickLng,
      "drop_lat": dropLat,
      "drop_lng": dropLng,
      "pick_state_id": pickStateId,
      "drop_state_id": dropStateId,
      "record_id": loadId
    };

    var respons = await api.sendRequest.post(
      "$basUrlApi/edit_load.php",
      data: jsonEncode(body),
    );

    return respons.data;
  }

//?- - - - - lorryOwnerProfile - - - - - !//
  Future<ReviewModel> lorryOwnerProfile(
      {required String uid,
      required String ownerId,
      required String lorryId}) async {
    Map body = {"uid": uid, "owner_id": ownerId, "lorry_id": lorryId};
    var response = await api.sendRequest.post(
      "$basUrlApi/lorri_profile.php",
      data: body,
    );

    return ReviewModel.fromJson(response.data);
  }

//!- - - - - TransProfile - - - - - !//
  Future<ProfileDetilsModel> transProfile({required String uid}) async {
    Map body = {
      "uid": uid,
    };  
    var response = await api.sendRequest.post(
      "$basUrlApi/trans_profile.php",
      data: body,
    );

    return ProfileDetilsModel.fromJson(response.data);
  }

//?- - - - - BookHistory - - - - - !//
  Future<BookedLoadsModel> bookHistory(
      {required String uid, required String status}) async {
    Map body = {"uid": uid, "status": status};
    var respons = await api.sendRequest.post(
      "$basUrlApi/book_history.php",
      data: jsonEncode(body),
    );
    return BookedLoadsModel.fromJson(respons.data);
  }

//!- - - - - BookDetails - - - - - !//
  Future<BookedHistoryModel> bookDetails(
      {required String uid, required String loadId}) async {
    Map body = {
      "uid": uid,
      "load_id": loadId,
    };
    var respons = await api.sendRequest.post(
      "$basUrlApi/book_details.php",
      data: jsonEncode(body),
    );

    return BookedHistoryModel.fromJson(respons.data);
  }

//?- - - - - BookOffer - - - - - !//
  Future bookOffer(
      {required String uid,
      required String loadId,
      required String status,
      required String offerTotal,
      required String offerType,
      required String offerPrice,
      required String offerDescription}) async {
    Map body = {
      "uid": uid,
      "load_id": loadId,
      "status": status,
      "offer_total": offerTotal,
      "offer_type": offerType,
      "offer_price": offerPrice,
      "offer_description": offerDescription
    };

    log("$body");
    var response = await api.sendRequest.post(
      "$basUrlApi/offer_decision.php",
      data: jsonEncode(body),
    );

    return response.data;
  }

//!- - - - - RejectOffer - - - - - !//
  Future rejectOffer(
      {required String uid,
      required String loadId,
      required String commentReject}) async {
    Map body = {
      "uid": uid,
      "load_id": loadId,
      "status": "2",
      "comment_reject": commentReject
    };
    var response = await api.sendRequest.post(
      "$basUrlApi/offer_decision.php",
      data: jsonEncode(body),
    );

    return response.data;
  }

//?- - - - - WallectUpdate - - - - - !//
  Future walletUpdate({required String uid, required String amount}) async {
    Map body = {"uid": uid, "wallet": amount};
    var respons =
        await api.sendRequest.post("$basUrlApi/wallet_up.php", data: body);

    return respons.data;
  }

//!- - - - - WalletReport - - - - - !//
  Future<WalletModel> walletReport({required String uid}) async {
    var response = await api.sendRequest
        .post("$basUrlApi/wallet_report.php", data: jsonEncode({"uid": uid}));

    return WalletModel.fromJson(response.data);
  }

//?- - - - - acceptPay - - - - - !//
  Future acceptPay(
      {required String uid,
      required String loadId,
      required String status,
      required String walAmt,
      required String pMethodId,
      required String transId}) async {
    Map body = {
      "uid": uid,
      "load_id": loadId,
      "status": status,
      "wal_amt": walAmt,
      "p_method_id": pMethodId,
      "trans_id": transId
    };
    var response = await api.sendRequest.post(
      "$basUrlApi/offer_decision.php",
      data: body,
    );
    return response.data;
  }

//!- - - - - OnlyAccept - - - - - !//
  Future accept(
      {required String uid,
      required String loadId,
      required String status,
      required String amount,
      required String amtType,
      required String totalAmt,
      required String walAmt,
      required String pMethodeId,
      required String transId,
      required String description}) async {
    Map body = {
      "uid": uid,
      "load_id": loadId,
      "status": status,
      "comment_reject": "",
      "amount": amount,
      "amt_type": amtType,
      "total_amt": totalAmt,
      "wal_amt": walAmt,
      "p_method_id": pMethodeId,
      "trans_id": transId,
      "description": description
    };

    var response =
        await api.sendRequest.post("$basUrlApi/offer_decision.php", data: body);

    return response.data;
  }

//?- - - - - PrivacyPolicy - - - - - !//
  Future<PrivacyPolicyModel> privacyPolicy() async {
    var response = await api.sendRequest.get("$basUrlApi/pagelist.php");
    return PrivacyPolicyModel.fromJson(response.data);
  }

//!- - - - - Faq - - - - - !//
  Future<FaqDataModel> faq({required String uid}) async {
    var response = await api.sendRequest
        .post("$basUrlApi/faq.php", data: jsonEncode({"uid": uid}));

    return FaqDataModel.fromJson(response.data);
  }

//?- - - - - Notification - - - - - !//
  Future notification({required String uid}) async {
    var response = await api.sendRequest
        .post("$basUrlApi/notification.php", data: jsonEncode({"uid": uid}));

    return NotificationModel.fromJson(jsonDecode(response.data));
  }

//!- - - - - SslCommerz - - - - - !//
  Future sslcommerz({required String valId}) async {
    var response = await api.sendRequest.post(
        "https://sandbox.sslcommerz.com//validator/api/validationserverAPI.php?val_id=$valId&store_id=cscod6242b3f49944d&store_passwd=cscod6242b3f49944d@ssl");

    return response.data;
  }
}

