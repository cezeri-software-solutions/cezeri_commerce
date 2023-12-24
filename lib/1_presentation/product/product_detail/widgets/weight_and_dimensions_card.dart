import 'package:cezeri_commerce/1_presentation/core/widgets/my_text_form_field_small_double.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/product/product_bloc.dart';
import '../../../../constants.dart';

class WeightAndDimensionsCard extends StatelessWidget {
  final ProductBloc productBloc;

  const WeightAndDimensionsCard({super.key, required this.productBloc});

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
                const Text('Gewicht & Abmessungen', style: TextStyles.h3BoldPrimary),
                const Divider(),
                MyTextFormFieldSmallDouble(
                  aboveText: 'Gewicht kg',
                  controller: state.weightController,
                  onChanged: (_) => productBloc.add(OnProductControllerChangedEvent()),
                ),
                Gaps.h16,
                MyTextFormFieldSmallDouble(
                  aboveText: 'Höhe cm',
                  controller: state.heightController,
                  onChanged: (_) => productBloc.add(OnProductControllerChangedEvent()),
                ),
                Gaps.h16,
                MyTextFormFieldSmallDouble(
                  aboveText: 'Länge cm',
                  controller: state.depthController,
                  onChanged: (_) => productBloc.add(OnProductControllerChangedEvent()),
                ),
                Gaps.h16,
                MyTextFormFieldSmallDouble(
                  aboveText: 'Breite cm',
                  controller: state.widthController,
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
