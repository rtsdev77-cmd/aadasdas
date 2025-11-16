// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../AppConstData/app_colors.dart';
import '../../Controllers/homepage_controller.dart';
import '../../widgets/widgets.dart';
import 'package:share_plus/share_plus.dart';

import '../../AppConstData/typography.dart';

class ReferFriend extends StatefulWidget {
  const ReferFriend({super.key});

  @override
  State<ReferFriend> createState() => _ReferFriendState();
}

class _ReferFriendState extends State<ReferFriend> {
  HomePageController homePageController = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Refer to Friends".tr,
          style: TextStyle(
              fontSize: 18,
              fontFamily: fontFamilyBold,
              fontWeight: FontWeight.w500,
              color: Colors.black),
        ),
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: SizedBox(
                child: Center(
              child: SvgPicture.asset("assets/icons/backicon.svg",
                  color: Colors.black, width: 20, height: 20),
            ))),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SvgPicture.asset('assets/image/refer friend.svg'),
              Text(
                "Refer a Friends, Get \$50".tr,
                style: TextStyle(
                    color: textBlackColor,
                    fontSize: 18,
                    fontFamily: fontFamilyBold,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Get \$10 in Credit When Someone Sing Up Using Your Referal Link".tr,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: textGreyColor,
                    fontFamily: fontFamilyRegular),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Expanded(
                      child: commonButton(
                    title: "Share".tr,
                    onTapp: () {
                      Share.share(
                        'Hey! Now use our app to share with your family or friends. User will get wallet amount on your 1st successful trip. Enter my referral code ${homePageController.userData.code} & Enjoy your trip !!!https://play.google.com/store/apps/details?id=com.cscodetech.movers',
                      );
                    },
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
