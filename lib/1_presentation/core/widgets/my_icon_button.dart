import 'package:flutter/material.dart';

import 'my_circular_progress_indicator.dart';

class MyIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? iconSize;
  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;
  final double? splashRadius;
  final Color? color;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final Color? splashColor;
  final Color? disabledColor;
  final MouseCursor? mouseCursor;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? tooltip;
  final bool? enableFeedback;
  final BoxConstraints? constraints;
  final ButtonStyle? style;
  final bool? isSelected;
  final Widget? selectedIcon;

  const MyIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.iconSize,
    this.visualDensity,
    this.padding,
    this.alignment = Alignment.center,
    this.splashRadius,
    this.color,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.enableFeedback,
    this.constraints,
    this.style,
    this.isSelected,
    this.selectedIcon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: isLoading ? const MyCircularProgressIndicator() : icon,
      onPressed: isLoading ? null : onPressed,
      iconSize: iconSize,
      visualDensity: visualDensity,
      padding: padding,
      alignment: alignment,
      splashRadius: splashRadius,
      color: color,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      disabledColor: disabledColor,
      mouseCursor: mouseCursor,
      focusNode: focusNode,
      autofocus: autofocus,
      tooltip: tooltip,
      enableFeedback: enableFeedback,
      constraints: constraints,
      style: style,
      isSelected: isSelected,
      selectedIcon: selectedIcon,
    );
  }
}
