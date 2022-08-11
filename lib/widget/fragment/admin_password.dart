import 'package:driveindex_web/widget/ui/start_column.dart';
import 'package:flutter/material.dart';

class AdminPasswordFragment extends StatefulWidget {
  const AdminPasswordFragment({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminPasswordFragmentState();
}

class _AdminPasswordFragmentState extends State<AdminPasswordFragment> {
  @override
  Widget build(BuildContext context) {
    return StartColumn(
      children: [
        Text("password")
      ],
    );
  }
}