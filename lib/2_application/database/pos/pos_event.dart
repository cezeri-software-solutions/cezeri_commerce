part of 'pos_bloc.dart';

abstract class PosEvent {}

class SetPosStateInitialEvent extends PosEvent {}

class SetPosStatesOnLoadEvent extends PosEvent {
  final MarketplaceShop marketplace;
  final Customer customer;

  SetPosStatesOnLoadEvent({required this.marketplace, required this.customer});
}

class DeletePosBasketEvent extends PosEvent {
  final MarketplaceShop marketplace;
  final Customer customer;
  final MainSettings settings;

  DeletePosBasketEvent({required this.marketplace, required this.customer, required this.settings});
}

class CreateReceiptsEvent extends PosEvent {
  final Receipt receipt;

  CreateReceiptsEvent({required this.receipt});
}

class ChangePosCustomerEvent extends PosEvent {
  final Customer customer;

  ChangePosCustomerEvent({required this.customer});
}

class UpdateReceiptOnAnythingChangedEvent extends PosEvent {}

class LoadProductsBySearchTextEvent extends PosEvent {}

class LoadProductByEanEvent extends PosEvent {
  final BuildContext context;
  final String ean;

  LoadProductByEanEvent({required this.context, required this.ean});
}

class AddProductToBasketEvent extends PosEvent {
  final Product product;

  AddProductToBasketEvent({required this.product});
}

class RemoveProductFromBasketEvent extends PosEvent {
  final int index;

  RemoveProductFromBasketEvent({required this.index});
}

class RemoveProductQuantityFromBasketEvent extends PosEvent {
  final int index;

  RemoveProductQuantityFromBasketEvent({required this.index});
}

//* Controller

class SetTotalDiscountPercentControllerEvent extends PosEvent {}

class SetTotalDiscountAmountGrossControllerEvent extends PosEvent {}

//* Helper

class SetIsModalSheetOpenEvent extends PosEvent {
  final bool value;

  SetIsModalSheetOpenEvent({required this.value});
}

class SetPrintInvoiceEvent extends PosEvent {}
