import 'package:driveindex_web/module/file_module.dart';
import 'package:driveindex_web/util/canonical_path.dart';
import 'package:driveindex_web/util/size_caculate.dart';
import 'package:driveindex_web/util/timestamp_wrapper.dart';
import 'package:driveindex_web/widget/ui/compose_row_column.dart';
import 'package:driveindex_web/widget/ui/page_indicator.dart';
import 'package:flutter/material.dart';

typedef ContentResolver = Future<String?> Function(String item);

class DirList extends StatelessWidget {
  final Map<String, dynamic> list;
  final CanonicalPath currentPath;
  final int totalPage;
  final int totalCount;
  final int currentPage;
  final Function(String item)? onPush;
  final Function? onPop;
  final Function(int pageIndex) onJumpTo;

  const DirList({
    Key? key,
    required this.totalPage,
    required this.totalCount,
    required this.currentPage,
    required this.currentPath,
    required this.list,
    required this.onJumpTo,
    this.onPush,
    this.onPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardColumn(
          elevation: 1,
          children: _buildList(),
        ),
        const SizedBox(height: 20),
        PageIndicator(
          totalPage: totalPage,
          totalCount: totalCount,
          currentPage: currentPage,
          onJumpTo: onJumpTo,
        ),
      ],
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
      // SizedBox(
      //   width: 150,
      //   child: Text(TimestampWrapper.of(value["info"]["modified_time"])),
      // ),
      // SizedBox(
      //   width: 80,
      //   child: Text(SizeWrapper.of(value["info"]["size"])),
      // ),
    ];
  }
}