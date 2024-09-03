import 'package:flutter/material.dart';

import '../../core/core.dart';
class StatContainer extends StatelessWidget {
  final String title;
  final String body;
  final double? width;
  const StatContainer({
    super.key,
    required this.title,
    required this.body,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return MyFormFieldContainer(
      height: 120,
      width: width ?? width,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text(body, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
