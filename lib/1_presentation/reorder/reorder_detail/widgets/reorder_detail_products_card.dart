import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/3_domain/entities/reorder/reorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/reorder_detail/reorder_detail_bloc.dart';
import '../../../../3_domain/entities/product/product.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';
import '../functions/show_reorder_detail_products_dialog.dart';

class ReorderDetailProductsCard extends StatelessWidget {
  final ReorderDetailBloc reorderDetailBloc;

  const ReorderDetailProductsCard({super.key, required this.reorderDetailBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReorderDetailBloc, ReorderDetailState>(
      bloc: reorderDetailBloc,
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.article_outlined, color: Colors.transparent),
                    const Expanded(
                      flex: RWReOP.pos,
                      child: Text('Pos.', style: TextStyles.s12Bold),
                    ),
                    Gaps.w8,
                    const Expanded(
                      flex: RWReOP.articleNumber,
                      child: Text('Artikelnr.', style: TextStyles.s12Bold),
                    ),
                    Gaps.w8,
                    const Expanded(
                      flex: RWReOP.articleName,
                      child: Text('Name', style: TextStyles.s12Bold),
                    ),
                    Gaps.w8,
                    const Expanded(
                      flex: RWReOP.quantity,
                      child: Text('Menge', style: TextStyles.s12Bold),
                    ),
                    Gaps.w8,
                    const Expanded(
                      flex: RWReOP.openQuantity,
                      child: Text('Offene Menge', style: TextStyles.s12Bold),
                    ),
                    Gaps.w8,
                    const Expanded(
                      flex: RWReOP.price,
                      child: Text('Netto Stk.', style: TextStyles.s12Bold),
                    ),
                    Gaps.w8,
                    const Expanded(
                      flex: RWReOP.totalPrice,
                      child: Text('Netto Ges.', style: TextStyles.s12Bold),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 28),
                      child: const IconButton(
                        onPressed: null,
                        padding: EdgeInsets.zero,
                        splashRadius: 0.0001,
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.delete, color: Colors.transparent),
                      ),
                    ),
                  ],
                ),
                Gaps.h8,
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.reorder!.listOfReorderProducts.length,
                  itemBuilder: (context, index) {
                    final reorderProduct = state.reorder!.listOfReorderProducts[index];
                    final openQuantity = reorderProduct.quantity - reorderProduct.bookedQuantity;

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => showMyProductQuickViewById(context: context, productId: reorderProduct.productId, showStatProduct: true),
                              child: const Icon(Icons.article_outlined, color: CustomColors.primaryColor),
                            ),
                            Gaps.w8,
                            Expanded(
                              flex: RWReOP.pos,
                              child: MyTextFormFieldSmallDouble(
                                readOnly: true,
                                hintText: reorderProduct.pos.toString(),
                                fillColor: reorderProduct.productId.isEmpty || reorderProduct.productId.startsWith('00000')
                                    ? CustomColors.backgroundLightOrange
                                    : null,
                              ),
                            ),
                            Gaps.w8,
                            Expanded(
                              flex: RWReOP.articleNumber,
                              child: MyTextFormFieldSmall(
                                readOnly: !state.isEditable[index],
                                controller: state.articleNumberControllers[index],
                                onChanged: (_) => reorderDetailBloc.add(OnReorderDetailPosControllerChangedEvent()),
                                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                              ),
                            ),
                            Gaps.w8,
                            Expanded(
                              flex: RWReOP.articleName,
                              child: MyTextFormFieldSmall(
                                readOnly: !state.isEditable[index],
                                controller: state.articleNameControllers[index],
                                onChanged: (_) => reorderDetailBloc.add(OnReorderDetailPosControllerChangedEvent()),
                                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                              ),
                            ),
                            Gaps.w8,
                            Expanded(
                              flex: RWReOP.quantity,
                              child: MyTextFormFieldSmall(
                                controller: state.quantityControllers[index],
                                onChanged: (_) => reorderDetailBloc.add(OnReorderDetailPosControllerChangedEvent()),
                                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                              ),
                            ),
                            Gaps.w8,
                            Expanded(
                              flex: RWReOP.openQuantity,
                              child: MyTextFormFieldSmall(
                                readOnly: true,
                                fillColor: state.reorder!.reorderStatus == ReorderStatus.partiallyCompleted && openQuantity > 0
                                    ? CustomColors.backgroundLightOrange
                                    : null,
                                hintText: openQuantity.toString(),
                                onChanged: (_) => reorderDetailBloc.add(OnReorderDetailPosControllerChangedEvent()),
                                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                              ),
                            ),
                            Gaps.w8,
                            Expanded(
                              flex: RWReOP.price,
                              child: MyTextFormFieldSmall(
                                controller: state.wholesalePriceNetControllers[index],
                                onChanged: (_) => reorderDetailBloc.add(OnReorderDetailPosControllerChangedEvent()),
                                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                              ),
                            ),
                            Gaps.w8,
                            Expanded(
                              flex: RWReOP.totalPrice,
                              child: MyTextFormFieldSmall(
                                readOnly: true,
                                hintText: reorderProduct.totalPriceNet.toDouble().toString(),
                                onChanged: (_) => reorderDetailBloc.add(OnReorderDetailPosControllerChangedEvent()),
                                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                              ),
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 28),
                              child: IconButton(
                                onPressed: () => showMyDialogDelete(
                                  context: context,
                                  content: 'Bist du sicher, dass du den Artikel "//${reorderProduct.name}" löschen willst?',
                                  onConfirm: () {
                                    reorderDetailBloc.add(OnReorderDeatilRemoveProductEvent(index: index));
                                    context.router.maybePop();
                                  },
                                ),
                                padding: EdgeInsets.zero,
                                splashRadius: 0.0001,
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                        Gaps.h8,
                      ],
                    );
                  },
                ),
                Gaps.h8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    state.isLoadingOnObserveReorderDetailProducts
                        ? const MyCircularProgressIndicator()
                        : TextButton.icon(
                            onPressed: () => state.listOfProducts == null || state.reloadProducts
                                ? reorderDetailBloc.add(OnReorderDetailGetProductsEvent())
                                : showReorderDetailProductsDialog(context, reorderDetailBloc),
                            icon: const Icon(Icons.add, color: Colors.green),
                            label: const Text('Aus Artikelliste'),
                          ),
                    TextButton.icon(
                      onPressed: () => reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: Product.empty(), quantity: 1)),
                      icon: const Icon(Icons.add, color: Colors.green),
                      label: const Text('Leeres Feld'),
                    ),
                  ],
                ),
                Gaps.h8,
              ],
            ),
          ),
        );
      },
    );
  }
}
