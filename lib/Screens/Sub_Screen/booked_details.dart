// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Controllers/bookeddetails_controller.dart';
import '../Api_Provider/imageupload_api.dart';
import 'payment_method.dart';
import 'profile_page.dart';
import '../../widgets/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../AppConstData/app_colors.dart';
import '../../AppConstData/routes.dart';
import '../../AppConstData/typography.dart';
import '../../Controllers/map_location_update_controller.dart';
import '../../firebase_services/fetchdata.dart';
import '../Api_Provider/api_provider.dart';

class BookedDetails extends StatefulWidget {
  final String uid;
  final String loadId;

  const BookedDetails({super.key, required this.uid, required this.loadId});

  @override
  State<BookedDetails> createState() => _BookedDetailsState();
}

class _BookedDetailsState extends State<BookedDetails> {
  String currency = "\$";
  BookedHistoryController bookedHistoryController = Get.put(BookedHistoryController());
  @override
  void initState() {
    super.initState();
    debugPrint("=========== uid ========== ${widget.uid}");
    debugPrint("========= lorryId ======== ${widget.loadId}");
    bidLoder = false;
    fetchDataFromApi();
  }

  bool bidLoder = false;

  String isPicked = "";

  @override
  void dispose() {
    super.dispose();
    bookedHistoryController.isLoading = true;
  }

  MaplocationUpdate maplocationUpdate = Get.put(MaplocationUpdate());
  FetchingServices fetchLocation = FetchingServices();
  late GoogleMapController _controller;

  fetchDataFromApi() {
    ApiProvider()
        .bookDetails(uid: widget.uid, loadId: widget.loadId)
        .then((value) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      currency = prefs.getString("currencyIcon")!;
      bookedHistoryController.setBookedData(value);
      bookedHistoryController.setIsLoading(false);
      debugPrint("=========== uid ========== ${widget.uid}");
      debugPrint("========= lorryId ======== ${widget.loadId}");
      debugPrint("========= flowId ========= ${bookedHistoryController.historyData.loadDetails.flowId}");
      debugPrint("========= isRate ========= ${bookedHistoryController.historyData.loadDetails.isRate}");
      fetchLocation.getLocation(lorryId: bookedHistoryController.historyData.loadDetails.lorryId).listen((event) {
        print("LOC?ATION ${event["ispicked"]} ${bookedHistoryController.historyData.loadDetails.lorryId}");
        Future.delayed(Duration(seconds: 5)).then((value) {
          if(event["long"] == "0"){
            setState(() {
              isPicked = event["ispicked"];
              movingLat = double.parse(bookedHistoryController.historyData.loadDetails.pickLat);
              movingLong = double.parse(bookedHistoryController.historyData.loadDetails.pickLng);
            });
            maplocationUpdate.addMarkerpickup("Pickup", double.parse(bookedHistoryController.historyData.loadDetails.pickLat), double.parse(bookedHistoryController.historyData.loadDetails.pickLng));
            maplocationUpdate.addMarkerdrop("Drop", double.parse(bookedHistoryController.historyData.loadDetails.dropLat), double.parse(bookedHistoryController.historyData.loadDetails.dropLng));
            maplocationUpdate.getDirections(latPick: double.parse(bookedHistoryController.historyData.loadDetails.pickLat), longPick: double.parse(bookedHistoryController.historyData.loadDetails.pickLng), latDrop: double.parse(bookedHistoryController.historyData.loadDetails.dropLat), longDrop: double.parse(bookedHistoryController.historyData.loadDetails.dropLng));
          } else if(event["ispicked"] == "7") {
            setState(() {
              isPicked = event["ispicked"];
              movingLat = double.parse(event["late"]);
              movingLong = double.parse(event["long"]);
            });
            maplocationUpdate.startLiveTracking(pickLat: bookedHistoryController.historyData.loadDetails.pickLat, pickLong: bookedHistoryController.historyData.loadDetails.pickLng, dropLat: bookedHistoryController.historyData.loadDetails.dropLat, dropLong: bookedHistoryController.historyData.loadDetails.dropLng, vehicleLat: event["late"], vehicleLng: event["long"], isPickup: false,);
          } else {
            setState(() {
              isPicked = event["ispicked"];
              movingLat = double.parse(event["late"]);
              movingLong = double.parse(event["long"]);
            });
            maplocationUpdate.startLiveTracking(pickLat: bookedHistoryController.historyData.loadDetails.pickLat, pickLong: bookedHistoryController.historyData.loadDetails.pickLng, dropLat: bookedHistoryController.historyData.loadDetails.dropLat, dropLong: bookedHistoryController.historyData.loadDetails.dropLng, vehicleLat: event["late"], vehicleLng: event["long"],isPickup: true);
          }
        },);
      },);
    });
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(
          Duration(seconds: 1),
          () {
            fetchDataFromApi();
          },
        );
      },
      child: GetBuilder<BookedHistoryController>(
          builder: (bookedHistoryController) {
        return Scaffold(
          bottomNavigationBar: bookedHistoryController.isLoading
              ? SizedBox()
              : (bookedHistoryController.historyData.loadDetails.flowId == "8" && bookedHistoryController.historyData.loadDetails.isRate == "0")
                  ? Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(top: 5, right: 15, bottom: 10, left: 15),
                      child: Row(
                        children: [
                          Expanded(
                              child: commonButton(
                            title: "${"Rate to".tr} ${bookedHistoryController.historyData.loadDetails.bidderName}",
                            onTapp: () {
                              TextEditingController feedback = TextEditingController();

                              Get.bottomSheet(StatefulBuilder(
                                  builder: (context, setState12) {
                                return Container(
                                  height: Get.height * 0.47,
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                    color: Colors.white,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: NetworkImage("$basUrl${bookedHistoryController.historyData.loadDetails.bidderImg}"),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          bookedHistoryController.historyData.loadDetails.bidderName,
                                          style: TextStyle(
                                            color: textBlackColor,
                                            fontSize: 20,
                                            fontFamily: fontFamilyBold,
                                          ),
                                        ),
                                        Text(
                                          bookedHistoryController.historyData.loadDetails.lorryNumber,
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
                                            bookedHistoryController.setRating(rating);
                                          },
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all( color: Colors.grey .withOpacity(0.3)),
                                          ),
                                          height: 100,
                                          child: TextField(
                                            controller: feedback,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
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
                                                title: "${"Rate to".tr} ${bookedHistoryController.historyData.loadDetails.bidderName}",
                                                onTapp: () {
                                                  if (feedback.text.isNotEmpty && bookedHistoryController.rating != 0.0) {
                                                    ApiProvider().rating(
                                                      loadId: widget.loadId,
                                                      uid: widget.uid,
                                                      rateText:feedback.text,
                                                      totalRate:"${bookedHistoryController.rating}",
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
                              }));
                            },
                          )),
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
                    height: 22, width: 22, color: textBlackColor,
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
          ),
          body: bidLoder == false
            ? bookedHistoryController.isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: commonDetils(
                                  vehicleImg: bookedHistoryController.historyData.loadDetails.vehicleImg,
                                  vehicleTitle: bookedHistoryController.historyData.loadDetails.vehicleTitle,
                                  currency: currency,
                                  amount: bookedHistoryController.historyData.loadDetails.amount,
                                  amtType: bookedHistoryController.historyData.loadDetails.amtType,
                                  totalAmt: bookedHistoryController.historyData.loadDetails.totalAmt,
                                  pickupState: bookedHistoryController.historyData.loadDetails.pickupState,
                                  pickupPoint: bookedHistoryController.historyData.loadDetails.pickupPoint,
                                  dropState: bookedHistoryController.historyData.loadDetails.dropState,
                                  dropPoint: bookedHistoryController.historyData.loadDetails.dropPoint,
                                  postDate: bookedHistoryController.historyData.loadDetails.postDate.toString(),
                                  weight: bookedHistoryController.historyData.loadDetails.weight,
                                  materialName: bookedHistoryController.historyData.loadDetails.materialName,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          SizedBox(height: isPicked == "4" || isPicked == "7" ? 10 : 0),
                          isPicked == "4" || isPicked == "7" ? Text(
                            "Track your order".tr,
                            style: TextStyle(
                              color: textBlackColor,
                              fontSize: 16,
                              fontFamily: fontFamilyBold,
                              fontWeight: FontWeight.w500,
                            ),
                          ) : SizedBox(),
                          SizedBox(height: isPicked == "4" || isPicked == "7" ? 10 : 0),
                          isPicked == "4" || isPicked == "7" ? (movingLat == 0 ? commonSimmer(height: 300, width: double.infinity) : SizedBox(
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
                                          initialCameraPosition: CameraPosition(target: LatLng(movingLat, movingLong), zoom: 14,),
                                          myLocationEnabled: false,
                                          tiltGesturesEnabled: true,
                                          compassEnabled: true,
                                          scrollGesturesEnabled: true,
                                          zoomControlsEnabled: true,
                                          onMapCreated: (GoogleMapController controller) {
                                            _controller = controller;
                                            maplocationUpdate.zoomOutToFitPolyline(controller: _controller, pickLat: bookedHistoryController.historyData.loadDetails.pickLat, pickLng: bookedHistoryController.historyData.loadDetails.pickLng, dropLat: bookedHistoryController.historyData.loadDetails.dropLat, dropLng: bookedHistoryController.historyData.loadDetails.dropLng);
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
                          SizedBox(height: 20),
                          Text(
                            "Lorry Owner Response".tr,
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
                                        borderRadius:BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.3),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              debugPrint("=========== uid ========== ${widget.uid}");
                                              debugPrint("========= ownerId ======== ${bookedHistoryController.historyData.loadDetails.bidderId}");
                                              debugPrint("========= lorryId ======== ${bookedHistoryController.historyData.loadDetails.lorryId}");
                                              Get.to(
                                                ProfileScreen(
                                                  uid: widget.uid,
                                                  ownerId: bookedHistoryController.historyData.loadDetails.bidderId,
                                                  lorryId: bookedHistoryController.historyData.loadDetails.lorryId,
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
                                                    bookedHistoryController.historyData.loadDetails.rate,
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
                                                          text: "$currency${bookedHistoryController.historyData.loadDetails.offerPrice.isNotEmpty ? bookedHistoryController.historyData.loadDetails.offerPrice : bookedHistoryController.historyData.loadDetails.amount}",
                                                          style: TextStyle(
                                                            color: textBlackColor,
                                                            fontSize: 13,
                                                            fontFamily: fontFamilyBold,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: " /${bookedHistoryController.historyData.loadDetails.offerType.isNotEmpty ? bookedHistoryController.historyData.loadDetails.offerType : bookedHistoryController.historyData.loadDetails.amtType}",
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
                                                          text: "$currency${bookedHistoryController.historyData.loadDetails.offerTotal.isNotEmpty ? bookedHistoryController.historyData.loadDetails.offerTotal : bookedHistoryController.historyData.loadDetails.totalAmt}",
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
                                                bookedHistoryController.historyData.loadDetails.bidderName,
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
                                              backgroundImage: NetworkImage("$basUrl${bookedHistoryController.historyData.loadDetails.bidderImg}"),
                                            ),
                                          ),
                                          if (bookedHistoryController.historyData.loadDetails.isAccept == "1" && bookedHistoryController.historyData.loadDetails.flowId == "1")
                                            Column(
                                              children: [
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: commonButton(
                                                        title: "Accept & Pay".tr,
                                                        onTapp: () {
                                                          Get.to(
                                                            PaymentMethod(
                                                              price: bookedHistoryController.historyData.loadDetails.totalAmt.toString(),
                                                              totalPrice: bookedHistoryController.historyData.loadDetails.totalAmt.toString(),
                                                              uid: widget.uid,
                                                              loadId: widget.loadId,
                                                              ownerId: bookedHistoryController.historyData.loadDetails.bidderId,
                                                              description: bookedHistoryController.historyData.loadDetails.description,
                                                              isBooked: true,
                                                              lorryId: bookedHistoryController.historyData.loadDetails.lorryId,
                                                              isPayOnly: false,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          else if (bookedHistoryController.historyData.loadDetails.flowId == "2")
                                            SizedBox(height: 0)
                                          else if (bookedHistoryController.historyData.loadDetails.flowId == "3")
                                            Column(
                                              children: [
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    OutlinedButton(
                                                        style: OutlinedButton.styleFrom(
                                                          elevation: 0,
                                                          fixedSize:Size.fromHeight(40),
                                                          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(12)),
                                                          side: BorderSide(color: Color(0xffFF9F9F)),
                                                        ),
                                                        onPressed: () {
                                                          ApiProvider()
                                                              .rejectOffer(
                                                                  uid: widget.uid,
                                                                  loadId: widget .loadId,
                                                                  commentReject: "",
                                                                )
                                                              .then((value) {
                                                            var decode = value;
                                                            if (decode["Result"] == "true") {
                                                              Get.offNamed(Routes.bookedLorries);
                                                              showCommonToast(msg: decode["ResponseMsg"]);
                                                            } else {
                                                              showCommonToast(msg: decode["ResponseMsg"]);
                                                              Get.back();
                                                            }
                                                          });
                                                        },
                                                        child: Text("Reject".tr,
                                                          style: TextStyle(
                                                            color: Color(0xffFF9F9F),
                                                            fontSize: 15,
                                                            fontFamily: "urbani_extrabold",
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          elevation: 0,
                                                          fixedSize: Size.fromHeight(40),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:BorderRadius.circular(12),
                                                          ),
                                                          backgroundColor: priMaryColor,
                                                        ),
                                                        onPressed: () {
                                                          Get.to(PaymentMethod(
                                                            price: bookedHistoryController.historyData.loadDetails.offerTotal,
                                                            totalPrice: bookedHistoryController.historyData.loadDetails.offerTotal.toString(),
                                                            uid: widget.uid,
                                                            loadId: widget.loadId,
                                                            ownerId: bookedHistoryController.historyData.loadDetails.bidderId,
                                                            description: bookedHistoryController.historyData.loadDetails.description,
                                                            isBooked: true,
                                                            lorryId: bookedHistoryController.historyData.loadDetails.lorryId,
                                                            isPayOnly: true,
                                                            amtTyp: bookedHistoryController.historyData.loadDetails.amtType,
                                                          ));
                                                        },
                                                        child: Text(
                                                          "Accept & Pay".tr,
                                                          style: TextStyle(
                                                            color: whiteColor,
                                                            fontSize: 15,
                                                            fontFamily: "urbani_extrabold",
                                                            fontWeight:FontWeight.w700,
                                                            ),
                                                          ),
                                                        ),
                                                    ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          elevation: 0,
                                                          fixedSize: Size.fromHeight(40),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                          backgroundColor: Color(0xffFF69B6),
                                                        ),
                                                        onPressed: () {
                                                          TextEditingController description = TextEditingController();
                                                          Get.bottomSheet(
                                                              isScrollControlled: true,
                                                              GetBuilder<BookedHistoryController>(
                                                                  builder: (bookedHistoryController) {
                                                            return Container(
                                                              padding: EdgeInsets.all(15),
                                                              decoration:BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius:BorderRadius.vertical(top: Radius.circular(12)),
                                                              ),
                                                              child: SingleChildScrollView(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      "Bid Now".tr,
                                                                      style: TextStyle(
                                                                        fontSize: 20,
                                                                        color: textBlackColor,
                                                                        fontFamily: fontFamilyBold,
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      color: Colors.grey.withOpacity(0.3),
                                                                    ),
                                                                    Text(
                                                                      "Enter your Price".tr,
                                                                      style: TextStyle(
                                                                        fontSize: 16,
                                                                        color: textBlackColor,
                                                                        fontFamily: fontFamilyBold,
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 10),
                                                                    TextField(
                                                                      keyboardType:TextInputType.number,
                                                                      controller: bookedHistoryController.amount,
                                                                      onChanged: (value) {
                                                                        if (value.isEmpty) {
                                                                          bookedHistoryController.setIsAmount(false);
                                                                        } else {
                                                                          bookedHistoryController.setIsAmount(bookedHistoryController.amount.text.isEmpty);
                                                                        }
                                                                      },
                                                                      style: TextStyle(
                                                                        color:textBlackColor,
                                                                        fontSize: 14,
                                                                        fontFamily: fontFamilyRegular,
                                                                      ),
                                                                      decoration: InputDecoration(
                                                                        suffixIcon: Row(
                                                                          mainAxisSize: MainAxisSize.min,
                                                                          children: [
                                                                            bookedHistoryController.isAmount
                                                                                ? SizedBox(
                                                                                    width: 20,
                                                                                    height: 20,
                                                                                    child: Center(
                                                                                      child: SvgPicture.asset(
                                                                                        "assets/icons/exclamation-circle.svg",
                                                                                        color: Colors.red,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                : SizedBox(),
                                                                            bookedHistoryController.isAmount
                                                                                ? SizedBox(width: 8)
                                                                                : SizedBox(),
                                                                            Text(bookedHistoryController.isPriceFix
                                                                                ? "Per Tonnes".tr
                                                                                : "Fix".tr),
                                                                            Switch(
                                                                              activeColor: priMaryColor,
                                                                              value: bookedHistoryController.isPriceFix,
                                                                              onChanged: (value) {
                                                                                bookedHistoryController.setIsPriceFix(value);
                                                                              },
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        hintText: "Amount".tr,
                                                                        hintStyle: TextStyle(
                                                                          color: textGreyColor,
                                                                          fontSize: 13,
                                                                          fontFamily: fontFamilyRegular,
                                                                        ),
                                                                        prefixIcon: SizedBox(
                                                                          width: 20,
                                                                          height: 20,
                                                                          child: Center(
                                                                            child: SvgPicture.asset(
                                                                              "assets/icons/sack-dollar.svg",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(12),
                                                                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                                                                        ),
                                                                        disabledBorder: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(12),
                                                                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                                                                        ),
                                                                        enabledBorder: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(12),
                                                                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(height:15),
                                                                    Text(
                                                                      "Description".tr,
                                                                      style: TextStyle(
                                                                        fontSize: 16,
                                                                        color: textBlackColor,
                                                                        fontFamily: fontFamilyBold,
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 10),
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child: Container(
                                                                            height: 120,
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                                                              border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                                                            ),
                                                                            child: TextField(
                                                                              controller: description,
                                                                              decoration: InputDecoration(
                                                                                contentPadding: EdgeInsets.all(8),
                                                                                isDense: true, border: InputBorder.none,
                                                                              ),
                                                                              style: TextStyle(
                                                                                color: textBlackColor,
                                                                                fontSize: 16,
                                                                                fontFamily: fontFamilyRegular,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(height: 20),
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                            child:commonButton(
                                                                          title:"Send offer".tr,
                                                                          onTapp: () async{
                                                                            if (bookedHistoryController.amount.text.isNotEmpty) {
                                                                              setState(() {
                                                                                bidLoder = true;
                                                                              });
                                                                              Get.back();
                                                                             await ApiProvider().bookOffer(
                                                                                uid: widget.uid,
                                                                                loadId: widget.loadId,
                                                                                status: "3",
                                                                                offerTotal: bookedHistoryController.isPriceFix 
                                                                                ? (int.parse(bookedHistoryController.amount.text.toString()) * int.parse(bookedHistoryController.historyData.loadDetails.weight)).toString()
                                                                                : bookedHistoryController.amount.text,
                                                                                  offerType: bookedHistoryController.isPriceFix ? "Tonne" : "Fixed",
                                                                                  offerDescription: description.text,
                                                                                  offerPrice: bookedHistoryController.amount.text,
                                                                                ).then((value) {
                                                                                var decode = value;
                                                                                if (decode["Result"] == "true") {
                                                                                  Get.back();
                                                                                  showCommonToast(msg: decode["ResponseMsg"]);
                                                                                  bookedHistoryController.amount.text = "";
                                                                                  setState(() {
                                                                                    bidLoder = false;
                                                                                  });
                                                                                } else {
                                                                                  showCommonToast(msg: decode["ResponseMsg"]);
                                                                                  Get.back();
                                                                                  setState(() {
                                                                                    bidLoder = false;
                                                                                  });
                                                                                }
                                                                              });
                                                                            }
                                                                          },
                                                                        ),),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }));
                                                        },
                                                        child: Text(
                                                          "offer".tr,
                                                          style: TextStyle(
                                                            color: whiteColor,
                                                            fontSize: 15,
                                                            fontFamily: "urbani_extrabold",
                                                            fontWeight:FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          else if (bookedHistoryController.historyData.loadDetails.flowId == "6")
                                            Column(
                                              children: [
                                                SizedBox(height: 10),
                                                Text(
                                                  "Waiting for offer Response".tr,
                                                  style: TextStyle(
                                                    color: priMaryColor,
                                                    fontSize: 14,
                                                    fontFamily: fontFamilyRegular,
                                                    fontWeight:  FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            )
                                          else if (bookedHistoryController.historyData.loadDetails.flowId == "0")
                                            Column(
                                              children: [
                                                SizedBox(height: 10),
                                                Text(
                                                  "Waiting for Response".tr,
                                                  style: TextStyle(
                                                    color: priMaryColor,
                                                    fontSize: 14,
                                                    fontFamily: fontFamilyRegular,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            )
                                          else
                                            SizedBox(height: 0),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              if (bookedHistoryController.historyData.loadDetails.flowId == "4" ||
                                  bookedHistoryController.historyData.loadDetails.flowId == "7")
                                Positioned(
                                  top: -10,
                                  child: InkWell(
                                  onTap: () {
                                    makingPhoneCall(phoneNumber: bookedHistoryController.historyData.loadDetails.bidderMobile);
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
                                    debugPrint("============= owner ID ============ ${bookedHistoryController.historyData.loadDetails.bidderId}");
                                    debugPrint("============= lorry ID ============ ${bookedHistoryController.historyData.loadDetails.lorryId}");
                                    // Get.to(
                                    //   ProfileScreen(
                                    //     uid: widget.uid,
                                    //     ownerId: loadsDetailsController.detailsData.loadDetails.bidderId,
                                    //     lorryId: loadsDetailsController.detailsData.loadDetails.lorryId,
                                    //   ),
                                    // );
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  trailing: Text(
                                    bookedHistoryController.historyData.loadDetails.subdriverMobile,
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
                                      bookedHistoryController.historyData.loadDetails.subdriverName,
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
                                    makingPhoneCall(phoneNumber: bookedHistoryController.historyData.loadDetails.subdriverMobile);
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
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 80,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Center(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      leading: SvgPicture.asset("assets/icons/security.svg"),
                                      title: Transform.translate(
                                        offset: Offset(0, -2),
                                        child: Text(
                                          "Load Tracking Status".tr,
                                          style: TextStyle(
                                            color: textBlackColor,
                                            fontSize: 17,
                                            fontFamily: fontFamilyBold,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      subtitle: Text(
                                        bookedHistoryController.historyData.loadDetails.message.tr,
                                        style: TextStyle(color: textGreyColor, fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
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
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          if (int.parse(bookedHistoryController.historyData.loadDetails.flowId) >= 4 &&
                          bookedHistoryController.historyData.loadDetails.flowId != "5" &&
                          bookedHistoryController.historyData.loadDetails.flowId != "6")
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
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
                                                  bookedHistoryController.historyData.loadDetails.pMethodName,
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
                                                  bookedHistoryController.historyData.loadDetails.orderTransactionId,
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
                                                    fontFamily: fontFamilyRegular,
                                                    color: textGreyColor,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Spacer(),
                                                Text(
                                                  "$currency${bookedHistoryController.historyData.loadDetails.totalAmt}",
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
                                            bookedHistoryController.historyData.loadDetails.walAmt == "0"
                                            ? Container()
                                            : SizedBox(height: 15),
                                            bookedHistoryController.historyData.loadDetails.walAmt == "0"
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
                                                  "$currency${bookedHistoryController.historyData.loadDetails.walAmt}",
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
                                            Divider(height: 30, color: Colors.grey),
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
                                                  "$currency${bookedHistoryController.historyData.loadDetails.payAmt}",
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
                            ),
                        ],
                      ),
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        );
      }),
    );
  }
}
//flow id = 1 and is_accept = 1 accept and pay button

// flow_id = 0
//
// accept  = status =1 , load_id,uid
//
// flow_id = 0 waiting for partner decision
// flow_id = 1 show accept & pay ,reject , offer
// flow_id = 2 order cancellled
// flow_id = 3 show accpet & pay , reject ,offer
// flow_id = 4 acepted
// flow_id = 5 cancelled
// flow_id = 6 offer send to partner waiting for decision
// flow_id = 7 load pick up done
// flow_id = 8 load completed

//0,1,2,3,5,8

makingPhoneCall({required String phoneNumber}) async {
  final contactPermission = await Permission.phone.request();
  if(contactPermission.isGranted){
    var url = Uri.parse(
        "tel:${phoneNumber}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Get.to(() => LoginScreen());
    }
  }
}
