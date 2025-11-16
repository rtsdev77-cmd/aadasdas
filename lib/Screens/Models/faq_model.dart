// To parse this JSON data, do
//
//     final faqDataModel = faqDataModelFromJson(jsonString);

import 'dart:convert';

FaqDataModel faqDataModelFromJson(String str) => FaqDataModel.fromJson(json.decode(str));

String faqDataModelToJson(FaqDataModel data) => json.encode(data.toJson());

class FaqDataModel {
  List<FaqDatum> faqData;
  String responseCode;
  String result;
  String responseMsg;

  FaqDataModel({
    required this.faqData,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory FaqDataModel.fromJson(Map<String, dynamic> json) => FaqDataModel(
    faqData: List<FaqDatum>.from(json["FaqData"].map((x) => FaqDatum.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "FaqData": List<dynamic>.from(faqData.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class FaqDatum {
  String id;
  String question;
  String answer;
  String status;

  FaqDatum({
    required this.id,
    required this.question,
    required this.answer,
    required this.status,
  });

  factory FaqDatum.fromJson(Map<String, dynamic> json) => FaqDatum(
    id: json["id"],
    question: json["question"],
    answer: json["answer"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
    "status": status,
  };
}
