import 'package:dio/dio.dart';
import 'package:driveindex_web/module/dio_client.dart';
import 'package:driveindex_web/util/config_manager.dart';
import 'package:json_annotation/json_annotation.dart';

class AdminModule {
  static Future<Map<String, dynamic>> checkLogin() async {
    return (await DioClient.get(
      "/api/admin/token_state",
      options: await _adminHeader,
    )).data!;
  }

  static Future<Map<String, dynamic>> getAzureClient() async {
    return (await DioClient.get(
      "/api/admin/azure_client",
      options: await _adminHeader,
    )).data!;
  }

  static Future<Map<String, dynamic>> saveAzureClient({
    required String id, required String calledName,
    required String clientId, required String clientSecret,
  }) async {
    return (await DioClient.post(
      "/api/admin/azure_client/$id",
      data: {
        "client_id": clientId,
        "client_secret": clientSecret,
        "called_name": calledName,
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

  static Future<Map<String, dynamic>> saveClientAccount({
    required String id, required String parentClient,
    required String calledName,
  }) async {
    return (await DioClient.post(
      "/api/admin/azure_account/$parentClient/$id",
      data: {
        "called_name": calledName,
      },
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

  static Future<Options> get _adminHeader async => Options(
    headers: {
      "DriveIndex-Authentication": (await ConfigManager.ADMIN_TOKEN)
    }
  );
}

typedef AdminTreeResponse = RequestResult<List<AzureClient>>;

abstract class CommonDetail {
  final String id;
  final String calledName;

  CommonDetail({
    required this.id,
    required this.calledName,
  });
}

@JsonSerializable()
class AzureClient extends CommonDetail {
  final List<AzureAccount> child;

  AzureClient({
    required super.id,
    required super.calledName,
    required this.child,
  });
}

@JsonSerializable()
class AzureAccount extends CommonDetail {
  final List<DriveConfig> child;

  AzureAccount({
    required super.id,
    required super.calledName,
    required this.child,
  });
}

class DriveConfig extends CommonDetail {
  final String dirHome;

  DriveConfig({
    required super.id,
    required super.calledName,
    required this.dirHome,
  });
}