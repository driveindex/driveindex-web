import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  static get handler => (BuildContext? context, Map<String, List<String>> params) {
    return const NotFoundScreen();
  };

  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "页面不存在~",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24
        ),
      ),
    );
  }
}