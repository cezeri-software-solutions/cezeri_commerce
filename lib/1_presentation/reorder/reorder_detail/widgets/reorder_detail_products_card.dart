import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/reorder_detail/reorder_detail_bloc.dart';
import '../../../../constants.dart';
import '../../../core/widgets/my_circular_progress_indicator.dart';
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
                    const Expanded(
                      flex: RowWidthsRDP.articleNumber,
                      child: Text('Artikelnr.', style: TextStyles.s12Bold),
                    ),
                    Gaps.w8,
                    const Expanded(
                      flex: RowWidthsRDP.articleName,
                      child: Text('Name', style: TextStyles.s12Bold),
                    ),
                    Gaps.w8,
                    const Expanded(
                      flex: RowWidthsRDP.tax,
                      child: Text('Steuer', style: TextStyles.s12Bold),
                    ),
                    Gaps.w8,
                    const Expanded(
                      flex: RowWidthsRDP.quantity,
                      child: Text('Menge', style: TextStyles.s12Bold),
                    ),
                    Gaps.w8,
                    const Expanded(
                      flex: RowWidthsRDP.unitPriceNet,
                      child: Text('Netto Stk.', style: TextStyles.s12Bold),
                    ),
                    Gaps.w8,
                    const Expanded(
                      flex: RowWidthsRDP.discountGrossUnit,
                      child: Text('Rabatt %', style: TextStyles.s12Bold),
                    ),
                    Gaps.w8,
                    const Expanded(
                      flex: RowWidthsRDP.unitPriceGross,
                      child: Text('Brutto Stk.', style: TextStyles.s12Bold),
                    ),
                    Gaps.w8,
                    const Expanded(
                      flex: RowWidthsRDP.totalPriceGross,
                      child: Text('Gesamt Brutto', style: TextStyles.s12Bold),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    state.isLoadingOnObserveReorderDetailProducts
                        ? const MyCircularProgressIndicator()
                        : TextButton.icon(
                            onPressed: () => state.listOfProducts == null
                                ? reorderDetailBloc.add(OnReorderDetailGetProductsEvent())
                                : showReorderDetailProductsDialog(context, reorderDetailBloc),
                            icon: const Icon(Icons.add, color: Colors.green),
                            label: const Text('Aus Artikelliste'),
                          ),
                    TextButton.icon(
                      onPressed: () {}, //widget.receiptDetailBloc.add(AddProductToReceiptProductsEvent(receiptProduct: ReceiptProduct.empty())),
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
