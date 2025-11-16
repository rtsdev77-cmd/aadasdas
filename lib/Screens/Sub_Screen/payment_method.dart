// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../Controllers/payment_method_controller.dart';
import '../Api_Provider/imageupload_api.dart';
import '../Payment_methods/razorpayy.dart';
import 'loads_details.dart';
import '../../widgets/widgets.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../AppConstData/app_colors.dart';
import '../../AppConstData/typography.dart';
import '../../Controllers/bookedlorries_controller.dart';
import '../../Controllers/homepage_controller.dart';
import '../../Controllers/myloads_controller.dart';
import '../Api_Provider/api_provider.dart';
import '../Payment_methods/flutterWave.dart';
import '../Payment_methods/inputformat.dart';
import '../Payment_methods/paymentcard.dart';

import '../Payment_methods/paytm_payment.dart';
import '../Payment_methods/senang_pay.dart';
import '../Payment_methods/strippayment_web.dart';

class PaymentMethod extends StatefulWidget {
  final String price;
  final String totalPrice;
  final String uid;
  final String loadId;
  final String ownerId;
  final String lorryId;
  final String? walAmt;
  final String description;
  final bool isBooked;
  final bool? isPayOnly;
  final String? amtTyp;
  const PaymentMethod({
    super.key,
    required this.price,
    required this.totalPrice,
    required this.uid,
    required this.loadId,
    required this.ownerId,
    required this.lorryId,
    this.walAmt,
    required this.description,
    required this.isBooked,
    this.isPayOnly,
    this.amtTyp,
  });

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  PaymentMethodController paymentMethodController = Get.put(PaymentMethodController());
  HomePageController homePageController = Get.put(HomePageController());
  MyLoadsController myLoadsController = Get.put(MyLoadsController());
  BookedLorriesController bookedLorriesController = Get.put(BookedLorriesController());
  final RazorPayClass _razorPayClass = RazorPayClass();

  String currency = "\$";
  bool istrue = true;
  bool isOnlyWallet = false;
  int walletMain = 0;
  int totalPayment = 0;
  int walletValue = 0;
  var plugin;
  // = PaystackPlugin();

  @override
  void initState() {
    super.initState();
    debugPrint("============ price =========== ${widget.price}");
    debugPrint("========= totalPrice ========= ${widget.totalPrice}");
    _razorPayClass.initiateRazorPay(
        handlePaymentError: handlePaymentError,
        handleExternalWallet: handleExternalWallet,
        handlePaymentSuccess: handlePaymentSuccess);
    ApiProvider().paymentMethodData().then((value) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      ApiProvider()
          .walletReport(uid: homePageController.userData.id)
          .then((value) {
        setState(() {
          paymentMethodController.walletModel = value;
          walletMain = int.parse(paymentMethodController.walletModel.wallet);
          totalPayment = int.parse(widget.totalPrice);
          istrue = false;
        });
      });
      setState(() {
        paymentMethodController.paymentGateway = value;
        currency = prefs.getString("currencyIcon")!;
      });
    });
  }

  void paymentSuccessfull(String transid) {
    if (widget.isBooked) {
      if (widget.isPayOnly!) {
        ApiProvider().accept(
          uid: widget.uid,
          loadId: widget.loadId,
          status: "1",
          amount: totalPayment.toString(),
          amtType: widget.amtTyp!,
          totalAmt: widget.totalPrice,
          walAmt: walletValue.toString(),
          pMethodeId: paymentMethodController.paymentGateway.paymentdata[paymentMethodController.selectPayment].id,
          transId: transid,
          description: widget.description,
        ).then((value) {
          var decode = value;
          if (decode["Result"] == "true") {
            Get.close(2);
            showCommonToast(msg: decode["ResponseMsg"]);
          } else {
            showCommonToast(msg: decode["ResponseMsg"]);
          }
        });
      } else {
        ApiProvider().acceptPay(
          uid: widget.uid,
          loadId: widget.loadId,
          status: "4",
          walAmt: walletValue.toString(),
          pMethodId: paymentMethodController.paymentGateway.paymentdata[paymentMethodController.selectPayment].id,
          transId: transid,
        ).then((value) {
          var decode = value;
          if (decode["Result"] == "true") {
            Get.close(2);
            showCommonToast(msg: decode["ResponseMsg"]);
          } else {
            showCommonToast(msg: decode["ResponseMsg"]);
          }
        });
      }
    } else {
      ApiProvider().makeDecision(
        uid: widget.uid,
        status: "1",
        loadId: widget.loadId,
        ownerId: widget.ownerId,
        lorryId: widget.lorryId,
        amount: widget.price,
        totalAmt: totalPayment.toString(),
        walAmt: walletValue.toString(),
        pMethodId: paymentMethodController.paymentGateway.paymentdata[paymentMethodController.selectPayment].id,
        transId: transid,
        description: widget.description,
        amtType: widget.amtTyp!,
      ).then((value) {
        var decode = value;
        showCommonToast(msg: decode["ResponseMsg"]);
        Get.close(2);
      });
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    paymentSuccessfull(response.paymentId!);
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
  void dispose() {
    super.dispose();
    _razorPayClass.desposRazorPay();
    paymentMethodController.isWallet = false;
    myLoadsController.isLoading = false;
    bookedLorriesController.isLoading = false;
    istrue = true;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentMethodController>(
      builder: (paymentMethodController) {
        return WillPopScope(
          onWillPop: (() async => true),
          child: Scaffold(
            bottomNavigationBar: istrue
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(top: 5, right: 15, bottom: 10, left: 15),
                    child: Row(
                      children: [
                        isOnlyWallet
                            ? Expanded(
                                child: commonButton(
                                title: "Continue With Wallet".tr,
                                onTapp: () {
                                  if (widget.isBooked) {
                                    if (widget.isPayOnly!) {
                                      ApiProvider().accept(
                                        uid: widget.uid,
                                        loadId: widget.loadId,
                                        status: "1",
                                        amount: widget.price,
                                        amtType: widget.amtTyp!,
                                        totalAmt: widget.totalPrice,
                                        walAmt: walletValue.toString(),
                                        pMethodeId: "3",
                                        transId: "0",
                                        description: widget.description,
                                      ).then((value) {
                                        var decode = value;
                                        if (decode["Result"] == "true") {
                                          Get.close(2);
                                          showCommonToast(msg: decode["ResponseMsg"]);
                                        } else {
                                          showCommonToast(msg: decode["ResponseMsg"]);
                                        }
                                      });
                                    } else {
                                      ApiProvider().acceptPay(
                                        uid: widget.uid,
                                        loadId: widget.loadId,
                                        status: "4",
                                        walAmt: walletValue.toString(),
                                        pMethodId: "3",
                                        transId: "0",
                                      ).then((value) {
                                        var decode = value;
                                        if (decode["Result"] == "true") {
                                          Get.close(2);
                                          showCommonToast(msg: decode["ResponseMsg"]);
                                        } else {
                                          showCommonToast(msg: decode["ResponseMsg"]);
                                        }
                                      });
                                    }
                                  } else {
                                    ApiProvider().makeDecision(
                                      uid: widget.uid,
                                      status: "1",
                                      loadId: widget.loadId,
                                      ownerId: widget.ownerId,
                                      lorryId: widget.lorryId,
                                      amount: widget.price,
                                      totalAmt: widget.totalPrice,
                                      walAmt: walletValue.toString(),
                                      pMethodId: "3",
                                      transId: "0",
                                      description: widget.description,
                                      amtType: widget.amtTyp!,
                                    ).then((value) {
                                      var decode = value;
                                      showCommonToast(msg: decode["ResponseMsg"]);
                                      Get.close(1);
                                    });
                                  }
                                },
                              ))
                            : Expanded(
                                child: commonButton(
                                  title: "${"Continue".tr} $currency$totalPayment",
                                  onTapp: () async {
                                    if (paymentMethodController.selectPayment == 2) {
                                      _razorPayClass.openCheckout(
                                          name: homePageController.userData.name,
                                          number: homePageController.userData.mobile,
                                          amount: totalPayment.toString(),
                                          key: paymentMethodController.paymentGateway.paymentdata[paymentMethodController.selectPayment].attributes,
                                        );
                                    } else if (paymentMethodController.selectPayment == 0) {
                                      List<String> keyList = paymentMethodController.paymentGateway.paymentdata[paymentMethodController.selectPayment].attributes.split(",");
                                      paypalPayment(
                                        amt: totalPayment.toString(),
                                        key: keyList[0],
                                        secretKey: keyList[1],
                                        onSuccess: (Map params) async {
                                          paymentSuccessfull(params.length.toString());
                                        },
                                        context: context,
                                      );
                                    } else if (paymentMethodController.selectPayment == 4) {
                                      Get.to(() => PayTmPayment(
                                        totalAmount: totalPayment.toString(),
                                        uid: widget.uid,
                                      ))!.then((otid) {
                                        if (otid != null) {
                                          paymentSuccessfull(otid);
                                        } else {
                                          Get.back();
                                        }
                                      });
                                    } else if (paymentMethodController.selectPayment == 5) {
                                      Get.to(
                                        Flutterwave(
                                          email: homePageController.userData.email,
                                          totalAmount: totalPayment.toString(),
                                        ),
                                      )!.then((otid) {
                                        if (otid != null) {
                                          paymentSuccessfull(otid);
                                        } else {
                                          Get.back();
                                        }
                                      });
                                    } else if (paymentMethodController.selectPayment == 7) {
                                      List attributes = paymentMethodController.paymentGateway.paymentdata[paymentMethodController.selectPayment].attributes.split(",");
                                      await plugin.initialize(
                                        publicKey: attributes[0],
                                      );
                                      // chargeCard(
                                      //   amount: int.parse(totalPayment.toString()),
                                      //   email: homePageController.userData.email,
                                      //   ontap: () {
                                      //     paymentSuccessfull("transid");
                                      //   },
                                      //   plugin: plugin,
                                      //   context: context,
                                      // );
                                    } else if (paymentMethodController.selectPayment == 1) {
                                      stripePayment();
                                    } else if (paymentMethodController.selectPayment == 8) {
                                      Get.to(
                                        SenangPay(
                                          email: homePageController.userData.email,
                                          totalAmount: totalPayment.toString(),
                                          name: homePageController.userData.name,
                                          phon: homePageController.userData.mobile,
                                        ),
                                      );
                                    } else if (paymentMethodController.selectPayment == 6) {
                                      var id = UniqueKey().toString();
                                      sslCommerzGeneralCall(
                                        tranId: id.toString(),
                                        amount: double.parse(totalPayment.toString()),
                                        successfull: () {
                                          paymentSuccessfull(id);
                                        },
                                      );
                                    } else if (paymentMethodController.selectPayment == 9) {
                                      bkashPaymentMethode(
                                        context,
                                        amount: totalPayment.toString(),
                                        onSuccess: (trxId) {
                                          paymentSuccessfull(trxId);

                                          debugPrint("====== trxId ====== $trxId");
                                        },
                                        onFailure: (error) {
                                          debugPrint("====== log 3 ====== ");
                                          debugPrint("====== error ====== $error");
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              leading: InkWell(
                onTap: () async {
                  Get.back();
                },
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/icons/backicon.svg",
                      height: 22,
                      width: 22,
                      color: textBlackColor,
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              title: Text(
                "Payment Method".tr,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: fontFamilyBold,
                  fontWeight: FontWeight.w500,
                  color: textBlackColor,
                ),
              ),
            ),
            body: istrue
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          paymentMethodController.walletModel.wallet.compareTo("0") == 0
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Wallet information".tr,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: fontFamilyBold,
                                        fontWeight: FontWeight.w500,
                                        color: textBlackColor,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.grey.withOpacity(0.3),
                                              ),
                                            ),
                                            child: ListTile(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                              leading: CircleAvatar(
                                                backgroundColor: Colors.transparent,
                                                child: SvgPicture.asset('assets/icons/wallet0.svg'),
                                              ),
                                              title: Text(
                                                "${"Balance".tr} $currency$walletMain",
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: fontFamilyBold,
                                                  fontWeight: FontWeight.w500,
                                                  color: textBlackColor,
                                                ),
                                              ),
                                              trailing: Switch(
                                                activeColor: priMaryColor,
                                                value: paymentMethodController.isWallet,
                                                onChanged: (value) {
                                                  paymentMethodController.setIsWallet(value);

                                                  if (value) {
                                                    if (int.parse(widget.price) > walletMain) {
                                                      walletValue = walletMain;
                                                      totalPayment -= walletValue;
                                                      walletMain = 0;
                                                    } else {
                                                      isOnlyWallet = true;
                                                      walletValue = int.parse(widget.price);
                                                      totalPayment -= walletValue;
                                                      walletMain -= int.parse(widget.price);
                                                    }
                                                  } else {
                                                    isOnlyWallet = false;
                                                    walletValue = 0;
                                                    walletMain = int.parse(paymentMethodController.walletModel.wallet);
                                                    totalPayment = int.parse(widget.totalPrice);
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                          Text(
                            "Payment Information".tr,
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: fontFamilyBold,
                              fontWeight: FontWeight.w500,
                              color: textBlackColor,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.3),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Sub Total".tr,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: textGreyColor,
                                              fontFamily: fontFamilyRegular,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "$currency${widget.price}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: textBlackColor,
                                              fontFamily: fontFamilyBold,
                                            ),
                                          )
                                        ],
                                      ),
                                      paymentMethodController.walletModel.wallet.compareTo("0") == 0
                                          ? const SizedBox()
                                          : Column(
                                              children: [
                                                SizedBox(height: 15),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Wallet".tr,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: textGreyColor,
                                                        fontFamily: fontFamilyRegular,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      "$currency$walletValue",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.green,
                                                        fontFamily: fontFamilyRegular,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                      Divider(
                                        height: 20,
                                        color: Colors.grey.withOpacity(0.3),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Total Payment".tr,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: textGreyColor,
                                              fontFamily: fontFamilyRegular,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "$currency$totalPayment",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: textBlackColor,
                                              fontFamily: fontFamilyBold,
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
                          isOnlyWallet
                              ? SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                      "Select Payment Gateway".tr,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: fontFamilyBold,
                                        fontWeight: FontWeight.w500,
                                        color: textBlackColor,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    if (istrue == false)
                                      ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return paymentMethodController.paymentGateway.paymentdata[index].pShow == "0"
                                              ? const SizedBox()
                                              : InkWell(
                                                  onTap: () {
                                                    paymentMethodController.setSelectMethode(index);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(10),
                                                    height: 90,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(12),
                                                      color: paymentMethodController.selectPayment == index
                                                          ? priMaryColor.withOpacity(0.05)
                                                          : Colors.white,
                                                      border: Border.all(
                                                        color: paymentMethodController.selectPayment == index
                                                            ? priMaryColor
                                                            : Colors.grey.withOpacity(0.3),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        paymentMethodController.paymentGateway.paymentdata[index].img.isNotEmpty
                                                            ? Container(
                                                                height: 60,
                                                                width: 60,
                                                                decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                    image: NetworkImage(
                                                                      "$basUrl${paymentMethodController.paymentGateway.paymentdata[index].img}",
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
                                                                      paymentMethodController.paymentGateway.paymentdata[index].title,
                                                                      style: TextStyle(
                                                                        color: textBlackColor,
                                                                        fontFamily: fontFamilyBold,
                                                                        fontSize: 16,
                                                                      ),
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 1,
                                                                    ),
                                                                    SizedBox(height:3),
                                                                    Text(
                                                                      paymentMethodController.paymentGateway.paymentdata[index].subtitle,
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
                                                          value: paymentMethodController.selectPayment == index
                                                              ? true
                                                              : false,
                                                          groupValue: true,
                                                          onChanged: (value) {
                                                            paymentMethodController.setSelectMethode(index);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                        },
                                        separatorBuilder: (context, index) {
                                          return paymentMethodController.paymentGateway.paymentdata[index].pShow == "0"
                                              ? const SizedBox()
                                              : Container(height: 10);
                                        },
                                        itemCount: paymentMethodController.paymentGateway.paymentdata.length,
                                      )
                                    else
                                      ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            padding: const EdgeInsets.all(10),
                                            height: 90,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: paymentMethodController.selectPayment == index
                                                  ? priMaryColor.withOpacity(0.05)
                                                  : Colors.white,
                                              border: Border.all(
                                                color: paymentMethodController.selectPayment == index
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
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  //?-------- stripe ----------//
  final _paymentCard = PaymentCardCreated();
  final _card = PaymentCardCreated();
  var _autoValidateMode = AutovalidateMode.disabled;
  final _formKey = GlobalKey<FormState>();
  var numberController = TextEditingController();

  stripePayment() {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
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
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
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
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: Get.height * 0.03),
                            Text(
                              "Add Your payment information".tr,
                              style: const TextStyle(
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
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    style: const TextStyle(color: Colors.black),
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
                                          padding: const EdgeInsets.symmetric(
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
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Flexible(
                                        flex: 4,
                                        child: TextFormField(
                                          style: const TextStyle(color: Colors.grey),
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
                                              borderSide: BorderSide(color: priMaryColor),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: priMaryColor),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: priMaryColor),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: priMaryColor),
                                            ),
                                            hintText: "Number behind the card".tr,
                                            hintStyle: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                            labelStyle: const TextStyle(
                                              color: Colors.grey,
                                            ),
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
                                          style: const TextStyle(color: Colors.black),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                            LengthLimitingTextInputFormatter(4),
                                            CardMonthInputFormatter(),
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
                                            focusedErrorBorder: OutlineInputBorder(
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
                                            hintStyle: TextStyle(color: Colors.black),
                                            labelStyle: TextStyle(color: Colors.grey),
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
                                      ),
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
                                            amount: "$totalPayment",
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
          // buyOrderInStore(otid);
          paymentSuccessfull(otid);
        }
      });
      showCommonToast(msg: "Payment card is valid".tr);
    }
  }

}
