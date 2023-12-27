import 'package:flutter/material.dart';

class MyAnimatedExpansionContainer extends StatelessWidget {
  final Widget child;
  final bool isExpanded;
  final Duration? duration;
  final Duration? reverseDuration;
  final Curve? firstCurve;
  final Curve? secondCurve;
  final Curve? sizeCurve;

  const MyAnimatedExpansionContainer({
    super.key,
    required this.child,
    required this.isExpanded,
    this.duration,
    this.reverseDuration,
    this.firstCurve,
    this.secondCurve,
    this.sizeCurve,
  });

  @override
  Widget build(BuildContext context) {
    final duration = this.duration ?? const Duration(milliseconds: 250);
    final reverseDuration = this.reverseDuration ?? const Duration(milliseconds: 250);
    final firstCurve = this.firstCurve ?? Curves.linear;
    final secondCurve = this.secondCurve ?? Curves.linear;
    final sizeCurve = this.sizeCurve ?? Curves.linear;

    return AnimatedCrossFade(
      duration: duration,
      reverseDuration: reverseDuration,
      firstChild: Container(),
      crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstCurve: firstCurve,
      secondCurve: secondCurve,
      sizeCurve: sizeCurve,
      secondChild: child,
    );
  }
}
