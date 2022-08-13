import 'package:driveindex_web/util/fluro_router.dart';
import 'package:flutter/material.dart';

class ConfirmDialog {
  static void show({
    required BuildContext context,
    String title = "确认？",
    required String message,
    required void Function() onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(title),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Fluro.pop(context);
              },
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () {
                onConfirm();
              },
              child: const Text("确定"),
            ),
          ],
        );
      },
    );
  }
}