import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../2_application/database/reorder_detail/reorder_detail_bloc.dart';
import '../../../3_domain/entities/reorder/reorder.dart';
import '../../../3_domain/entities/reorder/supplier.dart';
import '../../../constants.dart';
import '../../core/core.dart';
import 'reorder_detail_screen.dart';
import 'widgets/reorder_detail_header_container.dart';
import 'widgets/reorder_detail_products_card.dart';
import 'widgets/reorder_detail_products_total_card.dart';

class ReorderDetailPage extends StatelessWidget {
  final ReorderDetailBloc reorderDetailBloc;
  final ReorderCreateOrEdit reorderCreateOrEdit;
  final Supplier? supplier;

  const ReorderDetailPage({super.key, required this.reorderDetailBloc, required this.reorderCreateOrEdit, required this.supplier});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReorderDetailBloc, ReorderDetailState>(
      bloc: reorderDetailBloc,
      builder: (context, state) {
        final appBar = AppBar(
          title:
              reorderCreateOrEdit == ReorderCreateOrEdit.create ? const Text('Nachlieferung') : Text('Nachlieferung ${state.reorder!.reorderNumber}'),
          centerTitle: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET) ? true : false,
          actions: [
            if (reorderCreateOrEdit == ReorderCreateOrEdit.edit && state.reorder != null && state.reorder!.id.isNotEmpty)
              IconButton(
                onPressed: () => reorderDetailBloc.add(SetReorderDetailEvent(
                  supplier: supplier,
                  reorderCreateOrEdit: reorderCreateOrEdit,
                  reorderId: state.reorder!.id,
                )),
                icon: const Icon(Icons.refresh, size: 30),
              ),
            ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET) ? Gaps.w32 : Gaps.w8,
            MyOutlinedButton(
              buttonText: 'Speichern',
              onPressed: () {
                if (!_validateReorder(context, state.reorder!)) return;
                if (reorderCreateOrEdit == ReorderCreateOrEdit.edit) {
                  reorderDetailBloc.add(ReorderDetailUpdateReorderEvent());
                } else {
                  reorderDetailBloc.add(ReorderDetailCreateReorderEvent());
                }
              },
              isLoading: state.isLoadingOnCreateReorder || state.isLoadingOnUpdateReorder,
              buttonBackgroundColor: Colors.green,
            ),
            ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET) ? Gaps.w32 : Gaps.w8,
          ],
        );

        return Scaffold(
          appBar: appBar,
          body: SafeArea(
            child: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET)
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          ReorderDetailHeaderContainer(reorderDetailBloc: reorderDetailBloc),
                          Gaps.h16,
                          ReorderDetailProductsCard(reorderDetailBloc: reorderDetailBloc),
                          Gaps.h16,
                          Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              Gaps.w16,
                              Expanded(
                                child: ReorderDetailProductsTotalCard(reorderDetailBloc: reorderDetailBloc),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView(
                      children: [
                        ReorderDetailHeaderContainer(reorderDetailBloc: reorderDetailBloc),
                        Gaps.h16,
                        ReorderDetailProductsCard(reorderDetailBloc: reorderDetailBloc),
                        Gaps.h16,
                        ReorderDetailProductsTotalCard(reorderDetailBloc: reorderDetailBloc),
                        Gaps.h16,
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  bool _validateReorder(BuildContext context, Reorder reorder) {
    if (reorder.listOfReorderProducts.any((e) => e.articleNumber.isEmpty)) {
      showMyDialogAlert(context: context, title: 'Achtung', content: 'Es darf kein Artikel ohne Artikelnummer vorhanden sein');
      return false;
    }

    if (reorder.listOfReorderProducts.any((e) => e.name.isEmpty)) {
      showMyDialogAlert(context: context, title: 'Achtung', content: 'Es darf kein Artikel ohne Artikelname vorhanden sein');
      return false;
    }

    return true;
  }
}
