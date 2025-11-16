// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../AppConstData/app_colors.dart';
import '../../AppConstData/typography.dart';
import '../../Controllers/profile_detils_controller.dart';
import '../Api_Provider/imageupload_api.dart';

import '../Api_Provider/api_provider.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  final String ownerId;
  final String lorryId;

  const ProfileScreen({
    super.key,
    required this.uid,
    required this.ownerId,
    required this.lorryId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileDetilsController profileController = Get.put(ProfileDetilsController());

  @override
  void initState() {
    super.initState();
    debugPrint("=========== uid ========== ${widget.uid}");
    debugPrint("========= ownerId ======== ${widget.ownerId}");
    debugPrint("========= lorryId ======== ${widget.lorryId}");
    ApiProvider().lorryOwnerProfile(uid: widget.uid, ownerId: widget.ownerId, lorryId: widget.lorryId).then((value) {
      profileController.setProfileData(value);
      profileController.setIsLoading(false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    profileController.isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileDetilsController>(
      builder: (reviewController) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: priMaryColor,
            centerTitle: true,
            title: Text(
              "Profile".tr,
              style: TextStyle(
                fontSize: 18,
                fontFamily: fontFamilyBold,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: reviewController.isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          Transform.translate(
                            offset: Offset(0, -15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SvgPicture.asset(
                                    "assets/image/Ellipse 80.svg",
                                    fit: BoxFit.fitWidth,
                                    color: priMaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: -20,
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                      "$basUrl${reviewController.profileData!.lorrizprofile.proPic}",
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 2,
                                  right: 15,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.white,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/icons/badge-check.svg",
                                        width: 16,
                                        height: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Text(
                        reviewController.profileData!.lorrizprofile.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: fontFamilyBold,
                          fontSize: 18,
                          color: textBlackColor,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/ic_star_profile.svg",
                            height: 20,
                            width: 20,
                            color: priMaryColor,
                          ),
                          SizedBox(width: 8),
                          Transform.translate(
                            offset: Offset(0, 2),
                            child: Text(
                              reviewController.profileData!.lorrizprofile.review,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: fontFamilyBold,
                                color: priMaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 75,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: textGreyColor.withOpacity(0.5),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Date of Joining".tr,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: fontFamilyRegular,
                                            color: textGreyColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          reviewController.profileData!.lorrizprofile.rdate.toString().split(" ").first,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: fontFamilyRegular,
                                            color: textBlackColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Load".tr,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: fontFamilyRegular,
                                            color: textGreyColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          reviewController.profileData!.lorrizprofile.totalLorry.toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: fontFamilyRegular,
                                            color: textBlackColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Total Review".tr,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: fontFamilyRegular,
                                            color: textGreyColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          reviewController.profileData!.lorrizprofile.totalReview.toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: fontFamilyRegular,
                                            color: textBlackColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      reviewController.profileData!.lorrizprofile.totalRoutes.isNull
                          ? SizedBox()
                          : Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Route Operation".tr,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontFamily: fontFamilyBold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: SizedBox(
                                    height: 100,
                                    width: Get.width,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return SizedBox(
                                          width: 80,
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 60,
                                                width: 60,
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.grey.withOpacity(0.4),
                                                  ),
                                                ),
                                                child: Image.network(
                                                  "$basUrl${reviewController.profileData!.lorrizprofile.totalRoutes[index].toString().split(",").last}",
                                                  color: priMaryColor.withOpacity(0.4),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                reviewController.profileData!.lorrizprofile.totalRoutes[index].toString().split(",").first,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: fontFamilyBold,
                                                  color: textBlackColor,
                                                ),
                                                overflow:TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return SizedBox(width: 5);
                                      },
                                      itemCount: reviewController.profileData!.lorrizprofile.totalRoutes.length,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/ic_star_profile.svg",
                              height: 20,
                              width: 20,
                              color: priMaryColor,
                            ),
                            SizedBox(width: 8),
                            Transform.translate(
                              offset: Offset(0, 2),
                              child: Text(
                                reviewController.profileData!.lorrizprofile.review,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontFamilyBold,
                                  color: textBlackColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Transform.translate(
                              offset: Offset(0, 2),
                              child: CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 5,
                              ),
                            ),
                            SizedBox(width: 8),
                            Transform.translate(
                              offset: Offset(0, 2),
                              child: Text(
                                "${reviewController.profileData!.lorrizprofile.totalReview} ${"Review".tr}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: fontFamilyBold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      reviewController.profileData!.lorrizprofile.totalReviewUserWise.isNull
                          ? SizedBox()
                          : ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.3),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.all(0),
                                    title: Text(
                                      reviewController.profileData!.lorrizprofile.totalReviewUserWise[index].customername,
                                      style: TextStyle(
                                        color: textBlackColor,
                                        fontSize: 16,
                                        fontFamily: fontFamilyBold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      reviewController.profileData!.lorrizprofile.totalReviewUserWise[index].rateText,
                                      style: TextStyle(
                                        color: textGreyColor,
                                        fontSize: 14,
                                        fontFamily: fontFamilyRegular,
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/ic_star_profile.svg",
                                          width: 20,
                                          height: 20,
                                          color: priMaryColor,
                                        ),
                                        SizedBox(width: 8),
                                        Text(reviewController.profileData!.lorrizprofile.totalReviewUserWise[index].rateNumber),
                                      ],
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage(
                                        "$basUrl${reviewController.profileData!.lorrizprofile.totalReviewUserWise[index].userImg}",
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 10);
                              },
                              itemCount: reviewController.profileData!.lorrizprofile.totalReviewUserWise.length,
                            ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
