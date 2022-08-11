import 'package:flutter/material.dart';

class BreadcrumbsWidget extends StatelessWidget {
  final String path;
  final Function(String) onNavigate;

  const BreadcrumbsWidget({
    Key? key,
    required this.path,
    required this.onNavigate
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text("BreadcrumbsWidget"),
    );
  }
}