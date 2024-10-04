import 'package:flutter/material.dart';

import '../../../constants.dart';

class MyButtonSmall extends StatelessWidget {
  final Widget child;
  final Widget? trailing;
  final String? labelText;
  final VoidCallback? onTap;
  final VoidCallback? onTrailingTap;

  const MyButtonSmall({super.key, required this.child, this.trailing, this.labelText, this.onTap, this.onTrailingTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) Text(' ${labelText!}', style: TextStyles.infoOnTextFieldSmall),
        Container(
          height: 32,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: CustomColors.borderColorLight),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: GestureDetector(onTap: onTap, child: child)),
              trailing != null ? Flexible(child: GestureDetector(onTap: onTrailingTap, child: trailing!)) : const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}
