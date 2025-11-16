
// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import '../Api_Provider/imageupload_api.dart';
import 'post_loads1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AppConstData/app_colors.dart';
import '../../AppConstData/typography.dart';
import '../../Controllers/postloads1_controller.dart';
import '../../widgets/widgets.dart';
import '../Api_Provider/api_provider.dart';

class PostLoads extends StatefulWidget {
  const PostLoads({super.key});

  @override
  State<PostLoads> createState() => _PostLoadsState();
}

class _PostLoadsState extends State<PostLoads> {
  @override
  void initState() {
    super.initState();
    getGkey();
    editdata();
  }

  editdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String decodedata = preferences.getString("tempEditdata") ?? "";
    Map data = {};
    if (decodedata.isNotEmpty) {
      data = jsonDecode(decodedata);
    }
    if (data.isNotEmpty) {
      postLoads1Controller.editeTitle = data["id"];
      postLoads1Controller.loadId = data["loadId"];
      postLoads1Controller.isEdit = data["isEdit"];
      postLoads1Controller.materialName.text = data["materialName"];
      postLoads1Controller.amount.text = data["amount"];
      postLoads1Controller.description.text = data["description"];
      postLoads1Controller.pickUpController.text = data["pickUpController"];
      postLoads1Controller.numberTonnes.text = data["numberTonnes"];
      postLoads1Controller.dropDownController.text = data["dropDownController"];
      postLoads1Controller.picUpState = data["picUpState"];
      postLoads1Controller.dropPoint = data["dropPoint"];
      postLoads1Controller.picUpLng = data["picUpLng"];
      postLoads1Controller.picUpLat = data["picUpLat"];
      postLoads1Controller.dropUpLng = data["dropUpLng"];
      postLoads1Controller.dropUpLat = data["dropUpLat"];
      postLoads1Controller.numberOfHours.text = data["numberOfHours"];
      postLoads1Controller.pickup.text = data["pickup"];
      postLoads1Controller.drop.text = data["drop"];
      preferences.setString("tempEditdata", "");
    } else {}
  }

  String gkey = "";
  getGkey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      gkey = prefs.getString("gkey") ?? googleApiKey;
    });
  }

  @override
  void dispose() {
    super.dispose();
    despose();
  }

  PostLoads1Controller postLoads1Controller = Get.put(PostLoads1Controller());

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
        body: Stack(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.transparent),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text("1",
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
                          child: Text("Load Details".tr,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontFamily: fontFamilyBold,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: SizedBox(
                            width: Get.width * 0.07,
                            child: const Divider(
                              color: Colors.white70,
                              thickness: 1.5,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.white70),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text("2",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: fontFamilyRegular,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          flex: 3,
                          child: Text("Vehicle Type".tr,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontFamily: fontFamilyBold,
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: SizedBox(
                            width: Get.width * 0.07,
                            child: const Divider(
                              color: Colors.white70,
                              thickness: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.white70),
                              shape: BoxShape.circle),
                          child: Center(
                              child: Text("3",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: fontFamilyRegular,
                                      color: Colors.white70))),
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
                                    color: Colors.white70),
                                maxLines: 1)),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
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
                                blurStyle: BlurStyle.outer)
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: Get.width,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                            "assets/icons/ic_pickup_map.svg",
                                            width: 24,
                                            height: 24),
                                        Expanded(
                                          child: pickUpPoint(),
                                        ),
                                        postLoads1Controller.isPickUp
                                            ? SvgPicture.asset(
                                                "assets/icons/exclamation-circle.svg",
                                                width: 24,
                                                height: 24,
                                                color: Colors.red)
                                            : const SizedBox(),
                                      ],
                                    ),
                                    Divider(
                                        color: Colors.grey.withOpacity(0.3),
                                        height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                            "assets/icons/ic_pickup_map.svg",
                                            width: 24,
                                            height: 24),
                                        Expanded(
                                          child: dropPoint(),
                                        ),
                                        postLoads1Controller.isDropPoint
                                            ? SvgPicture.asset(
                                                "assets/icons/exclamation-circle.svg",
                                                width: 24,
                                                height: 24,
                                                color: Colors.red)
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextField(
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    postLoads1Controller.setIsMaterialName(false);
                                  } else {
                                    postLoads1Controller.setIsMaterialName(postLoads1Controller.materialName.text.isEmpty);
                                  }
                                },
                                controller: postLoads1Controller.materialName,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: fontFamilyRegular,
                                  color: textBlackColor,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Material Name".tr,
                                  suffixIcon: postLoads1Controller.isMaterialName
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
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  hintStyle: TextStyle(
                                      fontSize: 17,
                                      fontFamily: fontFamilyRegular,
                                      color: textGreyColor),
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
                                        color: Colors.grey.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextField(
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    postLoads1Controller.setIsNumTonnes(false);
                                  } else {
                                    postLoads1Controller.setIsNumTonnes(postLoads1Controller.numberTonnes.text.isEmpty);
                                  }
                                },
                                controller: postLoads1Controller.numberTonnes,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: fontFamilyRegular,
                                    color: textBlackColor),
                                decoration: InputDecoration(
                                  hintText: "Number of Tonnes".tr,
                                  suffixIcon: postLoads1Controller.isNumTonnes
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
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  hintStyle: TextStyle(
                                      fontSize: 17,
                                      fontFamily: fontFamilyRegular,
                                      color: textGreyColor),
                                  prefixIcon: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Center(
                                      child: SvgPicture.asset("assets/icons/delivery-cart-arrow-up.svg"),
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextField(
                                controller: postLoads1Controller.description,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: fontFamilyRegular,
                                    color: textBlackColor),
                                decoration: InputDecoration(
                                  hintText: "Description".tr,
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 16),
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
                                        color: Colors.grey.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: commonButton(
                                  title: "Next",
                                  onTapp: () {
                                    if (postLoads1Controller.pickUpController.text.isNotEmpty &&
                                        postLoads1Controller.dropDownController.text.isNotEmpty &&
                                        postLoads1Controller.materialName.text.isNotEmpty &&
                                        postLoads1Controller.numberTonnes.text.isNotEmpty) {
                                      ApiProvider().checkStat(
                                        pickUpName: postLoads1Controller.picUpState!,
                                        dropStateName:postLoads1Controller.dropPoint!)
                                          .then((value) {
                                        var decode = value;
                                        if (decode["Result"] == "true") {
                                          Get.to(PostLoads1(
                                            weight: postLoads1Controller.numberTonnes.text,
                                            pickupPoint: postLoads1Controller.pickUpController.text,
                                            pickStateId: decode["pick_state_id"],
                                            pickLng: postLoads1Controller.picUpLng!,
                                            pickLat: postLoads1Controller.picUpLat!,
                                            materialName: postLoads1Controller.materialName.text,
                                            dropStateId: decode["drop_state_id"],
                                            dropPoint: postLoads1Controller.dropDownController.text,
                                            dropLng: postLoads1Controller.dropUpLng!,
                                            dropLat: postLoads1Controller.dropUpLat!,
                                            description: postLoads1Controller.description.text,
                                          ));
                                        } else {
                                          if (decode["drop_state_id"] == "0") {
                                            setState(() {
                                              postLoads1Controller.dropDownController.text = "";
                                            });
                                          }
                                          if (decode["pick_state_id"] == "0") {
                                            setState(() {
                                              postLoads1Controller.pickUpController.text = "";
                                            });
                                          }
                                          snakbar(decode["ResponseMsg"], context);
                                        }
                                      });
                                    }
                                    if (postLoads1Controller.pickUpController.text.isEmpty) {
                                      postLoads1Controller.setIsPickUp(true);
                                    }
                                    if (postLoads1Controller.dropDownController.text.isEmpty) {
                                      postLoads1Controller.setIsDropPoint(true);
                                    }
                                    if (postLoads1Controller.materialName.text.isEmpty) {
                                      postLoads1Controller.setIsMaterialName(true);
                                    }
                                    if (postLoads1Controller.numberTonnes.text.isEmpty) {
                                      postLoads1Controller.setIsNumTonnes(true);
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  despose() {
    postLoads1Controller.isDropPoint = false;
    postLoads1Controller.isPickUp = false;
    postLoads1Controller.isNumTonnes = false;
    postLoads1Controller.isMaterialName = false;
    postLoads1Controller.materialName.text = "";
    postLoads1Controller.isEdit = false;
    postLoads1Controller.amount.text = "";
    postLoads1Controller.editeTitle = "Post Load";
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

  dropPoint() {
    return GooglePlaceAutoCompleteTextField(
      textStyle: TextStyle(
          fontSize: 17, fontFamily: fontFamilyRegular, color: textBlackColor),
      boxDecoration:
          BoxDecoration(border: Border.all(color: Colors.transparent)),
      textEditingController: postLoads1Controller.dropDownController,
      googleAPIKey: gkey,
      inputDecoration: InputDecoration(
          hintText: "Drop Point".tr,
          hintStyle: TextStyle(
              fontSize: 17,
              fontFamily: fontFamilyRegular,
              color: textGreyColor),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero),
      debounceTime: 400,
      getPlaceDetailWithLatLng: (Prediction prediction) {
        getAddressFromLatLong(prediction.lat, prediction.lng).then((value) {
          setState(() {
            postLoads1Controller.dropPoint = value;
          });
        debugPrint("+++++++++++++++++++++++++ dropPoint :--- ${postLoads1Controller.dropPoint}");
        });
        setState(() {
          postLoads1Controller.dropUpLat = prediction.lat;
          postLoads1Controller.dropUpLng = prediction.lng;
        });
        debugPrint("+++++++++++++++++++++++++ placeDetails :--- ${prediction.lat}");
        debugPrint("+++++++++++++++++++++++++ placeDetails :--- ${postLoads1Controller.dropUpLng}");
      },
      itemClick: (Prediction prediction) {
        postLoads1Controller.setIsDropPoint(false);
        postLoads1Controller.dropDownController.text =
            prediction.description ?? "";
        postLoads1Controller.dropDownController.selection =
            TextSelection.fromPosition(
                TextPosition(offset: prediction.description?.length ?? 0));
      },
      itemBuilder: (context, index, Prediction prediction) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(
                width: 7,
              ),
              Expanded(child: Text(prediction.description ?? ""))
            ],
          ),
        );
      },
      isCrossBtnShown: false,
    );
  }

  pickUpPoint() {
    return GooglePlaceAutoCompleteTextField(
      textStyle: TextStyle(
        fontSize: 17,
        fontFamily: fontFamilyRegular,
        color: textBlackColor,
      ),
      boxDecoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
      textEditingController: postLoads1Controller.pickUpController,
      googleAPIKey: gkey,
      inputDecoration: InputDecoration(
        hintText: "Pickup Point".tr,
        hintStyle: TextStyle(
          fontSize: 17,
          fontFamily: fontFamilyRegular,
          color: textGreyColor,
        ),
        border: InputBorder.none,
        isDense: true,
        contentPadding: const EdgeInsets.all(0),
      ),
      debounceTime: 400,
      getPlaceDetailWithLatLng: (Prediction prediction) {
          debugPrint("========== prediction.lat ========= ${prediction.lat}");
          debugPrint("========== prediction.lng ========= ${prediction.lng}");
        getAddressFromLatLong(prediction.lat, prediction.lng).then((value) {
          setState(() {
           postLoads1Controller.picUpState = value; 
          });
          debugPrint("========== picUpState ========= ${postLoads1Controller.picUpState}");
        });
        setState(() {
          postLoads1Controller.picUpLat = prediction.lat;
          postLoads1Controller.picUpLng = prediction.lng;
        });
          debugPrint("========== picUpLat ========= ${postLoads1Controller.picUpLat}");
          debugPrint("========== picUpLng ========= ${postLoads1Controller.picUpLng}");
      },

      itemClick: (Prediction prediction) {
        postLoads1Controller.setIsPickUp(false);
        postLoads1Controller.pickUpController.text = prediction.description ?? "";
        postLoads1Controller.pickUpController.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description?.length ?? 0));
      },

      itemBuilder: (context, index, Prediction prediction) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(
                width: 7,
              ),
              Expanded(child: Text(prediction.description ?? ""))
            ],
          ),
        );
      },

      isCrossBtnShown: false,
    );
  }
}

Future<String> getAddressFromLatLong(String? lat, String? long) async {
  if (lat == null || long == null) return "";

  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      double.parse(lat),
      double.parse(long),
    );
    if (placemarks.isNotEmpty) {
      final placemark = placemarks[0];
      // administrativeArea usually corresponds to the state.
      return placemark.administrativeArea ?? "";
    }
  } catch (e) {
    debugPrint("Error getting address from lat/long: $e");
    return "";
  }

  return "";
}
