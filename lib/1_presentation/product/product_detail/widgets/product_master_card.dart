import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/product/product_bloc.dart';
import '../../../../constants.dart';
import '../../../core/widgets/my_form_field_small.dart';

class ProductMasterCard extends StatelessWidget {
  final ProductBloc productBloc;

  const ProductMasterCard({super.key, required this.productBloc});

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
                const Text('Artikelstamm', style: TextStyles.h3BoldPrimary),
                const Divider(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Artikel-Nr.',
                        controller: state.articleNumberController,
                      ),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'EAN',
                        controller: state.eanController,
                      ),
                    ),
                  ],
                ),
                Gaps.h8,
                MyTextFormFieldSmall(
                  labelText: 'Artikel-Bez.',
                  controller: state.nameController,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
