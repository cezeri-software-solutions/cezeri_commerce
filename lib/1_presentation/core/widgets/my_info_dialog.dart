import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/core/widgets/my_outlined_button.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class MyInfoDialog extends StatelessWidget {
  final String title;
  final String content;

  const MyInfoDialog({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: TextStyles.h1),
              Gaps.h16,
              Text(content, style: TextStyles.h3, textAlign: TextAlign.center),
              Gaps.h32,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MyOutlinedButton(buttonText: 'OK', onPressed: () => context.router.pop()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
