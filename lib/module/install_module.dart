import 'package:driveindex_web/module/api_module.dart';

class InstallModule {
  static Uri status = Uri.parse(ApiModule.ORIGIN + "/api/install/status");
  static Future<bool> getStatus() async {
    Map data = await ApiModule.get(status);
    return data["status"];
  }
}