import 'package:dio/dio.dart';
import 'package:driveindex_web/module/login_module.dart';
import 'package:driveindex_web/util/config_manager.dart';
import 'package:driveindex_web/util/fluro_router.dart';
import 'package:flutter/material.dart';
import 'package:log4f/log4f.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LoginScreen extends StatefulWidget {
  static get handler => (BuildContext? context, Map<String, List<String>> params) {
    return const LoginScreen();
  };

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _password = TextEditingController();
  bool _passwordVisible = false;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    ConfigManager.HAS_LOGIN = Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      maxWidth: 500,
      alignment: Alignment.center,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 400),
        child: Card(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      "DriveIndex",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _password,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "请输入管理员密码",
                        suffixIcon: IconButton(
                          icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      enabled: !_loading,
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () {
                        if (_loading) return;
                        String password = _password.value.text;
                        if (password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("密码为空！"))
                          );
                          return;
                        }
                        _login(password, (String token) {
                          ConfigManager.HAS_LOGIN = Future.value(true);
                          ConfigManager.ADMIN_TOKEN = Future.value(token);
                          Fluro.navigateTo(context, "/admin");
                        });
                        setState(() {
                          _loading = true;
                        });
                      },
                      child: const SizedBox(
                        width: 80, height: 40,
                        child: Center(
                          child: Text(
                            "登录",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  void _login(String password, Function(String) onSuccess) async {
    ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);
    try {
      Map<String, dynamic> resp = await LoginModule.login(password: password);
      if (resp["code"] == 200) {
        onSuccess(resp["data"]["token"]);
        return;
      }
      scaffold.showSnackBar(
        SnackBar(content: Text("登录失败，${resp["message"]}")),
      );
    } on DioError catch (e) {
      Log4f.d(tag: "login_page.dart", msg: e.message);
      scaffold.showSnackBar(
        SnackBar(content: Text("登录失败，${e.message}")),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }
}