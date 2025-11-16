// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../AppConstData/app_colors.dart';
import '../../AppConstData/routes.dart';
import '../../Controllers/homepage_controller.dart';
import '../../Controllers/manage_page.dart';
import '../Api_Provider/imageupload_api.dart';
import '../../widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageController homePageController = Get.put(HomePageController());

  @override
  void initState() {
    super.initState();
    homePageController.getDataFromLocalData().then((value) {
      if (value.toString().isNotEmpty) {
        // OneSignal.User.addTags({"userid": homePageController.userData.id,});
        homePageController.getHomePageData(uid: homePageController.userData.id);
      }
      homePageController.setIcon(homePageController.verification12(homePageController.userData.isVerify));
      ManagePageCalling().setLogin(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(
      builder: (homePageController) {
        if (homePageController.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () {
              return Future.delayed(
                const Duration(seconds: 1),
                () {
                  homePageController.updateUserProfile(context);
                },
              );
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: AppBar(
                  toolbarHeight: 80,
                  backgroundColor: priMaryColor,
                  elevation: 0,
                  titleSpacing: 0,
                  title: Column(
                    children: [
                      ListTile(
                        dense: true,
                        leading: homePageController.userData.proPic.toString().isNotEmpty
                            ? CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(
                                  "$basUrl${homePageController.userData.proPic}",
                                ),
                                radius: 25,
                                child: Image.network(
                                  "$basUrl${homePageController.userData.proPic}",
                                  color: Colors.transparent,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return commonSimmer(height: 50, width: 50);
                                  },
                                  loadingBuilder: (context, child, loadingProgress) {
                                    return (loadingProgress == null)
                                        ? child
                                        : commonSimmer(height: 50, width: 50);
                                  },
                                ))
                            : const CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: AssetImage("assets/image/05.png"),
                                radius: 25,
                              ),
                        trailing: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.notification);
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.1),
                            radius: 20,
                            child: SvgPicture.asset(
                              "assets/icons/notification.svg",
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                        title: Transform.translate(
                          offset: const Offset(0, -5),
                          child: Text(
                            "Hello..".tr,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontFamily: "urbani_regular",
                            ),
                          ),
                        ),
                        subtitle: Text(
                          homePageController.userData.name.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontFamily: "urbani_extrabold",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: priMaryColor,
                            ),
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Become world’s Transporter".tr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 32,
                                    color: Color(0xffFFF500),
                                    fontFamily: "urbani_extrabold",
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        homePageController.homePageData.homeData!.topMsg ?? "",
                                        style: const TextStyle(
                                          fontFamily: "urbani_extrabold",
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Transform.translate(
                                      offset: const Offset(0, -1),
                                      child: SvgPicture.asset(
                                        homePageController.verification!,
                                        height: 18,
                                        width: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Flexible(
                                      child: InkWell(
                                        onTap: () {
                                          if (homePageController.userData.isVerify == "2") {
                                            Get.toNamed(Routes.postLoads);
                                          } else if (homePageController.userData.isVerify == "1") {
                                            snakbar("verification Under Process", context);
                                          } else {
                                            Get.toNamed(Routes.verifyIdentity);
                                          }
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 125,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(0.8),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/Group.svg",
                                                height: 20,
                                                width: 20,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 8),
                                              Flexible(
                                                child: Transform.translate(
                                                  offset: const Offset(0, 1),
                                                  child: Text(
                                                    "Post Loads".tr,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily:  "urbani_extrabold",
                                                      fontSize: 13,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: InkWell(
                                        onTap: () {
                                          if (homePageController.userData.isVerify == "2") {
                                            Get.toNamed(Routes.findLorry);
                                          } else if (homePageController.userData.isVerify == "1") {
                                            snakbar("verification Under Process", context);
                                          } else {
                                            Get.toNamed(Routes.verifyIdentity);
                                          }
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 125,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(0.8),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/ic_find_lorryf.svg",
                                                height: 20,
                                                width: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Flexible(
                                                child: Transform.translate(
                                                  offset: const Offset(0, 1),
                                                  child: Text(
                                                    "Find Lorry".tr,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: "urbani_extrabold",
                                                      fontSize: 13,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: carousel.CarouselSlider(
                        options: carousel.CarouselOptions(
                          aspectRatio: 2.0,
                          height: 200,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          viewportFraction: 1,
                          autoPlay: true,
                        ),
                        items: [
                          for (int a = 0; a < homePageController.homePageData.homeData!.banner!.length; a++)
                            homePageController.homePageData.homeData!.banner![a].img!.isEmpty
                                ? SizedBox(
                                    width: Get.width,
                                    height: 100.0,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      enabled: true,
                                      child: Container(
                                        height: 200,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      "$basUrl${homePageController.homePageData.homeData!.banner![a].img}",
                                      fit: BoxFit.cover,
                                      width: Get.width,
                                      errorBuilder: (context, error, stackTrace) {
                                        return commonSimmer(height: 200, width: Get.width);
                                      },
                                      loadingBuilder: (context, child, loadingProgress) {
                                        return (loadingProgress == null)
                                            ? child
                                            : commonSimmer(height: 200, width: Get.width);
                                      },
                                    ),
                                  ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Operating Routes".tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "urbani_extrabold",
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GridView.builder(
                        itemCount: homePageController.homePageData.homeData!.statelist!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisExtent: 150,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                  "$basUrl${homePageController.homePageData.homeData!.statelist![index].img}",
                                  width: 72,
                                  height: 72,
                                  color: secondaryColor.withOpacity(0.4),
                                  errorBuilder: (context, error, stackTrace) {
                                    return commonSimmer(height: 65, width: 65);
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    return (loadingProgress == null)
                                        ? child
                                        : commonSimmer(height: 65, width: 65);
                                  },
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      homePageController.homePageData.homeData!.statelist![index].title ?? "",
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: textBlackColor,
                                        fontFamily: "urbani_extrabold",
                                        fontWeight: FontWeight.w700,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/Group.svg",
                                      height: 14,
                                      width: 14,
                                      color: textGreyColor,
                                    ),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Transform.translate(
                                        offset: const Offset(0, 1),
                                        child: Text(
                                          "${homePageController.homePageData.homeData!.statelist![index].totalLoad} Load",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: textGreyColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/ic_find_lorryf.svg",
                                      height: 14,
                                      width: 14,
                                      color: textGreyColor,
                                    ),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Transform.translate(
                                        offset: const Offset(0, 1),
                                        child: Text(
                                          "${homePageController.homePageData.homeData!.statelist![index].totalLorry} Lorry",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: textGreyColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
