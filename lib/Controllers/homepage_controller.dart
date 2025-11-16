import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/Api_Provider/api_provider.dart';
import '../Screens/Models/homepage_model.dart';
import '../Screens/Models/login_user_model.dart';
import '../widgets/widgets.dart';

class HomePageController extends GetxController implements GetxService {
  late UserLogin userData;
  late HomePageModel homePageData;

  updateUserProfile(context) {
    ApiProvider()
        .loginUser(
            code: userData.ccode,
            number: userData.mobile,
            password: userData.password)
        .then((value) async {
      var data = value;
      if (data["Result"] == "true") {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String decodeData = jsonEncode(data["UserLogin"]);
        await prefs.setString("userData", decodeData);
        getDataFromLocalData().then((value) {
          if (value.toString().isNotEmpty) {
            setIcon(verification12(userData.isVerify));

            getHomePageData(uid: userData.id);
          }
        });
      } else {
        snakbar(data["ResponseMsg"], context);
      }
    });
  }

  verification12(String id) {
    switch (id) {
      case "0":
        return "assets/icons/alert-circle.svg";
      case "1":
        return "assets/icons/ic_document_process.svg";
      case "2":
        return "assets/icons/badge-check.svg";
      default:
        return "assets/icons/alert-circle.svg";
    }
  }

  String? verification;

  bool isLoading = true;

  setIsLoading(bool value) {
    isLoading = value;
    update();
  }

  setIcon(String value) {
    verification = value;
    update();
  }

  Future getDataFromLocalData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedMap = prefs.getString('userData');

    if (encodedMap!.isNotEmpty) {
      var decodedata = jsonDecode(encodedMap);
      userData = UserLogin.fromJson(decodedata);

      prefs.setString("uid", userData.id);
      update();
    }
  }

  getHomePageData({required String uid}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiProvider().homePageData(uid: uid).then((value) {
      homePageData = HomePageModel.fromJson(value);
      update();
      prefs.setString("wallet", homePageData.homeData!.wallet.toString());
      prefs.setString("walletValue", homePageData.homeData!.wallet.toString());
      prefs.setString("currencyIcon", homePageData.homeData!.currency.toString());
      prefs.setString("gkey", homePageData.homeData!.gKey ?? "");
      print("GKEY ${homePageData.homeData!.gKey}");
      update();
      setIsLoading(false);
    });
  }

  removeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userData", "");
    prefs.setString("walletValue", "");
    prefs.setString("currencyIcon", "");
    prefs.setString("uid", "");
  }
}
