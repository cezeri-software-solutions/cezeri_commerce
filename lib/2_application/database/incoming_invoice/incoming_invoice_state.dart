part of 'incoming_invoice_bloc.dart';

//! copyWith NICHT GENERIEREN
//! abstractFailure wurde manuell angepasst
class IncomingInvoiceState {
  final List<IncomingInvoice>? listOfInvoices;
  final List<IncomingInvoice> listOfSelectedInvoices;
  final AbstractFailure? abstractFailure;
  final bool isLoadingInvoicesOnObserve;
  final bool isLoadingInvoiceOnDelete;
  final Option<Either<AbstractFailure, List<IncomingInvoice>>> fosInvoicesOnObserveOption;
  final Option<Either<List<AbstractFailure>, Unit>> fosInvoicesOnDeleteOption;

  //* Helpers
  final int perPageQuantity;
  final int totalQuantity;
  final int currentPage;

  //* Helpers isSelected
  final List<IncomingInvoice> selectedInvoices;
  final bool isAllInvoicesSelected;

  //* Controller
  final SearchController searchController;

  const IncomingInvoiceState({
    required this.listOfInvoices,
    required this.listOfSelectedInvoices,
    required this.abstractFailure,
    required this.isLoadingInvoicesOnObserve,
    required this.isLoadingInvoiceOnDelete,
    required this.fosInvoicesOnObserveOption,
    required this.fosInvoicesOnDeleteOption,
    required this.perPageQuantity,
    required this.totalQuantity,
    required this.currentPage,
    required this.selectedInvoices,
    required this.isAllInvoicesSelected,
    required this.searchController,
  });

  factory IncomingInvoiceState.initial() {
    return IncomingInvoiceState(
      listOfInvoices: null,
      listOfSelectedInvoices: [],
      abstractFailure: null,
      isLoadingInvoicesOnObserve: false,
      isLoadingInvoiceOnDelete: false,
      fosInvoicesOnObserveOption: none(),
      fosInvoicesOnDeleteOption: none(),
      perPageQuantity: 20,
      totalQuantity: 1,
      currentPage: 1,
      selectedInvoices: [],
      isAllInvoicesSelected: false,
      searchController: SearchController(),
    );
  }

  IncomingInvoiceState copyWith({
    List<IncomingInvoice>? listOfInvoices,
    List<IncomingInvoice>? listOfSelectedInvoices,
    AbstractFailure? abstractFailure,
    bool resetAbstractFailure = false, // Hinzugefügt, um null explizit zu setzen
    bool? isLoadingInvoicesOnObserve,
    bool? isLoadingInvoiceOnDelete,
    Option<Either<AbstractFailure, List<IncomingInvoice>>>? fosInvoicesOnObserveOption,
    Option<Either<List<AbstractFailure>, Unit>>? fosInvoicesOnDeleteOption,
    int? perPageQuantity,
    int? totalQuantity,
    int? currentPage,
    List<IncomingInvoice>? selectedInvoices,
    bool? isAllInvoicesSelected,
    SearchController? searchController,
  }) {
    return IncomingInvoiceState(
      listOfInvoices: listOfInvoices ?? this.listOfInvoices,
      listOfSelectedInvoices: listOfSelectedInvoices ?? this.listOfSelectedInvoices,
      abstractFailure: resetAbstractFailure ? null : (abstractFailure ?? this.abstractFailure),
      isLoadingInvoicesOnObserve: isLoadingInvoicesOnObserve ?? this.isLoadingInvoicesOnObserve,
      isLoadingInvoiceOnDelete: isLoadingInvoiceOnDelete ?? this.isLoadingInvoiceOnDelete,
      fosInvoicesOnObserveOption: fosInvoicesOnObserveOption ?? this.fosInvoicesOnObserveOption,
      fosInvoicesOnDeleteOption: fosInvoicesOnDeleteOption ?? this.fosInvoicesOnDeleteOption,
      perPageQuantity: perPageQuantity ?? this.perPageQuantity,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      currentPage: currentPage ?? this.currentPage,
      selectedInvoices: selectedInvoices ?? this.selectedInvoices,
      isAllInvoicesSelected: isAllInvoicesSelected ?? this.isAllInvoicesSelected,
      searchController: searchController ?? this.searchController,
    );
  }
}
