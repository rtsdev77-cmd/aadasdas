import 'package:get/get.dart';

import '../Screens/Models/review_model.dart';

class ProfileDetilsController  extends GetxController implements GetxService {

  String? uid;
  String? ownerId;
  String? lorryId;

  ReviewModel? profileData;
  bool isLoading = true;

  setIsLoading(bool value){
    isLoading = value;
    update();
  }


  setDataInReview({required String lorryId1,required String ownerId1,required String uid1}){
    uid = uid1;
    ownerId = ownerId1;
    lorryId = lorryId1;
    update();
  }

  setProfileData(value){
    profileData = value;
    update();
  }

}