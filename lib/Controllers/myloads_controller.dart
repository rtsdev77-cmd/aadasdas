import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/Api_Provider/api_provider.dart';
import '../Screens/Models/my_loads_model.dart';

class MyLoadsController extends GetxController implements GetxService {
  late MyLoadsModel currentData;
  bool isLoading = true;
  late MyLoadsModel complete;
  String uid = '';
  String currency = "\$";
  setIsLoading(bool value) {
    isLoading = value;
    update();
  }

  setDataInCurrentList(value) {
    currentData = value;
    update();
  }

  setDataInCompletList(value) {
    complete = value;
    update();
  }

  fetchDataFromApi() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString("uid")!;
    currency = prefs.getString("currencyIcon")!;

    ApiProvider().myLoadsData(uid: uid, status: "Current").then((value) async {
      setDataInCurrentList(value);
      ApiProvider().myLoadsData(uid: uid, status: "complet").then((value) {
        setDataInCompletList(value);
        setIsLoading(false);
      });
    });
  }
}
