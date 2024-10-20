import 'package:flutter/material.dart';

import '../../../../constants.dart';

class FieldTitle extends StatelessWidget {
  final String fieldTitle;
  final bool isMandatory;

  const FieldTitle({super.key, required this.fieldTitle, required this.isMandatory});

  @override
  Widget build(BuildContext context) {
    if (!isMandatory) return Text(' $fieldTitle', style: TextStyles.infoOnTextFieldSmall, maxLines: 1, overflow: TextOverflow.ellipsis);

    return Row(
      children: [
        Text(' $fieldTitle', style: TextStyles.infoOnTextFieldSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
        const Text('*', maxLines: 1, style: TextStyle(fontSize: 12, color: Colors.red, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
