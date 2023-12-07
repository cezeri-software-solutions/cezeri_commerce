import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../3_domain/entities/reorder/reorder.dart';
import '../../../3_domain/repositories/firebase/reorder_repository.dart';
import '../../../core/firebase_failures.dart';

part 'reorder_event.dart';
part 'reorder_state.dart';

class ReorderBloc extends Bloc<ReorderEvent, ReorderState> {
  final ReorderRepository reorderRepository;

  ReorderBloc({required this.reorderRepository}) : super(ReorderState.initial()) {
//? #########################################################################

    on<SetReorderStateToInitialEvent>((event, emit) {
      emit(ReorderState.initial());
    });

//? #########################################################################

    on<GetAllReordersEvenet>((event, emit) async {
      emit(state.copyWith(isLoadingReordersOnObserve: true));

      final failureOrSuccess = await reorderRepository.getListOfReorders();
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
      emit(state.copyWith(
        isAllReordersSelected: state.isAllReordersSelected && reorders.length < state.selectedReorders.length ? false : state.isAllReordersSelected,
        selectedReorders: reorders,
      ));
    });

//? #########################################################################
  }
}
