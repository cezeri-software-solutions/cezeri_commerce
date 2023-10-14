part of 'receipt_detail_bloc.dart';

@immutable
abstract class ReceiptDetailEvent {}

class SetReceiptReceiptDetailEvent extends ReceiptDetailEvent {
  final Receipt receipt;
  final List<Tax> listOfTaxRules;

  SetReceiptReceiptDetailEvent({required this.receipt, required this.listOfTaxRules});
}

class SetListOfReceiptProductssReceiptDetailEvent extends ReceiptDetailEvent {
  final List<ReceiptProduct> listOfReceiptProducts;

  SetListOfReceiptProductssReceiptDetailEvent({required this.listOfReceiptProducts});
}

class AddProductToReceiptProductsEvent extends ReceiptDetailEvent {
  final ReceiptProduct receiptProduct;

  AddProductToReceiptProductsEvent({required this.receiptProduct});
}

class RemoveProductFromReceiptProductsEvent extends ReceiptDetailEvent {
  final int index;

  RemoveProductFromReceiptProductsEvent({required this.index});
}

class SetIsInScanModeEvent extends ReceiptDetailEvent {
  final bool isInScanMode;

  SetIsInScanModeEvent({required this.isInScanMode});
}

class SetTotalDiscountPercentControllerEvent extends ReceiptDetailEvent {
  final double value;

  SetTotalDiscountPercentControllerEvent({required this.value});
}

class SetTotalDiscountAmountGrossControllerEvent extends ReceiptDetailEvent {
  final double value;

  SetTotalDiscountAmountGrossControllerEvent({required this.value});
}

class SetShippingAmountGrossControllerEvent extends ReceiptDetailEvent {
  final double value;

  SetShippingAmountGrossControllerEvent({required this.value});
}

class SetAdditionalAmountGrossControllerEvent extends ReceiptDetailEvent {
  final double value;

  SetAdditionalAmountGrossControllerEvent({required this.value});
}

class SetControllerOnTapOutsideReceiptDetailEvent extends ReceiptDetailEvent {}

//? #################################################################################################
//? ################## Contollers ###################################################################

class OnBarcodeScannedEvent extends ReceiptDetailEvent {}

class SetAllControllersEvent extends ReceiptDetailEvent {
  final List<ReceiptProduct>? listOfReceiptProducts;

  SetAllControllersEvent({this.listOfReceiptProducts});
}

class SetTaxRuleEvent extends ReceiptDetailEvent {
  final Tax taxRule;
  final int index;

  SetTaxRuleEvent({required this.taxRule, required this.index});
}

class SetArticleNumberControllerEvent extends ReceiptDetailEvent {
  final int index;

  SetArticleNumberControllerEvent({required this.index});
}

class SetArticleNameControllerEvent extends ReceiptDetailEvent {
  final int index;

  SetArticleNameControllerEvent({required this.index});
}

class SetQuantityControllerEvent extends ReceiptDetailEvent {
  final int index;

  SetQuantityControllerEvent({required this.index});
}

class SetUnitPriceNetControllerEvent extends ReceiptDetailEvent {
  final int index;

  SetUnitPriceNetControllerEvent({required this.index});
}

class SetPosDiscountPercentControllerEvent extends ReceiptDetailEvent {
  final int index;

  SetPosDiscountPercentControllerEvent({required this.index});
}

class SetUnitPriceGrossControllerEvent extends ReceiptDetailEvent {
  final int index;

  SetUnitPriceGrossControllerEvent({required this.index});
}
