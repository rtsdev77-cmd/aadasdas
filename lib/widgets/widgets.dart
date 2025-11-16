// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bkash/flutter_bkash.dart';
// import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../Controllers/postloads1_controller.dart';
import '../Screens/Api_Provider/api_provider.dart';
import 'package:shimmer/shimmer.dart';
import '../AppConstData/app_colors.dart';
import '../AppConstData/typography.dart';
import '../Screens/Api_Provider/imageupload_api.dart';
import '../Screens/Payment_methods/paypal/flutter_paypal.dart';

commonButton({required String title, required VoidCallback onTapp}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        fixedSize: const Size.fromHeight(48),
        backgroundColor: priMaryColor,
      ),
      onPressed: onTapp,
      child: Text(
        title.tr,
        style: TextStyle(
          color: whiteColor,
          fontSize: 16,
          fontFamily: "urbani_extrabold",
          fontWeight: FontWeight.w700,
        ),
      ),
    );
}

commonBg() {
  return Column(
    children: [
      Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: Get.height,
            width: Get.width,
            color: priMaryColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: Get.width,
                    ),
                    Image.asset("assets/image/Rectangle 39456.png",
                        height: 650, width: 220),
                    Positioned(
                        top: 10,
                        right: 020,
                        child: Image.asset("assets/image/Rectangle 39457.png",
                            height: 650, width: 220)),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 70,
            child: SvgPicture.asset(
              "assets/logo/Group 427320347.svg",
              height: 40,
              width: 120,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ],
  );
}

commonTextField(
    {required TextEditingController controller,
    required String hintText,
    required TextInputType keyBordType,
    bool? isValide,
    void Function(String)? onTap}) {
  return TextField(
    onChanged: onTap,
    style: TextStyle(
        color: textBlackColor, fontFamily: "urbani_regular", fontSize: 16),
    controller: controller,
    keyboardType: keyBordType,
    decoration: InputDecoration(
      hintStyle: TextStyle(
          color: textGreyColor, fontFamily: "urbani_regular", fontSize: 14),
      hintText: hintText.tr,
      suffixIcon: isValide.isNull
          ? const SizedBox()
          : isValide!
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: Center(
                      child: SvgPicture.asset(
                    "assets/icons/alert-circle.svg",
                    color: Colors.red,
                    height: 22,
                    width: 22,
                  )))
              : const SizedBox(),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textGreyColor)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textGreyColor)),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textGreyColor)),
    ),
  );
}

commonTextField2(
    {required String hintText,
    required String icon,
    required TextEditingController controller,
    required TextInputType keyBordType,
    required bool isValidate}) {
  return GetBuilder<PostLoads1Controller>(builder: (postLoads1Controller) {
    return TextField(
      onChanged: (value) {},
      keyboardType: keyBordType,
      controller: controller,
      style: TextStyle(
          fontSize: 17, fontFamily: fontFamilyRegular, color: textBlackColor),
      decoration: InputDecoration(
        hintText: hintText.tr,
        suffixIcon: postLoads1Controller.isMaterialName
            ? SizedBox(
                height: 20,
                width: 20,
                child: Center(
                    child: SvgPicture.asset(
                        "assets/icons/exclamation-circle.svg",
                        color: Colors.red)))
            : const SizedBox(),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        hintStyle: TextStyle(
            fontSize: 17, fontFamily: fontFamilyRegular, color: textGreyColor),
        prefixIcon: SizedBox(
            height: 20,
            width: 20,
            child: Center(child: SvgPicture.asset(icon))),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  });
}

showCommonToast({required String msg}) {
  Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_SHORT);
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snakbar(
    String title, context) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(title),
  ));
}

commonDetils({
  required String vehicleImg,
  required String vehicleTitle,
  required String currency,
  required String amount,
  required String amtType,
  required String totalAmt,
  required String pickupState,
  required String pickupPoint,
  required String dropState,
  required String dropPoint,
  required String postDate,
  required String weight,
  required String materialName,
}) {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.withOpacity(0.3)),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Image.network("$basUrl$vehicleImg", height: 55, width: 55),
            const SizedBox(width: 8),
            Text(vehicleTitle,
              style: TextStyle(
                fontSize: 14,
                fontFamily: fontFamilyRegular,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            Column(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "$currency$amount",
                        style: TextStyle(
                          color: textBlackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: fontFamilyBold,
                        ),
                      ),
                      TextSpan(
                        text: " /$amtType",
                        style: TextStyle(
                          color: textGreyColor,
                          fontSize: 10,
                          fontFamily: fontFamilyRegular,
                        ),
                      ),
                    ],
                  ),
                ),
                amtType.compareTo("Fixed") == 0
                    ? const SizedBox()
                    : Text("$currency$totalAmt"),
              ],
            ),
          ],
        ),
        Divider(
          color: Colors.grey.withOpacity(0.3),
          height: 40,
        ),
        for(var i = 0; i <= 1; i++)
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                i == 0 
                ? "assets/icons/ic_current_long.svg"
                : "assets/icons/ic_destination_long.svg",
                height: 30, width: 30,
              ),
              SizedBox(width: 15),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      i == 0
                      ? pickupState
                      : dropState,
                      style: TextStyle(
                        fontSize: 18,
                        color: textBlackColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: fontFamilyBold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      i == 0
                      ? pickupPoint
                      : dropPoint,
                      style: TextStyle(
                        color: textGreyColor, fontFamily: fontFamilyRegular,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  "Date".tr,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: fontFamilyRegular,
                      color: textGreyColor),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  postDate.toString().split(" ").first,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: fontFamilyBold,
                      color: textBlackColor),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "Tonnes".tr,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: fontFamilyRegular,
                      color: textGreyColor),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  weight,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: fontFamilyBold,
                      color: textBlackColor),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "Material".tr,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: fontFamilyRegular,
                      color: textGreyColor),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  materialName,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: fontFamilyBold,
                      color: textBlackColor),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

commonSimmer({
  required double height,
  required double width,
}) {
  return Shimmer.fromColors(
    baseColor: Colors.black45,
    highlightColor: Colors.grey.shade100,
    enabled: true,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [],
      ),
    ),
  );
}

//!- - - - - PayStack - - - - - !//
// void chargeCard({
//   required int amount,
//   required String email,
//   required VoidCallback ontap,
//   required PaystackPlugin plugin,
//   required BuildContext context,
// }) async {
//   // Close any open modal/dialog (optional)
//   Get.back();
//
//   final charge = Charge()
//     ..amount = amount * 100 // Paystack requires amount in kobo
//     ..reference = getReference()
//     ..putCustomField('custom_id', '846gey6w')
//     ..email = email;
//
//   try {
//     final response = await plugin.checkout(
//       context,
//       method: CheckoutMethod.card,
//       charge: charge,
//       fullscreen: false, // Optional: Use fullscreen or not
//     );
//
//     if (response.status == true) {
//       ontap(); // Call your success handler
//     } else {
//       showCommonToast(msg: 'Payment Failed!!!'.tr);
//     }
//   } catch (e) {
//     showCommonToast(msg: 'An error occurred during payment.');
//     debugPrint('Paystack Error: $e');
//   }
// }

String getReference() {
  var platform = (Platform.isIOS) ? 'iOS' : 'Android';
  final thisDate = DateTime.now().millisecondsSinceEpoch;
  return 'ChargedFrom${platform}_$thisDate';
}

//!- - - - - PayPal - - - - - !//
paypalPayment({
  required String amt,
  required String key,
  required String secretKey,
  required Function onSuccess,
  required BuildContext context,
}) {
  Get.back();
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) {
        return UsePaypal(
          sandboxMode: true,
          clientId: key,
          secretKey: secretKey,
          returnURL: "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-35S7886705514393E",
          cancelURL: "$basUrl/paypal/cancle.php",
          transactions: [
            {
              "amount": {
                "total": amt,
                "currency": "USD",
                "details": {
                  "subtotal": amt,
                  "shipping": '0',
                  "shipping_discount": 0
                }
              },
              "description": "The payment transaction description.",
              // "payment_options": {
              //   "allowed_payment_method":
              //       "INSTANT_FUNDING_SOURCE"
              // },
              "item_list": {
                "items": [
                  {
                    "name": "A demo product",
                    "quantity": 1,
                    "price": amt,
                    "currency": "USD"
                  }
                ],
                // shipping address is not required though
                // "shipping_address": {
                //   "recipient_name": "Jane Foster",
                //   "line1": "Travis County",
                //   "line2": "",
                //   "city": "Austin",
                //   "country_code": "US",
                //   "postal_code": "73301",
                //   "phone": "+00000000",
                //   "state": "Texas"
                // },
              }
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: onSuccess,
          onError: (error) {
            showCommonToast(msg: error.toString());
            debugPrint("========== error ============ $error");
          },
          onCancel: (params) {
            showCommonToast(msg: params.toString());
            debugPrint("========== params ============ $params");
          },
        );
        // return SizedBox();
      },
    ),
  );
}

//!- - - - - SslCommerz - - - - - !//
Future<void> sslCommerzGeneralCall({
    required String tranId,
    required double amount,
    required Function successfull,
  }) async {
    debugPrint("=========== tranId =========== $tranId");
    debugPrint("=========== amount =========== $amount");
  Sslcommerz sslcommerz = Sslcommerz(
    initializer: SSLCommerzInitialization(
      //Use the ipn if you have valid one, or it will fail the transaction.
      ipn_url: "www.ipnurl.com",
      currency: SSLCurrencyType.BDT,
      product_category: "transport export",
      sdkType: SSLCSdkType.TESTBOX,
      store_id: "cscod6242b3f49944d",
      store_passwd: "cscod6242b3f49944d@ssl",
      total_amount: amount,
      tran_id: tranId,
      multi_card_name: "",
    ),
  );

  try {
    SSLCTransactionInfoModel result = await sslcommerz.payNow();

    if (result.status!.toLowerCase() == "failed") {
      Get.back();
      showCommonToast(msg: "Transaction is Failed....");
    } else if (result.status!.toLowerCase() == "closed") {
      Get.back();
      showCommonToast(msg: "SDK Closed by User");
    } else {
      if (result.status!.toUpperCase() == "VALID") {
        ApiProvider().sslcommerz(valId: result.valId!).then((value) {
          if (value["status"] == "VALIDATED") {
            successfull();
            showCommonToast(msg: "Transaction is ${result.status} and Amount is ${result.amount}");
          }
        });
      } else {
        showCommonToast(msg: "Transaction is ${result.status} and Amount is ${result.amount}");
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}


// ! - - - - - - - - -  Bkash - - - - - - - - - !//
Future<void> bkashPaymentMethode(
  context, 
  {
  required String amount,
  required Function(String trxId) onSuccess,
  required Function(String error) onFailure,
}) async {
  try {
    final bkash = FlutterBkash(
      bkashCredentials: BkashCredentials(
        isSandbox: true, // Set false for production
        username: "sandboxTokenizedUser02",
        password: "sandboxTokenizedUser02@12345",
        appKey: "4f6o0cjiki2rfm34kfdadl1eqq",
        appSecret: "2is7hdktrekvrbljjh44ll3d9l1dtjo4pasmjvs5vl5qr3fug4b",
      ),
    );

    final result = await bkash.pay(
      context: context, // Provide your BuildContext
      amount: double.parse(amount),
      merchantInvoiceNumber: "Invoice123456",
    );

    // if (result != null && result.trxId.isNotEmpty) {
    if (result.trxId.isNotEmpty) {
      onSuccess(result.trxId);
    } else {
      onFailure("Transaction failed");
    }
  } catch (e) {
    onFailure(e.toString());
  }
}


