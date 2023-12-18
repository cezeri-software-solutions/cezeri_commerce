import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/core/widgets/my_outlined_button.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class MyDialogDelete extends StatelessWidget {
  final String? title;
  final String? content;
  final VoidCallback onConfirm;

  const MyDialogDelete({super.key, this.title, this.content, required this.onConfirm});

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
              Text(title ?? 'Löschen', style: TextStyles.h1),
              Gaps.h16,
              Text(content ?? 'Bist du sicher, dass es unwiederruflich löschen willst?', style: TextStyles.h3, textAlign: TextAlign.center),
              Gaps.h32,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(child: const Text('Abbrechen'), onPressed: () => context.router.pop()),
                  MyOutlinedButton(buttonText: 'Löschen', onPressed: onConfirm, buttonBackgroundColor: Colors.red),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
