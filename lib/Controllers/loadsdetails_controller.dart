import 'package:get/get.dart';

import '../Screens/Models/loaddetails_model.dart';

class LoadsDetailsController extends GetxController  implements GetxService {
  late LoadsDetils detailsData;
  int zod = 0;

  bool isLoading = true;
  setIsLoading(bool value){
    isLoading = value;
    update();
  }

  setDetilsValue(value,value1){
    detailsData = value;
    zod = value1;
    update();
  }
}