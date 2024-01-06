import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/product_detail/product_detail_bloc.dart';
import '../../../../3_domain/entities/product/product.dart';
import '../../../../constants.dart';
import '../../../core/functions/dialogs.dart';

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
                Row(
                  children: [
                    const Text('Set-Artikel', style: TextStyles.h2Bold),
                    if (state.product!.isSetArticle) ...[
                      Gaps.w16,
                      IconButton(onPressed: () {}, icon: const Icon(Icons.delete, color: Colors.red)),
                    ],
                  ],
                ),
                Row(
                  children: [
                    if (state.product!.isSetArticle) ...[
                      IconButton(onPressed: () {}, icon: const Icon(Icons.add, color: Colors.green)),
                      Gaps.w16,
                    ],
                    Switch.adaptive(value: state.product!.isSetArticle, onChanged: (value) => _setIsSetArticle(context, state.product!, value)),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _setIsSetArticle(BuildContext context, Product product, bool value) {
    if (product.haveVariants && value) {
      showMyDialogAlert(context: context, title: 'Achtung', content: 'Ein Artikel kann kein Variantenartikel und Set-Artikel zugleich sein');
      return;
    }

    productDetailBloc.add(OnProductSetIsSetArticleEvent());
  }
}
