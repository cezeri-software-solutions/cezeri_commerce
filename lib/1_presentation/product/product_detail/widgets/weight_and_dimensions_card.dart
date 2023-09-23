import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../core/widgets/my_text_form_field.dart';

class WeightAndDimensionsCard extends StatelessWidget {
  const WeightAndDimensionsCard({
    super.key,
    required TextEditingController weightController,
    required TextEditingController widthController,
    required TextEditingController heightController,
    required TextEditingController depthController,
  })  : _weightController = weightController,
        _widthController = widthController,
        _heightController = heightController,
        _depthController = depthController;

  final TextEditingController _weightController;
  final TextEditingController _widthController;
  final TextEditingController _heightController;
  final TextEditingController _depthController;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Gewicht & Abmessungen', style: TextStyles.h3BoldPrimary),
            const Divider(),
            MyTextFormField(
              labelText: 'Gewicht',
              controller: _weightController,
            ),
            Gaps.h16,
            MyTextFormField(
              labelText: 'Breite cm',
              controller: _widthController,
            ),
            Gaps.h16,
            MyTextFormField(
              labelText: 'Höhe cm',
              controller: _heightController,
            ),
            Gaps.h16,
            MyTextFormField(
              labelText: 'Tiefe cm',
              controller: _depthController,
            ),
          ],
        ),
      ),
    );
  }
}
