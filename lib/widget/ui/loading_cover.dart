import 'package:flutter/material.dart';

class LoadingCover extends StatelessWidget {
  final bool visible;

  const LoadingCover({
    Key? key,
    this.visible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 200, minWidth: double.infinity
        ),
        color: const Color.fromARGB(150, 255, 255, 255),
        child: const Center(
          child: CircularProgressIndicator(value: null),
        ),
      ),
    );
  }
}