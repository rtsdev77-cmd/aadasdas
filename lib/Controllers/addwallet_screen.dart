import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Screens/Models/payment_method_model.dart';

class AddWalletController extends GetxController implements GetxService {

  TextEditingController priceController = TextEditingController();

  late PaymentGateway paymentGateway;

  bool isLoading = true;

  List staticPrice = [
    "100",
    "200",
    "300",
    "400",
    "500",
  ];

  int selectPayment = -1;


  setSelectMethode(value){
    selectPayment = value;
    update();
  }


  setPrice(String value){
    priceController.text = value;
    update();
  }



}