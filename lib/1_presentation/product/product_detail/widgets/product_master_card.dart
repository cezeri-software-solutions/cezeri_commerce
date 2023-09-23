import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../core/widgets/my_text_form_field.dart';

class ProductMasterCard extends StatelessWidget {
  const ProductMasterCard({
    super.key,
    required TextEditingController articleNumberController,
    required TextEditingController eanController,
    required TextEditingController nameController,
  })  : _articleNumberController = articleNumberController,
        _eanController = eanController,
        _nameController = nameController;

  final TextEditingController _articleNumberController;
  final TextEditingController _eanController;
  final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Artikelstamm', style: TextStyles.h3BoldPrimary),
            const Divider(height: 30),
            Row(
              children: [
                Expanded(
                  child: MyTextFormField(
                    labelText: 'Artikel-Nr.',
                    controller: _articleNumberController,
                  ),
                ),
                Gaps.w8,
                Expanded(
                  child: MyTextFormField(
                    labelText: 'EAN',
                    controller: _eanController,
                  ),
                ),
              ],
            ),
            Gaps.h8,
            MyTextFormField(
              labelText: 'Artikel-Bez.',
              controller: _nameController,
            ),
          ],
        ),
      ),
    );
  }
}
