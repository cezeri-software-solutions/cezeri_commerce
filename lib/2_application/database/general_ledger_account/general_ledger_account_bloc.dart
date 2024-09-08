import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../3_domain/entities/settings/general_ledger_account.dart';
import '../../../3_domain/repositories/database/general_ledger_account_repository.dart';
import '../../../failures/abstract_failure.dart';

part 'general_ledger_account_event.dart';
part 'general_ledger_account_state.dart';

class GeneralLedgerAccountBloc extends Bloc<GeneralLedgerAccountEvent, GeneralLedgerAccountState> {
  final GeneralLedgerAccountRepository _gLAccountRepository;

  GeneralLedgerAccountBloc({required GeneralLedgerAccountRepository gLAccountRepository})
      : _gLAccountRepository = gLAccountRepository,
        super(GeneralLedgerAccountState.initial()) {
    on<SetGLAccountStateToInitialEvent>(_onSetGLAccountStateToInitial);
    on<GetAllGLAccountsEvent>(_onGetAllGLAccounts);
    on<GetGLAccountEvent>(_onGetGLAccount);
    on<SetGLAccountEvent>(_onSetGLAccount);
    on<CreateGLAccountEvent>(_onCreateGLAccount);
    on<UpdateGLAccountEvent>(_onUpdateGLAccount);
    on<UpdateGLAccountIsActiveEvent>(_onUpdateGLAccountIsActive);
    on<UpdateGLAccountIsVisibleEvent>(_onUpdateGLAccountIsVisible);
    on<DeleteSelectedGLAccountsEvent>(_onDeleteSelectedGLAccounts);
    on<OnGLAccountSearchControllerChangedEvent>(_onGLAccountSearchControllerChanged);
    on<OnGLAccountSearchControllerClearedEvent>(_onGLAccountSearchControllerCleared);
    on<OnGLAccountIsActiveChangedEvent>(_onGLAccountIsActiveChanged);
    on<OnGLAccountIsVisibleChangedEvent>(_onGLAccountIsVisibleChanged);
    on<OnSelectAllGLAccountsEvent>(_onSelectAllGLAccounts);
    on<OnSelectGLAccountEvent>(_onSelectGLAccount);
    on<SetGLAccountControllerEvent>(_onSetGLAccountController);
    on<OnGLAccountControllerChangedEvent>(_onGLAccountControllerChanged);
  }

  void _onSetGLAccountStateToInitial(SetGLAccountStateToInitialEvent event, Emitter<GeneralLedgerAccountState> emit) {
    emit(GeneralLedgerAccountState.initial());
  }

  Future<void> _onGetAllGLAccounts(GetAllGLAccountsEvent event, Emitter<GeneralLedgerAccountState> emit) async {
    emit(state.copyWith(isLoadingGLAccountsOnObserve: true));

    final fos = await _gLAccountRepository.getListOfGLAccounts();
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

    final fos = await _gLAccountRepository.getGLAccount(event.gLAccount.id);
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

  void _onSetGLAccount(SetGLAccountEvent event, Emitter<GeneralLedgerAccountState> emit) {
    emit(state.copyWith(gLAccount: event.gLAccount));
    add(SetGLAccountControllerEvent());
  }

  Future<void> _onCreateGLAccount(CreateGLAccountEvent event, Emitter<GeneralLedgerAccountState> emit) async {
    emit(state.copyWith(isLoadingGLAccountOnCreate: true));

    final fos = await _gLAccountRepository.createGLAccount(state.gLAccount!);
    fos.fold(
      (failure) => emit(state.copyWith(abstractFailure: failure, isAnyFailure: true)),
      (glAccount) {
        final List<GeneralLedgerAccount> gLAccounts = List.from(state.listOfAllGLAccounts!);
        gLAccounts.add(glAccount);
        emit(state.copyWith(gLAccount: glAccount, listOfAllGLAccounts: gLAccounts, abstractFailure: null, isAnyFailure: false));
        add(OnGLAccountSearchControllerChangedEvent());
      },
    );

    emit(state.copyWith(
      isLoadingGLAccountOnCreate: false,
      fosGLAccountOnCreateOption: optionOf(fos),
    ));
    emit(state.copyWith(fosGLAccountOnCreateOption: none()));
  }

  Future<void> _onUpdateGLAccount(UpdateGLAccountEvent event, Emitter<GeneralLedgerAccountState> emit) async {
    emit(state.copyWith(isLoadingGLAccountOnUpdate: true));

    final fos = await _gLAccountRepository.updateGLAccount(state.gLAccount!);
    fos.fold(
      (failure) => emit(state.copyWith(abstractFailure: failure, isAnyFailure: true)),
      (glAccount) {
        final index = state.listOfAllGLAccounts!.indexWhere((e) => e.id == glAccount.id);
        final List<GeneralLedgerAccount> gLAccounts = List.from(state.listOfAllGLAccounts!);
        if (index != -1) gLAccounts[index] = glAccount;
        emit(state.copyWith(gLAccount: glAccount, listOfAllGLAccounts: gLAccounts, abstractFailure: null, isAnyFailure: false));
        add(OnGLAccountSearchControllerChangedEvent());
      },
    );

    emit(state.copyWith(
      isLoadingGLAccountOnUpdate: false,
      fosGLAccountOnUpdateOption: optionOf(fos),
    ));
    emit(state.copyWith(fosGLAccountOnUpdateOption: none()));
  }

  void _onUpdateGLAccountIsActive(UpdateGLAccountIsActiveEvent event, Emitter<GeneralLedgerAccountState> emit) {
    emit(state.copyWith(gLAccount: event.gLAccount.copyWith(isActive: !event.gLAccount.isActive)));
    add(UpdateGLAccountEvent());
  }

  void _onUpdateGLAccountIsVisible(UpdateGLAccountIsVisibleEvent event, Emitter<GeneralLedgerAccountState> emit) {
    emit(state.copyWith(gLAccount: event.gLAccount.copyWith(isVisible: !event.gLAccount.isVisible)));
    add(UpdateGLAccountEvent());
  }

  Future<void> _onDeleteSelectedGLAccounts(DeleteSelectedGLAccountsEvent event, Emitter<GeneralLedgerAccountState> emit) async {
    emit(state.copyWith(isLoadingGLAccountOnDelete: true));

    List<AbstractFailure> failures = [];
    for (final gLAccount in state.selectedGLAccounts) {
      final fos = await _gLAccountRepository.deleteGLAccount(gLAccount.id);
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
      '' => state.listOfAllGLAccounts!,
      _ => state.listOfAllGLAccounts!
          .where((e) =>
              splittedSearchText.every((entry) => e.name.toLowerCase().contains(entry) || e.generalLedgerAccount.toLowerCase().contains(entry)))
          .toList()
    };

    if (filteredGLAccounts.isNotEmpty) {
      filteredGLAccounts.sort((a, b) => a.generalLedgerAccount.compareTo(b.generalLedgerAccount));
    }

    final list0 = filteredGLAccounts.where((e) => e.generalLedgerAccount.isNotEmpty && e.generalLedgerAccount[0] == '0').toList();
    final list1 = filteredGLAccounts.where((e) => e.generalLedgerAccount.isNotEmpty && e.generalLedgerAccount[0] == '1').toList();
    final list2 = filteredGLAccounts.where((e) => e.generalLedgerAccount.isNotEmpty && e.generalLedgerAccount[0] == '2').toList();
    final list3 = filteredGLAccounts.where((e) => e.generalLedgerAccount.isNotEmpty && e.generalLedgerAccount[0] == '3').toList();
    final list4 = filteredGLAccounts.where((e) => e.generalLedgerAccount.isNotEmpty && e.generalLedgerAccount[0] == '4').toList();
    final list5 = filteredGLAccounts.where((e) => e.generalLedgerAccount.isNotEmpty && e.generalLedgerAccount[0] == '5').toList();
    final list6 = filteredGLAccounts.where((e) => e.generalLedgerAccount.isNotEmpty && e.generalLedgerAccount[0] == '6').toList();
    final list7 = filteredGLAccounts.where((e) => e.generalLedgerAccount.isNotEmpty && e.generalLedgerAccount[0] == '7').toList();
    final list8 = filteredGLAccounts.where((e) => e.generalLedgerAccount.isNotEmpty && e.generalLedgerAccount[0] == '8').toList();
    final list9 = filteredGLAccounts.where((e) => e.generalLedgerAccount.isNotEmpty && e.generalLedgerAccount[0] == '9').toList();

    emit(state.copyWith(
      listOfFilteredGLAccounts0: list0,
      listOfFilteredGLAccounts1: list1,
      listOfFilteredGLAccounts2: list2,
      listOfFilteredGLAccounts3: list3,
      listOfFilteredGLAccounts4: list4,
      listOfFilteredGLAccounts5: list5,
      listOfFilteredGLAccounts6: list6,
      listOfFilteredGLAccounts7: list7,
      listOfFilteredGLAccounts8: list8,
      listOfFilteredGLAccounts9: list9,
    ));
  }

  void _onGLAccountSearchControllerCleared(OnGLAccountSearchControllerClearedEvent event, Emitter<GeneralLedgerAccountState> emit) {
    emit(state.copyWith(searchController: SearchController()));
    add(OnGLAccountSearchControllerChangedEvent());
  }

  void _onGLAccountIsActiveChanged(OnGLAccountIsActiveChangedEvent event, Emitter<GeneralLedgerAccountState> emit) {
    emit(state.copyWith(gLAccount: state.gLAccount!.copyWith(isActive: !state.gLAccount!.isActive)));
  }

  void _onGLAccountIsVisibleChanged(OnGLAccountIsVisibleChangedEvent event, Emitter<GeneralLedgerAccountState> emit) {
    emit(state.copyWith(gLAccount: state.gLAccount!.copyWith(isVisible: !state.gLAccount!.isVisible)));
  }

  void _onSelectAllGLAccounts(OnSelectAllGLAccountsEvent event, Emitter<GeneralLedgerAccountState> emit) {
    if (event.isSelected) {
      emit(state.copyWith(selectedGLAccounts: state.listOfFilteredGLAccounts0, isAllGLAccountsSelected: true));
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
