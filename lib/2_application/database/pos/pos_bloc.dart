import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../1_presentation/core/core.dart';
import '../../../3_domain/entities/address.dart';
import '../../../3_domain/entities/customer/customer.dart';
import '../../../3_domain/entities/marketplace/marketplace_shop.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/receipt/receipt_customer.dart';
import '../../../3_domain/entities/receipt/receipt_marketplace.dart';
import '../../../3_domain/entities/receipt/receipt_product.dart';
import '../../../3_domain/entities/settings/main_settings.dart';
import '../../../3_domain/entities/settings/payment_method.dart';
import '../../../3_domain/repositories/firebase/customer_repository.dart';
import '../../../3_domain/repositories/firebase/main_settings_respository.dart';
import '../../../3_domain/repositories/firebase/marketplace_repository.dart';
import '../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../3_domain/repositories/firebase/receipt_repository.dart';
import '../../../failures/failures.dart';

part 'pos_event.dart';
part 'pos_state.dart';

class PosBloc extends Bloc<PosEvent, PosState> {
  final ReceiptRepository receiptRepository;
  final MarketplaceRepository marketplaceRepository;
  final MainSettingsRepository mainSettingsRepository;
  final CustomerRepository customerRepository;
  final ProductRepository productRepository;

  PosBloc({
    required this.receiptRepository,
    required this.marketplaceRepository,
    required this.mainSettingsRepository,
    required this.customerRepository,
    required this.productRepository,
  }) : super(PosState.initial()) {
    on<SetPosStateInitialEvent>(_onSetPosStateInitial);
    on<SetPosStatesOnLoadEvent>(_onSetPosStatesOnLoad);
    on<CreateReceiptsEvent>(_onCreateReceipts);
    on<DeletePosBasketEvent>(_onDeletePosBasket);
    on<ChangePosCustomerEvent>(_onChangePosCustomer);
    on<LoadProductsBySearchTextEvent>(_onLoadProductsBySearchText);
    on<UpdateReceiptOnAnythingChangedEvent>(_onUpdateReceiptOnAnythingChanged);
    on<LoadProductByEanEvent>(_onLoadProductByEan);
    on<AddProductToBasketEvent>(_onAddProductToBasket);
    on<RemoveProductFromBasketEvent>(_onRemoveProductFromBasket);
    on<RemoveProductQuantityFromBasketEvent>(_onRemoveProductQuantityFromBasket);
    on<SetTotalDiscountPercentControllerEvent>(_onSetTotalDiscountPercentController);
    on<SetTotalDiscountAmountGrossControllerEvent>(_onSetTotalDiscountAmountGrossController);
    on<SetIsModalSheetOpenEvent>(_onSetIsModalSheetOpen);
    on<SetPrintInvoiceEvent>(_onSetPrintInvoice);
  }

  void _onSetPosStateInitial(SetPosStateInitialEvent event, Emitter<PosState> emit) {
    emit(PosState.initial());
  }

  Future<void> _onSetPosStatesOnLoad(SetPosStatesOnLoadEvent event, Emitter<PosState> emit) async {
    emit(state.copyWith(isLoadingPosOnObserve: true));

    final fosSettings = await mainSettingsRepository.getSettings();
    fosSettings.fold(
      (failure) => emit(state.copyWith(databaseFailure: failure)),
      (settings) => emit(state.copyWith(mainSettings: settings, databaseFailure: null)),
    );

    final settings = fosSettings.getRight();

    final newReceipt = Receipt.empty().copyWith(
      customerId: event.customer.id,
      receiptCustomer: ReceiptCustomer.fromCustomer(event.customer),
      addressInvoice: getDefaultAddress(event.customer.listOfAddress, AddressType.invoice),
      addressDelivery: getDefaultAddress(event.customer.listOfAddress, AddressType.delivery),
      tax: event.customer.tax,
      listOfReceiptProduct: [],
      receiptTyp: ReceiptType.appointment,
      currency: settings.currency,
      marketplaceId: event.marketplace.id,
      receiptMarketplace: ReceiptMarketplace.fromMarketplace(event.marketplace),
      paymentMethod: PaymentMethod.paymentMethodList.where((e) => e.name == 'Barzahlung').firstOrNull,
    );

    emit(state.copyWith(
      receipt: newReceipt,
      customer: event.customer,
      marketplace: event.marketplace,
      isLoadingPosOnObserve: false,
      fosPosOnObserveOption: fosSettings.isRight() ? optionOf(const Right(unit)) : optionOf(Left(fosSettings.getLeft())),
    ));
    emit(state.copyWith(fosPosOnObserveOption: none()));
  }

  Future<void> _onCreateReceipts(CreateReceiptsEvent event, Emitter<PosState> emit) async {
    emit(state.copyWith(isLoadingPosOnCreate: true));

    final fosCreatedReceipts = await receiptRepository.createPosReceipts(event.receipt);

    emit(state.copyWith(isLoadingPosOnCreate: false, fosPosOnCreateOption: optionOf(fosCreatedReceipts)));
  }

  Future<void> _onDeletePosBasket(DeletePosBasketEvent event, Emitter<PosState> emit) async {
    final newReceipt = Receipt.empty().copyWith(
      customerId: event.customer.id,
      receiptCustomer: ReceiptCustomer.fromCustomer(event.customer),
      addressInvoice: getDefaultAddress(event.customer.listOfAddress, AddressType.invoice),
      addressDelivery: getDefaultAddress(event.customer.listOfAddress, AddressType.delivery),
      tax: event.customer.tax,
      listOfReceiptProduct: [],
      receiptTyp: ReceiptType.appointment,
      currency: event.settings.currency,
    );

    emit(state.copyWith(
      receipt: newReceipt,
      customer: event.customer,
      marketplace: event.marketplace,
      mainSettings: event.settings,
    ));
  }

  Future<void> _onChangePosCustomer(ChangePosCustomerEvent event, Emitter<PosState> emit) async {
    final customer = event.customer;
    final marketplace = state.marketplace!;
    final settings = state.mainSettings!;

    add(SetPosStateInitialEvent());
    add(DeletePosBasketEvent(marketplace: marketplace, customer: customer, settings: settings));
  }

  void _onUpdateReceiptOnAnythingChanged(UpdateReceiptOnAnythingChangedEvent event, Emitter<PosState> emit) {
    double profit = state.receipt.totalShippingNet;
    for (var product in state.receipt.listOfReceiptProduct) {
      profit += product.profit;
    }

    final receiptProducts = state.receipt.listOfReceiptProduct;
    List<ReceiptProduct> updatedReceiptProducts = [];

    for (int i = 0; i < receiptProducts.length; i++) {
      final discountPercentAmountGrossUnit =
          (calcPercentageAmount(receiptProducts[i].unitPriceGross, receiptProducts[i].discountPercent)).toMyRoundedDouble();
      final discountPercentAmountNetUnit = (discountPercentAmountGrossUnit / taxToCalc(receiptProducts[i].tax.taxRate)).toMyRoundedDouble();
      final receiptProdut = receiptProducts[i].copyWith(
        discountPercentAmountGrossUnit: discountPercentAmountGrossUnit,
        discountPercentAmountNetUnit: discountPercentAmountNetUnit,
        discountGross: ((discountPercentAmountGrossUnit + receiptProducts[i].discountGrossUnit) * receiptProducts[i].quantity).toMyRoundedDouble(),
        discountNet: ((discountPercentAmountNetUnit + receiptProducts[i].discountNetUnit) * receiptProducts[i].quantity).toMyRoundedDouble(),
      );
      updatedReceiptProducts.add(receiptProdut);
    }

    emit(state.copyWith(
      receipt: state.receipt.copyWith(
        discountPercentAmountGross: state.receipt.discountPercentAmountGross,
        discountPercentAmountNet: (state.receipt.discountPercentAmountGross / taxToCalc(state.receipt.tax.taxRate)).toMyRoundedDouble(),
        discountPercentAmountTax:
            (state.receipt.discountPercentAmountGross - (state.receipt.discountPercentAmountGross / taxToCalc(state.receipt.tax.taxRate)))
                .toMyRoundedDouble(),
        discountNet: (state.receipt.discountGross / taxToCalc(state.receipt.tax.taxRate)).toMyRoundedDouble(),
        discountTax: (state.receipt.discountGross - (state.receipt.discountGross / taxToCalc(state.receipt.tax.taxRate))).toMyRoundedDouble(),
        totalShippingNet: (state.receipt.totalShippingGross / taxToCalc(state.receipt.tax.taxRate)).toMyRoundedDouble(),
        totalShippingTax:
            (state.receipt.totalShippingGross - (state.receipt.totalShippingGross / taxToCalc(state.receipt.tax.taxRate))).toMyRoundedDouble(),
        additionalAmountNet: (state.receipt.additionalAmountGross / taxToCalc(state.receipt.tax.taxRate)).toMyRoundedDouble(),
        additionalAmountTax:
            (state.receipt.additionalAmountGross - (state.receipt.additionalAmountGross / taxToCalc(state.receipt.tax.taxRate))).toMyRoundedDouble(),
        //
        totalGross: _calcTotalGross(state.receipt),
        totalNet: (_calcTotalGross(state.receipt) / taxToCalc(state.receipt.tax.taxRate)).toMyRoundedDouble(),
        totalTax: _calcTaxAmount(state.receipt),
        subTotalGross: _calcProductsTotalGross(updatedReceiptProducts),
        subTotalNet: _calcProductsTotalNet(updatedReceiptProducts),
        subTotalTax: _calcProductsTotalGross(updatedReceiptProducts) - _calcProductsTotalNet(updatedReceiptProducts),
        posDiscountPercentAmountGross: _calcPosDiscountPercentAmount(updatedReceiptProducts),
        posDiscountPercentAmountNet:
            (_calcPosDiscountPercentAmount(updatedReceiptProducts) / taxToCalc(state.receipt.tax.taxRate)).toMyRoundedDouble(),
        posDiscountPercentAmountTax: (_calcPosDiscountPercentAmount(updatedReceiptProducts) -
                (_calcPosDiscountPercentAmount(updatedReceiptProducts) / taxToCalc(state.receipt.tax.taxRate)))
            .toMyRoundedDouble(),
        profit: profit,
        profitExclShipping: profit - state.receipt.totalShippingNet,
        profitExclWrapping: profit - state.receipt.totalWrappingNet,
        profitExclShippingAndWrapping: profit - state.receipt.totalShippingNet - state.receipt.totalWrappingNet,
      ),
    ));
  }

  Future<void> _onLoadProductsBySearchText(LoadProductsBySearchTextEvent event, Emitter<PosState> emit) async {
    emit(state.copyWith(isLoadingPosOnCreate: true));

    final fosProducts = await productRepository.getListOfFilteredProductsBySearchText(
      searchText: state.searchController.text,
      currentPage: 1,
      itemsPerPage: 20,
    );

    if (fosProducts.isRight()) emit(state.copyWith(listOfSearchResultProducts: fosProducts.getRight(), isLoadingPosOnCreate: false));
  }

  Future<void> _onLoadProductByEan(LoadProductByEanEvent event, Emitter<PosState> emit) async {
    if (state.isModalSheetOpen) return;
    final inListProduct = state.listOfSelectedProducts.where((e) => e.ean == event.ean).firstOrNull;

    if (inListProduct != null) {
      add(AddProductToBasketEvent(product: inListProduct));
      return;
    }

    emit(state.copyWith(isLoadingPosOnCreate: true));

    final fosProduct = await productRepository.getProductByEan(event.ean);

    print(fosProduct);

    emit(state.copyWith(isLoadingPosOnCreate: false));

    if (fosProduct.isRight()) add(AddProductToBasketEvent(product: fosProduct.getRight()));

    if (fosProduct.isLeft()) {
      add(SetIsModalSheetOpenEvent(value: true));
      if (event.context.mounted && fosProduct.getLeft() is EmptyFailure) {
        await showMyDialogAlert(
          canPop: false,
          context: event.context,
          title: 'Achtung!',
          content: 'In der Datenbank konnte kein Artikel mit der EAN: ${event.ean} gefunden werden.',
        );
        add(SetIsModalSheetOpenEvent(value: false));
      }

      if (event.context.mounted && fosProduct.getLeft() is! EmptyFailure) {
        await showMyDialogAlert(
          canPop: false,
          context: event.context,
          title: 'Achtung!',
          content: 'Beim Laden des Artikels ist ein Fehler aufgetreten.',
        );
        add(SetIsModalSheetOpenEvent(value: false));
      }
    }
  }

  void _onAddProductToBasket(AddProductToBasketEvent event, Emitter<PosState> emit) {
    final index = state.receipt.listOfReceiptProduct.indexWhere((e) => e.productId == event.product.id);
    print(index == -1 ? 'New product: ${event.product.name}' : 'Existing product: ${event.product.name}');

    if (index != -1) {
      List<ReceiptProduct> toUpdateList = List.from(state.receipt.listOfReceiptProduct);
      final updatedReceiptProduct = toUpdateList[index].copyWith(quantity: toUpdateList[index].quantity + 1);
      toUpdateList[index] = updatedReceiptProduct;
      emit(state.copyWith(receipt: state.receipt.copyWith(listOfReceiptProduct: toUpdateList)));
    } else {
      List<ReceiptProduct> toUpdateList = List.from(state.receipt.listOfReceiptProduct);
      toUpdateList.add(ReceiptProduct.fromProduct(event.product));
      final listOfSelectedProducts = state.listOfSelectedProducts..add(event.product);
      emit(state.copyWith(receipt: state.receipt.copyWith(listOfReceiptProduct: toUpdateList), listOfSelectedProducts: listOfSelectedProducts));
    }

    add(UpdateReceiptOnAnythingChangedEvent());
  }

  void _onRemoveProductFromBasket(RemoveProductFromBasketEvent event, Emitter<PosState> emit) {
    List<ReceiptProduct> toUpdateList = List.from(state.receipt.listOfReceiptProduct);
    toUpdateList.removeAt(event.index);
    emit(state.copyWith(receipt: state.receipt.copyWith(listOfReceiptProduct: toUpdateList)));

    add(UpdateReceiptOnAnythingChangedEvent());
  }

  void _onRemoveProductQuantityFromBasket(RemoveProductQuantityFromBasketEvent event, Emitter<PosState> emit) {
    if (state.receipt.listOfReceiptProduct[event.index].quantity <= 1) {
      add(RemoveProductFromBasketEvent(index: event.index));
    } else {
      List<ReceiptProduct> toUpdateList = List.from(state.receipt.listOfReceiptProduct);
      toUpdateList[event.index] = toUpdateList[event.index].copyWith(quantity: toUpdateList[event.index].quantity - 1);
      emit(state.copyWith(receipt: state.receipt.copyWith(listOfReceiptProduct: toUpdateList)));

      add(UpdateReceiptOnAnythingChangedEvent());
    }
  }

  void _onSetTotalDiscountPercentController(SetTotalDiscountPercentControllerEvent event, Emitter<PosState> emit) {
    emit(state.copyWith(receipt: state.receipt.copyWith(discountPercent: state.discountPercentController.text.toMyDouble())));
    add(UpdateReceiptOnAnythingChangedEvent());
  }

  void _onSetTotalDiscountAmountGrossController(SetTotalDiscountAmountGrossControllerEvent event, Emitter<PosState> emit) {
    emit(state.copyWith(receipt: state.receipt.copyWith(discountGross: state.discountAmountController.text.toMyDouble())));
    add(UpdateReceiptOnAnythingChangedEvent());
  }

  void _onSetIsModalSheetOpen(SetIsModalSheetOpenEvent event, Emitter<PosState> emit) {
    emit(state.copyWith(isModalSheetOpen: event.value));
  }

  void _onSetPrintInvoice(SetPrintInvoiceEvent event, Emitter<PosState> emit) {
    emit(state.copyWith(printInvoice: !state.printInvoice));
  }
}

//? #################################################################################################################################################
//? #################################################################################################################################################
//? ################### HELPER FUNCTIONS ############################################################################################################

double _calcProductsTotalNet(List<ReceiptProduct> receiptProducts) {
  if (receiptProducts.isEmpty) return 0.0;
  return (receiptProducts.map((e) => e.unitPriceNet * e.quantity).toList().reduce((value, element) => value + element)).toMyRoundedDouble();
}

double _calcProductsTotalGross(List<ReceiptProduct> receiptProducts) {
  if (receiptProducts.isEmpty) return 0.0;
  return (receiptProducts.map((e) => e.unitPriceGross * e.quantity).toList().reduce((value, element) => value + element)).toMyRoundedDouble();
}

double _calcPosDiscountPercentAmount(List<ReceiptProduct> receiptProducts) {
  double posPercentAmount = 0;
  for (final product in receiptProducts) {
    posPercentAmount += (calcPercentageAmount(product.unitPriceGross * product.quantity, product.discountPercent)).toMyRoundedDouble();
  }
  return posPercentAmount;
}

double _calcDiscountPercentageAmount(List<ReceiptProduct> receiptProducts, double discountPercentage) {
  return (calcPercentageAmount(_calcProductsTotalGross(receiptProducts), discountPercentage)).toMyRoundedDouble();
}

double _calcTaxAmount(Receipt receipt) {
  final productsTotalNet = _calcProductsTotalNet(receipt.listOfReceiptProduct);
  final procutsTotalGross = _calcProductsTotalGross(receipt.listOfReceiptProduct);
  final posDiscountPercentAmount = _calcPosDiscountPercentAmount(receipt.listOfReceiptProduct);
  final discountPercentageAmountGross = _calcDiscountPercentageAmount(receipt.listOfReceiptProduct, receipt.discountPercent);
  final discountAmountGross = _calcDiscountPercentageAmount(receipt.listOfReceiptProduct, receipt.discountPercent);

  return (procutsTotalGross - productsTotalNet) -
      calcTaxAmountFromGross(posDiscountPercentAmount, receipt.tax.taxRate).toMyRoundedDouble() -
      calcTaxAmountFromGross(discountPercentageAmountGross, receipt.tax.taxRate).toMyRoundedDouble() -
      calcTaxAmountFromGross(discountAmountGross, receipt.tax.taxRate).toMyRoundedDouble() +
      calcTaxAmountFromGross(0, receipt.tax.taxRate).toMyRoundedDouble() +
      calcTaxAmountFromGross(receipt.additionalAmountGross, receipt.tax.taxRate).toMyRoundedDouble();
}

double _calcTotalGross(Receipt receipt) {
  return _calcProductsTotalGross(receipt.listOfReceiptProduct) -
      _calcPosDiscountPercentAmount(receipt.listOfReceiptProduct) -
      _calcDiscountPercentageAmount(receipt.listOfReceiptProduct, receipt.discountPercent) -
      receipt.discountGross +
      receipt.totalShippingGross +
      receipt.additionalAmountGross;
}
