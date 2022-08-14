import 'package:driveindex_web/module/admin_module.dart';
import 'package:driveindex_web/util/fluro_router.dart';
import 'package:driveindex_web/widget/dialog/message_dialog.dart';
import 'package:driveindex_web/widget/ui/compose_row_column.dart';
import 'package:flutter/material.dart';

class DriveSaveDialog extends StatefulWidget {
  final Function callback;

  final String id;
  final String parentClient;
  final String parentAccount;
  final String calledName;
  final String dirHome;
  final bool enabled;

  DriveSaveDialog({
    Key? key,
    required this.callback,
    this.id = "",
    required this.parentClient,
    required this.parentAccount,
    this.calledName = "",
    this.dirHome = "",
    this.enabled = true,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool get _validate => _formKey.currentState?.validate() ?? false;

  final TextEditingController _idController = TextEditingController();
  String get _idValue => _idController.value.text;

  final TextEditingController _calledNameController = TextEditingController();
  String get _calledNameValue => _calledNameController.value.text;

  final TextEditingController _dirHomeController = TextEditingController();
  String get _dirHomeValue => _dirHomeController.value.text;

  @override
  State<StatefulWidget> createState() => _DriveCreationState();
}

class _DriveCreationState extends State<DriveSaveDialog> {
  @override
  void initState() {
    widget._idController.text = widget.id;
    widget._calledNameController.text = widget.calledName;
    widget._dirHomeController.text = widget.dirHome;
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
                  labelText: "请输入 ID（用于标识该配置）",
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
                controller: widget._dirHomeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "请输入起始目录",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "起始目录为空！若不做目录限制则无需添加配置。";
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
            Map<String, dynamic> resp = (await DriveConfigModule.saveDriveConfig(
              id: widget._idValue,
              parentClient: widget.parentClient,
              parentAccount: widget.parentAccount,
              calledName: widget._calledNameValue,
              dirHome: widget._dirHomeValue,
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