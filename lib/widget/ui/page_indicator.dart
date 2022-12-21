import 'package:driveindex_web/widget/ui/compose_row_column.dart';
import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int totalPage;
  final int totalCount;
  final int currentPage;
  final int pageSize;
  final Function(int pageIndex, int pageSize) onJumpTo;

  const PageIndicator({
    Key? key,
    required this.totalPage,
    required this.totalCount,
    required this.currentPage,
    required this.pageSize,
    required this.onJumpTo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextBaselineRow(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text("每页"),
            const SizedBox(width: 10),
            DropdownButton(
              value: pageSize,
              items: const [
                DropdownMenuItem(value: 20, child: Text("20")),
                DropdownMenuItem(value: 50, child: Text("50")),
                DropdownMenuItem(value: 100, child: Text("100")),
              ],
              onChanged: (value) {
                if (value != null) onJumpTo(0, value);
              },
            ),
            const SizedBox(width: 10),
            Text("条记录，共 $totalCount 条"),
          ],
        ),
        Visibility(
          visible: totalPage > 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _createIndicator(context),
          ),
        ),
      ],
    );
  }

  List<Widget> _createIndicator(BuildContext context) {
    List<Widget> widgets = [];

    if (currentPage > 0) {
      widgets.add(InkWell(
        child: const Icon(
          Icons.keyboard_arrow_left,
          size: 34,
        ),
        onTap: () => {
          onJumpTo(currentPage - 1, pageSize)
        },
      ));
    }

    List<int> indexes = [];
    widgets.add(_createIndicatorItem(context, 1));
    indexes.add(1);

    widgets.add(_createIndicatorItem(context, 2));
    indexes.add(2);

    if (currentPage - 1 > 3 && !indexes.contains(currentPage - 1)) {
      widgets.add(const Text("..."));
    }
    if (currentPage > 0 && !indexes.contains(currentPage)) {
      widgets.add(_createIndicatorItem(context, currentPage));
      indexes.add(currentPage);
    }
    if (currentPage + 1 <= totalPage && !indexes.contains(currentPage + 1)) {
      widgets.add(_createIndicatorItem(context, currentPage + 1));
      indexes.add(currentPage + 1);
    }
    if (currentPage + 2 <= totalPage && !indexes.contains(currentPage + 2)) {
      widgets.add(_createIndicatorItem(context, currentPage + 2));
      indexes.add(currentPage + 2);
    }
    if (currentPage + 2 < totalPage - 2 && !indexes.contains(currentPage + 2)) {
      widgets.add(const Text("..."));
    }
    if (!indexes.contains(totalPage - 1)) {
      widgets.add(_createIndicatorItem(context, totalPage - 1));
      indexes.add(totalPage - 1);
    }
    if (!indexes.contains(totalPage)) {
      widgets.add(_createIndicatorItem(context, totalPage));
      indexes.add(totalPage);
    }

    if (currentPage + 1 < totalPage) {
      widgets.add(InkWell(
        child: const Icon(
          Icons.keyboard_arrow_right,
          size: 34,
        ),
        onTap: () => {
          onJumpTo(currentPage + 1, pageSize)
        },
      ));
    }

    return widgets;
  }

  Widget _createIndicatorItem(BuildContext context, int target) {
    Color? indicator;
    if (target == currentPage + 1) {
      indicator = Theme.of(context).primaryColor;
    }
    return InkWell(
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        child: Text(
          "$target",
          style: TextStyle(
            color: indicator,
            fontSize: 18,
          ),
        ),
      ),
      onTap: () => {
        onJumpTo(target - 1, pageSize)
      },
    );
  }
}