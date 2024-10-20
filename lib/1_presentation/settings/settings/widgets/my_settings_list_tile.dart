import 'package:flutter/material.dart';

import '../../../../constants.dart';

class MySettingsListTile extends StatelessWidget {
  final Widget leading;
  final Widget trailing;
  final double trailingWidth;
  final String title;
  final VoidCallback? onPressed;

  const MySettingsListTile({
    super.key,
    this.leading = const Icon(null),
    this.trailing = const Icon(null),
    this.trailingWidth = 40,
    required this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            Expanded(flex: 6, child: Text(title, overflow: TextOverflow.ellipsis)),
            Expanded(flex: 2, child: trailing),
          ],
        ),
        Gaps.h8,
      ],
    );
  }
}
