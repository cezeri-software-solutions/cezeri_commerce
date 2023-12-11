import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/reorder/reorder_bloc.dart';
import '../../../3_domain/entities/reorder/reorder.dart';
import '../../../constants.dart';
import '../../../core/firebase_failures.dart';
import '../../../routes/router.gr.dart';
import '../reorder_detail/reorder_detail_screen.dart';

class ReordersOverviewPage extends StatelessWidget {
  final ReorderBloc reorderBloc;

  const ReordersOverviewPage({super.key, required this.reorderBloc});

  @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReorderBloc, ReorderState>(
      builder: (context, state) {
        if (state.isLoadingReordersOnObserve) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }
        if (state.firebaseFailure != null && state.isAnyFailure) {
          return switch (state.firebaseFailure.runtimeType) {
            EmptyFailure => const Expanded(child: Center(child: Text('Du hast noch keine Nachbestellungen angelegt oder importiert!'))),
            (_) => const Expanded(child: Center(child: Text('Ein Fehler beim Laden der Nachbestellungen ist aufgetreten!')))
          };
        }
        if (state.listOfAllReorders == null || state.listOfFilteredReorders == null) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }

        return Expanded(
          child: ListView.separated(
            itemCount: state.listOfFilteredReorders!.length,
            itemBuilder: (context, index) {
              final reorder = state.listOfFilteredReorders![index];
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox.adaptive(
                          value: state.isAllReordersSelected,
                          onChanged: (value) => reorderBloc.add(OnSelectAllReordersEvent(isSelected: value!)),
                        ),
                        const Expanded(child: Text('Nachbestellung', style: TextStyles.h3Bold)),
                        const Expanded(child: Text('Adresse', style: TextStyles.h3Bold)),
                      ],
                    ),
                    _ReorderContainer(reorder: reorder, index: index, reorderBloc: reorderBloc),
                  ],
                );
              } else {
                return _ReorderContainer(reorder: reorder, index: index, reorderBloc: reorderBloc);
              }
            },
            separatorBuilder: (context, index) => const Divider(),
          ),
        );
      },
    );
  }
}

class _ReorderContainer extends StatelessWidget {
  final Reorder reorder;
  final int index;
  final ReorderBloc reorderBloc;

  const _ReorderContainer({required this.reorder, required this.index, required this.reorderBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReorderBloc, ReorderState>(
      bloc: reorderBloc,
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Row(
            children: [
              Checkbox.adaptive(
                value: state.selectedReorders.any((e) => e.id == reorder.id),
                onChanged: (_) => reorderBloc.add(OnReorderSelectedEvent(reorder: reorder)),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => context.router.push(ReorderDetailRoute(reorderCreateOrEdit: ReorderCreateOrEdit.edit, reorderId: reorder.id)),
                  child: Text(reorder.reorderNumber.toString()),
                ),
              ),
              Expanded(
                child: Text(reorder.reorderSupplier.name),
              ),
            ],
          ),
        );
      },
    );
  }
}
