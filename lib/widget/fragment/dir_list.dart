import 'package:driveindex_web/module/file_module.dart';
import 'package:driveindex_web/util/canonical_path.dart';
import 'package:driveindex_web/widget/ui/compose_row_column.dart';
import 'package:flutter/material.dart';

typedef ContentResolver = Future<String?> Function(String item);

class DirList extends StatelessWidget {
  final Map<String, dynamic> list;
  final CanonicalPath currentPath;
  final int totalPage;
  final int totalCount;
  final Function(String item)? onPush;
  final Function? onPop;

  const DirList({
    Key? key,
    required this.totalPage,
    required this.totalCount,
    required this.currentPath,
    required this.list,
    this.onPush,
    this.onPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: CardColumn(
        elevation: 1,
        children: _buildList(),
      ),
    );
  }

  static const Widget LIST_DEVIDER = SizedBox(height: 5, width: 5);
  List<Widget> _buildList() {
    List<Widget> widgets = [];
    if (currentPath.getPath() != CanonicalPath.ROOT_PATH) {
      widgets.add(_createSingleItem(null));
    }
    List<dynamic> list = this.list.values.toList();
    for (Map<String, dynamic> value in list) {
      widgets.add(_createSingleItem(value));
    }
    return widgets;
  }

  Widget _createSingleItem(Map<String, dynamic>? value) {
    return InkWell(
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(FileModule.getItemIcon(value?["mine_type"])),
              LIST_DEVIDER,
              TextBaselineRow(
                children: _createItemTitle(value),
              )
            ],
          ),
        ),
      ),
      onTap: () => value != null
          ? onPush?.call(value["name"])
          : onPop?.call(),
    );
  }

  List<Widget> _createItemTitle(Map<String, dynamic>? value) {
    if (value == null) {
      return [
        const Text("..."),
      ];
    }
    return [
      Text(value["name"]),

    ];
  }
}