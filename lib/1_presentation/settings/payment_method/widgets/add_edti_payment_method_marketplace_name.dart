import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../../../3_domain/entities/settings/payment_method.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

class AddEditPaymentMethodMarketplaceName extends StatefulWidget {
  final PaymentMethod paymentMethod;

  const AddEditPaymentMethodMarketplaceName({super.key, required this.paymentMethod});

  @override
  State<AddEditPaymentMethodMarketplaceName> createState() => _AddEditPaymentMethodMarketplaceNameState();
}

class _AddEditPaymentMethodMarketplaceNameState extends State<AddEditPaymentMethodMarketplaceName> {
  late TextEditingController _paymentMethodController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _paymentMethodController = TextEditingController(text: widget.paymentMethod.nameInMarketplace);
  }

  @override
  Widget build(BuildContext context) {
    return MyModalScrollable(
      title: 'Zahlungsmethode Mapping',
      keyboardDismiss: KeyboardDissmiss.onTab,
      children: [
        Gaps.h24,
        const Text(
            'Gib die Namen der Zahlungsmethoden in deinen Marktplätzen ein.\nWenn du mehrere Marktplätze mit verschiedenen Namen für Zahlungsmethoden hast, kannst du diese durch Abtrennung eines "," eingeben.'),
        Gaps.h42,
        MyTextFormFieldSmall(
          controller: _paymentMethodController,
        ),
        Gaps.h42,
        MyOutlinedButton(
          buttonText: 'Speichern',
          onPressed: () {
            context.read<MainSettingsBloc>().add(
                  AddEditPaymentMethodMarketplaceNameEvent(value: _paymentMethodController.text, paymentMethod: widget.paymentMethod),
                );
            context.router.pop();
          },
        ),
        Gaps.h54,
      ],
    );
  }
}
