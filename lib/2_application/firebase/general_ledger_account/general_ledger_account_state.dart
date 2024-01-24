// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'general_ledger_account_bloc.dart';

@immutable
class GeneralLedgerAccountState {
  final GeneralLedgerAccount? gLAccount;
  final List<GeneralLedgerAccount>? listOfAllGLAccounts;
  final List<GeneralLedgerAccount>? listOfFilteredGLAccounts;
  final AbstractFailure? abstractFailure;
  final bool isAnyFailure;
  final bool isLoadingGLAccountOnObserve;
  final bool isLoadingGLAccountsOnObserve;
  final bool isLoadingGLAccountOnCreate;
  final bool isLoadingGLAccountOnUpdate;
  final bool isLoadingGLAccountOnDelete;
  final Option<Either<AbstractFailure, GeneralLedgerAccount>> fosGLAccountOnObserveOption;
  final Option<Either<AbstractFailure, List<GeneralLedgerAccount>>> fosGLAccountsOnObserveOption;
  final Option<Either<AbstractFailure, GeneralLedgerAccount>> fosGLAccountOnCreateOption;
  final Option<Either<AbstractFailure, GeneralLedgerAccount>> fosGLAccountOnUpdateOption;
  final Option<Either<List<AbstractFailure>, Unit>> fosGLAccountsOnDeleteOption;

  //* Helpers isSelected
  final List<GeneralLedgerAccount> selectedGLAccounts;
  final bool isAllGLAccountsSelected;

  //* Controller
  final SearchController searchController;
  final TextEditingController gLAccountController;
  final TextEditingController nameController;

  const GeneralLedgerAccountState({
    required this.gLAccount,
    required this.listOfAllGLAccounts,
    required this.listOfFilteredGLAccounts,
    required this.abstractFailure,
    required this.isAnyFailure,
    required this.isLoadingGLAccountOnObserve,
    required this.isLoadingGLAccountsOnObserve,
    required this.isLoadingGLAccountOnCreate,
    required this.isLoadingGLAccountOnUpdate,
    required this.isLoadingGLAccountOnDelete,
    required this.fosGLAccountOnObserveOption,
    required this.fosGLAccountsOnObserveOption,
    required this.fosGLAccountOnCreateOption,
    required this.fosGLAccountOnUpdateOption,
    required this.fosGLAccountsOnDeleteOption,
    required this.selectedGLAccounts,
    required this.isAllGLAccountsSelected,
    required this.searchController,
    required this.gLAccountController,
    required this.nameController,
  });

  factory GeneralLedgerAccountState.initial() {
    return GeneralLedgerAccountState(
      gLAccount: null,
      listOfAllGLAccounts: null,
      listOfFilteredGLAccounts: const [],
      abstractFailure: null,
      isAnyFailure: false,
      isLoadingGLAccountOnObserve: false,
      isLoadingGLAccountsOnObserve: false,
      isLoadingGLAccountOnCreate: false,
      isLoadingGLAccountOnUpdate: false,
      isLoadingGLAccountOnDelete: false,
      fosGLAccountOnObserveOption: none(),
      fosGLAccountsOnObserveOption: none(),
      fosGLAccountOnCreateOption: none(),
      fosGLAccountOnUpdateOption: none(),
      fosGLAccountsOnDeleteOption: none(),
      selectedGLAccounts: const [],
      isAllGLAccountsSelected: false,
      searchController: SearchController(),
      gLAccountController: TextEditingController(),
      nameController: TextEditingController(),
    );
  }

  GeneralLedgerAccountState copyWith({
    GeneralLedgerAccount? gLAccount,
    List<GeneralLedgerAccount>? listOfAllGLAccounts,
    List<GeneralLedgerAccount>? listOfFilteredGLAccounts,
    AbstractFailure? abstractFailure,
    bool? isAnyFailure,
    bool? isLoadingGLAccountOnObserve,
    bool? isLoadingGLAccountsOnObserve,
    bool? isLoadingGLAccountOnCreate,
    bool? isLoadingGLAccountOnUpdate,
    bool? isLoadingGLAccountOnDelete,
    Option<Either<AbstractFailure, GeneralLedgerAccount>>? fosGLAccountOnObserveOption,
    Option<Either<AbstractFailure, List<GeneralLedgerAccount>>>? fosGLAccountsOnObserveOption,
    Option<Either<AbstractFailure, GeneralLedgerAccount>>? fosGLAccountOnCreateOption,
    Option<Either<AbstractFailure, GeneralLedgerAccount>>? fosGLAccountOnUpdateOption,
    Option<Either<List<AbstractFailure>, Unit>>? fosGLAccountsOnDeleteOption,
    List<GeneralLedgerAccount>? selectedGLAccounts,
    bool? isAllGLAccountsSelected,
    SearchController? searchController,
    TextEditingController? gLAccountController,
    TextEditingController? nameController,
  }) {
    return GeneralLedgerAccountState(
      gLAccount: gLAccount ?? this.gLAccount,
      listOfAllGLAccounts: listOfAllGLAccounts ?? this.listOfAllGLAccounts,
      listOfFilteredGLAccounts: listOfFilteredGLAccounts ?? this.listOfFilteredGLAccounts,
      abstractFailure: abstractFailure ?? this.abstractFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingGLAccountOnObserve: isLoadingGLAccountOnObserve ?? this.isLoadingGLAccountOnObserve,
      isLoadingGLAccountsOnObserve: isLoadingGLAccountsOnObserve ?? this.isLoadingGLAccountsOnObserve,
      isLoadingGLAccountOnCreate: isLoadingGLAccountOnCreate ?? this.isLoadingGLAccountOnCreate,
      isLoadingGLAccountOnUpdate: isLoadingGLAccountOnUpdate ?? this.isLoadingGLAccountOnUpdate,
      isLoadingGLAccountOnDelete: isLoadingGLAccountOnDelete ?? this.isLoadingGLAccountOnDelete,
      fosGLAccountOnObserveOption: fosGLAccountOnObserveOption ?? this.fosGLAccountOnObserveOption,
      fosGLAccountsOnObserveOption: fosGLAccountsOnObserveOption ?? this.fosGLAccountsOnObserveOption,
      fosGLAccountOnCreateOption: fosGLAccountOnCreateOption ?? this.fosGLAccountOnCreateOption,
      fosGLAccountOnUpdateOption: fosGLAccountOnUpdateOption ?? this.fosGLAccountOnUpdateOption,
      fosGLAccountsOnDeleteOption: fosGLAccountsOnDeleteOption ?? this.fosGLAccountsOnDeleteOption,
      selectedGLAccounts: selectedGLAccounts ?? this.selectedGLAccounts,
      isAllGLAccountsSelected: isAllGLAccountsSelected ?? this.isAllGLAccountsSelected,
      searchController: searchController ?? this.searchController,
      gLAccountController: gLAccountController ?? this.gLAccountController,
      nameController: nameController ?? this.nameController,
    );
  }
}
