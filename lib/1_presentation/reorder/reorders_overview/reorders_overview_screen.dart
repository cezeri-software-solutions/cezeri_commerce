import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/reorder/reorder_bloc.dart';
import '../../../injection.dart';
import '../../app_drawer.dart';
import '../../core/functions/my_scaffold_messanger.dart';
import '../../core/widgets/my_delete_dialog.dart';
import '../../core/widgets/my_info_dialog.dart';
import 'reorders_overview_page.dart';
import 'widgets/select_reorder_supplier_dialog.dart';

@RoutePage()
class ReordersOverviewScreen extends StatelessWidget {
  const ReordersOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reorderBloc = sl<ReorderBloc>()..add(GetAllReordersEvenet());

    final searchController = TextEditingController();

    return BlocProvider(
      create: (context) => reorderBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<ReorderBloc, ReorderState>(
            listenWhen: (p, c) => p.fosReordersOnObserveOption != c.fosReordersOnObserveOption,
            listener: (context, state) {
              state.fosReordersOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
                  (listOfProducts) => myScaffoldMessenger(context, null, null, 'Nachbestellungen wurden erfolgreich geladen', null),
                ),
              );
            },
          ),
          BlocListener<ReorderBloc, ReorderState>(
            listenWhen: (p, c) => p.fosReorderOnDeleteOption != c.fosReorderOnDeleteOption,
            listener: (context, state) {
              state.fosReorderOnDeleteOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
                  (reorder) => myScaffoldMessenger(context, null, null, 'Ausgewählte Nachbestellungen erfolgreich gelöscht', null),
                ),
              );
            },
          ),
          BlocListener<ReorderBloc, ReorderState>(
            listenWhen: (p, c) => p.fosReorderOnObserveSuppliersOption != c.fosReorderOnObserveSuppliersOption,
            listener: (context, state) {
              state.fosReorderOnObserveSuppliersOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
                  (suppliers) => _openSelectSupplierDialog(context, reorderBloc),
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<ReorderBloc, ReorderState>(
          builder: (context, state) {
            return Scaffold(
              drawer: const AppDrawer(),
              appBar: AppBar(
                title: Text(state.listOfFilteredReorders != null ? 'Nachbestellungen (${state.listOfFilteredReorders!.length})' : 'Nachbestellungen'),
                actions: [
                  IconButton(onPressed: () => context.read<ReorderBloc>().add(GetAllReordersEvenet()), icon: const Icon(Icons.refresh)),
                  IconButton(
                      onPressed: () {
                        if (state.listOfSuppliers.isEmpty) {
                          reorderBloc.add(OnReorderGetAllSuppliersEvent());
                        } else {
                          _openSelectSupplierDialog(context, reorderBloc);
                        }
                      },
                      icon: const Icon(Icons.add, color: Colors.green)),
                  IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => state.selectedReorders.isEmpty
                          ? const MyInfoDialog(title: 'Achtung!', content: 'Bitte wähle mindestens einen Artikel aus.')
                          : MyDeleteDialog(
                              content: 'Bist du sicher, dass du alle ausgewählten Artikel unwiederruflich löschen willst?',
                              onConfirm: () {
                                context.read<ReorderBloc>().add(DeleteSelectedReordersEvent(selectedReorders: state.selectedReorders));
                                context.router.pop();
                              },
                            ),
                    ),
                    icon: state.isLoadingReorderOnDelete
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
                      onChanged: (value) => context.read<ReorderBloc>().add(SetSearchFieldTextEvent(searchText: value)),
                      onSubmitted: (value) => context.read<ReorderBloc>().add(OnSearchFieldSubmittedEvent()),
                      onSuffixTap: () {
                        searchController.clear();
                        context.read<ReorderBloc>().add(SetSearchFieldTextEvent(searchText: ''));
                        context.read<ReorderBloc>().add(OnSearchFieldSubmittedEvent());
                      },
                    ),
                  ),
                  ReordersOverviewPage(reorderBloc: reorderBloc),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

void _openSelectSupplierDialog(BuildContext context, ReorderBloc reorderBloc) {
  showDialog(context: context, builder: (_) => BlocProvider.value(value: reorderBloc, child: SelectReorderSupplierDialog(reorderBloc: reorderBloc)));
}
