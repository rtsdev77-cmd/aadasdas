import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../Screens/Models/vehicle_list_model.dart';

class PostLoads1Controller extends GetxController implements GetxService {
  late VehicleListModel vehicleList;

  double rating = 0.0;

  setRating(value) {
    rating = value;
    update();
  }

  TextEditingController pickUpController = TextEditingController();
  TextEditingController dropDownController = TextEditingController();
  TextEditingController materialName = TextEditingController();
  TextEditingController numberTonnes = TextEditingController();
  TextEditingController description = TextEditingController();

  bool isEdit = false;
  String? editeTitle;
  String? loadId;

  setTitle(String value) {
    editeTitle = value;
    update();
  }

  bool isPriceFix = false;
  bool isHours = false;
  bool isLoading = true;
  bool isMySelf = false;
  bool isLoading1 = false;

  setIsEdit(bool value) {
    isEdit = value;
    update();
  }

  setIsLoading1(bool value) {
    isLoading1 = value;
    update();
  }

  String? picUpState;
  String? dropPoint;

  String? picUpLat;
  String? picUpLng;

  String? dropUpLat;
  String? dropUpLng;

  bool isPickUp = false;
  bool isDropPoint = false;
  bool isMaterialName = false;
  bool isNumTonnes = false;

  int selectVehicle = -1;
  String? vehicleID;

  setSelectVehicle(int value) {
    selectVehicle = value;
    update();
  }

  setIsDropPoint(bool value) {
    isDropPoint = value;
    update();
  }

  setIsPickUp(bool value) {
    isPickUp = value;
    update();
  }

  setIsMaterialName(bool value) {
    isMaterialName = value;
    update();
  }

  setIsNumTonnes(bool value) {
    isNumTonnes = value;
    update();
  }

  TextEditingController name = TextEditingController();
  TextEditingController pickup = TextEditingController();
  TextEditingController drop = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController numberOfHours = TextEditingController();

  bool isAmount = false;
  bool isNumberOfHours = false;
  bool isPickUpDetails = false;
  bool isDropDetails = false;

  setIsAmount(bool value) {
    isAmount = value;
    update();
  }

  setIsNumberOfHours(bool value) {
    isNumberOfHours = value;
    update();
  }

  setIsPickUpDetails(bool value) {
    isPickUpDetails = value;
    update();
  }

  setIsDropDetails(bool value) {
    isDropDetails = value;
    update();
  }

  setIsLoading(bool value) {
    isLoading = value;
    update();
  }

  setIsPriceFix(bool value) {
    isPriceFix = value;
    update();
  }

  setIsHours(bool value) {
    isHours = value;
    update();
  }

  setIsMySelf(bool value) {
    isMySelf = value;
    update();
  }

  getDataFromApi({required var value}) {
    vehicleList = VehicleListModel.fromJson(value);
    update();
    setIsLoading(false);
  }
}
