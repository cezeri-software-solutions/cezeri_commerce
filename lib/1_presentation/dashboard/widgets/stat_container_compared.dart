import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../core/core.dart';

class StatContainerCompared extends StatelessWidget {
  final String title;
  final String value1;
  final String value2;
  final Widget? thirdLine;
  final double? width;
  const StatContainerCompared({
    super.key,
    required this.title,
    required this.value1,
    required this.value2,
    this.thirdLine,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return MyFormFieldContainer(
      // height: 140,
      width: width ?? width,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text(value1, textAlign: TextAlign.center, style: TextStyles.h3Bold),
          Text(value2, textAlign: TextAlign.center, style: TextStyles.h3),
          if (thirdLine != null) thirdLine!,
        ],
      ),
    );
  }
}
