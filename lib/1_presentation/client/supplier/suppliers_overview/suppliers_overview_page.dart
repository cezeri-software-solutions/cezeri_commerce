import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../2_application/database/supplier/supplier_bloc.dart';
import '../../../../3_domain/entities/reorder/supplier.dart';
import '../../../../constants.dart';
import '../../../../routes/router.gr.dart';
import '../../../core/core.dart';
import '../supplier_detail/supplier_detail_screen.dart';

class SuppliersOverviewPage extends StatelessWidget {
  final SupplierBloc supplierBloc;

  const SuppliersOverviewPage({super.key, required this.supplierBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierBloc, SupplierState>(
      builder: (context, state) {
        if (state.isLoadingSuppliersOnObserve) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }
        if (state.firebaseFailure != null && state.isAnyFailure) {
          return const Expanded(child: Center(child: Text('Ein Fehler beim Laden der Lieferanten ist aufgetreten!')));
        }
        if (state.listOfAllSuppliers == null || state.listOfFilteredSuppliers == null) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }
        if (state.listOfAllSuppliers!.isEmpty) {
          return const Expanded(child: Center(child: Text('Du hast noch keine Lieferanten angelegt oder importiert!')));
        }

        return Expanded(
          child: Scrollbar(
            child: ListView.separated(
              itemCount: state.listOfFilteredSuppliers!.length,
              itemBuilder: (context, index) {
                final supplier = state.listOfFilteredSuppliers![index];
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox.adaptive(
                            value: state.isAllSuppliersSelected,
                            onChanged: (value) => supplierBloc.add(OnSelectAllSuppliersEvent(isSelected: value!)),
                          ),
                          const Expanded(child: Text('Lieferant', style: TextStyles.h3Bold)),
                          const Expanded(child: Text('Adresse', style: TextStyles.h3Bold)),
                        ],
                      ),
                      _SupplierContainer(supplier: supplier, index: index, supplierBloc: supplierBloc),
                    ],
                  );
                } else {
                  return _SupplierContainer(supplier: supplier, index: index, supplierBloc: supplierBloc);
                }
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
        );
      },
    );
  }
}

class _SupplierContainer extends StatelessWidget {
  final Supplier supplier;
  final int index;
  final SupplierBloc supplierBloc;

  const _SupplierContainer({required this.supplier, required this.index, required this.supplierBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierBloc, SupplierState>(
      bloc: supplierBloc,
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Row(
            children: [
              Checkbox.adaptive(
                value: state.selectedSuppliers.any((e) => e.id == supplier.id),
                onChanged: (_) => supplierBloc.add(OnSupplierSelectedEvent(supplier: supplier)),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    supplierBloc.add(GetSupplierEvent(supplier: supplier));
                    context.router.push(SupplierDetailRoute(supplierBloc: supplierBloc, supplierCreateOrEdit: SupplierCreateOrEdit.edit));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(supplier.supplierNumber.toString()),
                      Text(supplier.company),
                      Text(supplier.name),
                      Text(DateFormat('dd.MM.yyy', 'de').format(supplier.creationDate)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(supplier.street),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: supplier.postcode),
                          const TextSpan(text: ' '),
                          TextSpan(text: supplier.city),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(supplier.country.name),
                        Gaps.w8,
                        MyCountryFlag(country: supplier.country, size: 12),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
