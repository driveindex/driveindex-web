import 'package:driveindex_web/module/admin_module.dart';
import 'package:driveindex_web/util/fluro_router.dart';
import 'package:driveindex_web/widget/dialog/message_dialog.dart';
import 'package:driveindex_web/widget/ui/compose_row_column.dart';
import 'package:flutter/material.dart';

class AccountSaveDialog extends StatefulWidget {
  final Function callback;

  final String id;
  final String parentClient;
  final String calledName;

  AccountSaveDialog({
    Key? key,
    required this.callback,
    this.id = "",
    required this.parentClient,
    this.calledName = "",
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool get _validate => _formKey.currentState?.validate() ?? false;

  final TextEditingController _idController = TextEditingController();
  String get _idValue => _idController.value.text;

  final TextEditingController _calledNameController = TextEditingController();
  String get _calledNameValue => _calledNameController.value.text;

  @override
  State<StatefulWidget> createState() => _AccountCreationState();
}

class _AccountCreationState extends State<AccountSaveDialog> {
  @override
  void initState() {
    widget._idController.text = widget.id;
    widget._calledNameController.text = widget.calledName;
    super.initState();
  }

  static const double DEVIDE_SIZE = 30;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text("添加账号"),
      ),
      content: Container(
        constraints: const BoxConstraints(
          maxWidth: 600, minWidth: 480,
          maxHeight: double.infinity, minHeight: 300
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
            Map<String, dynamic> resp = (await AdminModule.saveClientAccount(
              id: widget._idValue,
              calledName: widget._calledNameValue,
              parentClient: widget.parentClient,
            ));
            if (resp["code"] == 200) {
              widget.callback();
              _pop();
              return;
            }
            MessageDialog.show(context: context, title: "失败！", message: "保存失败，${resp["message"]}");
          },
          child: const Text("提交"),
        ),
      ],
    );
  }

  void _pop() {
    Fluro.pop(context);
  }
}