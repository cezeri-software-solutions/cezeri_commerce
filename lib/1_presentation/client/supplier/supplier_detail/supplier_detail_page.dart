import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/supplier/supplier_bloc.dart';
import '../../../../3_domain/entities/reorder/supplier.dart';
import '../../../../3_domain/enums/enums.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';
import 'supplier_detail_screen.dart';
import 'widgets/supplier_address_card.dart';
import 'widgets/supplier_master_card.dart';

class SupplierDetailPage extends StatelessWidget {
  final Supplier? supplier;
  final SupplierBloc supplierBloc;
  final SupplierCreateOrEdit supplierCreateOrEdit;

  const SupplierDetailPage({super.key, this.supplier, required this.supplierBloc, required this.supplierCreateOrEdit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierBloc, SupplierState>(
      bloc: supplierBloc,
      builder: (context, state) {
        final screenWidth = context.screenWidth;
        final responsiveness = screenWidth > 700 ? Responsiveness.isTablet : Responsiveness.isMobil;

        final appBar = AppBar(
          title: const Text('Lieferant'),
          centerTitle: responsiveness == Responsiveness.isTablet ? true : false,
          actions: [
            if (supplierCreateOrEdit == SupplierCreateOrEdit.edit)
              IconButton(
                onPressed: () => supplierBloc.add(GetSupplierEvent(supplier: state.supplier!)),
                icon: const Icon(Icons.refresh, size: 30),
              ),
            responsiveness == Responsiveness.isTablet ? Gaps.w32 : Gaps.w8,
            MyOutlinedButton(
              buttonText: 'Speichern',
              onPressed: () {
                if (supplierCreateOrEdit == SupplierCreateOrEdit.edit) {
                  supplierBloc.add(UpdateSupplierEvent());
                } else {
                  supplierBloc.add(CreateSupplierEvent());
                }
              },
              isLoading: state.isLoadingSupplierOnUpdate,
              buttonBackgroundColor: Colors.green,
            ),
            responsiveness == Responsiveness.isTablet ? Gaps.w32 : Gaps.w8,
          ],
        );

        return Scaffold(
          appBar: appBar,
          body: SafeArea(
            child: responsiveness == Responsiveness.isTablet
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SupplierMasterCard(supplierBloc: supplierBloc),
                              ),
                              Gaps.w8,
                              Expanded(
                                child: SupplierAddressCard(supplier: state.supplier!, supplierBloc: supplierBloc),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView(
                      children: [
                        SupplierMasterCard(supplierBloc: supplierBloc),
                        SupplierAddressCard(supplier: state.supplier!, supplierBloc: supplierBloc),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
