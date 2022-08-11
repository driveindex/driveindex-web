import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

typedef AzureContentResolver = Function(void Function(String) callback);

class MarkdownWidget extends StatefulWidget {
  final bool show;
  final AzureContentResolver resolver;

  const MarkdownWidget({
    Key? key,
    required this.show,
    required this.resolver,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MarkdownWidgetState();
}

class _MarkdownWidgetState extends State<MarkdownWidget> {
  String? _content;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.show,
      child: Card(
        child: _loadContent(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.resolver((content) {
      setState(() {
        _content = content;
      });
    });
  }

  Widget _loadContent() {
    if (_content == null) {
      return RefreshProgressIndicator();
    } else {
      return MarkdownBody(data: _content!);
    }
  }
}