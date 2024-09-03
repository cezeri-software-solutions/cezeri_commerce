import 'package:flutter/material.dart';

enum TappingPlace { left, middle, right }

class MyChipWithThreeOptions extends StatelessWidget {
  final String titleLeft;
  final String titleMiddle;
  final String titleRight;
  final VoidCallback onTapLeft;
  final VoidCallback onTapMiddle;
  final VoidCallback onTapRight;
  final Color colorLeft;
  final Color colorMiddle;
  final Color colorRight;
  final bool addBorder;

  const MyChipWithThreeOptions({
    super.key,
    required this.titleLeft,
    required this.titleMiddle,
    required this.titleRight,
    required this.onTapLeft,
    required this.onTapMiddle,
    required this.onTapRight,
    required this.colorLeft,
    required this.colorMiddle,
    required this.colorRight,
    this.addBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final border = addBorder ? Border.all(color: const Color.fromARGB(255, 196, 196, 196)) : null;

    return Row(
      children: [
        InkWell(
          onTap: onTapLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: colorLeft,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), topLeft: Radius.circular(20)),
              border: border,
            ),
            child: Center(child: Text(titleLeft)),
          ),
        ),
        InkWell(
          onTap: onTapMiddle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: colorMiddle,
              border: border,
            ),
            child: Center(child: Text(titleMiddle)),
          ),
        ),
        InkWell(
          onTap: onTapRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: colorRight,
              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20), topRight: Radius.circular(20)),
              border: border,
            ),
            child: Center(child: Text(titleRight)),
          ),
        ),
      ],
    );
  }
}
