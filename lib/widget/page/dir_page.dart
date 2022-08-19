import 'dart:async';

import 'package:driveindex_web/module/file_module.dart';
import 'package:driveindex_web/util/canonical_path.dart';
import 'package:driveindex_web/util/fluro_router.dart';
import 'package:driveindex_web/util/runtime_value.dart';
import 'package:driveindex_web/widget/fragment/dir_file.dart';
import 'package:driveindex_web/widget/fragment/dir_list.dart';
import 'package:driveindex_web/widget/page/not_found_page.dart';
import 'package:driveindex_web/widget/ui/breadcrumbs_widget.dart';
import 'package:driveindex_web/widget/ui/compose_row_column.dart';
import 'package:driveindex_web/widget/ui/loading_cover.dart';
import 'package:driveindex_web/widget/ui/markdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class DirScreen extends StatefulWidget {
  static get handler => (BuildContext? _, Map<String, List<String>> params) {
    return DirScreen(
      path: CanonicalPath.of(params["path"]?[0] ?? "/"),
      client: params["client"]?[0],
      account: params["account"]?[0],
      drive: params["drive"]?[0],
      page: int.tryParse(params["page"]?[0] ?? "null"),
      size: int.tryParse(params["size"]?[0] ?? "null"),
    );
  };

  final CanonicalPath path;
  final String? client;
  final String? account;
  final String? drive;
  final int? page;
  final int? size;

  const DirScreen({
    Key? key,
    required this.path,
    this.client,
    this.account,
    this.drive,
    this.page,
    this.size,
  }): super(key: key);

  @override
  State<StatefulWidget> createState() => _DirScreenState();
}

class _DirScreenState extends State<DirScreen> {
  final StreamController<Map<String, dynamic>> _controller = StreamController();

  bool _loading = true;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    _controller.stream.listen(onData);
    _getData();
    super.initState();
  }

  void onData(Map<String, dynamic>? data) {
    setState(() {
      _loading = false;
      _data = data;
    });
  }

  void _getData() async {
    _controller.add(await FileModule.getFile(widget.client, widget.account,
        widget.drive, widget.path.getPath(), RuntimeValue.FILE_PASSWORD,
        widget.page, widget.size));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: ResponsiveWrapper(
            maxWidth: 800,
            minWidth: 480,
            child: CardColumn(
              shadowColor: Theme.of(context).primaryColorLight,
              children: [
                BreadcrumbsWidget(
                  path: widget.path,
                  onNavigate: (CanonicalPath target) {
                    _redirect(target);
                  },
                ),
                const SizedBox(height: 10),
                ..._getContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getContent() {
    if (_loading) {
      return const [LoadingCover()];
    }
    if (_data == null) return [];
    int code = _data!["code"];
    if (code == -401) {
      return [const NotFoundScreen()];
    }
    if (code != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("文件处理失败：${_data!["message"]}"))
      );
      return [];
    }
    Map<String, dynamic> data = _data!["data"];
    if (data["mine_type"] == "directory") {
      List<dynamic> content = data["content"];
      Map<String, Map<String, dynamic>> list = {};
      for (Map<String, dynamic> value in content) {
        String name = value["name"];
        list[name.toLowerCase()] = value;
      }

      return [
        if (list.containsKey("header.md"))
          ...[
            MarkdownWidget(content: FileModule.download(widget.client, widget.account,
                widget.drive, (widget.path + list["header.md"]!["name"]).getPath(),
                RuntimeValue.FILE_PASSWORD)),
            const SizedBox(height: 10),
          ],
        DirList(
          totalPage: data["total_page"],
          totalCount: data["total_count"],
          list: list,
          currentPath: widget.path,
          onPush: (String item) => _redirect(widget.path + item),
          onPop: () => _redirect(widget.path.getParentPath()),
        ),
        if (list.containsKey("readme.md"))
          ...[
            const SizedBox(height: 10),
            MarkdownWidget(content: FileModule.download(widget.client, widget.account,
              widget.drive, (widget.path + list["readme.md"]!["name"]).getPath(),
              RuntimeValue.FILE_PASSWORD)),
          ],
      ];
    }
    return [
      Container(
        constraints: const BoxConstraints(
          minWidth: double.infinity
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16, horizontal: 24,
          ),
          child: DirFile(
            data: _data!["data"],
            urlResolver: () {
              Map<String, dynamic> data = FileModule.getParameters(widget.client,
                  widget.account, widget.drive, widget.path.getUrlEncodedPath(), null);
              return Fluro.parseData("/download", data);
            },
          ),
        ),
      ),
    ];
  }

  void _redirect(CanonicalPath path) {
    Map<String, dynamic> data = FileModule.getParameters(widget.client,
        widget.account, widget.drive, path.getUrlEncodedPath(), null);
    if (widget.page != null) data["page"] = widget.page;
    if (widget.size != null) data["size"] = widget.size;
    Fluro.navigateTo(context, "/index", data: data);
  }
}