import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/product/product_bloc.dart';
import '../../../../constants.dart';
import '../../../core/widgets/my_form_field_small.dart';

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
                MyTextFormFieldSmall(
                  labelText: 'Gewicht',
                  controller: state.weightController,
                ),
                Gaps.h16,
                MyTextFormFieldSmall(
                  labelText: 'Breite cm',
                  controller: state.widthController,
                ),
                Gaps.h16,
                MyTextFormFieldSmall(
                  labelText: 'Höhe cm',
                  controller: state.heightController,
                ),
                Gaps.h16,
                MyTextFormFieldSmall(
                  labelText: 'Tiefe cm',
                  controller: state.depthController,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
