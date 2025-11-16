// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../Controllers/sentrequest_controller.dart';

import '../../AppConstData/app_colors.dart';
import '../../AppConstData/routes.dart';
import '../../AppConstData/typography.dart';
import '../../Controllers/homepage_controller.dart';
import '../../widgets/widgets.dart';
import '../Api_Provider/api_provider.dart';

class SentRequest extends StatefulWidget {
  final String uid;
  final String pickupPoint;
  final String dropPoint;
  final String pickLat;
  final String pickLng;
  final String dropLat;
  final String dropLng;
  final String dropStateId;
  final String pickStateId;
  final String title;
  final String vehicleId;
  final String lorryId;
  final String lorryOwnerId;

  const SentRequest(
      {super.key,
      required this.uid,
      required this.vehicleId,
      required this.lorryOwnerId,
      required this.title,
      required this.pickupPoint,
      required this.dropPoint,
      required this.pickLat,
      required this.pickLng,
      required this.dropLat,
      required this.dropLng,
      required this.dropStateId,
      required this.pickStateId,
      required this.lorryId});

  @override
  State<SentRequest> createState() => _SentRequestState();
}

class _SentRequestState extends State<SentRequest> {
  SentRequestController sentRequestController = Get.put(SentRequestController());
  HomePageController homePageController = Get.put(HomePageController());

  TextEditingController pickUpController = TextEditingController();
  TextEditingController dropDownController = TextEditingController();
  TextEditingController materialName = TextEditingController();
  TextEditingController numberTonnes = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SentRequestController>(builder: (sentRequestController) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: priMaryColor,
            centerTitle: true,
            title: Text(
              widget.title.tr,
              style: TextStyle(
                fontSize: 18,
                fontFamily: fontFamilyBold,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Stack(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 220,
                              color: priMaryColor,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  blurStyle: BlurStyle.outer,
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: Get.width,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.3),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/ic_pickup_map.svg",
                                              width: 24,
                                              height: 24,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: Text(
                                                widget.pickupPoint,
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: fontFamilyRegular,
                                                  color: textBlackColor,
                                                ),
                                              ),
                                            ),
                                            sentRequestController.isPickUp
                                                ? SvgPicture.asset(
                                                    "assets/icons/exclamation-circle.svg",
                                                    width: 24,
                                                    height: 24,
                                                    color: Colors.red)
                                                : const SizedBox(),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Divider(
                                            color: Colors.grey.withOpacity(0.3),
                                            height: 20),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                                "assets/icons/ic_pickup_map.svg",
                                                width: 24,
                                                height: 24),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                                child: Text(
                                              widget.dropPoint,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: fontFamilyRegular,
                                                  color: textBlackColor),
                                            )),
                                            sentRequestController.isDropPoint
                                              ? SvgPicture.asset(
                                                  "assets/icons/exclamation-circle.svg",
                                                  width: 24,
                                                  height: 24,
                                                  color: Colors.red,
                                                )
                                              : const SizedBox(),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextField(
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        sentRequestController.setIsMaterialName(false);
                                      } else {
                                        sentRequestController.setIsMaterialName(materialName.text.isEmpty);
                                      }
                                    },
                                    controller: materialName,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: fontFamilyRegular,
                                        color: textBlackColor),
                                    decoration: InputDecoration(
                                      hintText: "Material Name".tr,
                                      suffixIcon: sentRequestController
                                              .isMaterialName
                                          ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: Center(
                                                child: SvgPicture.asset(
                                                  "assets/icons/exclamation-circle.svg",
                                                  color: Colors.red,
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                                      hintStyle: TextStyle(
                                        fontSize: 17,
                                        fontFamily: fontFamilyRegular,
                                        color: textGreyColor,
                                      ),
                                      prefixIcon: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Center(
                                          child: SvgPicture.asset(
                                            "assets/icons/box-check.svg",
                                          ),
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.grey.withOpacity(0.3)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.grey.withOpacity(0.3)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.grey.withOpacity(0.3)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextField(
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        sentRequestController
                                            .setIsNumTonnes(false);
                                      } else {
                                        sentRequestController.setIsNumTonnes(
                                            numberTonnes.text.isEmpty);
                                      }
                                    },
                                    controller: numberTonnes,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: fontFamilyRegular,
                                        color: textBlackColor),
                                    decoration: InputDecoration(
                                      hintText: "Number of Tonnes".tr,
                                      suffixIcon: sentRequestController
                                              .isNumTonnes
                                          ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: Center(
                                                  child: SvgPicture.asset("assets/icons/exclamation-circle.svg",color: Colors.red)))
                                          : const SizedBox(),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                      hintStyle: TextStyle(
                                          fontSize: 17,
                                          fontFamily: fontFamilyRegular,
                                          color: textGreyColor),
                                      prefixIcon: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Center(
                                              child: SvgPicture.asset(
                                                  "assets/icons/delivery-cart-arrow-up.svg"))),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.grey.withOpacity(0.3)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.grey.withOpacity(0.3)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.grey.withOpacity(0.3)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextField(
                                    controller: description,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: fontFamilyRegular,
                                        color: textBlackColor),
                                    decoration: InputDecoration(
                                      hintText: "Description".tr,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                      hintStyle: TextStyle(
                                          fontSize: 17,
                                          fontFamily: fontFamilyRegular,
                                          color: textGreyColor),
                                      prefixIcon: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Center(
                                              child: SvgPicture.asset(
                                                  "assets/icons/receipt-list.svg"))),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.grey.withOpacity(0.3)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.grey.withOpacity(0.3)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.grey.withOpacity(0.3)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16
                                  ),
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    controller: sentRequestController.amount,
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        sentRequestController
                                            .setIsAmount(false);
                                      } else {
                                        sentRequestController.setIsAmount(
                                            sentRequestController
                                                .amount.text.isEmpty);
                                      }
                                    },
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: fontFamilyRegular,
                                        color: textBlackColor),
                                    decoration: InputDecoration(
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          sentRequestController.isAmount
                                              ? SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: Center(
                                                      child: SvgPicture.asset(
                                                    "assets/icons/exclamation-circle.svg",
                                                    color: Colors.red,
                                                  )))
                                              : const SizedBox(),
                                          sentRequestController.isAmount
                                              ? const SizedBox(width: 8)
                                              : const SizedBox(),
                                          Text(sentRequestController.isPriceFix
                                              ? "Per Tonnes".tr
                                              : "Fix".tr),
                                          SizedBox(
                                            height: 20,
                                            child: Switch(
                                              activeColor: priMaryColor,
                                              value: sentRequestController
                                                  .isPriceFix,
                                              onChanged: (value) {
                                                sentRequestController
                                                    .setIsPriceFix(value);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      hintText: "Amount".tr,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                      hintStyle: TextStyle(
                                          fontSize: 17,
                                          fontFamily: fontFamilyRegular,
                                          color: textGreyColor),
                                      prefixIcon: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Center(
                                              child: SvgPicture.asset(
                                                  "assets/icons/sack-dollar.svg"))),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(0.3))),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(0.3))),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(0.3))),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextField(
                                    onTap: () {
                                      bottomSheet(
                                          sentRequestController.pickup, true);
                                    },
                                    onChanged: (value) {},
                                    readOnly: true,
                                    controller: sentRequestController.pickup,
                                    style: TextStyle(
                                      color: textBlackColor,
                                      fontSize: 17,
                                      fontFamily: fontFamilyRegular,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Pickup Contact Detail".tr,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                      suffixIcon:
                                          sentRequestController.isPickUpDetails
                                              ? SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: Center(
                                                      child: SvgPicture.asset(
                                                    "assets/icons/exclamation-circle.svg",
                                                    color: Colors.red,
                                                  )))
                                              : const SizedBox(),
                                      hintStyle: TextStyle(
                                          color: textGreyColor,
                                          fontSize: 17,
                                          fontFamily: fontFamilyRegular),
                                      prefixIcon: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Center(
                                              child: SvgPicture.asset(
                                                  "assets/icons/ic_user_bottom.svg"))),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(0.3))),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(0.3))),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(0.3))),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextField(
                                    onTap: () {
                                      bottomSheet(sentRequestController.drop, false);
                                    },
                                    onChanged: (value) {},
                                    readOnly: true,
                                    controller: sentRequestController.drop,
                                    style: TextStyle(
                                      color: textBlackColor,
                                      fontSize: 17,
                                      fontFamily: fontFamilyRegular,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Drop Contact Details".tr,
                                      suffixIcon:
                                          sentRequestController.isDropDetails
                                              ? SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: Center(
                                                      child: SvgPicture.asset(
                                                    "assets/icons/exclamation-circle.svg",
                                                    color: Colors.red,
                                                  )))
                                              : const SizedBox(),
                                      hintStyle: TextStyle(
                                          color: textGreyColor,
                                          fontSize: 17,
                                          fontFamily: fontFamilyRegular),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                      prefixIcon: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Center(
                                              child: SvgPicture.asset("assets/icons/ic_user_bottom.svg"))),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(0.3))),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(0.3))),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(0.3))),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  // const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      sentRequestController.isSendReruest
                                      ? SpinKitThreeBounce(color: priMaryColor, size: 25.0)
                                      : Expanded(
                                        child: commonButton(
                                          title: "Sent Request".tr,
                                          onTapp: () {
                                            if (sentRequestController.numberOfHours.text.isEmpty) {
                                              sentRequestController.setIsNumberOfHours(true);
                                            }
                                            if (sentRequestController.amount.text.isEmpty) {
                                              sentRequestController.setIsAmount(true);
                                            }
                                            if (sentRequestController.pickup.text.isEmpty) {
                                              sentRequestController.setIsPickUpDetails(true);
                                            }
                                            if (sentRequestController.drop.text.isEmpty) {
                                              sentRequestController.setIsDropDetails(true);
                                            }
                                            if (materialName.text.isEmpty) {
                                              sentRequestController.setIsMaterialName(true);
                                            }
                                            if (numberTonnes.text.isEmpty) {
                                              sentRequestController.setIsNumTonnes(true);
                                            }
                                            if (sentRequestController.isSendReruest == false) {
                                                if (sentRequestController.amount.text.isNotEmpty && sentRequestController.pickup.text.isNotEmpty && sentRequestController.drop.text.isNotEmpty && numberTonnes.text.isNotEmpty) {
                                                  sentRequestController.setIsSendReruest(true);
                                                  ApiProvider().postLoadRequest(
                                                    uid: widget.uid,
                                                    pickupPoint: widget.pickupPoint,
                                                    dropPoint: widget.dropPoint,
                                                    materialName: materialName.text,
                                                    weight: numberTonnes.text,
                                                    description: description.text,
                                                    vehicleId: widget.vehicleId,
                                                    amount: sentRequestController.amount.text,
                                                    amtType: sentRequestController.isPriceFix
                                                        ? "Tonne"
                                                        : "Fixed",
                                                    visibleHours: "0",
                                                    totalAmt: sentRequestController.isPriceFix
                                                        ? (int.parse(sentRequestController.amount.text.toString()) * int.parse(numberTonnes.text)).toString()
                                                        : sentRequestController.amount.text,
                                                    pickLat: widget.pickLat,
                                                    pickLng: widget.pickLng,
                                                    dropLat: widget.dropLat,
                                                    dropLng: widget.dropLng,
                                                    pickStateId: widget.pickStateId,
                                                    dropStateId: widget.dropStateId,
                                                    dropMobile: sentRequestController.drop.text.toString().split(" ").first,
                                                    dropName: sentRequestController.drop.text.toString().split("(").last,
                                                    pickMobile: sentRequestController.pickup.text.toString().split(" ").first,
                                                    pickName: sentRequestController.pickup.text.toString().split("(").last,
                                                    lorryId: widget.lorryId,
                                                    lorryOwnerId: widget.lorryOwnerId,
                                                  ).then((value) {
                                                    sentRequestController.setIsLoading(true);
                                                    var decode = value;
                                                    if (decode["Result"] == "true") {
                                                      sentRequestController.setIsLoading(false);
                                                      sentRequestController.setIsSendReruest(false);
                                                      Get.bottomSheet(Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        height: 330,
                                                        padding: EdgeInsets.all(20),
                                                        child: Column(
                                                          children: [
                                                            SvgPicture.asset("assets/image/loadpostdone.svg"),
                                                            const Spacer(),
                                                            Text(
                                                              "Request sent to Lorry Owner !".tr,
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontFamily: fontFamilyBold,
                                                                color: textBlackColor,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 10),
                                                            Text(
                                                              "Shortly You get revert !!".tr,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily: fontFamilyRegular,
                                                                fontWeight: FontWeight.w500,
                                                                color: textGreyColor,
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: commonButton(
                                                                    title: "Load Details".tr,
                                                                    onTapp: () {
                                                                      Get.offAllNamed(Routes.landingPage);
                                                                    },
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            const Spacer(),
                                                          ],
                                                        ),
                                                      ));
                                                    } else {
                                                      snakbar(decode["ResponseMsg"], context);
                                                      sentRequestController.setIsLoading(false);
                                                      sentRequestController.setIsSendReruest(false);
                                                    }
                                                  });
                                                }
                                              }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              sentRequestController.isLoading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ));
    });
  }

  Future bottomSheet(TextEditingController controller, bool ispickup) {
    return Get.bottomSheet(
        GetBuilder<SentRequestController>(builder: (sentRequestController) {
      return Container(
        height: 320,
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Contact Details".tr,
              style: TextStyle(
                  fontSize: 18,
                  color: textBlackColor,
                  fontFamily: fontFamilyBold),
            ),
            const Spacer(),
            TextField(
              controller: sentRequestController.name,
              style: TextStyle(
                  color: textBlackColor,
                  fontSize: 16,
                  fontFamily: fontFamilyRegular,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: "Name".tr,
                hintStyle: TextStyle(
                    color: textBlackColor,
                    fontSize: 16,
                    fontFamily: fontFamilyRegular,
                    fontWeight: FontWeight.w500),
                prefixIcon: SizedBox(
                    width: 20,
                    height: 20,
                    child: Center(
                        child: SvgPicture.asset(
                            "assets/icons/ic_user_bottom.svg"))),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.withOpacity(0.3))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.withOpacity(0.3))),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.withOpacity(0.3))),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: sentRequestController.number,
              style: TextStyle(
                  color: textBlackColor,
                  fontSize: 16,
                  fontFamily: fontFamilyRegular,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: "Mobile Number".tr,
                hintStyle: TextStyle(
                    color: textBlackColor,
                    fontSize: 16,
                    fontFamily: fontFamilyRegular,
                    fontWeight: FontWeight.w500),
                prefixIcon: SizedBox(
                    width: 20,
                    height: 20,
                    child: Center(
                        child: SvgPicture.asset("assets/icons/phone.svg"))),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.withOpacity(0.3))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.withOpacity(0.3))),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.withOpacity(0.3))),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: Checkbox(
                    activeColor: priMaryColor,
                    value: sentRequestController.isMySelf,
                    onChanged: (value) {
                      if (value == true) {
                        sentRequestController.number.text =
                            homePageController.userData.mobile;
                        sentRequestController.name.text =
                            homePageController.userData.name;
                      } else {
                        sentRequestController.number.text = "";
                        sentRequestController.name.text = '';
                      }
                      sentRequestController.setIsMySelf(value!);
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "My Self".tr,
                  style: TextStyle(
                      fontSize: 14,
                      color: textBlackColor,
                      fontFamily: fontFamilyBold),
                )
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                    child: commonButton(
                  title: "Next",
                  onTapp: () {
                    if (sentRequestController.number.text.isNotEmpty &&
                        sentRequestController.name.text.isNotEmpty) {
                      controller.text =
                          "${sentRequestController.number.text} (${sentRequestController.name.text}) ";
                      sentRequestController.name.text = "";
                      sentRequestController.number.text = "";
                      sentRequestController.setIsMySelf(false);

                      if (ispickup == false) {
                        sentRequestController.setIsDropDetails(false);
                      }
                      if (ispickup) {
                        sentRequestController.setIsPickUpDetails(false);
                      }
                      Get.back();
                    }
                  },
                )),
              ],
            )
          ],
        ),
      );
    }));
  }
}
