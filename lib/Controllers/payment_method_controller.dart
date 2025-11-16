import 'package:get/get.dart';

import '../Screens/Models/payment_method_model.dart';
import '../Screens/Models/wallet_model.dart';

class PaymentMethodController extends GetxController implements  GetxService {

  late PaymentGateway paymentGateway;
  late WalletModel walletModel;


  bool isWallet = false;

  setIsWallet(bool value){
    isWallet = value;
    update();
  }

  int selectPayment = -1;


  setSelectMethode(value){
    selectPayment = value;
    update();
  }

}