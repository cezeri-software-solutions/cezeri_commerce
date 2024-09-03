import 'package:flutter/material.dart';

class MySettingsListTile extends StatelessWidget {
  final Widget leading;
  final Widget trailing;
  final double trailingWidth;
  final String title;
  final VoidCallback? onPressed;
  final bool divider;
  const MySettingsListTile({
    Key? key,
    this.leading = const Icon(null),
    this.trailing = const Icon(null),
    this.trailingWidth = 40,
    required this.title,
    this.onPressed,
    this.divider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: themeData.colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              Expanded(
                flex: 6,
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: trailing,
              ),
            ],
          ),
          if (divider) ...[
            Divider(
              height: 0,
              color: Colors.grey[400],
            ),
          ]
        ],
      ),
    );
  }
}
