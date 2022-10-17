import 'package:driveindex_web/widget/ui/compose_row_column.dart';
import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int totalPage;
  final int totalCount;
  final int currentPage;
  final Function(int pageIndex) onJumpTo;

  PageIndicator({
    Key? key,
    required this.totalPage,
    required this.totalCount,
    required this.currentPage,
    required this.onJumpTo,
  }) : super(key: key);

  final TextEditingController _jumpTo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: CardRow(
            children: [

            ],
          ),
        ),
        SizedBox(
          width: 100,
          child: TextField(
            controller: _jumpTo,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "跳转到...",
            ),
          ),
        ),
        const SizedBox(height: 50),
        ElevatedButton(
          onPressed: () {
            int? jumpTo = int.tryParse(_jumpTo.value.text);
            if (jumpTo == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("请输入一个大于 0 的数字！"))
              );
              return;
            }
            onJumpTo(jumpTo);
          },
          child: const SizedBox(
            width: 80, height: 40,
            child: Center(
              child: Text(
                "提交",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}