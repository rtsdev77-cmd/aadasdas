// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../Controllers/addwallet_screen.dart';
import '../Payment_methods/flutterWave.dart';
import '../Payment_methods/senang_pay.dart';
import '../Payment_methods/strippayment_web.dart';
import '../../widgets/widgets.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../AppConstData/app_colors.dart';
import '../../AppConstData/typography.dart';
import '../../Controllers/homepage_controller.dart';
import '../../Controllers/walletscreen_controller.dart';
import '../Api_Provider/imageupload_api.dart';
import '../Api_Provider/api_provider.dart';
import '../Payment_methods/inputformat.dart';
import '../Payment_methods/paymentcard.dart';
import '../Payment_methods/paytm_payment.dart';
import '../Payment_methods/razorpayy.dart';

class AddWallet extends StatefulWidget {
  const AddWallet({super.key});

  @override
  State<AddWallet> createState() => _AddWalletState();
}

class _AddWalletState extends State<AddWallet> {
  AddWalletController addWalletController = Get.put(AddWalletController());
  HomePageController homePageController = Get.put(HomePageController());
  WalletScreenController walletScreenController = Get.put(WalletScreenController());

  bool istrue = false;
  String uid = '';
  var plugin;
  // = PaystackPlugin();
  final RazorPayClass _razorPayClass = RazorPayClass();

  @override
  void initState() {
    super.initState();
    addWalletController.priceController.clear();
    _razorPayClass.initiateRazorPay(
        handlePaymentError: handlePaymentError,
        handleExternalWallet: handleExternalWallet,
        handlePaymentSuccess: handlePaymentSuccess);
    ApiProvider().paymentMethodData().then((value) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        uid = preferences.getString("uid")!;
        addWalletController.paymentGateway = value;
        istrue = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorPayClass.desposRazorPay();
    addWalletController.selectPayment = -1;
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    paymentSuccessful();
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: ${response.code} - ${response.message!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: ${response.walletName!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddWalletController>(
      builder: (addWalletController) {
        var stack = Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: Get.width,
                  height: 220,
                  color: priMaryColor,
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Container(
                height: Get.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(15),
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter Amount".tr,
                        style: TextStyle(
                          fontSize: 18,
                          color: textBlackColor,
                          fontFamily: fontFamilyBold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 120,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: textGreyColor.withOpacity(0.5),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 30,
                                    child: TextField(
                                      controller:
                                          addWalletController.priceController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: fontFamilyRegular,
                                        fontWeight: FontWeight.w400,
                                        color: textBlackColor,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Enter Amount".tr,
                                        hintStyle: TextStyle(
                                          fontSize: 18,
                                          fontFamily: fontFamilyRegular,
                                          fontWeight: FontWeight.w400,
                                          color: textGreyColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: textGreyColor.withOpacity(0.5),
                                    height: 10,
                                  ),
                                  SizedBox(height: 10),
                                  Flexible(
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            addWalletController.setPrice(
                                              addWalletController
                                                  .staticPrice[index],
                                            );
                                          },
                                          child: Container(
                                            width: 70,
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: Text(
                                                addWalletController
                                                    .staticPrice[index],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: textBlackColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: fontFamilyRegular,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return SizedBox(width: 10);
                                      },
                                      itemCount: addWalletController.staticPrice.length,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Select Payment Gateway".tr,
                        style: TextStyle(
                          fontSize: 18,
                          color: textBlackColor,
                          fontFamily: fontFamilyBold,
                        ),
                      ),
                      SizedBox(height: 10),
                      if (istrue)
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                addWalletController.setSelectMethode(index);
                                debugPrint("=========== index ========== $index");
                              },
                              child: addWalletController.paymentGateway.paymentdata[index].pShow == "0"
                                  ? SizedBox()
                                  : Container(
                                      padding: EdgeInsets.all(10),
                                      height: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: addWalletController.selectPayment == index
                                          ? priMaryColor.withOpacity(0.05)
                                          : Colors.white,
                                        border: Border.all(
                                          color: addWalletController.selectPayment == index
                                            ? priMaryColor
                                            : Colors.grey.withOpacity(0.3),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          addWalletController.paymentGateway.paymentdata[index].img.isNotEmpty
                                              ? Container(
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        "$basUrl${addWalletController.paymentGateway.paymentdata[index].img}",
                                                      ),
                                                    ),
                                                    borderRadius: BorderRadius.circular(12),
                                                    color: Colors.grey.withOpacity(0.08),
                                                  ),
                                                )
                                              : Shimmer.fromColors(
                                                  baseColor: Colors.grey.shade200,
                                                  highlightColor: Colors.grey.shade100,
                                                  enabled: true,
                                                  child: Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.grey.withOpacity(0.5),
                                                    ),
                                                    margin: EdgeInsets.symmetric(vertical: 8),
                                                  ),
                                                ),
                                          SizedBox(width: 10),
                                          Flexible(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        addWalletController.paymentGateway.paymentdata[index].title,
                                                        style: TextStyle(
                                                          color: textBlackColor,
                                                          fontFamily: fontFamilyBold,
                                                          fontSize: 16,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                      SizedBox(height: 3),
                                                      Text(
                                                        addWalletController.paymentGateway.paymentdata[index].subtitle,
                                                        style: TextStyle(
                                                          color: textGreyColor,
                                                          fontSize: 12,
                                                          fontFamily: fontFamilyRegular,
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
                                          Radio(
                                            activeColor: priMaryColor,
                                            value: addWalletController.selectPayment == index
                                                ? true
                                                : false,
                                            groupValue: true,
                                            onChanged: (value) {
                                              addWalletController .setSelectMethode(index);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return addWalletController.paymentGateway.paymentdata[index].pShow == "0"
                              ? SizedBox()
                              : SizedBox(height: 10);
                          },
                          itemCount: addWalletController.paymentGateway.paymentdata.length,
                        )
                      else
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(10),
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: addWalletController.selectPayment == index
                                        ? priMaryColor.withOpacity(0.05)
                                        : Colors.white,
                                border: Border.all(
                                  color: addWalletController.selectPayment == index
                                          ? priMaryColor
                                          : Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade200,
                                highlightColor: Colors.grey.shade100,
                                enabled: true,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 90,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.grey.withOpacity(0.5),
                                        ),
                                        margin: EdgeInsets.symmetric(vertical: 8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                          itemCount: 5,
                        ),
                    ],
                  ),
                ),
              ),
            )
          ],
        );

        return Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: commonButton(
                    title: "Proceed".tr,
                    onTapp: () async {
                      if (addWalletController.priceController.text.isNotEmpty) {
                        if (addWalletController.selectPayment == 2) {
                          _razorPayClass.openCheckout(
                            name: homePageController.userData.name,
                            number: homePageController.userData.mobile,
                            amount: addWalletController.priceController.text,
                            key: addWalletController.paymentGateway.paymentdata[addWalletController.selectPayment].attributes,
                          );
                        } else if (addWalletController.selectPayment == 1) {
                          stripePayment();
                        } else if (addWalletController.selectPayment == 0) {
                          List<String> keyList = addWalletController.paymentGateway.paymentdata[addWalletController.selectPayment].attributes.split(",");
                          debugPrint('---------- clintid :-------- ${keyList[0]}');
                          debugPrint('-------- secretekey :------- ${keyList[1]}');
                          debugPrint('-------- secretekey :------- $keyList');
                          paypalPayment(
                            amt: addWalletController.priceController.text,
                            key: keyList[0],
                            secretKey: keyList[1],
                            onSuccess: (Map params) async {
                              paymentSuccessful();
                            },
                            context: context,
                          );
                        } else if (addWalletController.selectPayment == 4) {
                          Get.to(() => PayTmPayment(
                            totalAmount: addWalletController.priceController.text,
                            uid: uid,
                          ))!.then((otid) {
                            if (otid != null) {
                              paymentSuccessful();
                            } else {
                              Get.back();
                            }
                          });
                        } else if (addWalletController.selectPayment == 5) {
                          Get.to(Flutterwave(
                            email: homePageController.userData.email,
                            totalAmount: addWalletController.priceController.text,
                          ))!.then((otid) {
                            if (otid != null) {
                              paymentSuccessful();
                            } else {
                              Get.back();
                            }
                          });
                        } else if (addWalletController.selectPayment == 7) {
                          List attributes = addWalletController.paymentGateway.paymentdata[addWalletController.selectPayment].attributes.split(",");
                          await plugin.initialize(
                            publicKey: attributes[0],
                          );
                          // chargeCard(
                          //   amount: int.parse(addWalletController.priceController.text),
                          //   email: homePageController.userData.email,
                          //   ontap: () {
                          //     paymentSuccessful();
                          //   },
                          //   plugin: plugin,
                          //   context: context,
                          // );
                        } else if (addWalletController.selectPayment == 6) {
                          Random rad = Random();
                          sslCommerzGeneralCall(
                            tranId: rad.nextDouble().toString(),
                            amount: double.parse(addWalletController.priceController.text),
                            successfull: () {
                              paymentSuccessful();
                            },
                          );
                        } else if (addWalletController.selectPayment == 8) {
                          Get.to(
                            SenangPay(
                              email: homePageController.userData.email,
                              totalAmount: addWalletController.priceController.text,
                              name: homePageController.userData.name,
                              phon: homePageController.userData.mobile,
                            ),
                          )!.then((otid) {
                            if (otid != null) {
                              paymentSuccessful();
                            } else {
                              Get.back();
                            }
                          });
                        } else if (addWalletController.selectPayment == 9) {
                          bkashPaymentMethode(
                            context,
                            amount: addWalletController.priceController.text,
                            onSuccess: (trxId) {
                              paymentSuccessful();
                              debugPrint("====== trxId ====== $trxId");
                            },
                            onFailure: (error) {
                              debugPrint("====== error ====== $error");
                            },
                          );
                        }
                      } else {
                        showCommonToast(msg: "Enter Amount".tr);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: priMaryColor,
            centerTitle: true,
            title: Text(
              "Add Wallet".tr,
              style: TextStyle(
                fontSize: 18,
                fontFamily: fontFamilyBold,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: stack,
        );
      },
    );
  }

  final _paymentCard = PaymentCardCreated();
  final _card = PaymentCardCreated();

  var _autoValidateMode = AutovalidateMode.disabled;
  final _formKey = GlobalKey<FormState>();
  var numberController = TextEditingController();

  //? - - - - stripe - - - - - //
  stripePayment() {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: whiteColor,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Ink(
                  child: Column(
                    children: [
                      SizedBox(height: Get.height / 45),
                      Center(
                        child: Container(
                          height: Get.height / 85,
                          width: Get.width / 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: Get.height * 0.03),
                            Text(
                              "Add Your payment information".tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.02),
                            Form(
                              key: _formKey,
                              autovalidateMode: _autoValidateMode,
                              child: Column(
                                children: [
                                  SizedBox(height: 16),
                                  TextFormField(
                                    style: TextStyle(color: Colors.black),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(19),
                                      CardNumberInputFormatter()
                                    ],
                                    controller: numberController,
                                    onSaved: (String? value) {
                                      _paymentCard.number = CardUtils.getCleanedNumber(value!);

                                      CardTypee cardType = CardUtils.getCardTypeFrmNumber(_paymentCard.number.toString());
                                      setState(() {
                                        _card.name = cardType.toString();
                                        _paymentCard.type = cardType;
                                      });
                                    },
                                    onChanged: (val) {
                                      CardTypee cardType = CardUtils.getCardTypeFrmNumber(val);
                                      setState(() {
                                        _card.name = cardType.toString();
                                        _paymentCard.type = cardType;
                                      });
                                    },
                                    validator: CardUtils.validateCardNum,
                                    decoration: InputDecoration(
                                      prefixIcon: SizedBox(
                                        height: 10,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 14,
                                            horizontal: 6,
                                          ),
                                          child: CardUtils.getCardIcon(
                                            _paymentCard.type,
                                          ),
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: priMaryColor,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: priMaryColor,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: priMaryColor,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: priMaryColor,
                                        ),
                                      ),
                                      hintText: "What number is written on card?".tr,
                                      hintStyle: TextStyle(color: Colors.grey),
                                      labelStyle: TextStyle(color: Colors.grey),
                                      labelText: "Number".tr,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Flexible(
                                        flex: 4,
                                        child: TextFormField(
                                          style: TextStyle(color: Colors.grey),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                            LengthLimitingTextInputFormatter(4),
                                          ],
                                          decoration: InputDecoration(
                                            prefixIcon: SizedBox(
                                              height: 10,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: 14),
                                                child: SvgPicture.asset(
                                                  'assets/icons/credit-card.svg',
                                                  width: 6,
                                                  color: priMaryColor,
                                                ),
                                              ),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: priMaryColor,
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: priMaryColor,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: priMaryColor,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: priMaryColor,
                                              ),
                                            ),
                                            hintText: "Number behind the card".tr,
                                            hintStyle: TextStyle(color: Colors.grey),
                                            labelStyle: TextStyle(color: Colors.grey),
                                            labelText: 'CVV',
                                          ),
                                          keyboardType: TextInputType.number,
                                          onSaved: (value) {
                                            _paymentCard.cvv = int.parse(value!);
                                          },
                                        ),
                                      ),
                                      SizedBox(width: Get.width * 0.03),
                                      Flexible(
                                        flex: 4,
                                        child: TextFormField(
                                          style: TextStyle(color: Colors.black),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                            LengthLimitingTextInputFormatter(4),
                                            CardMonthInputFormatter()
                                          ],
                                          decoration: InputDecoration(
                                            prefixIcon: SizedBox(
                                              height: 10,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: 14),
                                                child: SvgPicture.asset(
                                                  'assets/icons/calendar-clock.svg',
                                                  width: 10,
                                                  color: priMaryColor,
                                                ),
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: priMaryColor,
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: priMaryColor,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: priMaryColor,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: priMaryColor,
                                              ),
                                            ),
                                            hintText: 'MM/YY',
                                            hintStyle:
                                                TextStyle(color: Colors.black),
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            labelText: "Expiry Date".tr,
                                          ),
                                          validator: CardUtils.validateDate,
                                          keyboardType: TextInputType.number,
                                          onSaved: (value) {
                                            List<int> expiryDate = CardUtils.getExpiryDate(value!);
                                            _paymentCard.month = expiryDate[0];
                                            _paymentCard.year = expiryDate[1];
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: Get.height * 0.055),
                                  Container(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: Get.width,
                                      child: commonButton(
                                        title: "Pay",
                                        onTapp: () {
                                          _validateInputs(
                                            amount: addWalletController.priceController.text,
                                            email: homePageController.userData.email,
                                            name: homePageController.userData.name,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: Get.height * 0.065),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _validateInputs({required String name, required String email, required String amount}) {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      setState(() {
        _autoValidateMode = AutovalidateMode.always; // Start validating on every change.
      });
      showCommonToast(msg: "Please fix the errors in red before submitting.".tr);
    } else {
      _paymentCard.name = name;
      _paymentCard.email = email;
      _paymentCard.amount = amount;
      form.save();

      Get.to(() => StripePaymentWeb(paymentCard: _paymentCard))!.then((otid) {
        Get.back();
        //! order Api call
        if (otid != null) {
          //! Api Call Payment Success
          paymentSuccessful();
        }
      });
      showCommonToast(msg: "Payment card is valid".tr);
    }
  }

  paymentSuccessful() {
    ApiProvider()
        .walletUpdate(
            uid: homePageController.userData.id,
            amount: addWalletController.priceController.text)
        .then((value) {
      var decode = value;
      showCommonToast(msg: "${decode["ResponseMsg"]}");
      walletScreenController.fetChDataFromApi();
      Get.close(1);
    });
  }
 
}
