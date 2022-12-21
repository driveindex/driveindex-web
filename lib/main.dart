import 'dart:ui';

import 'package:driveindex_web/widget/page/not_found_page.dart';
import 'package:driveindex_web/widget/page/admin_page.dart';
import 'package:driveindex_web/widget/page/dir_page.dart';
import 'package:driveindex_web/widget/page/login_page.dart';
import 'package:driveindex_web/util/fluro_router.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  if (!const bool.fromEnvironment("dart.vm.product")) {
    Logger.root.level = Level.ALL;
  } else {
    Logger.root.level = Level.INFO;
  }
  Logger.root.onRecord.listen((event) {
    print('${event.level.name}: ${event.time}: ${event.message}');
  });

  Fluro.notFoundHandler = Handler(handlerFunc: NotFoundScreen.handler);
  Fluro.define("/admin", handler: Handler(handlerFunc: AdminScreen.handler));
  Fluro.define("/login", handler: Handler(handlerFunc: LoginScreen.handler));
  Fluro.define("/index", handler: Handler(handlerFunc: DirScreen.handler));
  runApp(const DriveIndexApp());
}

class DriveIndexApp extends StatelessWidget {
  const DriveIndexApp({Key? key}) : super(key: key);

  static List<ResponsiveBreakpoint> get Breakpoint {
    return [
      const ResponsiveBreakpoint.resize(480, name: MOBILE),
      const ResponsiveBreakpoint.resize(800, name: TABLET),
      const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DriveIndex',
      builder: (context, widget) => ResponsiveWrapper.builder(
        ClampingScrollWrapper.builder(context, widget!),
        minWidth: 480,
        breakpoints: Breakpoint,
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