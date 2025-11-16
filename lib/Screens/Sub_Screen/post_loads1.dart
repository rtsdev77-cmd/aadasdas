// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/homepage_controller.dart';
import '../Api_Provider/imageupload_api.dart';
import 'post_loads2.dart';
import '../../widgets/widgets.dart';
import '../../AppConstData/app_colors.dart';
import '../../AppConstData/typography.dart';
import '../../Controllers/postloads1_controller.dart';
import '../Api_Provider/api_provider.dart';

class PostLoads1 extends StatefulWidget {
  final String description;
  final String dropLat;
  final String dropLng;
  final String dropPoint;
  final String dropStateId;
  final String materialName;
  final String pickLat;
  final String pickLng;
  final String pickStateId;
  final String pickupPoint;
  final String weight;
  const PostLoads1({
    super.key,
    required this.description,
    required this.dropLat,
    required this.dropLng,
    required this.dropPoint,
    required this.dropStateId,
    required this.materialName,
    required this.pickLat,
    required this.pickLng,
    required this.pickStateId,
    required this.pickupPoint,
    required this.weight,
  });

  @override
  State<PostLoads1> createState() => _PostLoads1State();
}

class _PostLoads1State extends State<PostLoads1> {
  HomePageController homePageController = Get.put(HomePageController());
  PostLoads1Controller postLoads1Controller = Get.put(PostLoads1Controller());
  @override
  void initState() {
    super.initState();
    setState(() {
      postLoads1Controller.selectVehicle = -1;
    });
    ApiProvider().getVehicleList(uid: homePageController.userData.id)
        .then((value) {
      postLoads1Controller.getDataFromApi(value: value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostLoads1Controller>(builder: (postLoads1Controller) {
      return WillPopScope(
        onWillPop: () async {
          postLoads1Controller.selectVehicle = -1;
          // Get.back();
          return true;
        },
        child: Scaffold(
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
                                border: Border.all(color: Colors.white70),
                                shape: BoxShape.circle),
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
                          const SizedBox(width: 8),
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
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white70),
                                shape: BoxShape.circle),
                            child: Center(
                                child: Text("2",
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
                                    color: Colors.white70,
                                    thickness: 1.5,
                                  ))),
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
                      SizedBox(height: 12),
                      Container(
                        width: Get.width,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select Vehicle".tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: textBlackColor,
                                fontFamily: fontFamilyBold,
                              ),
                            ),
                            SizedBox(height: 10),
                            postLoads1Controller.isLoading
                                ? GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 5,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisExtent: 100,
                                      crossAxisSpacing: 10,
                                    ),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: commonSimmer(height: 100, width: 100),
                                      );
                                    },
                                  )
                                : GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: postLoads1Controller.vehicleList.vehicleData.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisExtent: 100,
                                      crossAxisSpacing: 10,
                                    ),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          if (int.parse(postLoads1Controller.vehicleList.vehicleData[index].maxWeight) >= int.parse(widget.weight)) {
                                            postLoads1Controller.vehicleID = postLoads1Controller.vehicleList.vehicleData[index].id;
                                            postLoads1Controller.setSelectVehicle(index);
                                          } else {
                                            snakbar("It is not possible to choose a larry with a your load capacity".tr, context);
                                          }
                                        },
                                        child: Container(
                                          height: 120,
                                          width: 150,
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: postLoads1Controller.selectVehicle == index
                                                  ? priMaryColor.withOpacity(0.05)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: postLoads1Controller.selectVehicle == index
                                                      ? priMaryColor
                                                      : Colors.grey.withOpacity(0.3))),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Row(children: [
                                            Image.network(
                                              "$basUrl${postLoads1Controller.vehicleList.vehicleData[index].img}",
                                              height: 65,
                                              width: 65,
                                              errorBuilder: (context, error, stackTrace) {
                                                return commonSimmer(height: 58, width: 58);
                                              },
                                              loadingBuilder: (context, child, loadingProgress) {
                                                return (loadingProgress == null)
                                                    ? child
                                                    : commonSimmer(height: 58, width: 58);
                                              },
                                            ),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    postLoads1Controller.vehicleList.vehicleData[index].title,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: fontFamilyBold,
                                                      color: textBlackColor,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    "${postLoads1Controller.vehicleList.vehicleData[index].minWeight} - ${postLoads1Controller.vehicleList.vehicleData[index].maxWeight} ${"Tonnes".tr}",
                                                    style: TextStyle(
                                                      color: textBlackColor,
                                                      fontSize: 11,
                                                      fontFamily: fontFamilyRegular,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ]),
                                        ),
                                      );
                                    },
                                  ),
                            SizedBox(height: 1),
                            Row(
                              children: [
                                Expanded(
                                    child: commonButton(
                                  title: "Next".tr,
                                  onTapp: () {
                                    print("widget.pickLng ?? ${widget.dropLng}");
                                    if (postLoads1Controller.vehicleID != null) {
                                      if (postLoads1Controller.vehicleID!.isNotEmpty && postLoads1Controller.selectVehicle != -1) {
                                        Get.to(PostLoads2(
                                          uid: homePageController.userData.id,
                                          description: widget.description,
                                          dropLat: widget.dropLat,
                                          dropLng: widget.dropLng,
                                          dropPoint: widget.dropPoint,
                                          dropStateId: widget.dropStateId,
                                          materialName: widget.materialName,
                                          pickLat: widget.pickLat,
                                          pickLng: widget.pickLng,
                                          pickStateId: widget.pickStateId,
                                          pickupPoint: widget.pickupPoint,
                                          vehicleId: postLoads1Controller.vehicleID!,
                                          weight: widget.weight,
                                        ));
                                      } else {
                                        snakbar("Select Vehicle".tr, context);
                                      }
                                    } else {
                                      snakbar("Select Vehicle".tr, context);
                                    }
                                  },
                                )),
                              ],
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
