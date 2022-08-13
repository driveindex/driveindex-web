import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

class DioClient {
  static final Dio _client = Dio();

  static const API_HOST = "http://localhost:11411";

  static Future<Response<Map<String, dynamic>>> post(String path, {
    data, Map<String, dynamic>? parameters, Options? options
  }) {
    return _client.post<Map<String, dynamic>>(parsePath(path),
        data: data, queryParameters: parameters, options: options
    );
  }

  static Future<Response<Map<String, dynamic>>> get(String path, {
    Map<String, dynamic>? parameters, Options? options
  }) {
    return _client.get<Map<String, dynamic>>(parsePath(path),
        queryParameters: parameters, options: options
    );
  }

  static String parsePath(String path) {
    if (!path.startsWith("http")) {
      path = "$API_HOST$path";
    }
    return path;
  }
}

@JsonSerializable()
class SampleRequestResult {
  final int code;
  final String message;

  SampleRequestResult({
    required this.code,
    required this.message,
  });

  static final SampleRequestResult REQUEST_FAILED = SampleRequestResult(code: -1000, message: "请求失败");
  static final SampleRequestResult REQUEST_PARSE_FAILED = SampleRequestResult(code: -1001, message: "响应解析失败");
}

@JsonSerializable()
class RequestResult<T> extends SampleRequestResult {
  final T data;

  RequestResult({
    required super.code,
    required super.message,
    required this.data,
  });
}