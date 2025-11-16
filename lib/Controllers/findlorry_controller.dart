
import 'package:get/get.dart';
import '../Screens/Models/find_lorry_model.dart';

class FindLorryController extends GetxController  implements  GetxService{

  late FindLorryModel lorryData;
  int selectVehicle = 0;

  setSelectVehicle(int value){
  selectVehicle = value;
  update();
  }


  String? pickUpStatId;
  String? dropUpStatId;

  setPickUpStatId(String value){
    pickUpStatId = value;
    update();
  }

  setDropUpStatId(String value){
    dropUpStatId = value;
    update();
  }

  bool isShowData = false;
  bool isLoading = false;

  setIsShowData(bool value){
    isShowData = value;
    update();
  }

  setIsLoading(bool value){
    isLoading = value;
    update();
  }


  setDataInList(value){
    lorryData = value;
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

  setIsDropPoint(bool value){
    isDropPoint = value;
    update();
  }

  setIsPickUp(bool value){
    isPickUp = value;
    update();
  }
}