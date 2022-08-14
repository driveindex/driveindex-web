import 'package:dio/dio.dart';
import 'package:driveindex_web/module/admin_module.dart';
import 'package:driveindex_web/util/fluro_router.dart';
import 'package:flutter/material.dart';

class AdminPasswordFragment extends StatefulWidget {
  const AdminPasswordFragment({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminPasswordFragmentState();
}

class _AdminPasswordFragmentState extends State<AdminPasswordFragment> {
  final TextEditingController _passwordOld = TextEditingController();
  bool _passwordVisibleOld = false;
  String? _passwordOldError = null;

  final TextEditingController _passwordNew = TextEditingController();
  bool _passwordVisibleNew = false;
  String? _passwordNewError = null;

  final TextEditingController _passwordRepeat = TextEditingController();
  bool _passwordVisibleRepeat = false;
  String? _passwordRepeatError = null;

  bool _loading = false;

  static const double divideSize = 30;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _passwordOld,
          obscureText: !_passwordVisibleOld,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: "请输入旧密码",
            suffixIcon: IconButton(
              icon: Icon(_passwordVisibleOld ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _passwordVisibleOld = !_passwordVisibleOld;
                });
              },
            ),
            errorText: _passwordOldError,
          ),
          enabled: !_loading,
        ),
        const SizedBox(height: divideSize),
        TextField(
          controller: _passwordNew,
          obscureText: !_passwordVisibleNew,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: "请输入新密码",
            suffixIcon: IconButton(
              icon: Icon(_passwordVisibleNew ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _passwordVisibleNew = !_passwordVisibleNew;
                });
              },
            ),
            errorText: _passwordNewError,
          ),
          enabled: !_loading,
        ),
        const SizedBox(height: divideSize),
        TextField(
          controller: _passwordRepeat,
          obscureText: !_passwordVisibleRepeat,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: "请再次输入新密码",
            suffixIcon: IconButton(
              icon: Icon(_passwordVisibleRepeat ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _passwordVisibleRepeat = !_passwordVisibleRepeat;
                });
              },
            ),
            errorText: _passwordRepeatError,
          ),
          enabled: !_loading,
        ),
        const SizedBox(height: divideSize),
        ElevatedButton(
          onPressed: () {
            if (_loading) return;
            String old = _passwordOld.value.text;
            String newPass = _passwordNew.value.text;
            String repeat = _passwordRepeat.value.text;
            setState(() {
              _passwordOldError = old.isEmpty ? "旧密码为空！" : null;
              _passwordNewError = newPass.isEmpty ? "新密码为空！" : null;
              _passwordRepeatError = (newPass != repeat) ? "两次密码不一致" : null;
            });
            if (_passwordOldError != null || _passwordNewError != null
                || _passwordRepeatError != null) return;
            setState(() {
              _loading = true;
            });
            _setPassword(old, newPass, repeat, _onPasswordChanged);
          },
          child: const SizedBox(
            width: 120, height: 40,
            child: Center(
              child: Text(
                  "提交", style: TextStyle(fontSize: 16)
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _setPassword(String old, String newPass, String repeat, Function onSuccess) async {
    ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);
    try {
      Map<String, dynamic> resp = await AdminCommonModule.changePassword(old, newPass, repeat);
      if (resp["code"] == 200) {
        onSuccess();
        return;
      }
      if (resp["code"] == -1001) {
        setState(() {
          _passwordOldError = resp["message"];
        });
        return;
      }
      if (resp["code"] == -1002) {
        setState(() {
          _passwordRepeatError = resp["message"];
        });
        return;
      }
      scaffold.showSnackBar(
          SnackBar(content: Text("密码修改失败，${resp["message"]}"))
      );
    } on DioError catch (e) {
      scaffold.showSnackBar(
          SnackBar(content: Text("密码修改失败，${e.message}"))
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _onPasswordChanged() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text("成功！"),
          ),
          content: const Text("密码修改成功，将自动跳转至登录页面重新登陆。"),
          actions: [
            TextButton(
              onPressed: () => Fluro.navigateTo(context, "/login"),
              child: const Text("我知道了"),
            )
          ],
        );
      },
    );
  }
}