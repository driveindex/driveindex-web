import 'dart:async';

import 'package:driveindex_web/widget/ui/loading_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownWidget extends StatefulWidget {
  final Future<String?> content;

  const MarkdownWidget({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MarkdownWidgetState();
}

class _MarkdownWidgetState extends State<MarkdownWidget> {
  String? _content;

  @override
  void initState() {
    widget.content.then((value) {
      setState(() => _content = value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loadContent();
  }

  Widget _loadContent() {
    if (_content == null) {
      return const LoadingCover();
    } else {
      return Container(
        constraints: const BoxConstraints(
          minHeight: 200,
          minWidth: double.infinity,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 12, horizontal: 20
          ),
          child: MarkdownBody(data: _content!),
        ),
      );
    }
  }
}