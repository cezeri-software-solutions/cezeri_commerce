import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../core/core.dart';

class AddPaymentMethode extends StatelessWidget {
  final void Function(String paymentMethode) addToPaymentMethods;

  const AddPaymentMethode({super.key, required this.addToPaymentMethods});

  @override
  Widget build(BuildContext context) {
    final TextEditingController paymentMethodeController = TextEditingController();

    return MyModalScrollable(
      title: 'Neue Zahlungsmethode',
      keyboardDismiss: KeyboardDissmiss.onTab,
      children: [
        Gaps.h24,
        MyTextFormField(labelText: 'Zahlungsmethode', controller: paymentMethodeController),
        Gaps.h24,
        MyOutlinedButton(
          buttonText: 'Speichern',
          onPressed: () {
            addToPaymentMethods(paymentMethodeController.text);
            context.router.maybePop();
          },
        ),
        Gaps.h32,
      ],
    );
  }
}
