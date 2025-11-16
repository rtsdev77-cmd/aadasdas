// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

const String googleApiKey = "*******************";

String basUrl = "http://admin.scsc.space/";



class ImageUploadApi extends GetConnect {
  String basUrlApi = "${basUrl}api";

  Future editImage({required XFile image, required String uid}) async {
    final body = {
      "image0": MultipartFile(await image.readAsBytes(), filename: image.name),
      "size": "1",
      "uid": uid,
    };

    log("$body");
    FormData formData = FormData(body);

    var respons = await post(
      "$basUrlApi/pro_image.php", formData,
      contentType : "multipart/form-data",
    );
    return respons.body;
  }

  Future upLoadDox(
      {XFile? image,
      XFile? image1,
      XFile? imageSelfie,
      required String uid,
      required String status}) async {
    final body = {
      "image0": image.isNull
          ? ""
          : MultipartFile(await image!.readAsBytes(), filename: image.name),
      "image1": image1.isNull
          ? ""
          : MultipartFile(await image1!.readAsBytes(), filename: image1.name),
      "images0": imageSelfie.isNull
          ? ""
          : MultipartFile(await imageSelfie!.readAsBytes(), filename: imageSelfie.name),
      "size": "2",
      "sizes": "1",
      "status": status,
      "uid": uid,
    };

    FormData formData = FormData(body);

    log("++++++++++++++++++$body");
    var respons = await post("$basUrlApi/personal_document.php", formData,
        contentType: "multipart/form-data");

    log("+++++++++++++++++${respons.body}");
    return respons.body;
  }
}
