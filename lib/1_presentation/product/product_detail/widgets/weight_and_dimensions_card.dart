import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/product_detail/product_detail_bloc.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

class WeightAndDimensionsCard extends StatelessWidget {
  final ProductDetailBloc productDetailBloc;

  const WeightAndDimensionsCard({super.key, required this.productDetailBloc});

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
                const Text('Gewicht & Abmessungen', style: TextStyles.h3BoldPrimary),
                const Divider(),
                MyTextFormFieldSmallDouble(
                  aboveText: 'Gewicht kg',
                  controller: state.weightController,
                  onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                ),
                Gaps.h16,
                MyTextFormFieldSmallDouble(
                  aboveText: 'Höhe cm',
                  controller: state.heightController,
                  onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                ),
                Gaps.h16,
                MyTextFormFieldSmallDouble(
                  aboveText: 'Länge cm',
                  controller: state.depthController,
                  onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                ),
                Gaps.h16,
                MyTextFormFieldSmallDouble(
                  aboveText: 'Breite cm',
                  controller: state.widthController,
                  onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
