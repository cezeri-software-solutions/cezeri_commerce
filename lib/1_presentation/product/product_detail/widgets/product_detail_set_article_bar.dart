import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/product_detail/product_detail_bloc.dart';
import '../../../../constants.dart';

class ProductDetailSetArticleBar extends StatelessWidget {
  final ProductDetailBloc productDetailBloc;

  const ProductDetailSetArticleBar({super.key, required this.productDetailBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      bloc: productDetailBloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Set-Artikel',
                  style: TextStyles.h2Bold,
                ),
                Switch.adaptive(value: false, onChanged: (_) {}),
              ],
            ),
          ],
        );
      },
    );
  }
}
