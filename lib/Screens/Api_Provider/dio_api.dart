import 'package:dio/dio.dart';
import 'imageupload_api.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class Api {
  final Dio _dio = Dio();
  Api() {
    _dio.options.baseUrl = basUrl;
     _dio.options.headers = {
      'Content-Type': 'application/json',
      'X-API-KEY': 'cscodetech',
    };
    _dio.interceptors.add(PrettyDioLogger(
      requestBody: true,
      responseBody: true,
    ));
  }
  Dio get sendRequest => _dio;
}
