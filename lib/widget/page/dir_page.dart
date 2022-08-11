import 'package:driveindex_web/data/azure_file_data.dart';
import 'package:driveindex_web/util/fluro_router.dart';
import 'package:driveindex_web/widget/ui/breadcrumbs_widget.dart';
import 'package:driveindex_web/widget/ui/markdown_widget.dart';
import 'package:flutter/material.dart';

class DirScreen extends StatefulWidget {
  static get handler => (BuildContext? context, Map<String, List<String>> params) {
    return DirScreen(path: params["path"]?[0] ?? "/",);
  };

  final String path;

  const DirScreen({Key? key, required this.path}): super(key: key);

  @override
  State<StatefulWidget> createState() => _DirScreenState();
}

class _DirScreenState extends State<DirScreen> {
  Map<String, FileData> _list = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BreadcrumbsWidget(path: widget.path, onNavigate: (String target) {
          Fluro.navigateTo(context, "/?path=$target");
        }),
        MarkdownWidget(
          show: _list.containsKey("head.md"),
          resolver: (void Function(String) callback) {
            callback("");
          },
        ),
      ],
    );
  }
}