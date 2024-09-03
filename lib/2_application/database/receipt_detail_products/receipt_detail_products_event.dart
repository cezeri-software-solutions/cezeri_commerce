part of 'receipt_detail_products_bloc.dart';

@immutable
abstract class ReceiptDetailProductsEvent {}

class SetReceiptReceiptDetailEvent extends ReceiptDetailProductsEvent {
  final Receipt receipt;
  final List<Tax> listOfTaxRules;

  SetReceiptReceiptDetailEvent({required this.receipt, required this.listOfTaxRules});
}

class SetListOfReceiptProductssReceiptDetailEvent extends ReceiptDetailProductsEvent {
  final Receipt receipt;
  final List<Tax> listOfTaxRules;

  SetListOfReceiptProductssReceiptDetailEvent({required this.receipt, required this.listOfTaxRules});
}

class AddProductToReceiptProductsEvent extends ReceiptDetailProductsEvent {
  final ReceiptProduct receiptProduct;

  AddProductToReceiptProductsEvent({required this.receiptProduct});
}

class RemoveProductFromReceiptProductsEvent extends ReceiptDetailProductsEvent {
  final int index;

  RemoveProductFromReceiptProductsEvent({required this.index});
}

class SetIsInScanModeEvent extends ReceiptDetailProductsEvent {
  final bool isInScanMode;

  SetIsInScanModeEvent({required this.isInScanMode});
}

class SetTotalDiscountPercentControllerEvent extends ReceiptDetailProductsEvent {
  final double value;

  SetTotalDiscountPercentControllerEvent({required this.value});
}

class SetTotalDiscountAmountGrossControllerEvent extends ReceiptDetailProductsEvent {
  final double value;

  SetTotalDiscountAmountGrossControllerEvent({required this.value});
}

class SetShippingAmountGrossControllerEvent extends ReceiptDetailProductsEvent {
  final double value;

  SetShippingAmountGrossControllerEvent({required this.value});
}

class SetAdditionalAmountGrossControllerEvent extends ReceiptDetailProductsEvent {
  final double value;

  SetAdditionalAmountGrossControllerEvent({required this.value});
}

class OnReceiptDetailTotalControllerChangedEvent extends ReceiptDetailProductsEvent {}

class SetControllerOnTapOutsideReceiptDetailEvent extends ReceiptDetailProductsEvent {}

//? #################################################################################################
//? ################## Contollers ###################################################################

class SetAllControllersEvent extends ReceiptDetailProductsEvent {
  final List<ReceiptProduct>? listOfReceiptProducts;

  SetAllControllersEvent({this.listOfReceiptProducts});
}

class SetTaxRuleEvent extends ReceiptDetailProductsEvent {
  final Tax taxRule;
  final int index;

  SetTaxRuleEvent({required this.taxRule, required this.index});
}

class SetArticleNumberControllerEvent extends ReceiptDetailProductsEvent {
  final int index;

  SetArticleNumberControllerEvent({required this.index});
}

class SetArticleNameControllerEvent extends ReceiptDetailProductsEvent {
  final int index;

  SetArticleNameControllerEvent({required this.index});
}

class SetQuantityControllerEvent extends ReceiptDetailProductsEvent {
  final int index;

  SetQuantityControllerEvent({required this.index});
}

class SetUnitPriceNetControllerEvent extends ReceiptDetailProductsEvent {
  final int index;

  SetUnitPriceNetControllerEvent({required this.index});
}

class SetPosDiscountPercentControllerEvent extends ReceiptDetailProductsEvent {
  final int index;

  SetPosDiscountPercentControllerEvent({required this.index});
}

class SetUnitPriceGrossControllerEvent extends ReceiptDetailProductsEvent {
  final int index;

  SetUnitPriceGrossControllerEvent({required this.index});
}
