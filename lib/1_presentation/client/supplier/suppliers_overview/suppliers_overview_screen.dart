import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/app_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../../../2_application/database/supplier/supplier_bloc.dart';
import '../../../../3_domain/entities/reorder/supplier.dart';
import '../../../../injection.dart';
import '../../../../routes/router.gr.dart';
import '../../../core/core.dart';
import '../supplier_detail/supplier_detail_screen.dart';
import 'suppliers_overview_page.dart';

@RoutePage()
class SuppliersOverviewScreen extends StatelessWidget {
  const SuppliersOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supplierBloc = sl<SupplierBloc>()..add(GetAllSuppliersEvenet());

    final searchController = TextEditingController();

    return BlocProvider(
      create: (context) => supplierBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<SupplierBloc, SupplierState>(
            listenWhen: (p, c) => p.fosSuppliersOnObserveOption != c.fosSuppliersOnObserveOption,
            listener: (context, state) {
              state.fosSuppliersOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (listOfProducts) => myScaffoldMessenger(context, null, null, 'Lieferanten wurden erfolgreich geladen', null),
                ),
              );
            },
          ),
          BlocListener<SupplierBloc, SupplierState>(
            listenWhen: (p, c) => p.fosSupplierOnDeleteOption != c.fosSupplierOnDeleteOption,
            listener: (context, state) {
              state.fosSupplierOnDeleteOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, failure),
                  (supplier) => myScaffoldMessenger(context, null, null, 'Ausgewählte Lieferanten erfolgreich gelöscht', null),
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<SupplierBloc, SupplierState>(
          builder: (context, state) {
            return Scaffold(
              drawer: const AppDrawer(),
              appBar: AppBar(
                title: const Text('Lieferanten'),
                actions: [
                  IconButton(onPressed: () => context.read<SupplierBloc>().add(GetAllSuppliersEvenet()), icon: const Icon(Icons.refresh)),
                  IconButton(
                      onPressed: () {
                        final newSupplier =
                            Supplier.empty().copyWith(supplierNumber: context.read<MainSettingsBloc>().state.mainSettings!.nextSupplierNumber);
                        supplierBloc.add(SetSupplierEvent(supplier: newSupplier));
                        context.router.push(SupplierDetailRoute(supplierBloc: supplierBloc, supplierCreateOrEdit: SupplierCreateOrEdit.create));
                      },
                      icon: const Icon(Icons.add, color: Colors.green)),
                  IconButton(
                    onPressed: state.selectedSuppliers.isEmpty
                        ? () => showMyDialogAlert(context: context, title: 'Achtung!', content: 'Bitte wähle mindestens einen Lieferanten aus.')
                        : () => showMyDialogDelete(
                              context: context,
                              content: 'Bist du sicher, dass du alle ausgewählten Lieferanten unwiederruflich löschen willst?',
                              onConfirm: () {
                                context.read<SupplierBloc>().add(DeleteSelectedSuppliersEvent(selectedSuppliers: state.selectedSuppliers));
                                context.router.pop();
                              },
                            ),
                    icon: state.isLoadingSupplierOnDelete
                        ? const CircularProgressIndicator(color: Colors.red)
                        : const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: CupertinoSearchTextField(
                      controller: searchController,
                      onChanged: (value) => context.read<SupplierBloc>().add(SetSearchFieldTextEvent(searchText: value)),
                      onSubmitted: (value) => context.read<SupplierBloc>().add(OnSearchFieldSubmittedEvent()),
                      onSuffixTap: () {
                        searchController.clear();
                        context.read<SupplierBloc>().add(SetSearchFieldTextEvent(searchText: ''));
                        context.read<SupplierBloc>().add(OnSearchFieldSubmittedEvent());
                      },
                    ),
                  ),
                  SuppliersOverviewPage(supplierBloc: supplierBloc),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
