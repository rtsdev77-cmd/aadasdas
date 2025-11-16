import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../AppConstData/app_colors.dart';
import '../../AppConstData/routes.dart';
import '../../Controllers/walletscreen_controller.dart';

import '../../AppConstData/typography.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  WalletScreenController walletScreenController = Get.put(WalletScreenController());
  String currency = "\$";

  @override
  void dispose() {
    super.dispose();
    walletScreenController.istrue = false;
  }

  @override
  void initState() {
    super.initState();
    walletScreenController.getDataFromLocal().then((value) {
      walletScreenController.fetChDataFromApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletScreenController>(
      builder: (walletScreenController) {
        return RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () {
              walletScreenController.fetChDataFromApi();
            });
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: priMaryColor,
              centerTitle: true,
              actions: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.addWallet);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: priMaryColor,
                                  child: Text(
                                    "+",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Add".tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: textBlackColor,
                                    fontFamily: fontFamilyBold,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
              ],
              title: Text(
                "Wallet".tr,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: fontFamilyBold,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            body: walletScreenController.istrue
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 220,
                                      color: priMaryColor,
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    height: Get.height * 0.82,
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 5,
                                          blurStyle: BlurStyle.outer,
                                        )
                                      ],
                                    ),
                                    child: SingleChildScrollView(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: 195,
                                                  padding: EdgeInsets.all(15),
                                                  decoration: BoxDecoration(
                                                    color: secondaryColor,
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            'Total Earning'.tr,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: fontFamilyBold,
                                                            ),
                                                          ),
                                                          SizedBox(height: 8),
                                                          Text(
                                                            "${walletScreenController.currency}${walletScreenController.walletModel.wallet}".tr,
                                                            style: TextStyle(
                                                              fontSize: 24,
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: fontFamilyBold,
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          Text(
                                                            'E-Wallet'.tr,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w400,
                                                              fontFamily: fontFamilyRegular,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 32,
                                                              backgroundColor: Colors.white,
                                                              child: Transform.translate(
                                                                offset: Offset(1, 3),
                                                                child: Center(
                                                                  child: SvgPicture.asset(
                                                                    "assets/icons/walleticon.svg",
                                                                    width: 30,
                                                                    height: 30,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          Text(
                                            "Transaction History".tr,
                                            style: Typographyy.headLine.copyWith(color: textBlackColor,fontSize: 20),
                                          ),
                                          walletScreenController.walletModel.walletitem.isNotEmpty
                                              ? ListView.builder(
                                                  physics: NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemBuilder: (context, index) {
                                                    return ListTile(
                                                      dense: true,
                                                      title: Text(
                                                        walletScreenController.walletModel.walletitem[index].message,
                                                      ),
                                                      subtitle: Text(
                                                        walletScreenController.walletModel.walletitem[index].tdate,
                                                      ),
                                                      trailing: Text(
                                                        "${walletScreenController.walletModel.walletitem[index].status.compareTo("Credit") == 0 ? "+" : "-"}$currency${walletScreenController.walletModel.walletitem[index].amt}",
                                                        style: TextStyle(
                                                          color: walletScreenController.walletModel.walletitem[index].status.compareTo("Credit") == 0
                                                              ? Colors.green
                                                              : Colors.red,
                                                        ),
                                                      ),
                                                      leading: CircleAvatar(
                                                        backgroundColor: Colors.transparent,
                                                        child: SvgPicture.asset(
                                                          "assets/icons/wallet0.svg",
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  itemCount: walletScreenController.walletModel.walletitem.length,
                                                )
                                              : Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const SizedBox(height: 20),
                                                    SvgPicture.asset(
                                                      "assets/image/54.svg",
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      "You haven't made any transaction using wallet yet".tr,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: textGreyColor,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: "urbani_regular",
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            walletScreenController.isLoading
                                ? const CircularProgressIndicator()
                                : const SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
