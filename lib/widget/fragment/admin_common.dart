import 'dart:async';

import 'package:driveindex_web/module/admin_module.dart';
import 'package:driveindex_web/util/fluro_router.dart';
import 'package:driveindex_web/widget/dialog/account_dialog.dart';
import 'package:driveindex_web/widget/dialog/client_dialog.dart';
import 'package:driveindex_web/widget/dialog/confirm_dialog.dart';
import 'package:driveindex_web/widget/dialog/drive_dialog.dart';
import 'package:driveindex_web/widget/dialog/message_dialog.dart';
import 'package:driveindex_web/widget/ui/compose_row_column.dart';
import 'package:driveindex_web/widget/ui/loading_cover.dart';
import 'package:flutter/material.dart';

class AdminCommonFragment extends StatefulWidget {
  const AdminCommonFragment({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminCommonFragmentState();
}

class _AdminCommonFragmentState extends State<AdminCommonFragment> {
  final StreamController<Map<String, dynamic>> _controller = StreamController();

  bool _loading = false;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    _controller.stream.listen(onData);
    _refresh();
    super.initState();
  }

  void onData(Map<String, dynamic> data) {
    setState(() {
      _loading = false;
      _data = data;
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
                  children: _getAzureClientWidget(_data?["data"]),
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
                LoadingCover(visible: _loading),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _refresh() async {
    setState(() => _loading = true);
    _controller.add(await AzureClientModule.getAzureClient());
  }

  void _createNewClient() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ClientSaveDialog(callback: () {
          _refresh(); _pop();
        });
      }
    );
  }

  static const double ICON_SIZE = 20;
  static const double SUBTITLE_SIZE = 12;
  static const EdgeInsets CHILD_PADDING = EdgeInsets.symmetric(horizontal: 10);

  List<Widget> _getAzureClientWidget(List<dynamic>? client) {
    List<Widget> widgets = [];
    if (client != null) {
      setState(() => _loading = false);
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
                    Map<String, dynamic> resp = await AzureClientModule.defaultAzureClient(value["id"]);
                    if (resp["code"] != 200) {
                      MessageDialog.show(context: context, title: "失败！", message: "设置默认失败，${resp["message"]}");
                    } else {
                      _refresh(); _pop();
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
                StartColumn(
                  children: [
                    Text(
                      detail["called_name"],
                      style: !detail["enable"] ? const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey
                      ) : null,
                    ),
                    Text(
                      "应用 ID：${value["id"]}",
                      style: const TextStyle(
                        fontSize: SUBTITLE_SIZE,
                        color: Colors.grey,
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
                        enabled: detail["enable"],
                        callback: () {
                          _refresh(); _pop();
                        },
                      );
                    });
                  },
                  iconSize: ICON_SIZE,
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(context: context, builder: (BuildContext context) {
                      return AccountSaveDialog(
                        callback: () {
                          _refresh(); _pop();
                        },
                        parentClient: value["id"],
                      );
                    });
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
                        Map<String, dynamic> resp = await AzureClientModule.deleteAzureClient(value["id"]);
                        if (resp["code"] != 200) {
                          MessageDialog.show(context: context, title: "失败！", message: "删除失败，${resp["message"]}");
                        } else {
                          _refresh(); _pop();
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
                    Map<String, dynamic> resp = await AzureAccountModule.defaultAzureAccount(
                      id: value["id"], parentClient: aClient
                    );
                    if (resp["code"] != 200) {
                      MessageDialog.show(context: context, title: "失败！", message: "设置默认失败，${resp["message"]}");
                    } else {
                      _refresh(); _pop();
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
                    StartColumn(
                      children: [
                        Text(
                          detail["called_name"],
                          style: !detail["enable"] ? const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey
                          ) : null,
                        ),
                        Text(
                          "账号 ID：${value["id"]}",
                          style: const TextStyle(
                            fontSize: SUBTITLE_SIZE,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showDialog(context: context, builder: (BuildContext context) {
                      return AccountSaveDialog(
                        callback: () {
                          _refresh(); _pop();
                        },
                        id: value["id"],
                        parentClient: aClient,
                        enabled: detail["enable"],
                        calledName: detail["called_name"],
                      );
                    });
                  },
                  iconSize: ICON_SIZE,
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(context: context, builder: (BuildContext context) {
                      if (detail["need_login"]) {
                        return AccountLoginDialog(
                          id: value["id"],
                          aClient: aClient,
                          calledName: detail["called_name"],
                          callback: () {
                            _refresh(); _pop();
                          },
                        );
                      } else {
                        return DriveSaveDialog(
                          parentClient: aClient,
                          parentAccount: value["id"],
                          callback: () {
                            _refresh(); _pop();
                          },
                        );
                      }
                    });
                  },
                  iconSize: ICON_SIZE,
                  icon: Icon(detail["need_login"] ? Icons.login : Icons.add),
                ),
                IconButton(
                  onPressed: () {
                    ConfirmDialog.show(
                      context: context,
                      title: "确认删除？",
                      message: "确定删除$title吗？",
                      onConfirm: () async {
                        Map<String, dynamic> resp = await AzureAccountModule.deleteAzureAccount(
                          id: value["id"], parentClient: aClient
                        );
                        if (resp["code"] != 200) {
                          MessageDialog.show(context: context, title: "失败！", message: "删除失败，${resp["message"]}");
                        } else {
                          _refresh(); _pop();
                        }
                      },
                    );
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
      String title = "配置 “${detail["called_name"]}”（配置 ID：${value["id"]}）";
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  if (value["is_default"]) return;
                  ConfirmDialog.show(
                    context: context,
                    message: "确定要将$title设为默认吗？",
                    onConfirm: () async {
                      Map<String, dynamic> resp = await AzureAccountModule.defaultAzureAccount(
                          id: value["id"], parentClient: aClient
                      );
                      if (resp["code"] != 200) {
                        MessageDialog.show(context: context, title: "失败！", message: "设置默认失败，${resp["message"]}");
                      } else {
                        _refresh(); _pop();
                      }
                    },
                  );
                },
                iconSize: ICON_SIZE,
                icon: value["is_default"]
                    ? const Icon(Icons.star)
                    : const Icon(Icons.star_border),
              ),
              StartColumn(
                children: [
                  Text(
                    detail["called_name"],
                    style: !detail["enable"] ? const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey
                    ) : null,
                  ),
                  Text(
                    "配置 ID：${value["id"]}",
                    style: const TextStyle(
                      fontSize: SUBTITLE_SIZE,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  showDialog(context: context, builder: (BuildContext context) {
                    return DriveSaveDialog(
                      id: value["id"],
                      parentClient: aClient,
                      parentAccount: aAccount,
                      calledName: detail["called_name"],
                      dirHome: detail["dir_home"],
                      enabled: detail["enable"],
                      callback: () {
                        _refresh(); _pop();
                      },
                    );
                  });
                },
                iconSize: ICON_SIZE,
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {
                  ConfirmDialog.show(
                    context: context,
                    title: "确认删除？",
                    message: "确定删除$title吗？",
                    onConfirm: () async {
                      Map<String, dynamic> resp = await DriveConfigModule.deleteDriveConfig(
                        id: value["id"], parentClient: aClient, parentAccount: aAccount,
                      );
                      if (resp["code"] != 200) {
                        MessageDialog.show(context: context, title: "失败！", message: "删除失败，${resp["message"]}");
                      } else {
                        _refresh(); _pop();
                      }
                    },
                  );
                },
                iconSize: ICON_SIZE,
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  void _pop() {
    Fluro.pop(context);
  }
}

