import 'package:flutter/material.dart';

import '../../../constants.dart';

class RecommendedReorderQuantity extends StatelessWidget {
  final String title;
  final int quantity;
  final Color color;

  const RecommendedReorderQuantity({super.key, required this.title, required this.quantity, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: title),
                const TextSpan(text: ' '),
                TextSpan(text: quantity.toString(), style: TextStyles.s13Bold),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
