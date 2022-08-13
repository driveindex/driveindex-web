import 'dio_client.dart';

class LoginModule {
  static Future<Map<String, dynamic>> login({
    required String password,
  }) async {
    return (await DioClient.post(
        "/api/login",
        data: { "password": password }
    )).data!;
  }
}