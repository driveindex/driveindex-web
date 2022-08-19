import 'package:driveindex_web/widget/page/not_found_page.dart';
import 'package:driveindex_web/widget/page/admin_page.dart';
import 'package:driveindex_web/widget/page/dir_page.dart';
import 'package:driveindex_web/widget/page/login_page.dart';
import 'package:driveindex_web/util/fluro_router.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  Fluro.notFoundHandler = Handler(handlerFunc: NotFoundScreen.handler);
  Fluro.define("/admin", handler: Handler(handlerFunc: AdminScreen.handler));
  Fluro.define("/login", handler: Handler(handlerFunc: LoginScreen.handler));
  Fluro.define("/index", handler: Handler(handlerFunc: DirScreen.handler));
  runApp(const DriveIndexApp());
}

class DriveIndexApp extends StatelessWidget {
  const DriveIndexApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DriveIndex',
      builder: (context, widget) => ResponsiveWrapper.builder(
        ClampingScrollWrapper.builder(context, widget!),
        defaultScale: true,
        minWidth: 480,
        defaultName: DESKTOP,
        breakpoints: [
          const ResponsiveBreakpoint.autoScale(480, name: MOBILE),
          const ResponsiveBreakpoint.resize(600, name: MOBILE),
          const ResponsiveBreakpoint.resize(850, name: TABLET),
          const ResponsiveBreakpoint.resize(1080, name: DESKTOP),
        ],
        background: Container(color: const Color(0xFFF8F9FA)),
      ),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: Fluro.generator,
      initialRoute: "/index",
    );
  }
}