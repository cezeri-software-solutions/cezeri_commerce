import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/reorder/reorder_bloc.dart';
import '../../../../3_domain/entities/reorder/supplier.dart';
import '../../../../constants.dart';
import '../../../../routes/router.gr.dart';
import '../../reorder_detail/reorder_detail_screen.dart';

class SelectReorderSupplierDialog extends StatelessWidget {
  final ReorderBloc reorderBloc;

  const SelectReorderSupplierDialog({super.key, required this.reorderBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReorderBloc, ReorderState>(
      bloc: reorderBloc,
      builder: (context, state) {
        if (state.listOfFilteredSuppliers.isEmpty) reorderBloc.add(OnReorderGetAllSuppliersEvent());

        if (state.firebaseFailure != null && state.isAnyFailure) {
          return Dialog(child: SizedBox(width: 600, height: 1200, child: Center(child: Text(state.firebaseFailure.toString()))));
        }
        if (state.isLoadingReorderSuppliersOnObserve || state.listOfFilteredSuppliers.isEmpty) {
          return const Dialog(child: SizedBox(width: 600, height: 1200, child: Center(child: CircularProgressIndicator())));
        }

        List<Supplier> supplierList = state.listOfFilteredSuppliers;
        final screenHeight = MediaQuery.sizeOf(context).height;
        final screenWidth = MediaQuery.sizeOf(context).width;

        return Dialog(
          child: SizedBox(
            height: screenHeight > 1200 ? 1200 : screenHeight,
            width: screenWidth > 600 ? 600 : screenWidth,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoSearchTextField(
                        controller: state.supplierSearchController,
                        onChanged: (value) => reorderBloc.add(OnReorderSetFilteredSuppliersEvent()),
                        onSuffixTap: () => reorderBloc.add(OnReorderSupplierSearchTextClearedEvent()),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: supplierList.length,
                    itemBuilder: ((context, index) {
                      final supplier = supplierList[index];
                      return Column(
                        children: [
                          if (index == 0) Gaps.h10,
                          ListTile(
                            title: Text(supplier.company, style: TextStyles.defaultt),
                            subtitle: Text(supplier.supplierNumber.toString()),
                            onTap: () {
                              reorderBloc.add(OnReorderSupplierSearchTextClearedEvent());
                              context.router.maybePop();
                              context.router.push(ReorderDetailRoute(reorderCreateOrEdit: ReorderCreateOrEdit.create, supplier: supplier));
                            },
                          ),
                          const Divider(height: 0),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
