import 'package:dio/dio.dart';
import 'package:driveindex_web/module/dio_client.dart';
import 'package:driveindex_web/util/config_manager.dart';
import 'package:json_annotation/json_annotation.dart';

class AdminCommonModule {
  static Future<Map<String, dynamic>> getAzureClient() async {
    return (await DioClient.get(
      "/api/admin/azure_client",
      options: await _adminHeader
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