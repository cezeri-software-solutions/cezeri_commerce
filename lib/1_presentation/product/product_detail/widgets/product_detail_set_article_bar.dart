import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../../2_application/firebase/product_detail/product_detail_bloc.dart';
import '../../../../3_domain/entities/product/product.dart';
import '../../../../constants.dart';
import '../../../core/functions/dialogs.dart';
import '../../../core/widgets/my_circular_progress_indicator.dart';

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
                      IconButton(
                        onPressed: () {
                          if (state.listOfProducts != null) {
                            _showProductsDialog(context, productDetailBloc, state.listOfProducts);
                          } else {
                            productDetailBloc.add(GetListOfProductsEvent());
                            _showProductsDialog(context, productDetailBloc, state.listOfProducts);
                          }
                        },
                        icon: const Icon(Icons.add, color: Colors.green),
                      ),
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

  void _showProductsDialog(BuildContext context, ProductDetailBloc productDetailBloc, List<Product>? listOfProducts) {
    final pageIndexNotifier = ValueNotifier(listOfProducts == null ? 0 : 1);

    WoltModalSheet.show(
      pageIndexNotifier: pageIndexNotifier,
      context: context,
      pageListBuilder: (woltContext) {
        return [
          WoltModalSheetPage(
            child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
              bloc: productDetailBloc,
              builder: (context, state) {
                if (state.listOfProducts != null) {
                  pageIndexNotifier.value = 1;
                  return const SizedBox();
                }
                return const MyCircularProgressIndicator();
              },
            ),
          ),
          WoltModalSheetPage(child: const Text('Hallo')),
        ];
      },
    );
  }
}
