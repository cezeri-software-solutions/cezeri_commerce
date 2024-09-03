// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'general_ledger_account_bloc.dart';

@immutable
class GeneralLedgerAccountState {
  final GeneralLedgerAccount? gLAccount;
  final List<GeneralLedgerAccount>? listOfAllGLAccounts;
  final List<GeneralLedgerAccount> listOfFilteredGLAccounts0;
  final List<GeneralLedgerAccount> listOfFilteredGLAccounts1;
  final List<GeneralLedgerAccount> listOfFilteredGLAccounts2;
  final List<GeneralLedgerAccount> listOfFilteredGLAccounts3;
  final List<GeneralLedgerAccount> listOfFilteredGLAccounts4;
  final List<GeneralLedgerAccount> listOfFilteredGLAccounts5;
  final List<GeneralLedgerAccount> listOfFilteredGLAccounts6;
  final List<GeneralLedgerAccount> listOfFilteredGLAccounts7;
  final List<GeneralLedgerAccount> listOfFilteredGLAccounts8;
  final List<GeneralLedgerAccount> listOfFilteredGLAccounts9;
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
    required this.listOfFilteredGLAccounts0,
    required this.listOfFilteredGLAccounts1,
    required this.listOfFilteredGLAccounts2,
    required this.listOfFilteredGLAccounts3,
    required this.listOfFilteredGLAccounts4,
    required this.listOfFilteredGLAccounts5,
    required this.listOfFilteredGLAccounts6,
    required this.listOfFilteredGLAccounts7,
    required this.listOfFilteredGLAccounts8,
    required this.listOfFilteredGLAccounts9,
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
      listOfFilteredGLAccounts0: const [],
      listOfFilteredGLAccounts1: const [],
      listOfFilteredGLAccounts2: const [],
      listOfFilteredGLAccounts3: const [],
      listOfFilteredGLAccounts4: const [],
      listOfFilteredGLAccounts5: const [],
      listOfFilteredGLAccounts6: const [],
      listOfFilteredGLAccounts7: const [],
      listOfFilteredGLAccounts8: const [],
      listOfFilteredGLAccounts9: const [],
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
    List<GeneralLedgerAccount>? listOfFilteredGLAccounts0,
    List<GeneralLedgerAccount>? listOfFilteredGLAccounts1,
    List<GeneralLedgerAccount>? listOfFilteredGLAccounts2,
    List<GeneralLedgerAccount>? listOfFilteredGLAccounts3,
    List<GeneralLedgerAccount>? listOfFilteredGLAccounts4,
    List<GeneralLedgerAccount>? listOfFilteredGLAccounts5,
    List<GeneralLedgerAccount>? listOfFilteredGLAccounts6,
    List<GeneralLedgerAccount>? listOfFilteredGLAccounts7,
    List<GeneralLedgerAccount>? listOfFilteredGLAccounts8,
    List<GeneralLedgerAccount>? listOfFilteredGLAccounts9,
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
      listOfFilteredGLAccounts0: listOfFilteredGLAccounts0 ?? this.listOfFilteredGLAccounts0,
      listOfFilteredGLAccounts1: listOfFilteredGLAccounts1 ?? this.listOfFilteredGLAccounts1,
      listOfFilteredGLAccounts2: listOfFilteredGLAccounts2 ?? this.listOfFilteredGLAccounts2,
      listOfFilteredGLAccounts3: listOfFilteredGLAccounts3 ?? this.listOfFilteredGLAccounts3,
      listOfFilteredGLAccounts4: listOfFilteredGLAccounts4 ?? this.listOfFilteredGLAccounts4,
      listOfFilteredGLAccounts5: listOfFilteredGLAccounts5 ?? this.listOfFilteredGLAccounts5,
      listOfFilteredGLAccounts6: listOfFilteredGLAccounts6 ?? this.listOfFilteredGLAccounts6,
      listOfFilteredGLAccounts7: listOfFilteredGLAccounts7 ?? this.listOfFilteredGLAccounts7,
      listOfFilteredGLAccounts8: listOfFilteredGLAccounts8 ?? this.listOfFilteredGLAccounts8,
      listOfFilteredGLAccounts9: listOfFilteredGLAccounts9 ?? this.listOfFilteredGLAccounts9,
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
