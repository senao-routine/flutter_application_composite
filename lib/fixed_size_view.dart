import 'package:flutter/material.dart';

class FixedSizeView extends StatelessWidget {
  final Widget child;
  final double aspectRatio;
  final double maxWidth;
  final double maxHeight;

  const FixedSizeView({
    Key? key,
    required this.child,
    this.aspectRatio = 3 / 4,
    this.maxWidth = 450,
    this.maxHeight = 600,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;

          if (width / height > aspectRatio) {
            height = maxHeight;
            width = height * aspectRatio;
          } else {
            width = maxWidth;
            height = width / aspectRatio;
          }

          if (width > maxWidth) {
            width = maxWidth;
            height = maxHeight;
          }

          return Container(
            width: width,
            height: height,
            child: child,
          );
        },
      ),
    );
  }
}
