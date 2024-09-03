import 'package:flutter/material.dart';

class MyFormFieldContainer extends StatelessWidget {
  final double? height;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? borderRadius;
  const MyFormFieldContainer({
    Key? key,
    this.height,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.width,
    this.borderRadius = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
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
