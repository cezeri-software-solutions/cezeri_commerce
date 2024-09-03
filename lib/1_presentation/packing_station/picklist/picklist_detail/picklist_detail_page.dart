import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/packing_station/packing_station_bloc.dart';
import '../../../../3_domain/entities/picklist/picklist_product.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

class PicklistDetailPage extends StatelessWidget {
  final PackingStationBloc packingStationBloc;

  const PicklistDetailPage({super.key, required this.packingStationBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackingStationBloc, PackingStationState>(
      bloc: packingStationBloc,
      builder: (context, state) {
        if (state.picklist == null) return const Center(child: MyCircularProgressIndicator());
        return ListView.builder(
          itemCount: state.picklist!.listOfPicklistProducts.length,
          itemBuilder: (context, index) {
            final sortedListOfProducts = state.picklist!.listOfPicklistProducts..sort((a, b) => a.name.compareTo(b.name));
            final picklistProduct = sortedListOfProducts[index];
            int totalQuantity = 0;
            for (final picklistProduct in state.picklist!.listOfPicklistProducts) {
              totalQuantity += picklistProduct.quantity;
            }

            return Column(
              children: [
                if (index == 0) const Divider(height: 2),
                _PicklistProductsContainer(packingStationBloc: packingStationBloc, picklistProduct: picklistProduct, index: index),
                const Divider(height: 2),
                if (index == state.picklist!.listOfPicklistProducts.length - 1) ...[
                  Gaps.h24,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 250,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 2)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Aufträge:', style: TextStyles.h3),
                                Text(state.picklist!.listOfPicklistAppointments.length.toString(), style: TextStyles.h3Bold)
                              ],
                            ),
                            Gaps.h10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Artikel:', style: TextStyles.h3),
                                Text(state.picklist!.listOfPicklistProducts.length.toString(), style: TextStyles.h3Bold)
                              ],
                            ),
                            Gaps.h10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [const Text('Stückzahl:', style: TextStyles.h3), Text(totalQuantity.toString(), style: TextStyles.h3Bold)],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Gaps.h24,
                ]
              ],
            );
          },
        );
      },
    );
  }
}

class _PicklistProductsContainer extends StatelessWidget {
  final PackingStationBloc packingStationBloc;
  final PicklistProduct picklistProduct;
  final int index;

  const _PicklistProductsContainer({required this.packingStationBloc, required this.picklistProduct, required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackingStationBloc, PackingStationState>(
      bloc: packingStationBloc,
      builder: (context, state) {
        return Container(
          color: picklistProduct.pickedQuantity != picklistProduct.quantity ? Colors.white : Colors.green[200],
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Gaps.w8,
              picklistProduct.imageUrl != null && picklistProduct.imageUrl != ''
                  ? MyAvatar(name: picklistProduct.name, imageUrl: picklistProduct.imageUrl, fit: BoxFit.scaleDown)
                  : const SizedBox(height: 50, width: 50, child: Icon(Icons.question_mark)),
              Gaps.w8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(picklistProduct.articleNumber),
                    MyText(picklistProduct.name),
                  ],
                ),
              ),
              Text('${picklistProduct.pickedQuantity} / ${picklistProduct.quantity}', style: TextStyles.h2Bold),
              Gaps.w16,
              InkWell(
                onTap: () => packingStationBloc.add(PicklistOnPicklistQuantityChanged(index: index, isSubtract: true, pickCompletely: false)),
                child: Container(color: Colors.orange, height: 50, width: 50, child: const Icon(Icons.remove, color: Colors.white)),
              ),
              Gaps.w8,
              InkWell(
                onTap: () => packingStationBloc.add(PicklistOnPicklistQuantityChanged(index: index, isSubtract: false, pickCompletely: false)),
                child: Container(color: Colors.green, height: 50, width: 50, child: const Icon(Icons.add, color: Colors.white)),
              ),
              Gaps.w8,
              InkWell(
                onTap: () => packingStationBloc.add(PicklistOnPicklistQuantityChanged(index: index, isSubtract: false, pickCompletely: true)),
                child: Container(color: Colors.blue, height: 50, width: 50, child: const Icon(Icons.checklist, color: Colors.white)),
              ),
              Gaps.w8,
            ],
          ),
        );
      },
    );
  }
}
