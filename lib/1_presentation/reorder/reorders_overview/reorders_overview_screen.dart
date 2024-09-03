import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/reorder/reorder_bloc.dart';
import '../../../injection.dart';
import '../../app_drawer.dart';
import '../../core/core.dart';
import 'reorders_overview_page.dart';
import 'widgets/select_reorder_supplier_dialog.dart';

@RoutePage()
class ReordersOverviewScreen extends StatelessWidget {
  const ReordersOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reorderBloc = sl<ReorderBloc>()..add(GetReordersEvenet(tabValue: 0));

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
                  (failure) => failureRenderer(context, [failure]),
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
                  (failure) => failureRenderer(context, [failure]),
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
                  (failure) => failureRenderer(context, [failure]),
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
                  IconButton(
                      onPressed: () => context.read<ReorderBloc>().add(GetReordersEvenet(tabValue: state.tabValue)), icon: const Icon(Icons.refresh)),
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
                    onPressed: state.selectedReorders.isEmpty
                        ? () => showMyDialogAlert(context: context, title: 'Achtung!', content: 'Bitte wähle mindestens eine Nachbestellung aus.')
                        : () => showMyDialogDelete(
                              context: context,
                              content: 'Bist du sicher, dass du alle ausgewählten Nachbestellungen unwiederruflich löschen willst?',
                              onConfirm: () {
                                context.read<ReorderBloc>().add(DeleteSelectedReordersEvent());
                                context.router.pop();
                              },
                            ),
                    icon: state.isLoadingReorderOnDelete
                        ? const CircularProgressIndicator(color: Colors.red)
                        : const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
              body: SafeArea(
                child: Column(
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
                    DefaultTabController(
                      length: 4,
                      child: TabBar(
                        tabs: const [Tab(text: 'Offen'), Tab(text: 'Teilweise offen'), Tab(text: 'Geschlossen'), Tab(text: 'Alle')],
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                        unselectedLabelStyle: const TextStyle(),
                        onTap: (value) => reorderBloc.add(GetReordersEvenet(tabValue: value)),
                      ),
                    ),
                    ReordersOverviewPage(reorderBloc: reorderBloc),
                  ],
                ),
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
