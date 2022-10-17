import 'package:driveindex_web/util/canonical_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

class BreadcrumbsWidget extends StatelessWidget {
  final CanonicalPath path;
  final Function(CanonicalPath) onNavigate;

  const BreadcrumbsWidget({
    Key? key,
    required this.path,
    required this.onNavigate
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: BreadCrumb(
        items: _createItems(),
        divider: const Icon(Icons.chevron_right),
      ),
    );
  }

  List<BreadCrumbItem> _createItems() {
    List<BreadCrumbItem> list = [];
    CanonicalPath path = CanonicalPath.ROOT;
    list.add(_createSingleItem("/", path));
    for (String value in this.path.getPathStack()) {
      path += value;
      list.add(_createSingleItem(value, path));
    }
    return list;
  }

  BreadCrumbItem _createSingleItem(String title, CanonicalPath path) {
    return BreadCrumbItem(
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: InkWell(
            child: Container(
              constraints: const BoxConstraints(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(title),
              ),
            ),
            onTap: () => onNavigate(path),
          ),
        ),
      ),
    );
  }
}