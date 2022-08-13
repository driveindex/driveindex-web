import 'dart:async';

import 'package:driveindex_web/module/admin_module.dart';
import 'package:driveindex_web/util/fluro_router.dart';
import 'package:driveindex_web/widget/dialog/client_dialog.dart';
import 'package:driveindex_web/widget/dialog/confirm_dialog.dart';
import 'package:driveindex_web/widget/dialog/message_dialog.dart';
import 'package:driveindex_web/widget/ui/compose_row_column.dart';
import 'package:flutter/material.dart';

class AdminCommonFragment extends StatefulWidget {
  const AdminCommonFragment({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminCommonFragmentState();
}

class _AdminCommonFragmentState extends State<AdminCommonFragment> {
  int refreshFlag = 0;

  final StreamController<Map<String, dynamic>> _controller = StreamController();

  bool loading = false;
  Map<String, dynamic>? data;

  @override
  void initState() {
    _controller.stream.listen(onData);
    refresh();
    super.initState();
  }

  void onData(Map<String, dynamic> data) {
    setState(() {
      loading = false;
      this.data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StartColumn(
      children: [
        const Text(
          "Azure 驱动器管理",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        Card(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 400, minWidth: double.infinity),
            child: Stack(
              children: [
                StartColumn(
                  children: _getAzureClientWidget(data?["data"]),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: FloatingActionButton(
                      onPressed: _createNewClient,
                      child: const Icon(Icons.add),
                    ),
                  ),
                ),
                Visibility(
                  visible: loading,
                  child: Container(
                    color: const Color.fromARGB(150, 255, 255, 255),
                    child: const Center(
                      child: CircularProgressIndicator(value: null),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void refresh() async {
    setState(() => loading = true);
    _controller.add(await AdminModule.getAzureClient());
  }

  void _createNewClient() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ClientSaveDialog(callback: refresh);
      }
    );
  }

  static const double ICON_SIZE = 20;
  static const EdgeInsets CHILD_PADDING = EdgeInsets.symmetric(horizontal: 14);

  List<Widget> _getAzureClientWidget(List<dynamic>? client) {
    List<Widget> widgets = [];
    if (client != null) {
      setState(() => loading = false);
      for (Map<String, dynamic> value in client) {
        Map<String, dynamic> detail = value["detail"];
        String title = "应用 “${detail["called_name"]}”（应用 ID：${value["id"]}）";
        widgets.add(
          ExpansionTile(
            childrenPadding: CHILD_PADDING,
            leading: IconButton(
              onPressed: () {
                if (value["is_default"]) return;
                ConfirmDialog.show(
                  context: context,
                  message: "确定要将$title设为默认吗？",
                  onConfirm: () async {
                    Map<String, dynamic> resp = await AdminModule.defaultAzureClient(value["id"]);
                    if (resp["code"] != 200) {
                      MessageDialog.show(context: context, title: "失败！", message: "设置默认失败，${resp["message"]}");
                    } else {
                      refresh(); _pop();
                    }
                  },
                );
              },
              iconSize: ICON_SIZE,
              icon: value["is_default"]
                  ? const Icon(Icons.star)
                  : const Icon(Icons.star_border),
            ),
            title: Row(
              children: [
                TextBaselineRow(
                  children: [
                    Text(detail["called_name"]),
                    Text(
                      "（应用 ID：${value["id"]}）",
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showDialog(context: context, builder: (BuildContext context) {
                      return ClientSaveDialog(
                        id: value["id"],
                        calledName: detail["called_name"],
                        clientId: detail["client_id"],
                        clientSecret: detail["client_secret"],
                        callback: refresh,
                      );
                    });
                  },
                  iconSize: ICON_SIZE,
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {

                  },
                  iconSize: ICON_SIZE,
                  icon: const Icon(Icons.add),
                ),
                IconButton(
                  onPressed: () {
                    ConfirmDialog.show(
                      context: context,
                      title: "确认删除？",
                      message: "确定删除$title吗？",
                      onConfirm: () async {
                        Map<String, dynamic> resp = await AdminModule.deleteAzureClient(value["id"]);
                        if (resp["code"] != 200) {
                          MessageDialog.show(context: context, title: "失败！", message: "删除失败，${resp["message"]}");
                        } else {
                          refresh(); _pop();
                        }
                      },
                    );
                  },
                  iconSize: ICON_SIZE,
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            children: _getAzureAccountsWidget(value["id"], value["child"]),
          ),
        );
      }
    }
    return widgets;
  }

  List<Widget> _getAzureAccountsWidget(String aClient, List<dynamic>? accounts) {
    List<Widget> widgets = [];
    if (accounts != null) {
      for (Map<String, dynamic> value in accounts) {
        Map<String, dynamic> detail = value["detail"];
        widgets.add(
          ExpansionTile(
            childrenPadding: CHILD_PADDING,
            title: TextBaselineRow(
              children: [
                Text(detail["called_name"]),
                Text(
                  "（账号 ID：${value["id"]}）",
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {

                  },
                  iconSize: ICON_SIZE,
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {

                  },
                  iconSize: ICON_SIZE,
                  icon: const Icon(Icons.add),
                ),
                IconButton(
                  onPressed: () {

                  },
                  iconSize: ICON_SIZE,
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            children: _getAzureDrivesWidget(aClient, value["id"], value["child"]),
          ),
        );
      }
    }
    return widgets;
  }

  List<Widget> _getAzureDrivesWidget(String aClient, String aAccount, List<dynamic> drives) {
    List<Widget> widgets = [];
    for (Map<String, dynamic> value in drives) {
      Map<String, dynamic> detail = value["detail"];
      widgets.add(
        TextBaselineRow(
          children: [
            Text(detail["called_name"]),
            Text(
              "（配置 ID：${value["id"]}）",
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {

              },
              iconSize: ICON_SIZE,
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {

              },
              iconSize: ICON_SIZE,
              icon: const Icon(Icons.delete),
            ),
          ],
        )
      );
    }
    return widgets;
  }

  void _pop() {
    Fluro.pop(context);
  }
}

