import 'package:driveindex_web/module/admin_module.dart';
import 'package:driveindex_web/util/fluro_router.dart';
import 'package:driveindex_web/widget/dialog/message_dialog.dart';
import 'package:driveindex_web/widget/ui/compose_row_column.dart';
import 'package:flutter/material.dart';

class ClientSaveDialog extends StatefulWidget {
  final Function callback;

  final String id;
  final String calledName;
  final String clientId;
  final bool enabled;

  ClientSaveDialog({
    Key? key,
    required this.callback,
    this.id = "",
    this.calledName = "",
    this.clientId = "",
    this.enabled = true,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool get _validate => _formKey.currentState?.validate() ?? false;

  final TextEditingController _idController = TextEditingController();
  String get _idValue => _idController.value.text;

  final TextEditingController _calledNameController = TextEditingController();
  String get _calledNameValue => _calledNameController.value.text;

  final TextEditingController _clientIdController = TextEditingController();
  String get _clientIdValue => _clientIdController.value.text;

  @override
  State<StatefulWidget> createState() => _ClientCreationState();
}

class _ClientCreationState extends State<ClientSaveDialog> {
  @override
  void initState() {
    widget._idController.text = widget.id;
    widget._calledNameController.text = widget.calledName;
    widget._clientIdController.text = widget.clientId;
    _enabled = widget.enabled;
    super.initState();
  }

  static const double DEVIDE_SIZE = 30;

  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: widget.id.isEmpty
            ? const Text("添加新的 Azure 应用程序")
            : const Text("编辑 Azure 应用程序"),
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
                  labelText: "请输入 ID（用于标识该 Azure 应用程序）",
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
              TextFormField(
                controller: widget._clientIdController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "请输入 Azure 应用程序 ID（Client ID）",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Client ID 为空！";
                  }
                  RegExp reg = RegExp(r'[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}');
                  if (reg.hasMatch(value)) return null;
                  return "请检查您输入的 Client ID！";
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
            Map<String, dynamic> resp = (await AzureClientModule.saveAzureClient(
              id: widget._idValue,
              calledName: widget._calledNameValue,
              clientId: widget._clientIdValue,
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