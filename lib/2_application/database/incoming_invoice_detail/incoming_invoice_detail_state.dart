part of 'incoming_invoice_detail_bloc.dart';

//! copyWith NICHT GENERIEREN
//! abstractFailure wurde manuell angepasst
class IncomingInvoiceDetailState {
  final IncomingInvoice? originalInvoice;
  final IncomingInvoice? invoice;
  final Supplier? supplier;
  final AbstractFailure? abstractFailure;
  final bool isLoadingInvoiceOnObserve;
  final bool isLoadingInvoiceOnCreate;
  final bool isLoadingInvoiceOnUpdate;
  final bool isLoadingInvoiceOnDelete;
  final Option<Either<AbstractFailure, IncomingInvoice>> fosInvoiceOnObserveOption;
  final Option<Either<AbstractFailure, IncomingInvoice>> fosInvoiceOnCreateOption;
  final Option<Either<AbstractFailure, IncomingInvoice>> fosInvoiceOnUpdateOption;
  final Option<Either<List<AbstractFailure>, Unit>> fosInvoicesOnDeleteOption;

  //* Helper
  final IncomingInvoiceAddEditType type;

  //* Incoming Invoice Controller
  final TextEditingController invoiceNumberController;
  final TextEditingController discountPercentageController;
  final TextEditingController discountAmountController;
  final TextEditingController earlyPaymentDiscountController;

  //* Incoming Invoice Item Controller
  final ScrollController scrollController;
  final TextEditingController itemTitleController;
  final TextEditingController itemQuantityController;
  final TextEditingController itemUnitPriceNetController;
  final TextEditingController itemUnitPriceGrossController;
  final TextEditingController itemDiscountController;

  const IncomingInvoiceDetailState({
    required this.originalInvoice,
    required this.invoice,
    required this.supplier,
    required this.abstractFailure,
    required this.isLoadingInvoiceOnObserve,
    required this.isLoadingInvoiceOnCreate,
    required this.isLoadingInvoiceOnUpdate,
    required this.isLoadingInvoiceOnDelete,
    required this.fosInvoiceOnObserveOption,
    required this.fosInvoiceOnCreateOption,
    required this.fosInvoiceOnUpdateOption,
    required this.fosInvoicesOnDeleteOption,
    required this.type,
    required this.invoiceNumberController,
    required this.discountPercentageController,
    required this.discountAmountController,
    required this.earlyPaymentDiscountController,
    required this.scrollController,
    required this.itemTitleController,
    required this.itemQuantityController,
    required this.itemUnitPriceNetController,
    required this.itemUnitPriceGrossController,
    required this.itemDiscountController,
  });

  factory IncomingInvoiceDetailState.initial() {
    return IncomingInvoiceDetailState(
      originalInvoice: null,
      invoice: null,
      supplier: null,
      abstractFailure: null,
      isLoadingInvoiceOnObserve: false,
      isLoadingInvoiceOnCreate: false,
      isLoadingInvoiceOnUpdate: false,
      isLoadingInvoiceOnDelete: false,
      fosInvoiceOnObserveOption: none(),
      fosInvoiceOnCreateOption: none(),
      fosInvoiceOnUpdateOption: none(),
      fosInvoicesOnDeleteOption: none(),
      type: IncomingInvoiceAddEditType.create,
      invoiceNumberController: TextEditingController(),
      discountPercentageController: TextEditingController(),
      discountAmountController: TextEditingController(),
      earlyPaymentDiscountController: TextEditingController(),
      scrollController: ScrollController(),
      itemTitleController: TextEditingController(),
      itemQuantityController: TextEditingController(),
      itemUnitPriceNetController: TextEditingController(),
      itemUnitPriceGrossController: TextEditingController(),
      itemDiscountController: TextEditingController(),
    );
  }

  IncomingInvoiceDetailState copyWith({
    IncomingInvoice? originalInvoice,
    IncomingInvoice? invoice,
    Supplier? supplier,
    AbstractFailure? abstractFailure,
    bool resetAbstractFailure = false, // Hinzugefügt, um null explizit zu setzen
    bool? isLoadingInvoiceOnObserve,
    bool? isLoadingInvoiceOnCreate,
    bool? isLoadingInvoiceOnUpdate,
    bool? isLoadingInvoiceOnDelete,
    Option<Either<AbstractFailure, IncomingInvoice>>? fosInvoiceOnObserveOption,
    Option<Either<AbstractFailure, IncomingInvoice>>? fosInvoiceOnCreateOption,
    Option<Either<AbstractFailure, IncomingInvoice>>? fosInvoiceOnUpdateOption,
    Option<Either<List<AbstractFailure>, Unit>>? fosInvoicesOnDeleteOption,
    IncomingInvoiceAddEditType? type,
    TextEditingController? invoiceNumberController,
    TextEditingController? discountPercentageController,
    TextEditingController? discountAmountController,
    TextEditingController? earlyPaymentDiscountController,
    ScrollController? scrollController,
    TextEditingController? itemTitleController,
    TextEditingController? itemQuantityController,
    TextEditingController? itemUnitPriceNetController,
    TextEditingController? itemUnitPriceGrossController,
    TextEditingController? itemDiscountController,
  }) {
    return IncomingInvoiceDetailState(
      originalInvoice: originalInvoice ?? this.originalInvoice,
      invoice: invoice ?? this.invoice,
      supplier: supplier ?? this.supplier,
      abstractFailure: resetAbstractFailure ? null : (abstractFailure ?? this.abstractFailure),
      isLoadingInvoiceOnObserve: isLoadingInvoiceOnObserve ?? this.isLoadingInvoiceOnObserve,
      isLoadingInvoiceOnCreate: isLoadingInvoiceOnCreate ?? this.isLoadingInvoiceOnCreate,
      isLoadingInvoiceOnUpdate: isLoadingInvoiceOnUpdate ?? this.isLoadingInvoiceOnUpdate,
      isLoadingInvoiceOnDelete: isLoadingInvoiceOnDelete ?? this.isLoadingInvoiceOnDelete,
      fosInvoiceOnObserveOption: fosInvoiceOnObserveOption ?? this.fosInvoiceOnObserveOption,
      fosInvoiceOnCreateOption: fosInvoiceOnCreateOption ?? this.fosInvoiceOnCreateOption,
      fosInvoiceOnUpdateOption: fosInvoiceOnUpdateOption ?? this.fosInvoiceOnUpdateOption,
      fosInvoicesOnDeleteOption: fosInvoicesOnDeleteOption ?? this.fosInvoicesOnDeleteOption,
      type: type ?? this.type,
      invoiceNumberController: invoiceNumberController ?? this.invoiceNumberController,
      discountPercentageController: discountPercentageController ?? this.discountPercentageController,
      discountAmountController: discountAmountController ?? this.discountAmountController,
      earlyPaymentDiscountController: earlyPaymentDiscountController ?? this.earlyPaymentDiscountController,
      scrollController: scrollController ?? this.scrollController,
      itemTitleController: itemTitleController ?? this.itemTitleController,
      itemQuantityController: itemQuantityController ?? this.itemQuantityController,
      itemUnitPriceNetController: itemUnitPriceNetController ?? this.itemUnitPriceNetController,
      itemUnitPriceGrossController: itemUnitPriceGrossController ?? this.itemUnitPriceGrossController,
      itemDiscountController: itemDiscountController ?? this.itemDiscountController,
    );
  }
}
