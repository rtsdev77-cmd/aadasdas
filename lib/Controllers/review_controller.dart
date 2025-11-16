import 'package:get/get.dart';

import '../Screens/Models/profile_detils_model.dart';


class ReviewController  extends GetxController implements GetxService {

  ProfileDetilsModel? profileData;
  bool isLoading = true;

  setIsLoading(bool value){
    isLoading = value;
    update();
  }


  setProfileData(value){
    profileData = value;
    update();
  }

}