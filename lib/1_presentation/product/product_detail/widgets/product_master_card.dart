import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/product/product_bloc.dart';
import '../../../../constants.dart';
import '../../../core/widgets/my_form_field_small.dart';
import 'description_dialog.dart';

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
                        onChanged: (_) => productBloc.add(OnProductControllerChangedEvent()),
                      ),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'EAN',
                        controller: state.eanController,
                        onChanged: (_) => productBloc.add(OnProductControllerChangedEvent()),
                      ),
                    ),
                  ],
                ),
                Gaps.h8,
                Row(
                  children: [
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Artikel-Bez.',
                        controller: state.nameController,
                        onChanged: (_) => productBloc.add(OnProductControllerChangedEvent()),
                      ),
                    ),
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => BlocProvider.value(
                          value: productBloc,
                          child: DescriptionDialog(productBloc: productBloc),
                        ),
                      ),
                      icon: const Icon(Icons.description, color: CustomColors.primaryColor),
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
