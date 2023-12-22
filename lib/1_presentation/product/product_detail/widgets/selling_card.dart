import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/product/product_bloc.dart';
import '../../../../constants.dart';
import '../../../core/widgets/my_form_field_small.dart';

class SellingCard extends StatelessWidget {
  final ProductBloc productBloc;

  const SellingCard({super.key, required this.productBloc});

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
                const Text('Verkauf', style: TextStyles.h3BoldPrimary),
                const Divider(),
                MyTextFormFieldSmall(
                  labelText: 'VK-Preis Netto',
                  controller: state.netPriceController,
                  onChanged: (_) => productBloc.add(OnProductSalesPriceControllerChangedEvent(isNet: true)),
                ),
                Gaps.h16,
                MyTextFormFieldSmall(
                  labelText: 'VK-Preis Brutto',
                  controller: state.grossPriceController,
                  onChanged: (_) => productBloc.add(OnProductSalesPriceControllerChangedEvent(isNet: false)),
                ),
                Gaps.h16,
                MyTextFormFieldSmall(
                  labelText: 'UVP',
                  controller: state.recommendedRetailPriceController,
                  onChanged: (_) => productBloc.add(OnProductControllerChangedEvent()),
                ),
                Gaps.h16,
                MyTextFormFieldSmall(
                  labelText: 'Einheitspreis Netto',
                  controller: state.unitPriceController,
                  onChanged: (_) => productBloc.add(OnProductControllerChangedEvent()),
                ),
                Gaps.h16,
                MyTextFormFieldSmall(
                  labelText: 'Einheit',
                  hintText: 'z.B. pro 1 L',
                  controller: state.unityController,
                  onChanged: (_) => productBloc.add(OnProductControllerChangedEvent()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
