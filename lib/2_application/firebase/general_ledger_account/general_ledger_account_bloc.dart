import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../3_domain/entities/settings/general_ledger_account.dart';
import '../../../3_domain/repositories/firebase/general_ledger_account_repository.dart';
import '../../../core/abstract_failure.dart';

part 'general_ledger_account_event.dart';
part 'general_ledger_account_state.dart';

class GeneralLedgerAccountBloc extends Bloc<GeneralLedgerAccountEvent, GeneralLedgerAccountState> {
  final GeneralLedgerAccountRepository gLAccountRepository;
  GeneralLedgerAccountBloc({required this.gLAccountRepository}) : super(GeneralLedgerAccountState.initial()) {
    on<GeneralLedgerAccountEvent>((event, emit) {
      on<SetGLAccountStateToInitialEvent>(_onSetGLAccountStateToInitial);
      on<GetAllGLAccountsEvent>(_onGetAllGLAccounts);
      on<GetGLAccountEvent>(_onGetGLAccount);
      on<CreateGLAccountEvent>(_onCreateGLAccount);
      on<UpdateGLAccountEvent>(_onUpdateGLAccount);
      on<DeleteSelectedGLAccountsEvent>(_onDeleteSelectedGLAccounts);
      on<OnGLAccountSearchControllerChangedEvent>(_onGLAccountSearchControllerChanged);
      on<OnGLAccountSearchControllerClearedEvent>(_onGLAccountSearchControllerCleared);
      on<OnSelectAllGLAccountsEvent>(_onSelectAllGLAccounts);
      on<OnSelectGLAccountEvent>(_onSelectGLAccount);
      on<SetGLAccountControllerEvent>(_onSetGLAccountController);
      on<OnGLAccountControllerChangedEvent>(_onGLAccountControllerChanged);
    });
  }

  void _onSetGLAccountStateToInitial(GeneralLedgerAccountEvent event, Emitter<GeneralLedgerAccountState> emit) {
    emit(GeneralLedgerAccountState.initial());
  }

  Future<void> _onGetAllGLAccounts(GetAllGLAccountsEvent event, Emitter<GeneralLedgerAccountState> emit) async {
    emit(state.copyWith(isLoadingGLAccountsOnObserve: true));

    final fos = await gLAccountRepository.getListOfGLAccounts();
    fos.fold(
      (failure) => emit(state.copyWith(abstractFailure: failure, isAnyFailure: true)),
      (gLAccounts) {
        emit(state.copyWith(listOfAllGLAccounts: gLAccounts, selectedGLAccounts: [], abstractFailure: null, isAnyFailure: false));
        add(OnGLAccountSearchControllerChangedEvent());
      },
    );

    emit(state.copyWith(
      isLoadingGLAccountsOnObserve: false,
      fosGLAccountsOnObserveOption: optionOf(fos),
    ));
    emit(state.copyWith(fosGLAccountsOnObserveOption: none()));
  }

  Future<void> _onGetGLAccount(GetGLAccountEvent event, Emitter<GeneralLedgerAccountState> emit) async {
    emit(state.copyWith(isLoadingGLAccountOnObserve: true));

    final fos = await gLAccountRepository.getGLAccount(event.gLAccount.id);
    fos.fold(
      (failure) => emit(state.copyWith(abstractFailure: failure, isAnyFailure: true)),
      (glAccount) {
        emit(state.copyWith(gLAccount: glAccount, abstractFailure: null, isAnyFailure: false));
        add(SetGLAccountControllerEvent());
      },
    );

    emit(state.copyWith(
      isLoadingGLAccountOnObserve: false,
      fosGLAccountOnObserveOption: optionOf(fos),
    ));
    emit(state.copyWith(fosGLAccountOnObserveOption: none()));
  }

  Future<void> _onCreateGLAccount(CreateGLAccountEvent event, Emitter<GeneralLedgerAccountState> emit) async {
    emit(state.copyWith(isLoadingGLAccountOnCreate: true));

    final fos = await gLAccountRepository.createGLAccount(state.gLAccount!);
    fos.fold(
      (failure) => emit(state.copyWith(abstractFailure: failure, isAnyFailure: true)),
      (glAccount) => emit(state.copyWith(gLAccount: glAccount, abstractFailure: null, isAnyFailure: false)),
    );

    emit(state.copyWith(
      isLoadingGLAccountOnCreate: false,
      fosGLAccountOnCreateOption: optionOf(fos),
    ));
    emit(state.copyWith(fosGLAccountOnCreateOption: none()));
  }

  Future<void> _onUpdateGLAccount(UpdateGLAccountEvent event, Emitter<GeneralLedgerAccountState> emit) async {
    emit(state.copyWith(isLoadingGLAccountOnUpdate: true));

    final fos = await gLAccountRepository.updateGLAccount(state.gLAccount!);
    fos.fold(
      (failure) => emit(state.copyWith(abstractFailure: failure, isAnyFailure: true)),
      (glAccount) => emit(state.copyWith(gLAccount: glAccount, abstractFailure: null, isAnyFailure: false)),
    );

    emit(state.copyWith(
      isLoadingGLAccountOnUpdate: false,
      fosGLAccountOnUpdateOption: optionOf(fos),
    ));
    emit(state.copyWith(fosGLAccountOnUpdateOption: none()));
  }

  Future<void> _onDeleteSelectedGLAccounts(DeleteSelectedGLAccountsEvent event, Emitter<GeneralLedgerAccountState> emit) async {
    emit(state.copyWith(isLoadingGLAccountOnDelete: true));

    List<AbstractFailure> failures = [];
    for (final gLAccount in state.selectedGLAccounts) {
      final fos = await gLAccountRepository.deleteGLAccount(gLAccount.id);
      if (fos.isLeft()) fos.leftMap((l) => failures.add(l));
    }

    emit(state.copyWith(
      isLoadingGLAccountOnDelete: false,
      fosGLAccountsOnDeleteOption: failures.isNotEmpty ? Some(Left(failures)) : const Some(Right(unit)),
    ));
    emit(state.copyWith(fosGLAccountsOnDeleteOption: none()));
  }

  void _onGLAccountSearchControllerChanged(OnGLAccountSearchControllerChangedEvent event, Emitter<GeneralLedgerAccountState> emit) {
    final searchText = state.searchController.text.toLowerCase();
    final splittedSearchText = searchText.split(' ');

    final filteredGLAccounts = switch (searchText) {
      '' => state.listOfAllGLAccounts,
      _ => state.listOfAllGLAccounts!
          .where((e) =>
              splittedSearchText.every((entry) => e.name.toLowerCase().contains(entry) || e.generalLedgerAccount.toLowerCase().contains(entry)))
          .toList()
    };

    if (filteredGLAccounts != null && filteredGLAccounts.isNotEmpty) {
      filteredGLAccounts.sort((a, b) => b.generalLedgerAccount.compareTo(a.generalLedgerAccount));
    }
    emit(state.copyWith(listOfFilteredGLAccounts: filteredGLAccounts));
  }

  void _onGLAccountSearchControllerCleared(OnGLAccountSearchControllerClearedEvent event, Emitter<GeneralLedgerAccountState> emit) {
    emit(state.copyWith(searchController: SearchController()));
  }

  void _onSelectAllGLAccounts(OnSelectAllGLAccountsEvent event, Emitter<GeneralLedgerAccountState> emit) {
    if (event.isSelected) {
      emit(state.copyWith(selectedGLAccounts: state.listOfFilteredGLAccounts!, isAllGLAccountsSelected: true));
    } else {
      emit(state.copyWith(selectedGLAccounts: [], isAllGLAccountsSelected: false));
    }
  }

  void _onSelectGLAccount(OnSelectGLAccountEvent event, Emitter<GeneralLedgerAccountState> emit) {
    final isSelected = state.selectedGLAccounts.any((e) => e.id == event.gLAccount.id);
    List<GeneralLedgerAccount> updatedSelectedGLAccounts = List.from(state.selectedGLAccounts);

    if (isSelected) {
      updatedSelectedGLAccounts.removeWhere((e) => e.id == event.gLAccount.id);
    } else {
      updatedSelectedGLAccounts.add(event.gLAccount);
    }

    emit(state.copyWith(selectedGLAccounts: updatedSelectedGLAccounts));
  }

  void _onSetGLAccountController(SetGLAccountControllerEvent event, Emitter<GeneralLedgerAccountState> emit) {
    final gLAccount = state.gLAccount ?? GeneralLedgerAccount.empty();
    emit(state.copyWith(
      nameController: TextEditingController(text: gLAccount.name),
      gLAccountController: TextEditingController(text: gLAccount.generalLedgerAccount),
    ));
  }

  void _onGLAccountControllerChanged(OnGLAccountControllerChangedEvent event, Emitter<GeneralLedgerAccountState> emit) {
    final updatedGLAccount = state.gLAccount?.copyWith(
      name: state.nameController.text,
      generalLedgerAccount: state.gLAccountController.text,
    );

    emit(state.copyWith(gLAccount: updatedGLAccount));
  }
}
