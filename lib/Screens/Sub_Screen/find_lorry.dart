// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import '../../Controllers/findlorry_controller.dart';
import '../Models/find_lorry_model.dart';
import 'post_loads.dart';
import 'profile_page.dart';
import 'sent_request.dart';
import '../../widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../AppConstData/app_colors.dart';
import '../../AppConstData/typography.dart';
import '../../Controllers/homepage_controller.dart';
import '../Api_Provider/imageupload_api.dart';
import '../Api_Provider/api_provider.dart';

class FindLorry extends StatefulWidget {
  const FindLorry({super.key});

  @override
  State<FindLorry> createState() => _FindLorryState();
}

class _FindLorryState extends State<FindLorry> {
  @override
  void dispose() {
    super.dispose();
    findLorryController.lorryData.findLorryData.clear();
    findLorryController.isShowData = false;
  }

  @override
  void initState() {
    super.initState();
    getGkey();
    ApiProvider().findLorry(
      uid: homePageController.userData.id,
      pickStateId: "0",
      dropStateId: "0",
    ).then((value) {
      findLorryController.setDataInList(FindLorryModel.fromJson(value));
      findLorryController.setIsLoading(false);
      findLorryController.setIsShowData(true);
    });
  }

  String gkey = "";
  getGkey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      gkey = prefs.getString("gkey") ?? googleApiKey;
    });
  }
  FindLorryController findLorryController = Get.put(FindLorryController());
  HomePageController homePageController = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FindLorryController>(builder: (findLorryController) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: priMaryColor,
          centerTitle: true,
          title: Text(
            "Find Lorry".tr,
            style: TextStyle(
              fontSize: 18,
              fontFamily: fontFamilyBold,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Container(height: 220, color: priMaryColor)),
                    ],
                  ),
                  findLorryController.isShowData
                      ? findLorryController.lorryData.findLorryData.isEmpty
                          ? Center(
                              child: Column(
                                children: [
                                  SizedBox(height: Get.height * 0.1),
                                  Text(
                                    "Enter Your Loction".tr,
                                    style: TextStyle(
                                      color: textBlackColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: fontFamilyBold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 15),
                                  Text(
                                    "Select Vehicle type for your load".tr,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: fontFamilyBold,
                                      fontWeight: FontWeight.w700,
                                      color: textBlackColor,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: Get.width,
                                    height: 70,
                                    child: MediaQuery.removePadding(
                                      context: context,
                                      removeLeft: true,
                                      removeRight: true,
                                      child: ListView.separated(
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(width: 10);
                                        },
                                        shrinkWrap: true,
                                        itemCount: findLorryController.lorryData.findLorryData.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              findLorryController.setSelectVehicle(index);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: findLorryController.selectVehicle == index
                                                    ? priMaryColor.withOpacity(0.05)
                                                    : Colors.grey.withOpacity(0.1),
                                                border: Border.all(
                                                  color: findLorryController.selectVehicle == index
                                                      ? priMaryColor
                                                      : Colors.grey.withOpacity(0.1),
                                                ),
                                              ),
                                              height: 80,
                                              padding: EdgeInsets.symmetric(horizontal: 15),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      findLorryController.lorryData.findLorryData[index].title,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: findLorryController.selectVehicle == index
                                                            ? priMaryColor
                                                            : textBlackColor,
                                                        fontFamily: fontFamilyBold,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    "${findLorryController.lorryData.findLorryData[index].minWeight} - ${findLorryController.lorryData.findLorryData[index].maxWeight} ${"Tonnes".tr}",
                                                    style: TextStyle(
                                                      color: findLorryController.selectVehicle == index
                                                          ? priMaryColor
                                                          : textGreyColor,
                                                      fontSize: 14,
                                                      fontFamily: fontFamilyRegular,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "${findLorryController.lorryData.findLorryData[findLorryController.selectVehicle].lorrydata.length} ${"Available".tr}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: fontFamilyBold,
                                      fontWeight: FontWeight.w700,
                                      color: textBlackColor,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Container(
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
                                                Image.network(
                                                  "$basUrl${findLorryController.lorryData.findLorryData[findLorryController.selectVehicle].lorrydata[index].lorryImg}",
                                                  height: 100,
                                                  width: 100,
                                                ),
                                                SizedBox(width: 8),
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        findLorryController.lorryData.findLorryData[findLorryController.selectVehicle].lorrydata[index].lorryTitle,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: textBlackColor,
                                                          fontFamily: fontFamilyBold,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 4,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/ic_pickup_map.svg",
                                                            width: 20,
                                                            height: 20,
                                                          ),
                                                          const SizedBox(width: 4),
                                                          Flexible(
                                                            child: Text(
                                                              findLorryController.lorryData.findLorryData[findLorryController.selectVehicle].lorrydata[index].currLocation,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: textBlackColor,
                                                                fontFamily: fontFamilyRegular,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 4,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 8),
                                                      Text(
                                                        findLorryController.lorryData.findLorryData[findLorryController.selectVehicle].lorrydata[index].lorryNo,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: textBlackColor,
                                                          fontFamily: fontFamilyBold,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 4,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 18),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/icons/delivery-cart-arrow-up.svg",
                                                  height: 24,
                                                  width: 24,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  "${findLorryController.lorryData.findLorryData[findLorryController.selectVehicle].lorrydata[index].weight} ${"Tonnes".tr}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: textGreyColor,
                                                    overflow: TextOverflow.ellipsis,
                                                    fontFamily: fontFamilyRegular,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                const Spacer(),
                                                SvgPicture.asset(
                                                  "assets/icons/route.svg",
                                                  height: 24,
                                                  width: 24,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  "${findLorryController.lorryData.findLorryData[findLorryController.selectVehicle].lorrydata[index].routesCount} ${"Routes".tr}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: textGreyColor,
                                                    overflow: TextOverflow.ellipsis,
                                                    fontFamily: fontFamilyRegular,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                const Spacer(),
                                                SvgPicture.asset(
                                                  rcVerified(findLorryController.lorryData.findLorryData[findLorryController.selectVehicle].lorrydata[index].rcVerify),
                                                  height: 24,
                                                  width: 24,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  "Rc Verified".tr,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: textGreyColor,
                                                    overflow: TextOverflow.ellipsis,
                                                    fontFamily: fontFamilyRegular,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 18),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                              ),
                                              child: ListTile(
                                                onTap: () {
                                                  debugPrint("=========== uid ========== ${homePageController.userData.id}");
                                                  debugPrint("========= ownerId ======== ${findLorryController.lorryData.findLorryData[findLorryController.selectVehicle].lorrydata[index].lorryOwnerId}");
                                                  debugPrint("========= lorryId ======== ${findLorryController.lorryData.findLorryData[findLorryController.selectVehicle].lorrydata[index].lorryId}");
                                                  Get.to(
                                                    ProfileScreen(
                                                      uid: homePageController.userData.id,
                                                      ownerId: findLorryController.lorryData.findLorryData[findLorryController.selectVehicle].lorrydata[index].lorryOwnerId,
                                                      lorryId: findLorryController.lorryData.findLorryData[findLorryController.selectVehicle].lorrydata[index].lorryId,
                                                    ),
                                                  );
                                                },
                                                leading: CircleAvatar(
                                                  backgroundColor: Colors.transparent,
                                                  backgroundImage: NetworkImage("$basUrl${findLorryController.lorryData.findLorryData[findLorryController.selectVehicle].lorrydata[index].lorryOwnerImg}"),
                                                ),
                                                title: Transform.translate(
                                                  offset: const Offset(0, -2),
                                                  child: Text(
                                                    findLorryController.lorryData.findLorryData[findLorryController.selectVehicle].lorrydata[index].lorryOwnerTitle,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                trailing: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(16),
                                                    ),
                                                    backgroundColor: priMaryColor,
                                                  ),
                                                  onPressed: () {
                                                    Get.to(
                                                      SentRequest(
                                                        vehicleId: findLorryController.lorryData.findLorryData[findLorryController.selectVehicle].lorrydata[index].vehicleId,
                                                        uid: homePageController.userData.id,
                                                        lorryOwnerId: findLorryController.lorryData.findLorryData[findLorryController.selectVehicle].lorrydata[index].lorryOwnerId,
                                                        title: findLorryController.lorryData.findLorryData[findLorryController.selectVehicle].lorrydata[index].lorryTitle,
                                                        dropLat: findLorryController.dropUpLat!,
                                                        dropLng: findLorryController.dropUpLng!,
                                                        pickLat: findLorryController.picUpLat!,
                                                        pickLng: findLorryController.picUpLng!,
                                                        dropStateId: findLorryController.dropUpStatId!,
                                                        dropPoint: dropDownController.text,
                                                        pickStateId: findLorryController.pickUpStatId!,
                                                        pickupPoint: pickUpController.text,
                                                        lorryId: findLorryController.lorryData.findLorryData[findLorryController.selectVehicle].lorrydata[index].lorryId,
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    "Book Now".tr,
                                                    style: TextStyle(
                                                      color: whiteColor,
                                                      fontSize: 14,
                                                      fontFamily: "urbani_extrabold",
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                                subtitle: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/ic_star_profile.svg",
                                                      width: 16,
                                                      height: 16,
                                                      color: priMaryColor,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Transform.translate(
                                                      offset:  Offset(0, 1),
                                                      child: Text(
                                                        findLorryController.lorryData.findLorryData[findLorryController.selectVehicle].lorrydata[index].review,
                                                        style: TextStyle(
                                                          color: priMaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(height: 20);
                                    },
                                    itemCount: findLorryController.lorryData.findLorryData[findLorryController.selectVehicle].lorrydata.length,
                                  ),
                                ],
                              ),
                            )
                      : SizedBox(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    SizedBox(height: 12),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            blurStyle: BlurStyle.outer,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
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
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/ic_pickup_map.svg",
                                      width: 24,
                                      height: 24,
                                    ),
                                    Expanded(child: pickUpPoint()),
                                    findLorryController.isPickUp
                                        ? SvgPicture.asset(
                                            "assets/icons/exclamation-circle.svg",
                                            width: 24,
                                            height: 24,
                                            color: Colors.red,
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                                Divider(color: Colors.grey.withOpacity(0.3), height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/ic_pickup_map.svg",
                                      width: 24,
                                      height: 24,
                                    ),
                                    Expanded(child: dropPoint()),
                                    findLorryController.isDropPoint
                                        ? SvgPicture.asset(
                                            "assets/icons/exclamation-circle.svg",
                                            width: 24,
                                            height: 24,
                                            color: Colors.red,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              findLorryController.isLoading
                                  ? SpinKitThreeBounce(
                                      color: priMaryColor,
                                      size: 25.0,
                                    )
                                  : Expanded(
                                      child: commonButton(
                                        title: "Search".tr,
                                        onTapp: () {
                                          if (dropDownController.text.isNotEmpty && pickUpController.text.isNotEmpty) {
                                            findLorryController.setIsLoading(true);
                                            ApiProvider().checkStat(
                                              pickUpName: findLorryController.picUpState!,
                                              dropStateName: findLorryController.dropPoint!,
                                            ).then((value) {
                                              var decode = value;
                                              if (decode["Result"] == "true") {
                                                findLorryController.setPickUpStatId(decode["pick_state_id"]);
                                                findLorryController.setDropUpStatId(decode["drop_state_id"]);
                                                findLorryController.setIsLoading(true);
                                                ApiProvider().findLorry(
                                                  uid: homePageController.userData.id,
                                                  pickStateId: decode["pick_state_id"],
                                                  dropStateId: decode["drop_state_id"],
                                                ).then((value) {
                                                  findLorryController.setDataInList(FindLorryModel.fromJson(value));
                                                  findLorryController.setIsLoading(false);
                                                  findLorryController.setIsShowData(true);
                                                });
                                              } else {
                                                if (decode["drop_state_id"] == "0") {
                                                  setState(() {
                                                    dropDownController.text = "";
                                                  });
                                                }
                                                if (decode["pick_state_id"] == "0") {
                                                  setState(() {
                                                    pickUpController.text = "";
                                                  });
                                                }
                                                findLorryController.setIsLoading(false);
                                                snakbar(decode["ResponseMsg"], context);
                                              }
                                            });
                                          }
                                        },
                                      ),
                                    ),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  rcVerified(String id) {
    switch (id) {
      case "1":
        return "assets/icons/badge-check.svg";

      case "2":
        return "assets/icons/ic_unverified.svg";
    }
  }

  TextEditingController pickUpController = TextEditingController();

  TextEditingController dropDownController = TextEditingController();

  dropPoint() {
    return GooglePlaceAutoCompleteTextField(
      textStyle: TextStyle(
        fontSize: 17,
        fontFamily: fontFamilyRegular,
        color: textBlackColor,
      ),
      boxDecoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
      ),
      textEditingController: dropDownController,
      googleAPIKey: gkey,
      inputDecoration: InputDecoration(
        hintText: "Drop Point".tr,
        hintStyle: TextStyle(
          fontSize: 17,
          fontFamily: fontFamilyRegular,
          color: textGreyColor,
        ),
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
      debounceTime: 400,
      getPlaceDetailWithLatLng: (Prediction prediction) {
        getAddressFromLatLong(prediction.lat, prediction.lng).then((value) {
          setState(() {
            findLorryController.dropPoint = value;
            print("DROP ____-----$value");
          });
        });
        setState(() {
          findLorryController.dropUpLat = prediction.lat;
          findLorryController.dropUpLng = prediction.lng;
        });
      },
      itemClick: (Prediction prediction) {
        findLorryController.setIsDropPoint(false);
        dropDownController.text = prediction.description ?? "";
        dropDownController.selection = TextSelection.fromPosition(
          TextPosition(offset: prediction.description?.length ?? 0),
        );
      },
      itemBuilder: (context, index, Prediction prediction) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 7),
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
      boxDecoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
      ),
      textEditingController: pickUpController,
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
        getAddressFromLatLong(prediction.lat, prediction.lng).then((value) {
          setState(() {
            findLorryController.picUpState = value;
          });
        });
        setState(() {
          findLorryController.picUpLat = prediction.lat;
          findLorryController.picUpLng = prediction.lng;
        });
      },

      itemClick: (Prediction prediction) {
        findLorryController.setIsPickUp(false);
        pickUpController.text = prediction.description ?? "";
        pickUpController.selection = TextSelection.fromPosition(
          TextPosition(offset: prediction.description?.length ?? 0),
        );
      },

      itemBuilder: (context, index, Prediction prediction) {
        return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(Icons.location_on),
              SizedBox(width: 7),
              Expanded(child: Text(prediction.description ?? ""))
            ],
          ),
        );
      },
      isCrossBtnShown: false,
    );
  }
}
