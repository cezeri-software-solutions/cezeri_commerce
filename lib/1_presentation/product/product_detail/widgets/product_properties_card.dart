import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/product_detail/product_detail_bloc.dart';
import '../../../../constants.dart';

class ProductPropertiesCard extends StatelessWidget {
  final ProductDetailBloc productDetailBloc;

  const ProductPropertiesCard({super.key, required this.productDetailBloc});

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
                const Text('Eigenschaften', style: TextStyles.h3BoldPrimary),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Auslaufartikel: '),
                    Checkbox.adaptive(
                      value: state.product!.isOutlet,
                      onChanged: (val) => productDetailBloc.add(OnProductIsOutletChangedEvent(value: val!)),
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
