import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../AppConstData/routes.dart';
import '../Screens/otp_screen.dart';
import '../widgets/widgets.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/Api_Provider/api_provider.dart';

class SingUpController extends GetxController implements GetxService {
  bool isPasswordShow = true;
  bool isLoading = false;
  bool istreamAndCondition = false;
  String response = '';
  String countryCode = '+91';

  bool isMobileNumber = false;
  bool isFullName = false;
  bool emailAddress = false;
  bool passWord = false;

  setIsMobileNumber(bool value) {
    isMobileNumber = value;
    update();
  }

  setIsFullName(bool value) {
    isFullName = value;
    update();
  }

  setEmailAddress(bool value) {
    emailAddress = value;
    update();
  }

  setPassWord(bool value) {
    passWord = value;
    update();
  }

  countryData(value) {
    countryCode = value;
    update();
  }

  setIsLoading(value) {
    isLoading = value;
    update();
  }

  setIsPasswordShow() {
    isPasswordShow = !isPasswordShow;
    update();
  }

  setIstreamAndCondition() {
    istreamAndCondition = !istreamAndCondition;
    update();
  }

  void setUserData(context,
      {required String name,
      required String mobile,
      required String ccode,
      required String email,
      required String pass,
      required String reff}) {
    ApiProvider()
        .registerUser(
            password: pass,
            cCode: ccode,
            email: email,
            mobile: mobile,
            name: name,
            referCode: reff)
        .then((value) async {
      var dataaa = value;
      if (dataaa["Result"] == "true") {
       
        Get.offAllNamed(Routes.landingPage);
        snakbar(dataaa["ResponseMsg"], context);
      } else {
        snakbar(dataaa["ResponseMsg"], context);
      }
    });
  }

  setDataInLocal(
      {required String name,
      required String mobile,
      required String ccode,
      required String email,
      required String pass,
      required String reff}) async {
    Map userData = {
      "name": name,
      "mobile": mobile,
      "ccode": ccode,
      "email": email,
      "password": pass,
      "refercode": reff,
    };

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodeData = jsonEncode(userData);

    prefs.setString("tempUserData", encodeData);
  }

  getDataFromApi(context) {
    ApiProvider().checkMobileNumber(number: mobileController.text, code: countryCode)
        .then((value) {
          debugPrint("========== value ========== $value");
          debugPrint("========== result ========= ${value["Result"]}");
          debugPrint("========== otp auth ======= ${value["otp_auth"]}");
      if (value["Result"] == "false") {
        snakbar("Number is register", context);
        isLoading = false;
        update();
      } else {
        if (value["otp_auth"] == "No") {
          setDataInLocal(
            name: fullNameController.text,
            mobile: mobileController.text,
            ccode: countryCode,
            email: emailController.text,
            pass: passwordController.text,
            reff: referralCodeController.text,
          );
          SingUpController().setUserData(
            context,
            name: fullNameController.text,
            mobile: mobileController.text,
            email: emailController.text,
            ccode: countryCode,
            pass: passwordController.text,
            reff: referralCodeController.text,
          );
        } else {
          setDataInLocal(
            name: fullNameController.text,
            mobile: mobileController.text,
            ccode: countryCode,
            email: emailController.text,
            pass: passwordController.text,
            reff: referralCodeController.text,
          );
          Get.to(OtpScreen(mobileNumber: mobileController.text.trim(),ccode: countryCode, isSingup: true));
        }
      }
    });
  }

  TextEditingController mobileController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController referralCodeController = TextEditingController();
  TextEditingController codeController = TextEditingController();
}

//63563889361