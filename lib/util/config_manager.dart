// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class ConfigManager {
  static final Future<SharedPreferences> _config = SharedPreferences.getInstance();

  static const _HAS_LOGIN = "has_login";
  static Future<bool> get HAS_LOGIN =>
      _config.then((value) => value.getBool(_HAS_LOGIN) ?? false);
  static set HAS_LOGIN(Future<bool> value) =>
      value.then((value) => _config.then((shared) => shared.setBool(_HAS_LOGIN, value)));

  static const _ADMIN_TOKEN = "token";
  static Future<String> get ADMIN_TOKEN =>
      _config.then((value) => value.getString(_ADMIN_TOKEN) ?? "");
  static set ADMIN_TOKEN(Future<String> value) =>
      value.then((value) => _config.then((shared) => shared.setString(_ADMIN_TOKEN, value)));
}