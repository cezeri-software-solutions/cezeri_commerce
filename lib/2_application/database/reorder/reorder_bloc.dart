import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/3_domain/enums/enums.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../3_domain/entities/reorder/reorder.dart';
import '../../../3_domain/repositories/database/reorder_repository.dart';
import '../../../3_domain/repositories/database/supplier_repository.dart';
import '../../../failures/abstract_failure.dart';

part 'reorder_event.dart';
part 'reorder_state.dart';

class ReorderBloc extends Bloc<ReorderEvent, ReorderState> {
  final ReorderRepository reorderRepository;
  final SupplierRepository supplierRepository;

  ReorderBloc({required this.reorderRepository, required this.supplierRepository}) : super(ReorderState.initial()) {
//? #########################################################################

    on<SetReorderStateToInitialEvent>((event, emit) {
      emit(ReorderState.initial());
    });

//? #########################################################################

    on<GetReordersEvenet>((event, emit) async {
      emit(state.copyWith(isLoadingReordersOnObserve: true));

      final getReorderType = switch (event.tabValue) {
        0 => GetReordersType.open,
        1 => GetReordersType.partialOpen,
        2 => GetReordersType.completed,
        _ => GetReordersType.all,
      };

      final failureOrSuccess = await reorderRepository.getListOfReorders(getReorderType);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfReorder) {
          emit(state.copyWith(listOfAllReorders: listOfReorder, selectedReorders: [], firebaseFailure: null, isAnyFailure: false));
          add(OnSearchFieldSubmittedEvent());
        },
      );

      add(OnSearchFieldSubmittedEvent());

      emit(state.copyWith(
        isLoadingReordersOnObserve: false,
        fosReordersOnObserveOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosReordersOnObserveOption: none()));
    });

//? #########################################################################

    on<DeleteSelectedReordersEvent>((event, emit) async {
      emit(state.copyWith(isLoadingReorderOnDelete: true));

      final ids = state.selectedReorders.map((e) => e.id).toList();
      final failureOrSuccess = await reorderRepository.deleteReorders(ids);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (unit) {
          emit(state.copyWith(selectedReorders: [], firebaseFailure: null, isAnyFailure: false));
          add(GetReordersEvenet(tabValue: state.tabValue));
        },
      );

      emit(state.copyWith(
        isLoadingReorderOnDelete: false,
        fosReordersOnDeleteOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosReordersOnDeleteOption: none()));
    });

//? #########################################################################

    on<SetSearchFieldTextEvent>((event, emit) async {
      emit(state.copyWith(reorderSearchText: event.searchText));

      add(OnSearchFieldSubmittedEvent());
    });

    on<OnSearchFieldSubmittedEvent>((event, emit) async {
      final listOfReorders = switch (state.reorderSearchText) {
        '' => state.listOfAllReorders,
        (_) => state.listOfAllReorders!
            .where((e) =>
                e.reorderNumber.toString().toLowerCase().contains(state.reorderSearchText.toLowerCase()) ||
                e.reorderSupplier.company.toLowerCase().contains(state.reorderSearchText.toLowerCase()) ||
                e.reorderSupplier.name.toLowerCase().contains(state.reorderSearchText.toLowerCase()))
            .toList()
      };
      if (listOfReorders != null && listOfReorders.isNotEmpty) listOfReorders.sort((a, b) => b.reorderNumber.compareTo(a.reorderNumber));
      emit(state.copyWith(listOfFilteredReorders: listOfReorders));
    });

//? #########################################################################

    on<OnSelectAllReordersEvent>((event, emit) async {
      List<Reorder> reorders = [];
      bool isSelectedAll = false;
      if (event.isSelected) {
        isSelectedAll = true;
        reorders = List.from(state.listOfFilteredReorders!);
      }
      emit(state.copyWith(isAllReordersSelected: isSelectedAll, selectedReorders: reorders));
    });

//? #########################################################################

    on<OnReorderSelectedEvent>((event, emit) async {
      List<Reorder> reorders = List.from(state.selectedReorders);
      if (reorders.any((e) => e.id == event.reorder.id)) {
        reorders.removeWhere((e) => e.id == event.reorder.id);
      } else {
        reorders.add(event.reorder);
      }

      final isAllReordersSelected = state.listOfFilteredReorders!.every((e) => reorders.any((f) => f.id == e.id));

      emit(state.copyWith(isAllReordersSelected: isAllReordersSelected, selectedReorders: reorders));
    });

//? #########################################################################
  }
}
