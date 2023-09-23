import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../core/widgets/my_text_form_field.dart';

class SellingCard extends StatelessWidget {
  const SellingCard({
    super.key,
    required TextEditingController netPriceController,
    required TextEditingController grossPriceController,
    required TextEditingController recommendedRetailPriceController,
    required TextEditingController unitPriceController,
    required TextEditingController unityController,
  })  : _netPriceController = netPriceController,
        _grossPriceController = grossPriceController,
        _recommendedRetailPriceController = recommendedRetailPriceController,
        _unitPriceController = unitPriceController,
        _unityController = unityController;

  final TextEditingController _netPriceController;
  final TextEditingController _grossPriceController;
  final TextEditingController _recommendedRetailPriceController;
  final TextEditingController _unitPriceController;
  final TextEditingController _unityController;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Verkauf', style: TextStyles.h3BoldPrimary),
            const Divider(),
            MyTextFormField(
              labelText: 'VK-Preis Netto',
              controller: _netPriceController,
            ),
            Gaps.h16,
            MyTextFormField(
              labelText: 'VK-Preis Brutto',
              controller: _grossPriceController,
            ),
            Gaps.h16,
            MyTextFormField(
              labelText: 'UVP',
              controller: _recommendedRetailPriceController,
            ),
            Gaps.h16,
            MyTextFormField(
              labelText: 'Einheitspreis Netto',
              controller: _unitPriceController,
            ),
            Gaps.h16,
            MyTextFormField(
              labelText: 'Einheit',
              hintText: 'z.B. pro 1 L',
              controller: _unityController,
            ),
          ],
        ),
      ),
    );
  }
}
