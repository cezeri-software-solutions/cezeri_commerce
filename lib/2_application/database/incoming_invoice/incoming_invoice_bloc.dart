import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../3_domain/entities/incoming_invoice/incoming_invoice.dart';
import '../../../3_domain/repositories/database/incoming_invoice_repository.dart';
import '../../../failures/failures.dart';

part 'incoming_invoice_event.dart';
part 'incoming_invoice_state.dart';

class IncomingInvoiceBloc extends Bloc<IncomingInvoiceEvent, IncomingInvoiceState> {
  final IncomingInvoiceRepository _incomingInvoiceRepository;

  IncomingInvoiceBloc({required IncomingInvoiceRepository incomingInvoiceRepository})
      : _incomingInvoiceRepository = incomingInvoiceRepository,
        super(IncomingInvoiceState.initial()) {
    on<SetIncomingInvoiceStateToInitial>(_onSetIncomingInvoiceStateToInitial);
    on<GetIncomingInvoiceEvent>(_onGetIncomingInvoice);
    on<GetIncomingInvoicesEvent>(_onGetIncomingInvoices);
    on<DeleteSelectedInvoicesEvent>(_onDeleteSelectedInvoices); // TODO: implement me
    on<OnInvoiceSearchControllerClearedEvent>(_onInvoiceSearchControllerCleared);
    on<OnSelectAllInvoicesEvent>(_onSelectAllInvoices);
    on<OnSelectInvoiceEvent>(_onSelectInvoice);
    on<ItemsPerPageChangedEvent>(_onItemsPerPageChanged);
  }

  void _onSetIncomingInvoiceStateToInitial(SetIncomingInvoiceStateToInitial event, Emitter<IncomingInvoiceState> emit) {
    emit(IncomingInvoiceState.initial());
  }

  Future<void> _onGetIncomingInvoice(GetIncomingInvoiceEvent event, Emitter<IncomingInvoiceState> emit) async {
    final fos = await _incomingInvoiceRepository.getIncomingInvoice(event.id);
    fos.fold(
      (failure) => null,
      (loadedInvoice) {
        final index = state.listOfInvoices!.indexWhere((e) => e.id == loadedInvoice.id);
        List<IncomingInvoice> updatedList = List.from(state.listOfInvoices!);
        if (index != -1) updatedList[index] = loadedInvoice;
        final indexSelected = state.selectedInvoices.indexWhere((e) => e.id == loadedInvoice.id);
        List<IncomingInvoice> updatedSelected = List.from(state.selectedInvoices);
        if (indexSelected != -1) updatedSelected[indexSelected] = loadedInvoice;

        emit(state.copyWith(listOfInvoices: updatedList, listOfSelectedInvoices: updatedSelected, resetAbstractFailure: true));
      },
    );
  }

  Future<void> _onGetIncomingInvoices(GetIncomingInvoicesEvent event, Emitter<IncomingInvoiceState> emit) async {
    emit(state.copyWith(isLoadingInvoicesOnObserve: true));

    if (event.calcCount) {
      final fosCount = await _incomingInvoiceRepository.getCountOfIncomingInvoices(state.searchController.text);
      fosCount.fold(
        (failure) => emit(state.copyWith(abstractFailure: failure)),
        (countNumber) => emit(state.copyWith(totalQuantity: countNumber)),
      );
    }

    final fos = await _incomingInvoiceRepository.getListOfIncomingInvoices(
      searchText: state.searchController.text,
      currentPage: event.currentPage,
      itemsPerPage: state.perPageQuantity,
    );
    fos.fold(
      (failure) => emit(state.copyWith(abstractFailure: failure)),
      (listOfLoadedIncomingInvoices) {
        emit(state.copyWith(
          listOfInvoices: listOfLoadedIncomingInvoices,
          selectedInvoices: [],
          currentPage: event.currentPage,
          resetAbstractFailure: true,
        ));
      },
    );

    emit(state.copyWith(isLoadingInvoicesOnObserve: false, fosInvoicesOnObserveOption: optionOf(fos)));
    emit(state.copyWith(fosInvoicesOnObserveOption: none()));
  }

  Future<void> _onDeleteSelectedInvoices(DeleteSelectedInvoicesEvent event, Emitter<IncomingInvoiceState> emit) async {
    emit(state.copyWith(isLoadingInvoiceOnDelete: true));

    // TODO: implement me

    // emit(state.copyWith(isLoadingInvoiceOnDelete: false, fosInvoicesOnDeleteOption: optionOf(fos)));
    emit(state.copyWith(fosInvoicesOnDeleteOption: none()));
  }

  Future<void> _onInvoiceSearchControllerCleared(OnInvoiceSearchControllerClearedEvent event, Emitter<IncomingInvoiceState> emit) async {
    emit(state.copyWith(searchController: SearchController()));
    add(GetIncomingInvoicesEvent(calcCount: true, currentPage: 1));
  }

  Future<void> _onSelectAllInvoices(OnSelectAllInvoicesEvent event, Emitter<IncomingInvoiceState> emit) async {
    emit(state.copyWith(selectedInvoices: event.isSelected ? state.listOfInvoices! : [], isAllInvoicesSelected: event.isSelected));
  }

  Future<void> _onSelectInvoice(OnSelectInvoiceEvent event, Emitter<IncomingInvoiceState> emit) async {
    final List<IncomingInvoice> selectedInvoices = List.from(state.selectedInvoices);

    final index = selectedInvoices.indexWhere((e) => e.id == event.invoice.id);
    if (index == -1) {
      selectedInvoices.add(event.invoice);
    } else {
      selectedInvoices.removeAt(index);
    }

    final isSelectedAll = state.listOfInvoices!.length == selectedInvoices.length;

    emit(state.copyWith(selectedInvoices: selectedInvoices, isAllInvoicesSelected: isSelectedAll));
  }

  void _onItemsPerPageChanged(ItemsPerPageChangedEvent event, Emitter<IncomingInvoiceState> emit) {
    emit(state.copyWith(perPageQuantity: event.value));
    add(GetIncomingInvoicesEvent(calcCount: false, currentPage: 1));
  }
}
