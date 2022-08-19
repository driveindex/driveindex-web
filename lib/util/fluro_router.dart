import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class Fluro {
  Fluro._();

  static FluroRouter? _router;

  static FluroRouter get instance {
    _router ??= FluroRouter();
    return _router!;
  }

  static set notFoundHandler(Handler? value) {
    instance.notFoundHandler = value;
  }
  static Handler? get notFoundHandler => instance.notFoundHandler;

  static Route? Function(RouteSettings routeSettings) get generator {
    return instance.generator;
  }

  static void define(String routePath, {required Handler? handler,
    TransitionType? transitionType = TransitionType.fadeIn,
    Duration transitionDuration = const Duration(milliseconds: 200),
    RouteTransitionsBuilder? transitionBuilder}) {
    instance.define(routePath, handler: handler,
        transitionBuilder: transitionBuilder,
        transitionDuration: transitionDuration,
        transitionType: transitionType);
  }

  static Future navigateTo(BuildContext context, String path, {
    Map<String, dynamic>? data,
    bool replace = false,
    bool clearStack = false,
    bool maintainState = true,
    bool rootNavigator = false,
    TransitionType? transition,
    Duration? transitionDuration,
    RouteTransitionsBuilder? transitionBuilder,
    RouteSettings? routeSettings
  }) {
    return instance.navigateTo(
        context,
        parseData(path, data),
        replace: replace,
        clearStack: clearStack,
        maintainState: maintainState,
        rootNavigator: rootNavigator,
        transition: transition,
        transitionDuration: transitionDuration,
        transitionBuilder: transitionBuilder,
        routeSettings: routeSettings
    );
  }

  static String parseData(String path, Map<String, dynamic>? data) {
    if (data != null && !path.contains("?")) {
      path = "$path?";
    }
    data?.forEach((key, value) {
      if (!path.endsWith("?")) path = "$path&";
      if (value != null) path = "$path$key=$value";
    });
    return path;
  }

  static void pop<T>(BuildContext context, [T? result]) {
    instance.pop(context, result);
  }
}