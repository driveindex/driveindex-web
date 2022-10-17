import 'package:driveindex_web/util/runtime_value.dart';
import 'package:flutter/material.dart';

class DirPasswordScreen extends StatefulWidget {
  final Function onSubmit;

  const DirPasswordScreen({
    Key? key,
    required this.onSubmit
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DirPasswordState();
}

class _DirPasswordState extends State<DirPasswordScreen> {
  final TextEditingController _password = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 400),
      child: Center(
        child: SizedBox(
          width: 360,
          child: Column(
            children: [
              const Text(
                "当前文件已加密！",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _password,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "请输入密码",
                  suffixIcon: IconButton(
                    icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  String password = _password.value.text;
                  if (password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("密码为空！"))
                    );
                    return;
                  }
                  RuntimeValue.FILE_PASSWORD = password;
                  widget.onSubmit();
                },
                child: const SizedBox(
                  width: 80, height: 40,
                  child: Center(
                    child: Text(
                      "提交",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}