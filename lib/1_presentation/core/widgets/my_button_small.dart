import 'package:flutter/material.dart';

import '../../../constants.dart';

class MyButtonSmall extends StatelessWidget {
  final Widget child;
  final String? labelText;

  const MyButtonSmall({super.key, required this.child, this.labelText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) Text(' ${labelText!}', style: TextStyles.infoOnTextFieldSmall),
        Container(
          height: 28,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: CustomColors.borderColorLight),
          ),
          child: child,
        ),
      ],
    );
  }
}
