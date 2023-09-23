import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../core/widgets/my_text_form_field.dart';

class PurchaseCard extends StatelessWidget {
  const PurchaseCard({
    super.key,
    required TextEditingController wholesalePriceController,
    required TextEditingController supplierController,
    required TextEditingController supplierArticleNumberController,
    required TextEditingController manufacturerController,
  })  : _wholesalePriceController = wholesalePriceController,
        _supplierController = supplierController,
        _supplierArticleNumberController = supplierArticleNumberController,
        _manufacturerController = manufacturerController;

  final TextEditingController _wholesalePriceController;
  final TextEditingController _supplierController;
  final TextEditingController _supplierArticleNumberController;
  final TextEditingController _manufacturerController;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Einkauf', style: TextStyles.h3BoldPrimary),
            const Divider(height: 30),
            Row(
              children: [
                Expanded(
                  child: MyTextFormField(
                    labelText: 'EK-Preis',
                    controller: _wholesalePriceController,
                  ),
                ),
                Gaps.w8,
                Expanded(
                  child: MyTextFormField(
                    labelText: 'Lief. Name',
                    controller: _supplierController,
                  ),
                ),
              ],
            ),
            Gaps.h8,
            Row(
              children: [
                Expanded(
                  child: MyTextFormField(
                    labelText: 'Lief. Artikel-Nr.',
                    controller: _supplierArticleNumberController,
                  ),
                ),
                Gaps.w8,
                Expanded(
                  child: MyTextFormField(
                    labelText: 'Hersteller',
                    controller: _manufacturerController,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
