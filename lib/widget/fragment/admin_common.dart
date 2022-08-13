import 'package:driveindex_web/module/admin_module.dart';
import 'package:driveindex_web/widget/ui/start_column.dart';
import 'package:flutter/material.dart';

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
        Card(
          child: FutureBuilder(
            future: AdminModule.getAzureClient(),
            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> data) {
              return StartColumn(
                children: _getAzureClientWidget(data.data?["data"]),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _getAzureClientWidget(List<dynamic>? client) {
    List<Widget> widgets = [];
    if (client != null) {
      for (Map<String, dynamic> value in client) {
        widgets.add(
          ExpansionTile(
            title: Text(value["called_name"]),
            children: _getAzureAccountsWidget(value["child"]),
          ),
        );
      }
    }
    widgets.add(
      const Text("添加"),
    );
    return widgets;
  }

  List<Widget> _getAzureAccountsWidget(List<dynamic>? accounts) {
    List<Widget> widgets = [];
    if (accounts != null) {
      for (Map<String, dynamic> value in accounts) {
        widgets.add(
          ExpansionTile(
            title: Text(value["called_name"]),
            children: _getAzureDrivesWidget(value["child"]),
          ),
        );
      }
    }
    widgets.add(
      const Text("添加"),
    );
    return widgets;
  }

  List<Widget> _getAzureDrivesWidget(List<dynamic> drives) {
    List<Widget> widgets = [];
    for (Map<String, dynamic> value in drives) {
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

