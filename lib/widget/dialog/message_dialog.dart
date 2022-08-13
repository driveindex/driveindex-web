import 'package:driveindex_web/util/fluro_router.dart';
import 'package:flutter/material.dart';

class MessageDialog {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
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
              onPressed: () => Fluro.pop(context),
              child: const Text("我知道了"),
            )
          ],
        );
      },
    );
  }
}