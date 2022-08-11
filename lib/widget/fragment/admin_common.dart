import 'package:dio/dio.dart';
import 'package:driveindex_web/module/admin_module.dart';
import 'package:driveindex_web/module/dio_client.dart';
import 'package:driveindex_web/widget/ui/start_column.dart';
import 'package:flutter/material.dart';
import 'package:tree_view/tree_view.dart';

class AdminCommonFragment extends StatefulWidget {
  const AdminCommonFragment({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminCommonFragmentState();
}

class _AdminCommonFragmentState extends State<AdminCommonFragment> {
  @override
  Widget build(BuildContext context) {
    return StartColumn(
      children: [
        const Text(
          "Azure 驱动器管理",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        StartRow(
          children: [
            Card(
              child: FutureBuilder(
                future: AdminCommonModule.getAzureClient(),
                builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> data) {
                  return TreeView(
                    children: _getAzureClientWidget(data.data?["data"]),
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  List<TreeViewChild> _getAzureClientWidget(List<Map<String, dynamic>>? client) {
    List<TreeViewChild> widgets = [];
    if (client != null) {
      for (var value in client) {
        widgets.add(
          TreeViewChild(
            parent: Text(value["called_name"]),
            children: _getAzureAccountsWidget(value["child"]),
          ),
        );
      }
    }
    widgets.add(
      TreeViewChild(
        parent: const Text("添加"),
        children: const [],
      ),
    );
    return widgets;
  }

  List<TreeViewChild> _getAzureAccountsWidget(List<Map<String, dynamic>>? accounts) {
    List<TreeViewChild> widgets = [];
    if (accounts != null) {
      for (var value in accounts) {
        widgets.add(
          TreeViewChild(
            parent: Text(value["called_name"]),
            children: _getAzureDrivesWidget(value["child"]),
          ),
        );
      }
    }
    widgets.add(
      TreeViewChild(
        parent: const Text("添加"),
        children: const [],
      ),
    );
    return widgets;
  }

  List<Widget> _getAzureDrivesWidget(List<Map<String, dynamic>> drives) {
    List<Widget> widgets = [];
    for (var value in drives) {
      widgets.add(
        Text(value["called_name"]),
      );
    }
    widgets.add(
      const Text("添加"),
    );
    return widgets;
  }
}

