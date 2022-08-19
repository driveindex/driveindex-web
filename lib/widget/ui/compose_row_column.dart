import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StartColumn extends Column {
  StartColumn({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    List<Widget> children = const <Widget>[],
  }) : super(
    children: children,
    key: key,
    mainAxisAlignment: mainAxisAlignment,
    mainAxisSize: mainAxisSize,
    crossAxisAlignment: CrossAxisAlignment.start,
    textDirection: textDirection,
    verticalDirection: verticalDirection,
    textBaseline: textBaseline,
  );
}

class StartRow extends Row {
  StartRow({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    List<Widget> children = const <Widget>[],
  }) : super(
    children: children,
    key: key,
    mainAxisAlignment: mainAxisAlignment,
    mainAxisSize: mainAxisSize,
    crossAxisAlignment: CrossAxisAlignment.start,
    textDirection: textDirection,
    verticalDirection: verticalDirection,
    textBaseline: textBaseline,
  );
}

class TextBaselineRow extends Row {
  TextBaselineRow({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    List<Widget> children = const <Widget>[],
  }) : super(
    children: children,
    key: key,
    mainAxisAlignment: mainAxisAlignment,
    mainAxisSize: mainAxisSize,
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textDirection: textDirection,
    verticalDirection: verticalDirection,
    textBaseline: TextBaseline.alphabetic,
  );
}

class CardColumn extends Column {
  CardColumn({
    Key? key,
    double elevation = 50,
    Color? shadowColor,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    List<Widget?> children = const <Widget?>[],
  }) : super(
    children: map(children, elevation, shadowColor),
    key: key,
    mainAxisAlignment: mainAxisAlignment,
    mainAxisSize: mainAxisSize,
    crossAxisAlignment: CrossAxisAlignment.start,
    textDirection: textDirection,
    verticalDirection: verticalDirection,
    textBaseline: textBaseline,
  );

  static List<Widget> map(List<Widget?> children, double elevation,
      Color? shadowColor) {
    List<Widget> result = [];
    for (Widget? value in children) {
      if (value == null) continue;
      result.add(Card(
        elevation: elevation,
        shadowColor: shadowColor,
        child: value,
      ));
    }
    return result;
  }
}