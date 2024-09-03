import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '/1_presentation/core/core.dart';
import '/3_domain/entities/address.dart';
import '/3_domain/entities/carrier/carrier_product.dart';
import '/3_domain/entities/carrier/parcel_tracking.dart';
import '/3_domain/entities/customer/customer.dart';
import '/3_domain/entities/marketplace/abstract_marketplace.dart';
import '/3_domain/entities/product/product.dart';
import '/3_domain/entities/receipt/receipt.dart';
import '/3_domain/entities/receipt/receipt_carrier.dart';
import '/3_domain/entities/receipt/receipt_customer.dart';
import '/3_domain/entities/receipt/receipt_marketplace.dart';
import '/3_domain/entities/receipt/receipt_product.dart';
import '/3_domain/entities/settings/main_settings.dart';
import '/3_domain/entities/settings/payment_method.dart';
import '/3_domain/repositories/firebase/main_settings_respository.dart';
import '/3_domain/repositories/firebase/marketplace_repository.dart';
import '/3_domain/repositories/firebase/product_repository.dart';
import '/failures/failures.dart';
import '../../../3_domain/repositories/firebase/receipt_repository.dart';

part 'receipt_detail_event.dart';
part 'receipt_detail_state.dart';

class ReceiptDetailBloc extends Bloc<ReceiptDetailEvent, ReceiptDetailState> {
  final ReceiptRepository receiptRepository;
  final MarketplaceRepository marketplaceRepository;
  final MainSettingsRepository mainSettingsRepository;
  final ProductRepository productRepository;

  ReceiptDetailBloc({
    required this.receiptRepository,
    required this.marketplaceRepository,
    required this.mainSettingsRepository,
    required this.productRepository,
  }) : super(ReceiptDetailState.initial()) {
    on<SetReceiptDetailStatesToInitialEvent>(_onSetReceiptDetailStatesToInitial);
    on<ReceiptDetailSetEmptyReceiptEvent>(_onReceiptDetailSetEmptyReceipt);
    on<ReceiptDetailGetReceiptEvent>(_onReceiptDetailGetReceipt);
    on<ReceiptDetailGetProductByEanEvent>(_onReceiptDetailGetProductByEan);
    on<ReceiptDetailCreateParcelLabelReceiptEvent>(_onReceiptDetailCreateParcelLabelReceipt);
    on<ReceiptDetailUpdateReceiptEvent>(_onReceiptDetailUpdateReceipt);
    on<ReceiptDetailCreateReceiptManuallyEvent>(_onReceiptDetailCreateReceiptManually);
    on<ReceiptDetailEditAddressEvent>(_onReceiptDetailEditAddress);
    on<ReceiptDetailUpdateCustomerEvent>(_onReceiptDetailUpdateCustomer);
    on<ReceiptDetailCustomerEmailChangedEvent>(_onReceiptDetailCustomerEmailChanged);
    on<ReceiptDetailMarketplaceChangedEvent>(_onReceiptDetailMarketplaceChanged);
    on<ReceiptDetailDeliveryBlockedChangedEvent>(_onReceiptDetailDeliveryBlockedChanged);
    on<ReceiptDetailPaymentMethodChangedEvent>(_onReceiptDetailPaymentMethodChanged);
    on<ReceiptDetailPaymentStatusChangedEvent>(_onReceiptDetailPaymentStatusChanged);
    on<ReceiptDetailCarrierChangedEvent>(_onReceiptDetailCarrierChanged);
    on<ReceiptDetailCarrierProductChangedEvent>(_onReceiptDetailCarrierProductChanged);
    on<ReceiptDetailCommentChangedEvent>(_onReceiptDetailInternalCommentChanged);
    on<ReceiptDetailGetSameReceiptsEvent>(_onReceiptDetailGetSameReceipts);
  }

//? ###########################################################################################################################

  void _onSetReceiptDetailStatesToInitial(SetReceiptDetailStatesToInitialEvent event, Emitter<ReceiptDetailState> emit) {
    emit(ReceiptDetailState.initial());
  }

//? ###########################################################################################################################

  Future<void> _onReceiptDetailSetEmptyReceipt(ReceiptDetailSetEmptyReceiptEvent event, Emitter<ReceiptDetailState> emit) async {
    emit(state.copyWith(isLoadingReceiptOnObserve: true));

    emit(state.copyWith(receipt: event.newEmptyReceipt));

    final fosMarketplaces = await marketplaceRepository.getListOfMarketplaces();
    if (fosMarketplaces.isLeft()) emit(state.copyWith(databaseFailure: fosMarketplaces.getLeft(), isLoadingReceiptOnObserve: false));

    final fosSettings = await mainSettingsRepository.getSettings();
    if (fosSettings.isLeft()) emit(state.copyWith(databaseFailure: fosSettings.getLeft(), isLoadingReceiptOnObserve: false));

    emit(state.copyWith(
      receipt: event.newEmptyReceipt,
      listOfMarketplaces: fosMarketplaces.getRight(),
      mainSettings: fosSettings.getRight(),
      isLoadingReceiptOnObserve: false,
      triggerListenerAfterSetEmptyReceipt: optionOf(true),
    ));
  }

//? ###########################################################################################################################

  Future<void> _onReceiptDetailGetReceipt(ReceiptDetailGetReceiptEvent event, Emitter<ReceiptDetailState> emit) async {
    emit(state.copyWith(isLoadingReceiptOnObserve: true));

    final fosReceipt = await receiptRepository.getReceipt(event.receiptId, event.receiptType);
    if (fosReceipt.isLeft()) emit(state.copyWith(databaseFailure: fosReceipt.getLeft(), isLoadingReceiptOnObserve: false));
    final newReceipt = fosReceipt.getRight();

    final fosMarketplaces = await marketplaceRepository.getListOfMarketplaces();
    if (fosMarketplaces.isLeft()) emit(state.copyWith(databaseFailure: fosMarketplaces.getLeft(), isLoadingReceiptOnObserve: false));

    final fosSettings = await mainSettingsRepository.getSettings();
    if (fosSettings.isLeft()) emit(state.copyWith(databaseFailure: fosSettings.getLeft(), isLoadingReceiptOnObserve: false));

    emit(state.copyWith(
      receipt: newReceipt,
      internalCommentController: TextEditingController(text: newReceipt.commentInternal),
      globalCommentController: TextEditingController(text: newReceipt.commentGlobal),
      listOfMarketplaces: fosMarketplaces.getRight(),
      mainSettings: fosSettings.getRight(),
      isLoadingReceiptOnObserve: false,
      fosReceiptOnObserveOption: optionOf(fosReceipt),
    ));
    emit(state.copyWith(fosReceiptOnObserveOption: none()));
    add(ReceiptDetailGetSameReceiptsEvent());
  }

//? ###########################################################################################################################

  Future<void> _onReceiptDetailGetProductByEan(ReceiptDetailGetProductByEanEvent event, Emitter<ReceiptDetailState> emit) async {
    emit(state.copyWith(isLoadingProductOnObserve: true));

    final fos = await productRepository.getProductByEan(event.ean);

    emit(state.copyWith(
      isLoadingProductOnObserve: false,
      productByEan: fos.isRight() ? fos.getRight() : null,
      fosProductOnObserveOption: optionOf(fos),
    ));
    emit(state.copyWith(fosProductOnObserveOption: none()));
  }

//? ###########################################################################################################################

  Future<void> _onReceiptDetailCreateParcelLabelReceipt(ReceiptDetailCreateParcelLabelReceiptEvent event, Emitter<ReceiptDetailState> emit) async {
    emit(state.copyWith(isLoadingParcelLabelOnCreate: true));

    final fos = await receiptRepository.createNewParcelForReceipt(state.receipt!, event.weight);

    emit(state.copyWith(
      isLoadingParcelLabelOnCreate: false,
      fosParcelLabelOnCreate: optionOf(fos),
    ));
    emit(state.copyWith(fosParcelLabelOnCreate: none()));
  }

//? ###########################################################################################################################

  Future<void> _onReceiptDetailUpdateReceipt(ReceiptDetailUpdateReceiptEvent event, Emitter<ReceiptDetailState> emit) async {
    emit(state.copyWith(isLoadingReceiptOnUpdate: true));

    final newReceipt = event.receipt.copyWith(listOfReceiptProduct: event.newListOfReceiptProducts);

    final fos = await receiptRepository.updateReceipt(newReceipt, event.oldListOfReceiptProducts, event.newListOfReceiptProducts);

    emit(state.copyWith(
      isLoadingReceiptOnUpdate: false,
      fosReceiptOnUpdateOption: optionOf(fos),
    ));
    emit(state.copyWith(fosReceiptOnUpdateOption: none()));
  }

//? ###########################################################################################################################

  Future<void> _onReceiptDetailCreateReceiptManually(ReceiptDetailCreateReceiptManuallyEvent event, Emitter<ReceiptDetailState> emit) async {
    emit(state.copyWith(isLoadingReceiptOnCreate: true));

    final failureOrSuccess = await receiptRepository.createReceiptManually(event.receipt);

    emit(state.copyWith(
      isLoadingReceiptOnCreate: false,
      fosReceiptOnCreateOption: optionOf(failureOrSuccess),
    ));
    emit(state.copyWith(fosReceiptOnCreateOption: none()));
  }

//? ###########################################################################################################################

  void _onReceiptDetailEditAddress(ReceiptDetailEditAddressEvent event, Emitter<ReceiptDetailState> emit) {
    if (event.address.addressType == AddressType.delivery) {
      emit(state.copyWith(receipt: state.receipt!.copyWith(addressDelivery: event.address)));
    }

    if (event.address.addressType == AddressType.invoice) {
      emit(state.copyWith(receipt: state.receipt!.copyWith(addressInvoice: event.address)));
    }
  }

//? ###########################################################################################################################

  void _onReceiptDetailUpdateCustomer(ReceiptDetailUpdateCustomerEvent event, Emitter<ReceiptDetailState> emit) {
    emit(state.copyWith(receipt: state.receipt!.copyWith(receiptCustomer: ReceiptCustomer.fromCustomer(event.customer))));
  }

//? ###########################################################################################################################

  void _onReceiptDetailCustomerEmailChanged(ReceiptDetailCustomerEmailChangedEvent event, Emitter<ReceiptDetailState> emit) {
    emit(state.copyWith(receipt: state.receipt!.copyWith(receiptCustomer: state.receipt!.receiptCustomer.copyWith(email: event.email))));
  }

//? ###########################################################################################################################

  void _onReceiptDetailMarketplaceChanged(ReceiptDetailMarketplaceChangedEvent event, Emitter<ReceiptDetailState> emit) {
    emit(state.copyWith(
      receipt: state.receipt!.copyWith(
        marketplaceId: event.marketplace.id,
        receiptMarketplace: ReceiptMarketplace.fromMarketplace(event.marketplace),
      ),
    ));
  }

//? ###########################################################################################################################

  void _onReceiptDetailDeliveryBlockedChanged(ReceiptDetailDeliveryBlockedChangedEvent event, Emitter<ReceiptDetailState> emit) {
    emit(state.copyWith(receipt: state.receipt!.copyWith(isDeliveryBlocked: event.value)));
  }

//? ###########################################################################################################################

  void _onReceiptDetailPaymentMethodChanged(ReceiptDetailPaymentMethodChangedEvent event, Emitter<ReceiptDetailState> emit) {
    emit(state.copyWith(receipt: state.receipt!.copyWith(paymentMethod: event.paymentMethod)));
  }

//? ###########################################################################################################################

  void _onReceiptDetailPaymentStatusChanged(ReceiptDetailPaymentStatusChangedEvent event, Emitter<ReceiptDetailState> emit) {
    emit(state.copyWith(
      receipt: state.receipt!.copyWith(
        paymentStatus: switch (event.paymentStatus) {
          'Offen' => PaymentStatus.open,
          'Teilweise bezahlt' => PaymentStatus.partiallyPaid,
          'Komplett bezahlt' => PaymentStatus.paid,
          _ => PaymentStatus.open,
        },
      ),
    ));
  }

//? ###########################################################################################################################

  void _onReceiptDetailCarrierChanged(ReceiptDetailCarrierChangedEvent event, Emitter<ReceiptDetailState> emit) {
    emit(state.copyWith(receipt: state.receipt!.copyWith(receiptCarrier: event.receiptCarrier)));
  }

//? ###########################################################################################################################

  void _onReceiptDetailCarrierProductChanged(ReceiptDetailCarrierProductChangedEvent event, Emitter<ReceiptDetailState> emit) {
    emit(state.copyWith(
      receipt: state.receipt!.copyWith(
        receiptCarrier: state.receipt!.receiptCarrier.copyWith(
          carrierProduct: state.receipt!.receiptCarrier.carrierProduct.copyWith(
            productName: event.receiptCarrierProduct.productName,
            id: event.receiptCarrierProduct.id,
          ),
        ),
      ),
    ));
  }

//? ###########################################################################################################################

  void _onReceiptDetailInternalCommentChanged(ReceiptDetailCommentChangedEvent event, Emitter<ReceiptDetailState> emit) {
    emit(state.copyWith(
      receipt: state.receipt!.copyWith(commentInternal: state.internalCommentController.text, commentGlobal: state.globalCommentController.text),
    ));
  }

//? ###########################################################################################################################

  Future<void> _onReceiptDetailGetSameReceipts(ReceiptDetailGetSameReceiptsEvent event, Emitter<ReceiptDetailState> emit) async {
    emit(state.copyWith(isLoadingSameReceiptsOnObserve: true));

    final fosReceipts = await receiptRepository.getListOfReceiptsByReceiptId(state.receipt!.receiptId);
    if (fosReceipts.isLeft()) emit(state.copyWith(sameReceiptsFailure: fosReceipts.getLeft(), isLoadingSameReceiptsOnObserve: false));

    emit(state.copyWith(
      listOfSameReceipts: fosReceipts.getRight(),
      isLoadingSameReceiptsOnObserve: false,
    ));
  }

//? ###########################################################################################################################
//? ###########################################################################################################################
//? ###########################################################################################################################
//? ###########################################################################################################################
//? ###########################################################################################################################
//? ###########################################################################################################################
}
