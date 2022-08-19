import 'package:driveindex_web/module/dio_client.dart';
import 'package:flutter/material.dart';

class FileModule {
  static Future<Map<String, dynamic>> getFile(String? client, String? account,
      String? drive, String path, String? password,
      int? pageSize, int? pageIndex) async {
    Map<String, dynamic> parameters = getParameters(client, account, drive, path, password);
    if (pageSize != null) parameters["page_size"] = pageSize;
    if (pageIndex != null) parameters["page_index"] = pageIndex;
    return (await DioClient.get(
      "/api/azure/file",
      parameters: parameters,
    )).data!;
  }

  static Future<String?> download(String? client, String? account,
      String? drive, String path, String? password) async {
    Map<String, dynamic> data = getParameters(client, account, drive, path, password);
    data["direct"] = false;
    Map<String, dynamic> resp = (await DioClient.get(
      "/download",
      parameters: data,
    )).data!;
    if (resp["code"] != 200) return null;
    return (await DioClient.getContent(resp["data"])).data;
  }

  static Map<String, dynamic> getParameters(String? client, String? account,
      String? drive, String path, String? password) {
    Map<String, dynamic> parameters = {};
    parameters["path"] = path;
    if (client != null) parameters["client"] = client;
    if (account != null) parameters["account"] = account;
    if (drive != null) parameters["drive"] = drive;
    if (password != null) parameters["password"] = password;
    return parameters;
  }

  static IconData getItemIcon(String? mineType) {
    if (mineType == null) return Icons.arrow_upward;

    switch(mineType) {
      case "directory": return Icons.folder;
    }
    return Icons.text_snippet;
  }
}