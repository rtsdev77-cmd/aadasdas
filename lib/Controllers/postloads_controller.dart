import 'package:get/get.dart';

class PostLoadsController extends GetxController implements GetxService{
  int selectPage = 0;

  List pagee = [];
  setSelectPage(int value){
    selectPage = value;
    update();
  }

  List pages = [];

}