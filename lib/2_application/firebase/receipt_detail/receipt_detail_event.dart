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

//? ################## Contollers #################################

class SetAllControllersEvent extends ReceiptDetailEvent {
  final List<ReceiptProduct>? listOfReceiptProducts;

  SetAllControllersEvent({this.listOfReceiptProducts});
}

class SetTaxRuleEvent extends ReceiptDetailEvent {
  final Tax taxRule;
  final int index;

  SetTaxRuleEvent({required this.taxRule, required this.index});
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
