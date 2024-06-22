import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/supplier/supplier_bloc.dart';
import '../../../core/core.dart';
import 'supplier_detail_page.dart';

enum SupplierCreateOrEdit { create, edit }

@RoutePage()
class SupplierDetailScreen extends StatelessWidget {
  final SupplierBloc supplierBloc;
  final SupplierCreateOrEdit supplierCreateOrEdit;

  const SupplierDetailScreen({super.key, required this.supplierBloc, required this.supplierCreateOrEdit});

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: const Text('Lieferant'));

    return MultiBlocListener(
      listeners: [
        BlocListener<SupplierBloc, SupplierState>(
          bloc: supplierBloc,
          listenWhen: (p, c) => p.fosSupplierOnCreateOption != c.fosSupplierOnCreateOption,
          listener: (context, state) {
            state.fosSupplierOnCreateOption.fold(
              () => null,
              (a) => a.fold(
                (failure) => failureRenderer(context, [failure]),
                (createdSupplier) {
                  context.router.popUntilRouteWithName(SuppliersOverviewRoute.name);
                  supplierBloc.add(GetSupplierEvent(supplier: createdSupplier));
                  context.router.push(SupplierDetailRoute(supplierBloc: supplierBloc, supplierCreateOrEdit: SupplierCreateOrEdit.edit));
                },
              ),
            );
          },
        ),
        BlocListener<SupplierBloc, SupplierState>(
          bloc: supplierBloc,
          listenWhen: (p, c) => p.fosSupplierOnUpdateOption != c.fosSupplierOnUpdateOption,
          listener: (context, state) {
            state.fosSupplierOnUpdateOption.fold(
              () => null,
              (a) => a.fold(
                (failure) => failureRenderer(context, [failure]),
                (updatedSupplier) => myScaffoldMessenger(context, null, null, 'Lieferant wurde erfolgreich aktualisiert', null),
              ),
            );
          },
        ),
      ],
      child: BlocBuilder<SupplierBloc, SupplierState>(
        bloc: supplierBloc,
        builder: (context, state) {
          if (state.isLoadingSupplierOnObserve) return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));
          if ((state.firebaseFailure != null) || (supplierCreateOrEdit == SupplierCreateOrEdit.edit && state.supplier == null)) {
            return Scaffold(appBar: appBar, body: const Center(child: Text('Ein Fehler ist aufgetreten')));
          }

          return SupplierDetailPage(supplier: state.supplier, supplierBloc: supplierBloc, supplierCreateOrEdit: supplierCreateOrEdit);
        },
      ),
    );
  }
}
