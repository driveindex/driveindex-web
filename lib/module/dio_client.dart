import 'package:dio/dio.dart';

class DioClient {
  static final Dio _client = Dio();

  static const API_HOST = "http://localhost:11411";

  static Future<Response<Map<String, dynamic>>> post(String path, {
    data, Map<String, dynamic>? parameters, Options? options
  }) {
    return _client.post<Map<String, dynamic>>(parsePath(path),
      data: data,
      queryParameters: parameters,
      options: options,
    );
  }

  static Future<Response<Map<String, dynamic>>> get(String path, {
    Map<String, dynamic>? parameters, Options? options
  }) {
    return _client.get<Map<String, dynamic>>(parsePath(path),
      queryParameters: parameters,
      options: options,
    );
  }

  static Future<Response<String>> getContent(String path, {
    Map<String, dynamic>? parameters, Options? options
  }) {
    return _client.request<String>(parsePath(path),
      queryParameters: parameters,
      options: options,
    );
  }

  static String parsePath(String path) {
    if (!const bool.fromEnvironment("dart.vm.product")) {
      path = "$API_HOST$path";
    }
    return path;
  }
}