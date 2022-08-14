import 'package:flutter/material.dart';

class LoadingCover extends StatelessWidget {
  final bool visible;

  const LoadingCover({
    Key? key,
    required this.visible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        color: const Color.fromARGB(150, 255, 255, 255),
        child: const Center(
          child: CircularProgressIndicator(value: null),
        ),
      ),
    );
  }
}