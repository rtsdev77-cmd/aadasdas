// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../AppConstData/app_colors.dart';
import '../../Controllers/loadsdetails_controller.dart';
import '../../Controllers/map_location_update_controller.dart';
import '../../Controllers/myloads_controller.dart';
import '../../Controllers/postloads1_controller.dart';
import '../Api_Provider/imageupload_api.dart';
import 'payment_method.dart';
import 'profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AppConstData/routes.dart';
import '../../AppConstData/typography.dart';
import '../../firebase_services/fetchdata.dart';
import '../../widgets/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../Api_Provider/api_provider.dart';
import 'booked_details.dart';

class LoadsDetails extends StatefulWidget {
  final String uid;
  final String loadId;
  final String currency;
  const LoadsDetails({
    super.key,
    required this.uid,
    required this.loadId,
    required this.currency,
  });

  @override
  State<LoadsDetails> createState() => _LoadsDetailsState();
}

class _LoadsDetailsState extends State<LoadsDetails> {
  LoadsDetailsController loadsDetailsController = Get.put(LoadsDetailsController());
  PostLoads1Controller postLoads1Controller = Get.put(PostLoads1Controller());
  MyLoadsController myLoadsController = Get.put(MyLoadsController());
  MaplocationUpdate maplocationUpdate = Get.put(MaplocationUpdate());

  FetchingServices fetchLocation = FetchingServices();

  @override
  void initState() {
    super.initState();
    getDataFromApi();
  }

String isPicked = "";
  getDataFromApi() {
    movingLat = 0.0;
    movingLong = 0.0;
    ApiProvider().loadsDetils(
      uid: widget.uid,
      loadId: widget.loadId,
    ).then((value) async {
      loadsDetailsController.setDetilsValue(value, value.loadDetails.svisibleHours);
      loadsDetailsController.setIsLoading(false);
      if (loadsDetailsController.detailsData.loadDetails.loadStatus != "Pending") {
        fetchLocation.getLocation(lorryId: loadsDetailsController.detailsData.loadDetails.lorryId).listen((event) {
          print("LOC?ATION ${event["ispicked"]} ${loadsDetailsController.detailsData.loadDetails.lorryId}");
            setState(() {
              if(event["long"] == "0.0"){
                  isPicked = event["ispicked"];
                  movingLat = double.parse(loadsDetailsController.detailsData.loadDetails.pickLat);
                  movingLong = double.parse(loadsDetailsController.detailsData.loadDetails.pickLng);
        
                maplocationUpdate.addMarkerpickup("Pickup", double.parse(loadsDetailsController.detailsData.loadDetails.pickLat), double.parse(loadsDetailsController.detailsData.loadDetails.pickLng));
                maplocationUpdate.addMarkerdrop("Drop", double.parse(loadsDetailsController.detailsData.loadDetails.dropLat), double.parse(loadsDetailsController.detailsData.loadDetails.dropLng));
                maplocationUpdate.getDirections(latPick: double.parse(loadsDetailsController.detailsData.loadDetails.pickLat), longPick: double.parse(loadsDetailsController.detailsData.loadDetails.pickLng), latDrop: double.parse(loadsDetailsController.detailsData.loadDetails.dropLat), longDrop: double.parse(loadsDetailsController.detailsData.loadDetails.dropLng));
              } else if(event["ispicked"] == "2") {
        
                  isPicked = event["ispicked"];
                  movingLat = double.parse(event["late"]);
                  movingLong = double.parse(event["long"]);
        
                maplocationUpdate.startLiveTracking(pickLat: loadsDetailsController.detailsData.loadDetails.pickLat, pickLong: loadsDetailsController.detailsData.loadDetails.pickLng, dropLat: loadsDetailsController.detailsData.loadDetails.dropLat, dropLong: loadsDetailsController.detailsData.loadDetails.dropLng, vehicleLat: event["late"], vehicleLng: event["long"], isPickup: false,);
              } else {
                  isPicked = event["ispicked"];
                  movingLat = double.parse(event["late"]);
                  movingLong = double.parse(event["long"]);
                maplocationUpdate.startLiveTracking(pickLat: loadsDetailsController.detailsData.loadDetails.pickLat, pickLong: loadsDetailsController.detailsData.loadDetails.pickLng, dropLat: loadsDetailsController.detailsData.loadDetails.dropLat, dropLong: loadsDetailsController.detailsData.loadDetails.dropLng, vehicleLat: event["late"], vehicleLng: event["long"],isPickup: true);
              }
            });
        },);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    loadsDetailsController.isLoading = true;
  }

  void _animateToUser() {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(movingLat, movingLong),
          zoom: 14.0,
        ),
      ),
    );
  }


  TextEditingController feedback = TextEditingController();

  late GoogleMapController _controller;

  double rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(
          Duration(seconds: 1),
          () {
            getDataFromApi();
          },
        );
      },
      child: GetBuilder<LoadsDetailsController>(
        builder: (loadsDetailsController) {
          return loadsDetailsController.isLoading
              ? GetBuilder<PostLoads1Controller>(
                  builder: (postLoads1Controller) {
                    return Scaffold(body: Center(child: CircularProgressIndicator()));
                  },
                )
              : Scaffold(
                  bottomNavigationBar: (loadsDetailsController.detailsData.loadDetails.flowId == "3" && loadsDetailsController.detailsData.loadDetails.isRate == "0")
                      ? Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(top: 5, right: 15, bottom: 10, left: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: commonButton(
                                  title: "${"Rate to".tr} ${loadsDetailsController.detailsData.loadDetails.bidderName}",
                                  onTapp: () {
                                    Get.bottomSheet(
                                      StatefulBuilder(
                                        builder: (context, setState12) {
                                          return Container(
                                            height: Get.height * 0.47,
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(12),
                                              ),
                                              color: Colors.white,
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor: Colors.transparent,
                                                    backgroundImage: NetworkImage("$basUrl${loadsDetailsController.detailsData.loadDetails.bidderImg}"),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    loadsDetailsController.detailsData.loadDetails.bidderName,
                                                    style: TextStyle(
                                                      color: textBlackColor,
                                                      fontSize: 20,
                                                      fontFamily: fontFamilyBold,
                                                    ),
                                                  ),
                                                  Text(
                                                    loadsDetailsController.detailsData.loadDetails.lorryNumber,
                                                    style: TextStyle(
                                                      color: textBlackColor,
                                                      fontSize: 16,
                                                      fontFamily: fontFamilyRegular,
                                                    ),
                                                  ),
                                                  SizedBox(height: 15),
                                                  RatingBar.builder(
                                                    initialRating: 0,
                                                    minRating: 0,
                                                    itemSize: 35,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    glow: false,
                                                    unratedColor: priMaryColor.withOpacity(0.3),
                                                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                    itemBuilder: (context, _) => Icon(
                                                      Icons.star,
                                                      color: priMaryColor,
                                                    ),
                                                    onRatingUpdate: (rating) {
                                                      postLoads1Controller.setRating(rating);
                                                    },
                                                  ),
                                                  SizedBox(height: 10),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(12),
                                                      border: Border.all(
                                                        color: Colors.grey.withOpacity(0.3),
                                                      ),
                                                    ),
                                                    height: 100,
                                                    child: TextField(
                                                      controller: feedback,
                                                      decoration: InputDecoration(
                                                        contentPadding: EdgeInsets.symmetric(horizontal:10, vertical:10),
                                                        isDense: true,
                                                        border: InputBorder.none,
                                                        hintText: "Enter your Feedback".tr,
                                                        hintStyle: TextStyle(
                                                          fontSize: 16,
                                                          color: textGreyColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 20),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: commonButton(
                                                          title: "${"Rate to".tr} ${loadsDetailsController.detailsData.loadDetails.bidderName}",
                                                          onTapp: () {
                                                            if (feedback.text.isNotEmpty && postLoads1Controller.rating != 0.0) {
                                                              ApiProvider().rating(
                                                                loadId: widget.loadId,
                                                                uid: widget.uid,
                                                                rateText: feedback.text,
                                                                totalRate: "${postLoads1Controller.rating}",
                                                              ).then((value) {
                                                                var decode = jsonDecode(value);
                                                                if (decode["Result"] == "true") {
                                                                  showCommonToast(msg: decode["ResponseMsg"]);
                                                                  Get.back();
                                                                  Get.back();
                                                                } else {
                                                                  showCommonToast(msg: decode["ResponseMsg"]);
                                                                  Get.back();
                                                                }
                                                              });
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : null,
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    centerTitle: true,
                    elevation: 0,
                    leading: InkWell(
                      onTap: () async {
                        Get.back();
                      },
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/icons/backicon.svg",
                            height: 22,
                            width: 22,
                            color: textBlackColor,
                          ),
                        ),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    title: Text(
                      "${"Loads".tr} #${widget.loadId}".tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: fontFamilyBold,
                        fontWeight: FontWeight.w500,
                        color: textBlackColor,
                      ),
                    ),
                    actions: [
                      (loadsDetailsController.detailsData.loadDetails.flowId == "0" && loadsDetailsController.detailsData.loadDetails.bidStatus.isEmpty)
                          ? GetBuilder<PostLoads1Controller>(
                              builder: (postLoads1Controller) {
                                return PopupMenuButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  offset: Offset(0, 40),
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        enabled: false,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setDataInEditeScreen();
                                                Get.back();
                                                Get.offNamed(Routes.postLoads);
                                              },
                                              child: Text(
                                                "Edit",
                                                style: TextStyle(color: textBlackColor),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            InkWell(
                                              onTap: () {
                                                Get.back();
                                                Get.bottomSheet(
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    height: 330,
                                                    padding: EdgeInsets.all(20),
                                                    child: Column(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 35,
                                                          backgroundColor: priMaryColor.withOpacity(0.1),
                                                          child: Center(
                                                            child: SvgPicture.asset(
                                                              "assets/icons/walleticon.svg",
                                                            ),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          "Are you want to delete Load?".tr,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontFamily: fontFamilyBold,
                                                            color: textBlackColor,
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Text(
                                                          "if you delete this Load you would not be able to view or bid on this load".tr,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontFamily: fontFamilyRegular,
                                                            fontWeight: FontWeight.w500,
                                                            color: textGreyColor,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        Spacer(),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: OutlinedButton(
                                                                style: OutlinedButton.styleFrom(
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(16),
                                                                  ),
                                                                  fixedSize: Size.fromHeight(48),
                                                                  side: BorderSide(
                                                                    color: Colors.red,
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                child: Text(
                                                                  "No".tr,
                                                                  style: TextStyle(
                                                                    color: Colors.red,
                                                                    fontSize:16,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Spacer(),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  commonButton(
                                                                title:
                                                                    "Yes,Continue",
                                                                onTapp: () {
                                                                  ApiProvider().deleteLoads(
                                                                      uid: widget.uid,
                                                                      recordId: loadsDetailsController.detailsData.loadDetails.id,
                                                                    ).then((value) {
                                                                    var decode = value;
                                                                    if (decode["ResponseCode"] == "200") {
                                                                      Get.close(2);
                                                                      myLoadsController.fetchDataFromApi();
                                                                    } else {
                                                                      snakbar(decode["ResponseMsg"], context);
                                                                    }
                                                                  });
                                                                },
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Spacer(),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                "Delete",
                                                style: TextStyle(
                                                  color: textBlackColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ];
                                  },
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/icons/dots-vertical.svg",
                                        height: 22,
                                        width: 22,
                                        color: textBlackColor,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : SizedBox(),
                      SizedBox(width: 8),
                    ],
                  ),
                  body: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          if (loadsDetailsController.detailsData.loadDetails.hoursType.compareTo("fixed") == 0 && loadsDetailsController.detailsData.loadDetails.svisibleHours > 0)
                            TweenAnimationBuilder<Duration>(
                              duration: Duration(hours: loadsDetailsController.detailsData.loadDetails.svisibleHours),
                              tween: Tween(
                                begin: Duration(hours: loadsDetailsController.zod),
                                end: Duration.zero,
                              ),
                              onEnd: () {},
                              builder: (BuildContext context, Duration value, Widget? child) {
                                final houres = value.inHours;
                                final minutes = value.inMinutes % 60;
                                final seconds = value.inSeconds % 60;
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 55,
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: secondaryColor.withOpacity(0.1),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Expiry in".tr,
                                              style: TextStyle(
                                                color: textBlackColor,
                                              ),
                                            ),
                                            Spacer(),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    borderRadius:BorderRadius.circular(12),
                                                    color: Colors.white,
                                                  ),
                                                  child: Text("$houres"),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  ":",
                                                  style: TextStyle(color: textBlackColor),
                                                ),
                                                SizedBox(width: 5),
                                                Container(
                                                  padding: EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                    color: Colors.white,
                                                  ),
                                                  child: Text("$minutes"),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  ":",
                                                  style: TextStyle(color: textBlackColor),
                                                ),
                                                SizedBox(width: 5),
                                                Container(
                                                  padding: EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                    color: Colors.white,
                                                  ),
                                                  child: Text("$seconds"),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          else SizedBox(),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: commonDetils(
                                  vehicleImg: loadsDetailsController.detailsData.loadDetails.vehicleImg,
                                  vehicleTitle: loadsDetailsController.detailsData.loadDetails.vehicleTitle,
                                  currency: widget.currency,
                                  amount: loadsDetailsController.detailsData.loadDetails.amount,
                                  amtType: loadsDetailsController.detailsData.loadDetails.amtType,
                                  totalAmt: loadsDetailsController.detailsData.loadDetails.totalAmt,
                                  pickupState: loadsDetailsController.detailsData.loadDetails.pickupState,
                                  pickupPoint: loadsDetailsController.detailsData.loadDetails.pickupPoint,
                                  dropState: loadsDetailsController.detailsData.loadDetails.dropState,
                                  dropPoint: loadsDetailsController.detailsData.loadDetails.dropPoint,
                                  postDate: loadsDetailsController.detailsData.loadDetails.postDate.toString(),
                                  weight: loadsDetailsController.detailsData.loadDetails.weight,
                                  materialName: loadsDetailsController.detailsData.loadDetails.materialName,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          if (loadsDetailsController.detailsData.loadDetails.flowId == "0" && loadsDetailsController.detailsData.loadDetails.bidStatus.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bid Response".tr,
                                  style: TextStyle(
                                    color: textBlackColor,
                                    fontSize: 16,
                                    fontFamily: fontFamilyBold,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                        ),
                                        child: ListView.separated(
                                          separatorBuilder: (context, index) {
                                            return SizedBox(height: 8);
                                          },
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemCount: loadsDetailsController.detailsData.loadDetails.bidStatus.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                ListTile(
                                                  hoverColor: Colors.transparent,
                                                  onTap: () {
                                                    debugPrint("====== bid ======= owner ID ============ ${loadsDetailsController.detailsData.loadDetails.bidStatus[index]["bidder_id"]}");
                                                    debugPrint("====== bid ======= lorry ID ============ ${loadsDetailsController.detailsData.loadDetails.bidStatus[index]["lorry_id"]}");
                                                    Get.to(
                                                      ProfileScreen(
                                                        uid: widget.uid,
                                                        ownerId: loadsDetailsController.detailsData.loadDetails.bidStatus[index]["bidder_id"],
                                                        lorryId: loadsDetailsController.detailsData.loadDetails.bidStatus[index]["lorry_id"],
                                                      ),
                                                    );
                                                  },
                                                  contentPadding: EdgeInsets.zero,
                                                  trailing: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/ic_star_profile.svg",
                                                            width: 16,
                                                            height: 16,
                                                            color: priMaryColor,
                                                          ),
                                                          SizedBox(width: 5),
                                                          Transform.translate(
                                                            offset: Offset(0, 1),
                                                            child: Text(
                                                              loadsDetailsController.detailsData.loadDetails.bidStatus[index]["rate"],
                                                              style: TextStyle(
                                                                color: priMaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        loadsDetailsController.detailsData.loadDetails.bidStatus[index]["lorry_number"],
                                                        style: TextStyle(
                                                          color: textGreyColor,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  subtitle: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: "${widget.currency}${loadsDetailsController.detailsData.loadDetails.bidStatus[index]["amount"]}",
                                                              style: TextStyle(
                                                                color: textBlackColor,
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w500,
                                                                fontFamily: fontFamilyBold,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: " /${loadsDetailsController.detailsData.loadDetails.bidStatus[index]["amt_type"]}",
                                                              style: TextStyle(
                                                                color: textGreyColor,
                                                                fontSize: 10,
                                                                fontFamily: fontFamilyRegular,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 2),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: "${widget.currency}${loadsDetailsController.detailsData.loadDetails.bidStatus[index]["total_amt"]}",
                                                                  style: TextStyle(
                                                                    color: textBlackColor,
                                                                    fontSize: 13,
                                                                    fontFamily: fontFamilyBold,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: " /${"Payable Amount".tr}",
                                                                  style: TextStyle(
                                                                    color: textGreyColor,
                                                                    fontSize: 10,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  title: Text(
                                                    loadsDetailsController.detailsData.loadDetails.bidStatus[index]["bidder_name"],
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: fontFamilyBold,
                                                      color: textBlackColor,
                                                    ),
                                                  ),
                                                  leading: CircleAvatar(
                                                    backgroundColor: Colors.transparent,
                                                    radius: 25,
                                                    backgroundImage: NetworkImage(
                                                      "$basUrl${loadsDetailsController.detailsData.loadDetails.bidStatus[index]["bidder_img"]}",
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: OutlinedButton(
                                                        style: OutlinedButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular( 12),
                                                          ),
                                                          fixedSize: Size.fromHeight(42),
                                                          side: BorderSide(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          showAlertDialog(
                                                            context,
                                                            status: "0",
                                                            uid: widget.uid,
                                                            loadId: widget.loadId,
                                                            lorryId: loadsDetailsController.detailsData.loadDetails.bidStatus[index]["lorry_id"],
                                                            ownerId: loadsDetailsController.detailsData.loadDetails.bidStatus[index]["bidder_id"],
                                                          );
                                                        },
                                                        child: Text(
                                                          "Reject".tr,
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16,
                                                            fontFamily: fontFamilyRegular,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                          fixedSize:Size.fromHeight(42),
                                                          backgroundColor: priMaryColor,
                                                        ),
                                                        onPressed: () {
                                                          Get.bottomSheet(
                                                            Container(
                                                              padding: EdgeInsets.all(15),
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.vertical(
                                                                  top: Radius.circular(12),
                                                                ),
                                                              ),
                                                              child: SingleChildScrollView(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      "Bid Details".tr,
                                                                      style: TextStyle(
                                                                        color: textBlackColor,
                                                                        fontSize: 20,
                                                                        fontFamily: fontFamilyBold,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 10),
                                                                    Container(
                                                                      padding: EdgeInsets.all(15),
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(12),
                                                                        border: Border.all(
                                                                          color: Colors.grey.withOpacity(0.3),
                                                                        ),
                                                                      ),
                                                                      child: Column(
                                                                        children: [
                                                                          ListTile(
                                                                            contentPadding: EdgeInsets.zero,
                                                                            dense: true,
                                                                            trailing: Row(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                SvgPicture.asset(
                                                                                  "assets/icons/ic_star_profile.svg",
                                                                                  width: 16,
                                                                                  height: 16,
                                                                                  color: priMaryColor,
                                                                                ),
                                                                                SizedBox(width: 5),
                                                                                Transform.translate(
                                                                                  offset: Offset(0, 1),
                                                                                  child: Text(
                                                                                    loadsDetailsController.detailsData.loadDetails.bidStatus[index]["rate"],
                                                                                    style: TextStyle(color: priMaryColor),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            subtitle: Transform.translate(
                                                                              offset: Offset(-8, 0),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  RichText(
                                                                                    text: TextSpan(
                                                                                      children: [
                                                                                        TextSpan(
                                                                                          text: "${widget.currency}${loadsDetailsController.detailsData.loadDetails.bidStatus[index]["amount"]}",
                                                                                          style: TextStyle(
                                                                                            color: textBlackColor,
                                                                                            fontSize: 13,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontFamily: fontFamilyBold,
                                                                                          ),
                                                                                        ),
                                                                                        TextSpan(
                                                                                          text: " /${loadsDetailsController.detailsData.loadDetails.bidStatus[index]["amt_type"]}",
                                                                                          style: TextStyle(
                                                                                            color: textGreyColor,
                                                                                            fontSize: 10,
                                                                                            fontFamily: fontFamilyRegular,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(height: 2),
                                                                                  RichText(
                                                                                    text: TextSpan(
                                                                                      children: [
                                                                                        TextSpan(
                                                                                          text: "${widget.currency}${loadsDetailsController.detailsData.loadDetails.bidStatus[index]["total_amt"]}",
                                                                                          style: TextStyle(
                                                                                            color: textBlackColor,
                                                                                            fontSize: 13,
                                                                                            fontFamily: fontFamilyBold,
                                                                                          ),
                                                                                        ),
                                                                                        TextSpan(
                                                                                          text: " /${"Payable Amount".tr}",
                                                                                          style: TextStyle(
                                                                                            color: textGreyColor,
                                                                                            fontSize: 10,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            title: Transform.translate(
                                                                              offset: Offset(-8, 0),
                                                                              child: Text(
                                                                                loadsDetailsController.detailsData.loadDetails.bidStatus[index]["bidder_name"],
                                                                                style: TextStyle(
                                                                                  fontSize: 18,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontFamily: fontFamilyBold,
                                                                                  color: textBlackColor,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            leading: CircleAvatar(
                                                                              radius: 25,
                                                                              backgroundImage: NetworkImage("$basUrl${loadsDetailsController.detailsData.loadDetails.bidStatus[index]["bidder_img"]}"),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(bottom: 10),
                                                                            child: Divider(color: Colors.grey),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Spacer(flex: 1),
                                                                              SvgPicture.asset(
                                                                                "assets/icons/ic_find_lorryf.svg",
                                                                                height: 16,
                                                                                width: 16,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              SizedBox(width: 8),
                                                                              RichText(
                                                                                text: TextSpan(
                                                                                  children: [
                                                                                    TextSpan(
                                                                                      text: "${loadsDetailsController.detailsData.loadDetails.bidStatus[index]["total_lorry"]} ",
                                                                                      style: TextStyle(
                                                                                        color: textGreyColor,
                                                                                        fontSize: 12,
                                                                                        fontFamily: fontFamilyRegular,
                                                                                      ),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: "Lorry".tr,
                                                                                      style: TextStyle(
                                                                                        color: textGreyColor,
                                                                                        fontSize: 12,
                                                                                        fontFamily: fontFamilyRegular,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Spacer(flex: 2),
                                                                              SvgPicture.asset("assets/icons/Group.svg", height: 16, width: 16, color: Colors.grey),
                                                                              SizedBox(width: 8),
                                                                              RichText(
                                                                                text: TextSpan(
                                                                                  children: [
                                                                                    TextSpan(
                                                                                      text: "Since".tr,
                                                                                      style: TextStyle(
                                                                                        color: textGreyColor,
                                                                                        fontSize: 12,
                                                                                        fontFamily: fontFamilyRegular,
                                                                                      ),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: " ${loadsDetailsController.detailsData.loadDetails.bidStatus[index]["join_date"]}",
                                                                                      style: TextStyle(
                                                                                        color: textGreyColor,
                                                                                        fontSize: 12,
                                                                                        fontFamily: fontFamilyRegular,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Spacer(flex: 1),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(height:10),
                                                                    Text(
                                                                      "Description".tr,
                                                                      style:TextStyle(
                                                                        color:textBlackColor,
                                                                        fontSize: 16,
                                                                        fontFamily: fontFamilyBold,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    SizedBox(height:8),
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child: Container(
                                                                            padding: EdgeInsets.all(15),
                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.withOpacity(0.3))),
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text("${loadsDetailsController.detailsData.loadDetails.bidStatus[index]["description"]}", style: TextStyle(color: textGreyColor)),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(height: 20),
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child: commonButton(
                                                                            title: "ACCEPT & PAY",
                                                                            onTapp: () {
                                                                              Get.back();
                                                                              Get.to(PaymentMethod(
                                                                                price: loadsDetailsController.detailsData.loadDetails.bidStatus[index]["total_amt"],
                                                                                totalPrice: loadsDetailsController.detailsData.loadDetails.bidStatus[index]["total_amt"],
                                                                                loadId: widget.loadId,
                                                                                uid: widget.uid,
                                                                                lorryId: loadsDetailsController.detailsData.loadDetails.bidStatus[index]["lorry_id"],
                                                                                description: loadsDetailsController.detailsData.loadDetails.description,
                                                                                ownerId: loadsDetailsController.detailsData.loadDetails.bidStatus[index]["bidder_id"],
                                                                                walAmt: loadsDetailsController.detailsData.loadDetails.walAmt,
                                                                                isBooked: false,
                                                                                amtTyp: loadsDetailsController.detailsData.loadDetails.amtType,
                                                                              ));
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Text(
                                                          "Accept".tr,
                                                          style: TextStyle(
                                                            color: whiteColor,
                                                            fontSize: 16,
                                                            fontFamily: "urbani_extrabold",
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          else if ((loadsDetailsController.detailsData.loadDetails.flowId == "1" || loadsDetailsController.detailsData.loadDetails.flowId == "2") && loadsDetailsController.detailsData.loadDetails.bidStatus.isEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        // height: 80,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                        ),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          dense: true,
                                          leading: SvgPicture.asset("assets/icons/security.svg"),
                                          title: Transform.translate(
                                            offset: Offset(0, -2),
                                            child: Text(
                                              "Load Process".tr,
                                              style: TextStyle(
                                                color: textBlackColor,
                                                fontSize: 16,
                                                fontFamily: fontFamilyBold,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          subtitle: Text(
                                            loadsDetailsController.detailsData
                                                .loadDetails.message.tr,
                                            style: TextStyle(
                                              color: textGreyColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                          trailing: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Center(
                                              child: SvgPicture.asset(
                                                "assets/icons/arrow-right.svg",
                                                color: textBlackColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                               isPicked == "1" || isPicked == "2" ? Text(
                                  "Track your order".tr,
                                  style: TextStyle(
                                    color: textBlackColor,
                                    fontSize: 16,
                                    fontFamily: fontFamilyBold,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ) : SizedBox(),
                                SizedBox(height: isPicked == "1" || isPicked == "2" ? 10 : 0),
                                isPicked == "1" || isPicked == "2" ? (movingLat == 0 ? commonSimmer(height: 300, width: double.infinity) : SizedBox(
                                  height: 300,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: GetBuilder<MaplocationUpdate>(
                                      builder: (maplocationUpdate) {
                                        return Stack(
                                          children: [
                                            GoogleMap(
                                              gestureRecognizers: {
                                                Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
                                              },
                                              initialCameraPosition: CameraPosition(target: LatLng(movingLat, movingLong), zoom: 16,),
                                              myLocationEnabled: false,
                                              tiltGesturesEnabled: true,
                                              compassEnabled: true,
                                              scrollGesturesEnabled: true,
                                              zoomControlsEnabled: true,
                                              onMapCreated: (GoogleMapController controller) {
                                                _controller = controller;
                                                maplocationUpdate.zoomOutToFitPolyline(controller: _controller, pickLat: loadsDetailsController.detailsData.loadDetails.pickLat, pickLng: loadsDetailsController.detailsData.loadDetails.pickLng, dropLat: loadsDetailsController.detailsData.loadDetails.dropLat, dropLng: loadsDetailsController.detailsData.loadDetails.dropLng);
                                              },
                                              // onMapCreated: _onMapCreated11,
                                              markers: Set<Marker>.of(maplocationUpdate.markers.values),
                                              polylines: Set<Polyline>.of(maplocationUpdate.polylines.values),
                                            ),
                                            Positioned(
                                              top: 10,
                                              left: 10,
                                              child: InkWell(
                                                onTap: () {
                                                  _animateToUser();
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.grey.shade600),
                                                    shape: BoxShape.circle
                                                  ),
                                                  padding: EdgeInsets.all(5),
                                                  child: Icon(Icons.my_location_outlined, color: Colors.grey.shade600,),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    ),
                                  ),
                                )) : SizedBox(),
                                SizedBox(height: isPicked == "1" || isPicked == "2" ? 10 : 0),
                                Text(
                                  "Bidder information".tr,
                                  style: TextStyle(
                                    color: textBlackColor,
                                    fontSize: 16,
                                    fontFamily: fontFamilyBold,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.topRight,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.grey.withOpacity(0.3),
                                              ),
                                            ),
                                            child: ListTile(
                                              onTap: () {
                                                debugPrint("============= owner ID ============ ${loadsDetailsController.detailsData.loadDetails.bidderId}");
                                                debugPrint("============= lorry ID ============ ${loadsDetailsController.detailsData.loadDetails.lorryId}");
                                                Get.to(
                                                  ProfileScreen(
                                                    uid: widget.uid,
                                                    ownerId: loadsDetailsController.detailsData.loadDetails.bidderId,
                                                    lorryId: loadsDetailsController.detailsData.loadDetails.lorryId,
                                                  ),
                                                );
                                              },
                                              contentPadding: EdgeInsets.zero,
                                              dense: true,
                                              trailing: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/ic_star_profile.svg",
                                                            width: 16,
                                                            height: 16,
                                                            color: priMaryColor,
                                                          ),
                                                          SizedBox(width: 5),
                                                          Transform.translate(
                                                            offset: Offset(0, 1),
                                                            child: Text(
                                                              loadsDetailsController.detailsData.loadDetails.rate,
                                                              style: TextStyle(
                                                                color: priMaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        loadsDetailsController.detailsData.loadDetails.bidderMobile,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: fontFamilyBold,
                                                          color: priMaryColor,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              subtitle: Transform.translate(
                                                offset: Offset(-8, 0),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: "${widget.currency}${loadsDetailsController.detailsData.loadDetails.amount}",
                                                            style: TextStyle(
                                                              color: textBlackColor,
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: fontFamilyBold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: " /${loadsDetailsController.detailsData.loadDetails.amtType}",
                                                            style: TextStyle(
                                                              color: textGreyColor,
                                                              fontSize: 10,
                                                              fontFamily: fontFamilyRegular,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 2),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: "${widget.currency}${loadsDetailsController.detailsData.loadDetails.totalAmt}",
                                                            style: TextStyle(
                                                              color: textBlackColor,
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: fontFamilyBold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: " /${"Payable Amount".tr}",
                                                            style: TextStyle(
                                                              color: textGreyColor,
                                                              fontSize: 10,
                                                              fontFamily: fontFamilyRegular,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 2),
                                                  ],
                                                ),
                                              ),
                                              title: Transform.translate(
                                                offset: Offset(-8, 0),
                                                child: Text(
                                                  loadsDetailsController.detailsData.loadDetails.bidderName,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: fontFamilyBold,
                                                    color: textBlackColor,
                                                  ),
                                                ),
                                              ),
                                              leading: CircleAvatar(
                                                backgroundColor: Colors.transparent,
                                                radius: 25,
                                                backgroundImage: NetworkImage("$basUrl${loadsDetailsController.detailsData.loadDetails.bidderImg}"),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Positioned(
                                      top: -10,
                                      child: InkWell(
                                        onTap: () {
                                          makingPhoneCall(phoneNumber: loadsDetailsController.detailsData.loadDetails.bidderMobile);
                                        },
                                        child: CircleAvatar(
                                          radius: 15,
                                          backgroundColor: priMaryColor,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/icons/phone-call.svg",
                                              height: 20,
                                              width: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Subdriver Information".tr,
                                  style: TextStyle(
                                    color: textBlackColor,
                                    fontSize: 16,
                                    fontFamily: fontFamilyBold,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.3),
                                        ),
                                      ),
                                      child: ListTile(
                                        onTap: () {
                                          debugPrint("============= owner ID ============ ${loadsDetailsController.detailsData.loadDetails.bidderId}");
                                          debugPrint("============= lorry ID ============ ${loadsDetailsController.detailsData.loadDetails.lorryId}");
                                        },
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        trailing: Text(
                                          loadsDetailsController.detailsData.loadDetails.subdriverMobile,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: fontFamilyBold,
                                            color: priMaryColor,
                                          ),
                                        ),
                                        title: Transform.translate(
                                          offset: Offset(-8, 0),
                                          child: Text(
                                            loadsDetailsController.detailsData.loadDetails.subdriverName,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: fontFamilyBold,
                                              color: textBlackColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -10,
                                      child: InkWell(
                                        onTap: () {
                                          makingPhoneCall(phoneNumber: loadsDetailsController.detailsData.loadDetails.subdriverMobile);
                                        },
                                        child: CircleAvatar(
                                          radius: 15,
                                          backgroundColor: priMaryColor,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/icons/phone-call.svg",
                                              height: 20,
                                              width: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Payment Information".tr,
                                  style: TextStyle(
                                    color: textBlackColor,
                                    fontSize: 16,
                                    fontFamily: fontFamilyBold,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Payment Gateway".tr,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: fontFamilyRegular,
                                                    color: textGreyColor,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Spacer(),
                                                Text(
                                                  loadsDetailsController.detailsData.loadDetails.pMethodName,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: fontFamilyBold,
                                                    color: textBlackColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 15),
                                            Row(
                                              children: [
                                                Text(
                                                  "Transaction ID".tr,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: fontFamilyRegular,
                                                    color: textGreyColor,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Spacer(),
                                                Text(
                                                  loadsDetailsController.detailsData.loadDetails.orderTransactionId,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: fontFamilyBold,
                                                    color: textBlackColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 15),
                                            Row(
                                              children: [
                                                Text(
                                                  "Sub Total".tr,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        fontFamilyRegular,
                                                    color: textGreyColor,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Spacer(),
                                                Text(
                                                  "${widget.currency}${loadsDetailsController.detailsData.loadDetails.amount}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: fontFamilyBold,
                                                    color: textBlackColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            loadsDetailsController.detailsData.loadDetails.walAmt.compareTo("0") == 0
                                                ? SizedBox()
                                                : Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(height: 15),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Wallet".tr,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily: fontFamilyRegular,
                                                              color: textGreyColor,
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                          Spacer(),
                                                          Text(
                                                            "${widget.currency}${loadsDetailsController.detailsData.loadDetails.walAmt}",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily: fontFamilyRegular,
                                                              color: Colors.green,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                            Divider(
                                              height: 30,
                                              color: Colors.black,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Total Payment".tr,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        fontFamilyRegular,
                                                    color: textGreyColor,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Spacer(),
                                                Text(
                                                  "${widget.currency}${loadsDetailsController.detailsData.loadDetails.totalAmt}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: fontFamilyBold,
                                                    color: textBlackColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          else if (loadsDetailsController.detailsData.loadDetails.flowId == "3" && loadsDetailsController.detailsData.loadDetails.bidStatus.isEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bidder information".tr,
                                  style: TextStyle(
                                    color: textBlackColor,
                                    fontSize: 16,
                                    fontFamily: fontFamilyBold,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            Get.to(
                                              ProfileScreen(
                                                uid: widget.uid,
                                                ownerId: loadsDetailsController.detailsData.loadDetails.bidderId,
                                                lorryId: loadsDetailsController.detailsData.loadDetails.lorryId,
                                              ),
                                            );
                                          },
                                          contentPadding: EdgeInsets.zero,
                                          dense: true,
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/ic_star_profile.svg",
                                                width: 16,
                                                height: 16,
                                                color: priMaryColor,
                                              ),
                                              SizedBox(width: 5),
                                              Transform.translate(
                                                offset: Offset(0, 1),
                                                child: Text(
                                                  loadsDetailsController.detailsData.loadDetails.rate,
                                                  style: TextStyle(
                                                    color: priMaryColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          subtitle: Transform.translate(
                                            offset: Offset(-8, 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: "${widget.currency}${loadsDetailsController.detailsData.loadDetails.amount}",
                                                        style: TextStyle(
                                                          color: textBlackColor,
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: fontFamilyBold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: " /${loadsDetailsController.detailsData.loadDetails.amtType}",
                                                        style: TextStyle(
                                                          color: textGreyColor,
                                                          fontSize: 10,
                                                          fontFamily: fontFamilyRegular,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: "${widget.currency}${loadsDetailsController.detailsData.loadDetails.totalAmt}",
                                                        style: TextStyle(
                                                          color: textBlackColor,
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: fontFamilyBold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: " /${"Payable Amount".tr}",
                                                        style: TextStyle(
                                                          color: textGreyColor,
                                                          fontSize: 10,
                                                          fontFamily: fontFamilyRegular,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          title: Transform.translate(
                                            offset: Offset(-8, 0),
                                            child: Text(
                                              loadsDetailsController.detailsData.loadDetails.bidderName,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: fontFamilyBold,
                                                color: textBlackColor,
                                              ),
                                            ),
                                          ),
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                              "$basUrl${loadsDetailsController.detailsData.loadDetails.bidderImg}",
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Payment Information".tr,
                                  style: TextStyle(
                                    color: textBlackColor,
                                    fontSize: 16,
                                    fontFamily: fontFamilyBold,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Payment Gateway".tr,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        fontFamilyRegular,
                                                    color: textGreyColor,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Spacer(),
                                                Text(
                                                  loadsDetailsController.detailsData.loadDetails.pMethodName,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: fontFamilyBold,
                                                    color: textBlackColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 15),
                                            Row(
                                              children: [
                                                Text(
                                                  "Transaction ID".tr,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: fontFamilyRegular,
                                                    color: textGreyColor,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Spacer(),
                                                Text(
                                                  loadsDetailsController.detailsData.loadDetails.orderTransactionId,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: fontFamilyBold,
                                                    color: textBlackColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Sub Total".tr,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: fontFamilyRegular,
                                                    color: textGreyColor,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Spacer(),
                                                Text(
                                                  "${widget.currency}${loadsDetailsController.detailsData.loadDetails.amount}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: fontFamilyBold,
                                                    color: textBlackColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            loadsDetailsController.detailsData.loadDetails.walAmt == "0"
                                            ? Container()
                                            : SizedBox(height: 15),
                                            loadsDetailsController.detailsData.loadDetails.walAmt == "0"
                                            ? Container()
                                            : Row(
                                                children: [
                                                  Text(
                                                    "Wallet".tr,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: fontFamilyRegular,
                                                      color: textGreyColor,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    "${widget.currency}${loadsDetailsController.detailsData.loadDetails.walAmt}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: fontFamilyRegular,
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            Divider(
                                              height: 30,
                                              color: Colors.grey,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Total Payment".tr,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: fontFamilyRegular,
                                                    color: textGreyColor,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Spacer(),
                                                Text(
                                                  "${widget.currency}${loadsDetailsController.detailsData.loadDetails.totalAmt}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: fontFamilyBold,
                                                    color: textBlackColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.3),
                                      ),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      leading: SvgPicture.asset(
                                        "assets/icons/security.svg",
                                      ),
                                      title: Transform.translate(
                                        offset: Offset(0, -2),
                                        child: Text(
                                          "Load Process".tr,
                                          style: TextStyle(
                                            color: textBlackColor,
                                            fontSize: 16,
                                            fontFamily: fontFamilyBold,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Your required to contact the lorry owner for further communication".tr,
                                        style: TextStyle(
                                          color: textGreyColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                      trailing: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Center(
                                          child: SvgPicture.asset(
                                            "assets/icons/arrow-right.svg",
                                            color: textBlackColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  showAlertDialog(
    BuildContext context, {
    required String uid,
    required String status,
    required String loadId,
    required String ownerId,
    required String lorryId,
  }) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "No".tr,
        style: TextStyle(
          fontSize: 16,
          fontFamily: fontFamilyRegular,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () {
        Get.back();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Continue".tr,
        style: TextStyle(
          fontSize: 16,
          fontFamily: fontFamilyRegular,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () {
        ApiProvider().makeDecision(
          uid: uid,
          status: status,
          loadId: loadId,
          ownerId: ownerId,
          lorryId: lorryId,
          amount: "",
          totalAmt: "",
          walAmt: "",
          pMethodId: "",
          transId: "",
          description: "",
          amtType: "",
        ).then((value) {
          var decode = value;
          showCommonToast(msg: decode["ResponseMsg"]);
          Get.back();
          Get.back();
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Reject".tr,
        style: TextStyle(
          fontSize: 20,
          fontFamily: fontFamilyBold,
          fontWeight: FontWeight.w700,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
      content: Text(
        "Do you want to reject?".tr,
        style: TextStyle(
          fontSize: 16,
          fontFamily: fontFamilyRegular,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  setDataInEditeScreen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    Map tempEditData = {
      "id": "Edit Post Load #${loadsDetailsController.detailsData.loadDetails.id}",
      "loadId": loadsDetailsController.detailsData.loadDetails.id,
      "isEdit": true,
      "materialName": loadsDetailsController.detailsData.loadDetails.materialName,
      "amount": loadsDetailsController.detailsData.loadDetails.amount,
      "description": loadsDetailsController.detailsData.loadDetails.description,
      "pickUpController": loadsDetailsController.detailsData.loadDetails.pickupPoint,
      "numberTonnes": loadsDetailsController.detailsData.loadDetails.weight,
      "dropDownController": loadsDetailsController.detailsData.loadDetails.dropPoint,
      "picUpState": loadsDetailsController.detailsData.loadDetails.pickupState,
      "dropPoint": loadsDetailsController.detailsData.loadDetails.dropState,
      "picUpLng": loadsDetailsController.detailsData.loadDetails.pickLng,
      "picUpLat": loadsDetailsController.detailsData.loadDetails.pickLat,
      "dropUpLng": loadsDetailsController.detailsData.loadDetails.dropLng,
      "dropUpLat": loadsDetailsController.detailsData.loadDetails.dropLat,
      "numberOfHours": loadsDetailsController.detailsData.loadDetails.visibleHours,
      "pickup": "${loadsDetailsController.detailsData.loadDetails.pickMobile}( ${loadsDetailsController.detailsData.loadDetails.pickName})",
      "drop": "${loadsDetailsController.detailsData.loadDetails.dropMobile}( ${loadsDetailsController.detailsData.loadDetails.dropName})",
    };
    preferences.setString("tempEditdata", jsonEncode(tempEditData));
  }
}
