// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../AppConstData/routes.dart';
import '../../Controllers/homepage_controller.dart';
import '../../Controllers/postloads1_controller.dart';
import '../../widgets/widgets.dart';
import '../../AppConstData/app_colors.dart';
import '../../AppConstData/typography.dart';
import '../Api_Provider/api_provider.dart';

class PostLoads2 extends StatefulWidget {
  final String uid;
  final String pickupPoint;
  final String dropPoint;
  final String materialName;
  final String weight;
  final String description;
  final String vehicleId;
  final String pickLat;
  final String pickLng;
  final String dropLat;
  final String dropLng;
  final String pickStateId;
  final String dropStateId;

  const PostLoads2(
      {super.key,
      required this.uid,
      required this.pickupPoint,
      required this.dropPoint,
      required this.materialName,
      required this.weight,
      required this.description,
      required this.vehicleId,
      required this.pickLat,
      required this.pickLng,
      required this.dropLat,
      required this.dropLng,
      required this.pickStateId,
      required this.dropStateId});

  @override
  State<PostLoads2> createState() => _PostLoads2State();
}

class _PostLoads2State extends State<PostLoads2> {
  PostLoads1Controller postLoads1Controller = Get.put(PostLoads1Controller());
  HomePageController homePageController = Get.put(HomePageController());

  @override
  void dispose() {
    super.dispose();
    postLoads1Controller.isHours = false;
    postLoads1Controller.isPriceFix = false;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostLoads1Controller>(builder: (postLoads1Controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: priMaryColor,
          centerTitle: true,
          title: Text(
            postLoads1Controller.editeTitle ?? "Post Load".tr,
            style: TextStyle(
              fontSize: 18,
              fontFamily: fontFamilyBold,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 16,
                              width: 16,
                              // padding: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white70),
                                  shape: BoxShape.circle),
                              child: Center(
                                  child: Text("1",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: fontFamilyRegular,
                                          color: textBlackColor))),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                                flex: 3,
                                child: Text("Load Details".tr,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: fontFamilyBold,
                                        fontSize: 12,
                                        color: Colors.white),
                                    maxLines: 1)),
                            const SizedBox(
                              width: 5,
                            ),
                            Flexible(
                                child: SizedBox(
                                    width: Get.width * 0.07,
                                    child: const Divider(
                                      color: Colors.white,
                                      thickness: 1.5,
                                    ))),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 16,
                              width: 16,
                              // padding: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white70),
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  "2",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: fontFamilyRegular,
                                    color: textBlackColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                                flex: 3,
                                child: Text("Vehicle Type".tr,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: fontFamilyBold,
                                        fontSize: 12,
                                        color: Colors.white),
                                    maxLines: 1)),
                            const SizedBox(
                              width: 5,
                            ),
                            Flexible(
                                child: SizedBox(
                                    width: Get.width * 0.07,
                                    child: const Divider(
                                      color: Colors.white,
                                      thickness: 1.5,
                                    ))),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 16,
                              width: 16,
                              // padding: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white70),
                                  shape: BoxShape.circle),
                              child: Center(
                                  child: Text("3",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: fontFamilyRegular,
                                          color: textBlackColor))),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                                child: Text("Post".tr,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: fontFamilyBold,
                                        fontSize: 12,
                                        color: Colors.white),
                                    maxLines: 1)),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          // height: Get.height * 0.7,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5,
                                    blurStyle: BlurStyle.outer)
                              ]),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("What’s your expected price?".tr,
                                        style: TextStyle(
                                            fontSize: 14.5,
                                            fontFamily: fontFamilyBold,
                                            color: textBlackColor,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      controller: postLoads1Controller.amount,
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          postLoads1Controller
                                              .setIsAmount(false);
                                        } else {
                                          postLoads1Controller.setIsAmount(
                                              postLoads1Controller
                                                  .amount.text.isEmpty);
                                        }
                                      },
                                      style: TextStyle(
                                          color: textBlackColor,
                                          fontSize: 14,
                                          fontFamily: fontFamilyRegular,
                                          fontWeight: FontWeight.w700),
                                      decoration: InputDecoration(
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            postLoads1Controller.isAmount
                                                ? SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: Center(
                                                        child: SvgPicture.asset(
                                                      "assets/icons/exclamation-circle.svg",
                                                      color: Colors.red,
                                                    )))
                                                : const SizedBox(),
                                            postLoads1Controller.isAmount
                                                ? const SizedBox(width: 8)
                                                : const SizedBox(),
                                            Text(postLoads1Controller.isPriceFix
                                                ? "Per Tonnes".tr
                                                : "Fix".tr),
                                            Switch(
                                              activeColor: priMaryColor,
                                              value: postLoads1Controller
                                                  .isPriceFix,
                                              onChanged: (value) {
                                                postLoads1Controller
                                                    .setIsPriceFix(value);
                                              },
                                            ),
                                          ],
                                        ),
                                        hintText: "Amount".tr,
                                        hintStyle: TextStyle(
                                            color: textGreyColor,
                                            fontSize: 13,
                                            fontFamily: fontFamilyRegular),
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
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("The number of hours visible load?".tr,
                                        style: TextStyle(
                                            fontSize: 14.5,
                                            fontFamily: fontFamilyBold,
                                            color: textBlackColor,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    TextField(
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          postLoads1Controller
                                              .setIsNumberOfHours(false);
                                        } else {
                                          postLoads1Controller
                                              .setIsNumberOfHours(
                                                  postLoads1Controller
                                                      .numberOfHours
                                                      .text
                                                      .isEmpty);
                                        }
                                      },
                                      controller:
                                          postLoads1Controller.numberOfHours,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                          color: textBlackColor,
                                          fontSize: 14,
                                          fontFamily: fontFamilyRegular,
                                          fontWeight: FontWeight.w700),
                                      readOnly: postLoads1Controller.isHours,
                                      decoration: InputDecoration(
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            postLoads1Controller.isNumberOfHours
                                                ? SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: Center(
                                                        child: SvgPicture.asset(
                                                      "assets/icons/exclamation-circle.svg",
                                                      color: Colors.red,
                                                    )))
                                                : const SizedBox(),
                                            postLoads1Controller.isNumberOfHours
                                                ? const SizedBox(width: 8)
                                                : const SizedBox(),
                                            Text(postLoads1Controller.isHours
                                                ? "Not Fix".tr
                                                : "Hours".tr),
                                            Switch(
                                              activeColor: priMaryColor,
                                              value:
                                                  postLoads1Controller.isHours,
                                              onChanged: (value) {
                                                postLoads1Controller
                                                    .setIsHours(value);
                                                if (value) {
                                                  postLoads1Controller
                                                      .setIsNumberOfHours(
                                                          false);
                                                  postLoads1Controller
                                                      .numberOfHours.text = "0";
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        hintText: "Number of hours".tr,
                                        hintStyle: TextStyle(
                                            color: textGreyColor,
                                            fontSize: 13,
                                            fontFamily: fontFamilyRegular),
                                        prefixIcon: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Center(
                                                child: SvgPicture.asset(
                                                    "assets/icons/calendar-clock.svg"))),
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
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Pickup Contact Detail".tr,
                                        style: TextStyle(
                                            fontSize: 14.5,
                                            fontFamily: fontFamilyBold,
                                            color: textBlackColor,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    TextField(
                                      onTap: () {
                                        bottomSheet(
                                            postLoads1Controller.pickup, true);
                                      },
                                      onChanged: (value) {},
                                      readOnly: true,
                                      controller: postLoads1Controller.pickup,
                                      style: TextStyle(
                                          color: textBlackColor,
                                          fontSize: 14,
                                          fontFamily: fontFamilyRegular,
                                          fontWeight: FontWeight.w700),
                                      decoration: InputDecoration(
                                        hintText: "Pickup Contact Detail".tr,
                                        suffixIcon:
                                            postLoads1Controller.isPickUpDetails
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
                                            fontSize: 13,
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
                                  ],
                                ),

                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Drop Contact Details".tr,
                                        style: TextStyle(
                                            fontSize: 14.5,
                                            fontFamily: fontFamilyBold,
                                            color: textBlackColor,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    TextField(
                                      onTap: () {
                                        bottomSheet(
                                            postLoads1Controller.drop, false);
                                      },
                                      onChanged: (value) {},
                                      readOnly: true,
                                      controller: postLoads1Controller.drop,
                                      style: TextStyle(
                                          color: textBlackColor,
                                          fontSize: 14,
                                          fontFamily: fontFamilyRegular,
                                          fontWeight: FontWeight.w700),
                                      decoration: InputDecoration(
                                        hintText: "Drop Contact Details".tr,
                                        suffixIcon:
                                            postLoads1Controller.isDropDetails
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
                                            fontSize: 13,
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
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: commonButton(
                                        title: postLoads1Controller.isEdit
                                            ? "Edit Load".tr
                                            : "Post Load".tr,
                                        onTapp: () {
                                          if (postLoads1Controller.numberOfHours.text.isEmpty) {
                                            postLoads1Controller.setIsNumberOfHours(true);
                                          }
                                          if (postLoads1Controller.amount.text.isEmpty) {
                                            postLoads1Controller.setIsAmount(true);
                                          }
                                          if (postLoads1Controller.pickup.text.isEmpty) {
                                            postLoads1Controller.setIsPickUpDetails(true);
                                          }
                                          if (postLoads1Controller.drop.text.isEmpty) {
                                            postLoads1Controller.setIsDropDetails(true);
                                          }

                                          if (postLoads1Controller.numberOfHours.text.isNotEmpty &&
                                              postLoads1Controller.amount.text.isNotEmpty &&
                                              postLoads1Controller.pickup.text.isNotEmpty &&
                                              postLoads1Controller.drop.text.isNotEmpty) {
                                            postLoads1Controller.setIsLoading1(true);
                                            if (postLoads1Controller.isEdit) {
                                              ApiProvider().editeLoad(
                                                      uid: widget.uid,
                                                      pickupPoint: widget.pickupPoint,
                                                      dropPoint: widget.dropPoint,
                                                      materialName: widget.materialName,
                                                      weight: widget.weight,
                                                      description: widget.description,
                                                      vehicleId: widget.vehicleId,
                                                      amount: postLoads1Controller.amount.text,
                                                      amtType: postLoads1Controller.isPriceFix
                                                          ? "Tonne".tr
                                                          : "Fixed".tr,
                                                      visibleHours: postLoads1Controller.numberOfHours.text,
                                                      totalAmt: postLoads1Controller.isPriceFix
                                                          ? (int.parse(postLoads1Controller.amount.text.toString()) * int.parse(widget.weight)).toString()
                                                          : postLoads1Controller.amount.text,
                                                      pickLat: widget.pickLat,
                                                      pickLng: widget.pickLng,
                                                      dropLat: widget.dropLat,
                                                      dropLng: widget.dropLng,
                                                      pickStateId: widget.pickStateId,
                                                      dropStateId: widget.dropStateId,
                                                      loadId: postLoads1Controller.loadId!)
                                                  .then((value) {
                                                var decode = value;
                                                if (decode["Result"] == "true") {
                                                  postLoads1Controller.setIsLoading1(false);
                                                  bottomSheet12();
                                                } else {
                                                  snakbar(decode["ResponseMsg"], context);
                                                  postLoads1Controller.setIsLoading1(false);
                                                }
                                              });
                                            } else {
                                              debugPrint("widget.pickLng ==> ${widget.pickLng}");
                                              ApiProvider().postLoads(
                                                      uid: widget.uid,
                                                      pickupPoint: widget.pickupPoint,
                                                      dropPoint: widget.dropPoint,
                                                      materialName: widget.materialName,
                                                      weight: widget.weight,
                                                      description: widget.description,
                                                      vehicleId: widget.vehicleId,
                                                      amount: postLoads1Controller.amount.text,
                                                      amtType: postLoads1Controller.isPriceFix
                                                          ? "Tonne".tr
                                                          : "Fixed".tr,
                                                      visibleHours: postLoads1Controller.numberOfHours.text,
                                                      totalAmt: postLoads1Controller.isPriceFix
                                                          ? (int.parse(postLoads1Controller.amount.text.toString()) * int.parse(widget.weight)).toString()
                                                          : postLoads1Controller.amount.text,
                                                      pickLat: widget.pickLat,
                                                      pickLng: widget.pickLng,
                                                      dropLat: widget.dropLat,
                                                      dropLng: widget.dropLng,
                                                      pickStateId: widget.pickStateId,
                                                      dropStateId: widget.dropStateId,
                                                      dropMobile: postLoads1Controller.drop.text.toString().split(" ").first,
                                                      dropName: postLoads1Controller.drop.text.toString().split("(").last,
                                                      pickMobile: postLoads1Controller.pickup.text.toString().split(" ").first,
                                                      pickName: postLoads1Controller.pickup.text.toString().split("(").last)
                                                  .then((value) {
                                                var decode = value;
                                                if (decode["Result"] == "true") {
                                                  postLoads1Controller.setIsLoading1(false);
                                                  bottomSheet12();
                                                } else {
                                                  snakbar(decode["ResponseMsg"], context);
                                                  postLoads1Controller.setIsLoading1(false);
                                                }
                                              });
                                            }
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              postLoads1Controller.isLoading1
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      );
    });
  }

  Future bottomSheet12() {
    return Get.bottomSheet(
        isScrollControlled: true,
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          height: 330,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SvgPicture.asset("assets/image/loadpostdone.svg"),
              const Spacer(),
              Text(
                postLoads1Controller.isEdit
                    ? "Load Edited !".tr
                    : "Load Posted !".tr,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: fontFamilyBold,
                    color: textBlackColor),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Shortly You get leads !!".tr,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: fontFamilyRegular,
                    fontWeight: FontWeight.w500,
                    color: textGreyColor),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: commonButton(
                      title: "Load Details".tr,
                      onTapp: () {
                        despose();
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
  }

  despose() {
    postLoads1Controller.materialName.text = "Post Load";
    postLoads1Controller.isEdit = false;
    postLoads1Controller.amount.text = "";
    postLoads1Controller.editeTitle = "";
    postLoads1Controller.description.text = "";
    postLoads1Controller.pickUpController.text = "";
    postLoads1Controller.numberTonnes.text = "";
    postLoads1Controller.dropDownController.text = "";
    postLoads1Controller.picUpState = "";
    postLoads1Controller.dropPoint = "";
    postLoads1Controller.picUpLng = "";
    postLoads1Controller.picUpLat = "";
    postLoads1Controller.dropUpLng = "";
    postLoads1Controller.dropUpLat = "";
    postLoads1Controller.numberOfHours.text = "";
    postLoads1Controller.pickup.text = "";
    postLoads1Controller.drop.text = "";
  }

  Future bottomSheet(TextEditingController controller, bool ispickup) {
    return Get.bottomSheet(isScrollControlled: true,
        GetBuilder<PostLoads1Controller>(builder: (postLoads1Controller) {
      return Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: SingleChildScrollView(
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
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: postLoads1Controller.name,
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
                controller: postLoads1Controller.number,
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
                      value: postLoads1Controller.isMySelf,
                      onChanged: (value) {
                        if (value == true) {
                          postLoads1Controller.number.text =
                              homePageController.userData.mobile;
                          postLoads1Controller.name.text =
                              homePageController.userData.name;
                        } else {
                          postLoads1Controller.number.text = "";
                          postLoads1Controller.name.text = '';
                        }
                        postLoads1Controller.setIsMySelf(value!);
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
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: commonButton(
                    title: "Next".tr,
                    onTapp: () {
                      if (postLoads1Controller.number.text.isNotEmpty &&
                          postLoads1Controller.name.text.isNotEmpty) {
                        controller.text =
                            "${postLoads1Controller.number.text} (${postLoads1Controller.name.text}) ";
                        postLoads1Controller.name.text = "";
                        postLoads1Controller.number.text = "";
                        postLoads1Controller.setIsMySelf(false);

                        if (ispickup == false) {
                          postLoads1Controller.setIsDropDetails(false);
                        }
                        if (ispickup) {
                          postLoads1Controller.setIsPickUpDetails(false);
                        }
                        Get.back();
                      }
                    },
                  )),
                ],
              )
            ],
          ),
        ),
      );
    }));
  }
}
