import 'package:driveindex_web/module/admin_module.dart';
import 'package:driveindex_web/util/config_manager.dart';
import 'package:driveindex_web/util/fluro_router.dart';
import 'package:driveindex_web/widget/ui/compose_row_column.dart';
import 'package:flutter/material.dart';

import 'package:driveindex_web/widget/fragment/admin_common.dart';
import 'package:driveindex_web/widget/fragment/admin_password.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class AdminScreen extends StatefulWidget {
  static get handler => (BuildContext? context, Map<String, List<String>> params) {
    return AdminScreen(path: params["target"]?[0] ?? "common");
  };

  final String path;

  _AdminFragmentData get _page => _AdminFragmentData.pages[path]!;
  Widget get target {
    _AdminFragmentData page = _page;
    return StartColumn(
      children: [
        TextBaselineRow(
          children: [
            Text(
              page.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              page.description,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black38,
              ),
            )
          ],
        ),
        const SizedBox(height: 15),
        page.target,
      ],
    );
  }
  int get index => _page.index;

  const AdminScreen({
    Key? key,
    required this.path,
  }): super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  void initState() {
    super.initState();
    ConfigManager.HAS_LOGIN.then((value) async {
      if (!value) _navigateToLogin();
      // 若 token 失效则跳转登录页面
      Map<String, dynamic> resp = await AdminModule.checkLogin();
      if (resp["code"] != 200) _navigateToLogin();
    });
  }

  void _navigateToLogin() {
    Fluro.navigateTo(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    _DrawerList drawerList = _DrawerList(index: widget.index);
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: const Text("DriveIndex"),
          onTap: () {
            Fluro.navigateTo(context, "/");
          },
        ),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: ResponsiveWrapper(
          maxWidth: 700,
          minWidth: 480,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: widget.target,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: drawerList,
      ),
    );
  }
}

class _DrawerList extends StatelessWidget {
  final int index;

  const _DrawerList({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        _AdminFragmentData page = _AdminFragmentData.pagesList[index];
        return ListTile(
          title: Text(page.title),
          selected: page.index == this.index,
          onTap: () {
            Future.delayed(const Duration(milliseconds: 100), () {
              Fluro.pop(context);
              if (page.index == this.index) return;
              Future.delayed(const Duration(milliseconds: 200), () {
                Fluro.navigateTo(context, "/admin?target=${page.id}");
              });
            });
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
      itemCount: _AdminFragmentData.pages.length,
      scrollDirection: Axis.vertical,
    );
  }
}

class _AdminFragmentData {
  final int index;
  final String id;
  final String title;
  final String description;
  final Widget target;

  _AdminFragmentData({
    required this.index,
    required this.id,
    required this.title,
    required this.description,
    required this.target,
  });

  // static final List<_AdminFragmentData> pages = [
  //   _AdminFragmentData(index: 0, id: "common",title: "基本设置", description: "设置 DriveIndex 基本参数", target: const AdminCommonFragment()),
  //   _AdminFragmentData(index: 2, id: "password", title: "密码修改", description: "修改管理员密码", target: const AdminPasswordFragment()),
  //   _AdminFragmentData(index: 1, id: "azure", title: "Azure 管理", description: "管理 OneDrive 绑定配置，支持多个绑定", target: const AdminAzureFragment()),
  // ];

  static final Map<String, _AdminFragmentData> pages = {
    "common": _AdminFragmentData(index: 0, id: "common", title: "基本设置", description: "设置 DriveIndex 基本参数", target: const AdminCommonFragment()),
    "password": _AdminFragmentData(index: 1, id: "password", title: "密码修改", description: "修改管理员密码", target: const AdminPasswordFragment()),
    // "azure": _AdminFragmentData(index: 1, id: "azure", title: "Azure 管理", description: "管理 OneDrive 绑定配置，支持多个绑定", target: const AdminAzureFragment()),
  };


  static final List<_AdminFragmentData> pagesList = pages.values.toList();
}