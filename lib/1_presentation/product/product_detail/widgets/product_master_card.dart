import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/product_detail/product_detail_bloc.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

class ProductMasterCard extends StatelessWidget {
  final ProductDetailBloc productDetailBloc;

  const ProductMasterCard({super.key, required this.productDetailBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      bloc: productDetailBloc,
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
                        fieldTitle: 'Artikel-Nr.',
                        controller: state.articleNumberController,
                        onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                      ),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: MyTextFormFieldSmall(
                        fieldTitle: 'EAN',
                        controller: state.eanController,
                        onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                      ),
                    ),
                  ],
                ),
                Gaps.h8,
                Row(
                  children: [
                    Expanded(
                      child: MyTextFormFieldSmall(
                        fieldTitle: 'Artikel-Bez.',
                        controller: state.nameController,
                        onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.router.push(ProductDescriptionRoute(productDetailBloc: productDetailBloc)),

                      // productDetailBloc.add(OnProductShowDescriptionChangedEvent()),

                      // () async => await showDialog(
                      //   context: context,
                      //   barrierDismissible: false,
                      //   builder: (_) => BlocProvider.value(
                      //     value: productDetailBloc,
                      //     child: DescriptionDialog(productDetailBloc: productDetailBloc),
                      //   ),
                      // ),
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
