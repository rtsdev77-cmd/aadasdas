import 'package:get/get.dart';

import '../Screens/Models/booked_loads_model.dart';

class BookedLorriesController extends GetxController implements GetxService{

  late BookedLoadsModel currentLoads;
  late BookedLoadsModel completedLoads;
  bool isLoading = true;

  setDataCurrentLoads(value){
    currentLoads = value;
    update();
  }

  setDataCompletedLoads(value){
    completedLoads = value;
    update();
  }
}