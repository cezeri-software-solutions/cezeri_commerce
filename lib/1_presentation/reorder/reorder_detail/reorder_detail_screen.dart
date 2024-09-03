import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/reorder/reorder_detail/functions/on_pdf_pressed.dart';
import 'package:cezeri_commerce/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/reorder_detail/reorder_detail_bloc.dart';
import '../../../3_domain/entities/reorder/supplier.dart';
import '../../../injection.dart';
import '../../core/core.dart';
import 'functions/show_reorder_detail_products_dialog.dart';
import 'reorder_detail_page.dart';

enum ReorderCreateOrEdit { create, edit }

@RoutePage()
class ReorderDetailScreen extends StatelessWidget {
  final ReorderCreateOrEdit reorderCreateOrEdit;
  final Supplier? supplier;
  final String? reorderId;

  const ReorderDetailScreen({super.key, required this.reorderCreateOrEdit, this.supplier, this.reorderId});

  @override
  Widget build(BuildContext context) {
    final reorderDetailBloc = sl<ReorderDetailBloc>()
      ..add(SetReorderDetailEvent(
        supplier: supplier,
        reorderCreateOrEdit: reorderCreateOrEdit,
        reorderId: reorderId,
      ));

    final appBar = AppBar(title: const Text('Nachbestellung'));

    return BlocProvider(
      create: (context) => reorderDetailBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<ReorderDetailBloc, ReorderDetailState>(
            listenWhen: (p, c) => p.fosReorderDetailOnObserveOption != c.fosReorderDetailOnObserveOption,
            listener: (context, state) {
              state.fosReorderDetailOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (unit) => myScaffoldMessenger(context, null, null, 'Nachbestellung erfolgreich geladen', null),
                ),
              );
            },
          ),
          BlocListener<ReorderDetailBloc, ReorderDetailState>(
            listenWhen: (p, c) => p.fosReorderDetailOnObserveProductsOption != c.fosReorderDetailOnObserveProductsOption,
            listener: (context, state) {
              state.fosReorderDetailOnObserveProductsOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (listOfLoadedProducts) => showReorderDetailProductsDialog(context, reorderDetailBloc),
                ),
              );
            },
          ),
          BlocListener<ReorderDetailBloc, ReorderDetailState>(
            listenWhen: (p, c) => p.fosReorderDetailOnCreateOption != c.fosReorderDetailOnCreateOption,
            listener: (context, state) {
              state.fosReorderDetailOnCreateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (createdReorder) {
                    context.router.popUntilRouteWithName(ReordersOverviewRoute.name);
                    context.router.push(ReorderDetailRoute(reorderCreateOrEdit: ReorderCreateOrEdit.edit, reorderId: createdReorder.id));
                  },
                ),
              );
            },
          ),
          BlocListener<ReorderDetailBloc, ReorderDetailState>(
            listenWhen: (p, c) => p.fosReorderDetailOnOUpdateOption != c.fosReorderDetailOnOUpdateOption,
            listener: (context, state) {
              state.fosReorderDetailOnOUpdateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (updatedReorder) => myScaffoldMessenger(context, null, null, 'Nachbestellung wurde erfolgreich aktualisiert', null),
                ),
              );
            },
          ),
          BlocListener<ReorderDetailBloc, ReorderDetailState>(
            listenWhen: (p, c) => p.fosReorderDetailOnPdfDataOption != c.fosReorderDetailOnPdfDataOption,
            listener: (context, state) {
              print('HALLO 5');
              state.fosReorderDetailOnPdfDataOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (marketplaces) => onPdfPressed(context: context, reorder: state.reorder!, marketplaces: marketplaces),
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<ReorderDetailBloc, ReorderDetailState>(
          bloc: reorderDetailBloc,
          builder: (context, state) {
            if (state.isLoadingReorderDetailOnObserve) return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));
            if (state.firebaseFailure != null) {
              return Scaffold(appBar: appBar, body: const Center(child: Text('Ein Fehler ist aufgetreten')));
            }
            if (state.reorder == null) return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));

            return ReorderDetailPage(reorderDetailBloc: reorderDetailBloc, reorderCreateOrEdit: reorderCreateOrEdit, supplier: supplier);
          },
        ),
      ),
    );
  }
}
