import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/product/product_bloc.dart';
import '../../../../constants.dart';
import '../../../core/widgets/my_form_field_small.dart';

class PurchaseCard extends StatelessWidget {
  final ProductBloc productBloc;

  const PurchaseCard({super.key, required this.productBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      bloc: productBloc,
      builder: (context, state) {
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
                      child: MyTextFormFieldSmall(
                        labelText: 'EK-Preis',
                        controller: state.wholesalePriceController,
                      ),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Lief. Name',
                        controller: state.supplierController,
                      ),
                    ),
                  ],
                ),
                Gaps.h8,
                Row(
                  children: [
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Lief. Artikel-Nr.',
                        controller: state.supplierArticleNumberController,
                      ),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Hersteller',
                        controller: state.manufacturerController,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
