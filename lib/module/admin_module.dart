import 'package:dio/dio.dart';
import 'package:driveindex_web/module/dio_client.dart';
import 'package:driveindex_web/util/config_manager.dart';

Future<Options> get _adminHeader async => Options(
    headers: {
      "DriveIndex-Authentication": (await ConfigManager.ADMIN_TOKEN)
    }
);

class AdminCommonModule {
  static Future<Map<String, dynamic>> checkLogin() async {
    return (await DioClient.get(
      "/api/admin/token_state",
      options: await _adminHeader,
    )).data!;
  }

  static Future<Map<String, dynamic>> changePassword(String old, String newPass, String repeat) async {
    return (await DioClient.post(
      "/api/admin/password",
      data: { "old_pass": old, "new_pass": newPass, "repeat_pass": repeat },
      options: await _adminHeader,
    )).data!;
  }
}

class AzureClientModule {
  static Future<Map<String, dynamic>> getAzureClient() async {
    return (await DioClient.get(
      "/api/admin/azure_client",
      options: await _adminHeader,
    )).data!;
  }

  static Future<Map<String, dynamic>> saveAzureClient({
    required String id, required String calledName,
    required String clientId, required String clientSecret,
    required bool enabled,
  }) async {
    return (await DioClient.post(
      "/api/admin/azure_client/$id",
      data: {
        "client_id": clientId,
        "client_secret": clientSecret,
        "called_name": calledName,
        "enable": enabled,
      },
      options: await _adminHeader,
    )).data!;
  }

  static Future<Map<String, dynamic>> deleteAzureClient(String id) async {
    return (await DioClient.post(
      "/api/admin/azure_client/delete/$id",
      options: await _adminHeader,
    )).data!;
  }

  static Future<Map<String, dynamic>> defaultAzureClient(String id) async {
    return (await DioClient.post(
      "/api/admin/azure_client/default/$id",
      options: await _adminHeader,
    )).data!;
  }
}

class AzureAccountModule {
  static Future<Map<String, dynamic>> saveClientAccount({
    required String id, required String parentClient,
    required String calledName, required bool enabled,
  }) async {
    return (await DioClient.post(
      "/api/admin/azure_account/$parentClient/$id",
      data: {
        "called_name": calledName,
        "enable": enabled,
      },
      options: await _adminHeader,
    )).data!;
  }

  static Future<Map<String, dynamic>> getDeviceCode({
    required String id, required String parentClient
  }) async {
    return (await DioClient.get(
      "/api/admin/azure_account/device_code/$parentClient/$id",
      options: await _adminHeader,
    )).data!;
  }

  static Future<Map<String, dynamic>> checkDeviceCode({
    required String id, required String parentClient,
    required String tag
  }) async {
    return (await DioClient.post(
      "/api/admin/azure_account/check_code/$parentClient/$id",
      data: { "tag": tag },
      options: await _adminHeader,
    )).data!;
  }

  static Future<Map<String, dynamic>> deleteAzureAccount({
    required String id, required String parentClient
  }) async {
    return (await DioClient.post(
      "/api/admin/azure_account/delete/$parentClient/$id",
      options: await _adminHeader,
    )).data!;
  }

  static Future<Map<String, dynamic>> defaultAzureAccount({
    required String id, required String parentClient
  }) async {
    return (await DioClient.post(
      "/api/admin/azure_account/default/$parentClient/$id",
      options: await _adminHeader,
    )).data!;
  }
}

class DriveConfigModule {
  static Future<Map<String, dynamic>> saveDriveConfig({
    required String id,
    required String parentClient, required String parentAccount,
    required String calledName, required String dirHome,
    required bool enabled,
  }) async {
    return (await DioClient.post(
      "/api/admin/drive_config/$parentClient/$parentAccount/$id",
      data: {
        "called_name": calledName,
        "dir_home": dirHome,
        "enable": enabled,
      },
      options: await _adminHeader,
    )).data!;
  }

  static Future<Map<String, dynamic>> deleteDriveConfig({
    required String id,
    required String parentClient, required String parentAccount,
  }) async {
    return (await DioClient.post(
      "/api/admin/drive_config/delete/$parentClient/$parentAccount/$id",
      options: await _adminHeader,
    )).data!;
  }

  static Future<Map<String, dynamic>> defaultDriveConfig({
    required String id,
    required String parentClient, required String parentAccount,
  }) async {
    return (await DioClient.post(
      "/api/admin/drive_config/default/$parentClient/$parentAccount/$id",
      options: await _adminHeader,
    )).data!;
  }
}