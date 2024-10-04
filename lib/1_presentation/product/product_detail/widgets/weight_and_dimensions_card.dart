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
                MyTextFormFieldSmall(
                  fieldTitle: 'Gewicht kg',
                  controller: state.weightController,
                  inputType: FieldInputType.double,
                  onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                ),
                Gaps.h16,
                MyTextFormFieldSmall(
                  fieldTitle: 'Höhe cm',
                  controller: state.heightController,
                  inputType: FieldInputType.double,
                  onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                ),
                Gaps.h16,
                MyTextFormFieldSmall(
                  fieldTitle: 'Länge cm',
                  controller: state.depthController,
                  inputType: FieldInputType.double,
                  onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                ),
                Gaps.h16,
                MyTextFormFieldSmall(
                  fieldTitle: 'Breite cm',
                  controller: state.widthController,
                  inputType: FieldInputType.double,
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
