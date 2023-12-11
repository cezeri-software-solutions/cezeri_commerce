import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/reorder_detail/reorder_detail_bloc.dart';
import '../../../3_domain/entities/reorder/supplier.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../constants.dart';
import '../../core/widgets/my_outlined_button.dart';
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
        final screenWidth = MediaQuery.sizeOf(context).width;
        final responsiveness = screenWidth > 700 ? Responsiveness.isTablet : Responsiveness.isMobil;

        final appBar = AppBar(
          title:
              reorderCreateOrEdit == ReorderCreateOrEdit.create ? const Text('Nachlieferung') : Text('Nachlieferung ${state.reorder!.reorderNumber}'),
          centerTitle: responsiveness == Responsiveness.isTablet ? true : false,
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
            responsiveness == Responsiveness.isTablet ? Gaps.w32 : Gaps.w8,
            MyOutlinedButton(
              buttonText: 'Speichern',
              onPressed: () {
                if (reorderCreateOrEdit == ReorderCreateOrEdit.edit) {
                  // reorderBloc.add(UpdateReorderEvent());
                } else {
                  // reorderBloc.add(CreateReorderEvent());
                }
              },
              isLoading: state.isLoadingOnCreateReorder || state.isLoadingOnUpdateReorder,
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
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
