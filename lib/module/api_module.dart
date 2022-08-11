import 'dart:convert';
import 'dart:io';
import 'package:universal_html/js.dart' as js;

class ApiModule {
  static get TS {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }
  static get TS_FULL {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static get ORIGIN {
    if (const bool.fromEnvironment("dart.vm.product")) {
      return js.context["location"]["origin"];
    } else {
      return "http://127.0.0.1:18554";
    }
  }

  static final HttpClient _client = HttpClient();

  static Future<Map> get(Uri uri) async {
    return toJson(_client.getUrl(uri));
  }

  static Future<Map> post(Uri uri) async {
    return toJson(_client.postUrl(uri));
  }

  static Future<Map> toJson(Future<HttpClientRequest> request) async {
    HttpClientResponse response = await (await request).close();
    String body = await response.transform(const Utf8Decoder()).join();
    return const JsonDecoder().convert(body);
  }
}