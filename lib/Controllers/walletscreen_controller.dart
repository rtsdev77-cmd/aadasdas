import 'package:get/get.dart';
import '../Screens/Models/wallet_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/Api_Provider/api_provider.dart';

class WalletScreenController extends GetxController implements GetxService {
  String walletVale = '0';
  String currency = "\$0.00";
  String uid = "";
  bool istrue = true;
  late WalletModel walletModel;

  bool isLoading = true;

  setIsLoading(value) {
    isLoading = value;
    update();
  }

  fetChDataFromApi() {
    ApiProvider().walletReport(uid: uid).then((value) {
      walletModel = value;
      istrue = false;
      update();
    });
  }

  Future getDataFromLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString("uid")!;
    update();
    walletVale = prefs.getString("walletValue")!;
    currency = prefs.getString("currencyIcon")!;
    setIsLoading(false);
  }
}
