import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../AppConstData/routes.dart';

class ProfileController extends GetxController implements GetxService {
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool isPasswordShow = true;

  setIsPasswordShow() {
    isPasswordShow = !isPasswordShow;
    update();
  }

  List pagesPath = [
    Routes.walletScreen,
    Routes.reviewScreen,
    Routes.referFriend,
    Routes.referFriend,
    Routes.privacyPolicy,
    Routes.termsConditions,
    Routes.contactUs,
    Routes.faq,
    Routes.faq,
  ];

  List itemIcons = [
    "assets/icons/ic_profile_wallet.svg",
    "assets/icons/ic_star_profile.svg",
    "assets/icons/ic_profile_refer.svg",
    "assets/icons/ic_multi_lang.svg",
    "assets/icons/ic_profile_pages.svg",
    "assets/icons/ic_profile_pages.svg",
    "assets/icons/ic_profile_pages.svg",
    "assets/icons/ic_faq.svg",
    "assets/icons/ic_logout.svg",
  ];


  List nameOfCountry = [
    "English",
    "Spanish",
    "Arabic",
    "Hindi",
    "Gujarati",
    "Afrikaans",
    "Bengali",
    "Indonesian",
  ];

  List countryLogo = [
    "assets/logo/043-liberia.png",
    "assets/logo/230-spain.png",
    "assets/logo/195-united arab emirates.png",
    "assets/logo/055-india.png",
    "assets/logo/055-india.png",
    "assets/logo/188-south africa.png",
    "assets/logo/134-bangladesh.png",
    "assets/logo/185-indonesia.png",
  ];

  List items = [
    "Wallet",
    "Review",
    "Refer to Friends",
    "Language",
    "Privacy Policy",
    "Terms & Conditions",
    "Contact Us",
    "FAQ",
    "LogOut",
  ];

}