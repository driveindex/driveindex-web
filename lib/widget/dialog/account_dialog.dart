import 'dart:async';

import 'package:driveindex_web/module/admin_module.dart';
import 'package:driveindex_web/util/fluro_router.dart';
import 'package:driveindex_web/widget/dialog/message_dialog.dart';
import 'package:driveindex_web/widget/ui/compose_row_column.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountSaveDialog extends StatefulWidget {
  final Function callback;

  final String id;
  final String parentClient;
  final String calledName;
  final bool enabled;

  AccountSaveDialog({
    Key? key,
    required this.callback,
    this.id = "",
    required this.parentClient,
    this.calledName = "",
    this.enabled = true,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool get _validate => _formKey.currentState?.validate() ?? false;

  final TextEditingController _idController = TextEditingController();
  String get _idValue => _idController.value.text;

  final TextEditingController _calledNameController = TextEditingController();
  String get _calledNameValue => _calledNameController.value.text;

  @override
  State<StatefulWidget> createState() => _AccountSaveState();
}

class _AccountSaveState extends State<AccountSaveDialog> {
  @override
  void initState() {
    widget._idController.text = widget.id;
    widget._calledNameController.text = widget.calledName;
    _enabled = widget.enabled;
    super.initState();
  }

  static const double DEVIDE_SIZE = 30;

  bool _enabled = true;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text("添加账号"),
      ),
      content: Container(
        constraints: const BoxConstraints(
          maxWidth: 600, minWidth: 480
        ),
        child: Form(
          key: widget._formKey,
          child: StartColumn(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: widget._idController,
                enabled: widget.id.isEmpty,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "请输入 ID（用于标识该账号）",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "ID 为空！";
                  }
                  RegExp reg = RegExp(r'^\w{4,16}$');
                  if (reg.hasMatch(value)) return null;
                  return "仅支持数字、字母、下划线，且长度为 4 ~ 16 个字符！";
                },
              ),
              const SizedBox(height: DEVIDE_SIZE),
              TextFormField(
                controller: widget._calledNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "请输入代号（显示在网页上的名称）",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "代号为空！";
                  }
                  return null;
                },
              ),
              const SizedBox(height: DEVIDE_SIZE),
              Row(
                children: [
                  Text(_enabled ? "启用" : "禁用"),
                  const SizedBox(width: 40),
                  Switch(
                    value: _enabled,
                    onChanged: (value) {
                      setState(() => _enabled = value);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Fluro.pop(context),
          child: const Text("取消"),
        ),
        TextButton(
          onPressed: () async {
            if (!widget._validate) {
              return;
            }
            Map<String, dynamic> resp = (await AzureAccountModule.saveClientAccount(
              id: widget._idValue,
              calledName: widget._calledNameValue,
              parentClient: widget.parentClient,
              enabled: _enabled,
            ));
            if (resp["code"] == 200) {
              widget.callback();
              return;
            }
            MessageDialog.show(context: context, title: "失败！", message: "保存失败，${resp["message"]}");
          },
          child: const Text("提交"),
        ),
      ],
    );
  }
}

class AccountLoginDialog extends StatefulWidget {
  final String id;
  final String aClient;
  final String calledName;
  final Function callback;

  const AccountLoginDialog({
    Key? key,
    required this.id,
    required this.aClient,
    required this.calledName,
    required this.callback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountLoginState();
}

class _AccountLoginState extends State<AccountLoginDialog> {
  final StreamController<Map<String, dynamic>> _controller = StreamController();
  bool loading = false;
  Map<String, dynamic>? data;

  String? get userCode => data?["data"]["user_code"];
  String? get loginUri => data?["data"]["verification_uri"];

  bool copied = false;

  @override
  void initState() {
    _controller.stream.listen(onData);
    refresh();
    super.initState();
  }

  final StreamController<Map<String, dynamic>> _check = StreamController();
  int _timeout = 900;
  int _timing = 0;
  Duration _duration = const Duration(seconds: 5);
  void onData(Map<String, dynamic> data) async {
    setState(() {
      loading = false;
      this.data = data;
    });
    _timeout = double.parse(data["data"]["expires_in"]).round();
    _duration = Duration(
      seconds: double.parse(data["data"]["interval"]).round()
    );
    _timing = 0;
    _check.stream.listen(onCheck);
    _checkDeviceCode();
  }

  void onCheck(Map<String, dynamic> data) async {
    _timing += _duration.inSeconds;
    int code = data["code"];
    if (code != -3001 && code != 200) {
      return;
    }
    if (code == 200) {
      widget.callback();
    }
    _checkDeviceCode();
  }

  Timer? _checkTimer;
  void _checkDeviceCode() async {
    if (_timing > _timeout) return;
    _checkTimer = Timer(_duration, () async {
      _check.add(await AzureAccountModule.checkDeviceCode(
          id: widget.id, parentClient: widget.aClient,
          tag: data?["data"]["tag"] ?? ""
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text("登录账号到 ”${widget.calledName}“（ID：${widget.id}）"),
      ),
      content: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.passthrough,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "点击跳转登录链接",
                        style: const TextStyle(
                          color: Colors.blueAccent,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          if (loginUri == null) return;
                          launchUrl(
                            Uri.parse(loginUri!),
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      ),
                      const TextSpan(
                        text: "，然后在页面中输入下面的代码并完成登录。",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                child: Text(
                  userCode ?? "获取中...",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 42,
                  ),
                ),
                onTap: () {
                  if (userCode != null) {
                    Clipboard.setData(ClipboardData(text: userCode));
                  }
                  setState(() => copied = true);
                },
              ),
              Text(
                userCode == null ? "" : (copied ? "（已复制）" : "（点击代码即可复制）"),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _checkTimer?.cancel();
            Fluro.pop(context);
          },
          child: const Text("取消"),
        ),
      ],
    );
  }

  void refresh() async {
    setState(() => loading = true);
    _controller.add(await AzureAccountModule.getDeviceCode(
        id: widget.id,
        parentClient: widget.aClient
    ));
  }
}