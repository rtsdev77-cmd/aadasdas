import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../AppConstData/routes.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/Api_Provider/api_provider.dart';
import '../widgets/widgets.dart';

class LoginScreenController extends GetxController implements GetxService {
  TextEditingController codeController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isPassword = false;
  bool isShowPassword = true;
  bool isMobile = false;
  bool passWord = false;
  bool isPassValid = false;

  setPasswordView(bool value) {
    isPassword = value;
    update();
  }

  setIsPassValid(bool value) {
    isPassValid = value;
    update();
  }

  setIsMobile(bool value) {
    isMobile = value;
    update();
  }

  setIsPassWord(bool value) {
    passWord = value;
    update();
  }

  setShowPassword() {
    isShowPassword = !isShowPassword;
    update();
  }

  bool isLoading = false;

  setIsLoading(value) {
    isLoading = value;
    update();
  }

  checkController({required String code, context}) {
    setIsLoading(true);

    if (codeController.text.isEmpty && mobileController.text.isEmpty) {
      setPasswordView(false);
    } else {
      ApiProvider()
          .checkMobileNumber(number: mobileController.text, code: code)
          .then((value) {
        if (value["Result"] == "true") {
          snakbar("Number is not register", context);
          setPasswordView(false);
        } else {
          setPasswordView(true);
          if (passwordController.text.isNotEmpty) {
            ApiProvider()
                .loginUser(
                    code: code,
                    number: mobileController.text,
                    password: passwordController.text)
                .then((value) async {
              var data = value;
              if (data["Result"] == "true") {
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                
                Get.offAllNamed(Routes.landingPage);
                snakbar(data["ResponseMsg"], context);
              } else {
                snakbar(data["ResponseMsg"], context);
              }
            });
          }
        }
        setIsLoading(false);
      });
    }
  }
}


// onesignal_flutter: ^3.5.1
