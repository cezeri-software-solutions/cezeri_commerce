import 'package:flutter/material.dart';

import '../../core/core.dart';

class MyFormFieldContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final double? borderRadius;

  const MyFormFieldContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.height,
    this.width,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;
    final themeData = Theme.of(context);
    print(screenWidth);
    return SizedBox(
      width: width ?? (screenWidth > 600 ? 600 : screenWidth),
      child: Container(
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: Border.all(color: themeData.colorScheme.outline),
          color: themeData.colorScheme.primaryContainer, //Colors.blueGrey[50],
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius!),
          ),
        ),
        child: child,
      ),
    );
  }
}
