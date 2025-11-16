import 'package:get/get.dart';

class OnBoardingScreensController extends GetxController implements GetxService{

  int pageSelecter = 0;

  setPageSelecter(int value){
    pageSelecter = value;
    update();
  }


  List onBoardingTitle = [
    "Simplify the way you find carriers.",
    "Get better rates on every deal.",
    "The right load for the right truck.",
  ];

  List subTitle =  [
    "Search active loads by location and equipment type",
    "We offer a wide range of problem-solving products designed to help you ship more freight faster",
    "We match the right load to the right truck at the right price",
  ];

  List images = [
    "assets/image/onboardingimage.png",
    "assets/image/onboardingimage(1).png",
    "assets/image/onboardingimage(2).png",
  ];
}