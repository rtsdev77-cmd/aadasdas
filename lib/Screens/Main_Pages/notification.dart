// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../AppConstData/app_colors.dart';
import '../../AppConstData/typography.dart';
import '../../Controllers/homepage_controller.dart';
import '../Models/notification_model.dart';
import 'package:shimmer/shimmer.dart';

import '../Api_Provider/api_provider.dart';

class Notification extends StatefulWidget {
  const Notification({super.key});

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  HomePageController homePageController = Get.put(HomePageController());
  late NotificationModel notificationModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    ApiProvider()
        .notification(uid: homePageController.userData.id)
        .then((value) {
      setState(() {
        notificationModel = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: SizedBox(
            height: 24,
            width: 24,
            child: Center(
              child: SvgPicture.asset(
                "assets/icons/chevron-left.svg",
                width: 22,
                height: 22,
                color: textBlackColor,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          "Notification".tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: "urbani_extrabold",
            color: textBlackColor,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              isLoading
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.black45,
                          highlightColor: Colors.grey.shade100,
                          enabled: true,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            height: 80,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    )
                  : notificationModel.notificationData.isEmpty
                      ? IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/image/54.svg"),
                          ],
                        ),
                      )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: notificationModel.notificationData.length,
                          shrinkWrap: true,
                          reverse: true,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      notificationModel.notificationData[index].title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: textBlackColor,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: fontFamilyBold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Flexible(
                                    child: Text(
                                      notificationModel.notificationData[index].description,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: textGreyColor,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: fontFamilyRegular,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  // const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        notificationModel.notificationData[index].datetime.toString().split(" ").first,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: textBlackColor,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: fontFamilyRegular,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
