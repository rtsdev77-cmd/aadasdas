import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SentRequestController extends GetxController implements  GetxService{

  bool isDropPoint = false;
  bool isPriceFix = false;
  bool isPickUp = false;
  bool isMaterialName = false;
  bool isNumTonnes = false;
  bool isAmount = false;
  bool isNumberOfHours = false;
  bool isPickUpDetails = false;
  bool isDropDetails = false;
  bool isMySelf = false;
  bool isLoading = false;

  bool isSendReruest = false;

  setIsSendReruest(bool value){
    isSendReruest = value;
    update();
  }

  setIsLoading(bool value){
    isLoading = value;
    update();
  }

  setIsMySelf(bool value){
    isMySelf = value;
    update();
  }

  TextEditingController name = TextEditingController();
  TextEditingController pickup = TextEditingController();
  TextEditingController drop = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController numberOfHours = TextEditingController();

  setIsAmount(bool value){
    isAmount = value;
    update();
  }
  setIsPriceFix(bool value){
    isPriceFix = value;
    update();
  }
  setIsNumberOfHours(bool value){
    isNumberOfHours = value;
    update();
  }
  setIsPickUpDetails(bool value){
    isPickUpDetails = value;
    update();
  }
  setIsDropDetails(bool value){
    isDropDetails = value;
    update();
  }
  setIsMaterialName(bool value){
    isMaterialName = value;
    update();
  }
  setIsNumTonnes(bool value){
    isNumTonnes = value;
    update();
  }
  setIsDropPoint(bool value){
    isDropPoint = value;
    update();
  }
  setIsPickUp(bool value){
    isPickUp = value;
    update();
  }

}