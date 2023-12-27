import 'package:flutter/material.dart';

class MyChipWithTwoOptions extends StatelessWidget {
  final String titleLeft;
  final String titleRight;
  final VoidCallback onTapLeft;
  final VoidCallback onTapRight;
  final Color colorLeft;
  final Color colorRight;

  const MyChipWithTwoOptions({
    super.key,
    required this.titleLeft,
    required this.titleRight,
    required this.onTapLeft,
    required this.onTapRight,
    required this.colorLeft,
    required this.colorRight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onTapLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: colorLeft,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            child: Center(child: Text(titleLeft)),
          ),
        ),
        InkWell(
          onTap: onTapRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: colorRight,
              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Center(child: Text(titleRight)),
          ),
        ),
      ],
    );
  }
}
