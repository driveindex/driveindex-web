import 'package:driveindex_web/module/dio_client.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_html/html.dart' as html;

import 'package:driveindex_web/module/file_module.dart';
import 'package:driveindex_web/util/size_caculate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class DirFile extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function urlResolver;

  const DirFile({
    Key? key,
    required this.data,
    required this.urlResolver,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(FileModule.getItemIcon(data["mine_type"])),
            const SizedBox(width: 10),
            Text(
              data["name"],
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              ),
            ),
            const Spacer(),
            Visibility(
              visible: ResponsiveWrapper.of(context).isLargerThan(MOBILE),
              child: TextButton(
                child: const SizedBox(
                  height: 40,
                  child: Center(
                    child: Text("复制下载链接"),
                  ),
                ),
                onPressed: () {
                  String basePath = urlResolver();
                  if (!const bool.fromEnvironment("dart.vm.product")) {
                    basePath = "${DioClient.API_HOST}$basePath";
                  } else {
                    basePath = "${html.window.location.host}$basePath";
                  }
                  Clipboard.setData(ClipboardData(text: basePath));
                },
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              child: SizedBox(
                height: 40,
                child: Center(
                  child: Text(
                    "下载（${SizeWrapper.of(data["content"]["info"]["size"])}）"
                  ),
                ),
              ),
              onPressed: () {
                String basePath = urlResolver();
                if (!const bool.fromEnvironment("dart.vm.product")) {
                  basePath = "${DioClient.API_HOST}$basePath";
                }
                launchUrl(
                  Uri.parse(basePath),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          constraints: const BoxConstraints(
            minWidth: double.infinity,
            minHeight: 400,
          ),
          color: Colors.grey.shade200,
          child: _createPreview(),
        )
      ],
    );
  }

  Widget _createPreview() {
    return Center(
      child: Column(
        children: [
          Icon(
            FileModule.getItemIcon(data["mine_type"]),
            size: 60,
          ),
          Text(
            data["name"],
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
            ),
          ),
        ],
      ),
    );
  }
}