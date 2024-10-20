import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:cezeri_commerce/3_domain/repositories/database/incoming_invoice_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../1_presentation/incoming_invoice/incoming_invoice_detail/incoming_invoice_detail_screen.dart';
import '../../../3_domain/entities/incoming_invoice/incoming_invoice.dart';
import '../../../3_domain/entities/incoming_invoice/incoming_invoice_file.dart';
import '../../../3_domain/entities/incoming_invoice/incoming_invoice_item.dart';
import '../../../3_domain/entities/incoming_invoice/incoming_invoice_supplier.dart';
import '../../../3_domain/entities/reorder/reorder.dart';
import '../../../3_domain/entities/reorder/supplier.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../3_domain/repositories/database/supplier_repository.dart';
import '../../../failures/abstract_failure.dart';

part 'incoming_invoice_detail_event.dart';
part 'incoming_invoice_detail_state.dart';

class IncomingInvoiceDetailBloc extends Bloc<IncomingInvoiceDetailEvent, IncomingInvoiceDetailState> {
  final IncomingInvoiceRepository _incomingInvoiceRepository;
  final SupplierRepository _supplierRepository;

  IncomingInvoiceDetailBloc({required IncomingInvoiceRepository incomingInvoiceRepository, required SupplierRepository supplierRepository})
      : _incomingInvoiceRepository = incomingInvoiceRepository,
        _supplierRepository = supplierRepository,
        super(IncomingInvoiceDetailState.initial()) {
    on<SetIncomingInvoiceDetailToInitial>(_onSetIncomingInvoiceDetailToInitial);
    on<SetInitialControllerEvent>(_onSetInitialControllerEvent);
    on<SetIncomingInvoiceEvent>(_onSetIncomingInvoice);
    on<SetIncomingInvoiceOnCreateEvent>(_onSetIncomingInvoiceOnCreate);
    on<SetIncomingInvoiceOnCopyEvent>(_onSetIncomingInvoiceOnCopy);
    on<SetIncomingInvoiceOnEditEvent>(_onSetIncomingInvoiceOnEdit);
    on<GetIncomingInvoiceEvent>(_onGetIncomingInvoice);
    on<CreateIncomingInvoiceEvent>(_onCreateIncomingInvoice);
    on<UpdateIncomingInvoiceEvent>(_onUpdateIncomingInvoice); // TODO: implement
    on<OnInvoiceNumberControllerChangedEvent>(_onInvoiceNumberControllerChanged);
    on<OnDiscountPercentageControllerChangedEvent>(_oDiscountPercentageControllerChanged);
    on<OnDiscountAmountControllerChangedEvent>(_onDiscountAmountControllerChanged);
    on<OnEarlyPaymentControllerChangedEvent>(_onEarlyPaymentControllerChanged);
    on<OnDiscountPercentageChangedEvent>(_onDiscountPercentageChanged);
    on<OnDiscountAmountChangedEvent>(_onDiscountAmountChanged);
    on<OnCurrencyChangedEvent>(_onCurrencyChanged);
    on<OnPaymentMethodChangedEvent>(_onPaymentMethodChanged);
    on<OnEarlyPaymentDiscountDateChangedEvent>(_onEarlyPaymentDiscountDateChanged);
    on<OnInvoiceDateChangedEvent>(_onInvoiceDateChanged);
    on<OnBookingDateChangedEvent>(_onBookingDateChanged);
    on<OnDueDateChangedEvent>(_onDueDateChanged);
    on<OnDeliveryDateChangedEvent>(_onDeliveryDateChanged);
    //* ########################################### FILES ###########################################
    on<OnAddFilesToListEvent>(_onAddFilesToList);
    on<OnAddNewItemsFromReorderEvent>(_onAddNewItemsFromReorder);
    on<OnRemoveFileFromListEvent>(_onRemoveFileFromList);
    on<OnUpdateFileNameEvent>(_onUpdateFileName);
    //* ########################################### ITEMS ###########################################
    on<OnAddNewItemToListEvent>(_onAddNewItemToList);
    on<OnRemoveItemFromListEvent>(_onRemoveItemFromList);
    on<OnRemoveAllItemsFromListEvent>(_onRemoveAllItemsFromList);
    on<OnItemGLAccountChangedEvent>(_onItemGLAccountChanged);
    on<OnItemItemTitleChangedEvent>(_onItemItemTitleChanged);
    on<OnItemQuantityChangedEvent>(_onItemQuantityChanged);
    on<OnItemTaxChangedEvent>(_onItemTaxChanged);
    on<OnItemUnitNetPriceChangedEvent>(_onItemUnitNetPriceChanged);
    on<OnItemDiscountChangedEvent>(_onItemDiscountChanged);
    on<OnItemDiscountTypeChangedEvent>(_onItemDiscountTypeChanged);
    on<OnItemsMassEditingEvent>(_onItemsMassEditing);
  }

  void _onSetIncomingInvoiceDetailToInitial(SetIncomingInvoiceDetailToInitial event, Emitter<IncomingInvoiceDetailState> emit) {
    emit(IncomingInvoiceDetailState.initial());
  }

  void _onSetInitialControllerEvent(SetInitialControllerEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    emit(state.copyWith(
      invoiceNumberController: TextEditingController(text: state.invoice?.invoiceNumber),
      discountPercentageController: TextEditingController(text: state.invoice?.discountPercentage.toString()),
      discountAmountController: TextEditingController(text: state.invoice?.discountAmount.toString()),
      earlyPaymentDiscountController: TextEditingController(text: state.invoice?.earlyPaymentDiscount.toString()),
    ));
  }

  void _onSetIncomingInvoice(SetIncomingInvoiceEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    return switch (event.type) {
      IncomingInvoiceAddEditType.create => add(SetIncomingInvoiceOnCreateEvent(supplier: event.supplier!)),
      IncomingInvoiceAddEditType.copy => add(SetIncomingInvoiceOnCopyEvent(incomingInvoiceId: event.incomingInvoiceId!)),
      IncomingInvoiceAddEditType.edit => add(SetIncomingInvoiceOnEditEvent(supplier: event.supplier, incomingInvoiceId: event.incomingInvoiceId!)),
    };
  }

  void _onSetIncomingInvoiceOnCreate(SetIncomingInvoiceOnCreateEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    final supplier = IncomingInvoiceSupplier.fromSupplier(event.supplier);
    final emptyIncomingInvoice = IncomingInvoice.empty().copyWith(supplier: supplier);
    emit(state.copyWith(invoice: emptyIncomingInvoice, type: IncomingInvoiceAddEditType.create, supplier: event.supplier));
    add(SetInitialControllerEvent());
  }

  Future<void> _onSetIncomingInvoiceOnCopy(SetIncomingInvoiceOnCopyEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    emit(state.copyWith(isLoadingInvoiceOnObserve: true, type: IncomingInvoiceAddEditType.copy));

    final fos = await _incomingInvoiceRepository.getIncomingInvoice(event.incomingInvoiceId);
    if (fos.isLeft()) {
      emit(state.copyWith(abstractFailure: fos.getLeft(), isLoadingInvoiceOnObserve: false, fosInvoiceOnObserveOption: optionOf(fos)));
      emit(state.copyWith(fosInvoiceOnObserveOption: none()));
      return;
    }

    final loadedInvoice = fos.getRight();

    final fosSupplier = await _supplierRepository.getSupplier(loadedInvoice.supplier.supplierId);
    if (fosSupplier.isLeft()) {
      emit(state.copyWith(abstractFailure: fos.getLeft(), isLoadingInvoiceOnObserve: false, fosInvoiceOnObserveOption: optionOf(fos)));
      emit(state.copyWith(fosInvoiceOnObserveOption: none()));
      return;
    }

    final supplier = fosSupplier.getRight();

    final invoiceCopied = IncomingInvoice.empty().copyWith(
      supplier: IncomingInvoiceSupplier.fromSupplier(supplier),
      listOfIncomingInvoiceItems: loadedInvoice.listOfIncomingInvoiceItems,
      currency: loadedInvoice.currency,
      paymentMethod: loadedInvoice.paymentMethod,
    );

    emit(state.copyWith(
      invoice: invoiceCopied,
      originalInvoice: invoiceCopied.copyWith(),
      supplier: supplier,
      resetAbstractFailure: true,
      isLoadingInvoiceOnObserve: false,
      fosInvoiceOnObserveOption: optionOf(fos),
    ));
    emit(state.copyWith(fosInvoiceOnObserveOption: none()));

    add(SetInitialControllerEvent());
  }

  Future<void> _onSetIncomingInvoiceOnEdit(SetIncomingInvoiceOnEditEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    emit(state.copyWith(isLoadingInvoiceOnObserve: true, type: IncomingInvoiceAddEditType.edit));

    final fos = await _incomingInvoiceRepository.getIncomingInvoice(event.incomingInvoiceId);
    if (fos.isLeft()) {
      emit(state.copyWith(abstractFailure: fos.getLeft(), isLoadingInvoiceOnObserve: false, fosInvoiceOnObserveOption: optionOf(fos)));
      emit(state.copyWith(fosInvoiceOnObserveOption: none()));
      return;
    }

    final loadedInvoice = fos.getRight();
    Supplier? supplier = event.supplier;

    if (supplier == null) {
      final fosSupplier = await _supplierRepository.getSupplier(loadedInvoice.supplier.supplierId);
      if (fosSupplier.isLeft()) {
        emit(state.copyWith(abstractFailure: fos.getLeft(), isLoadingInvoiceOnObserve: false, fosInvoiceOnObserveOption: optionOf(fos)));
        emit(state.copyWith(fosInvoiceOnObserveOption: none()));
        return;
      }

      supplier = fosSupplier.getRight();
    }

    final invoiceWithSupplier = loadedInvoice.copyWith(supplier: IncomingInvoiceSupplier.fromSupplier(supplier));

    emit(state.copyWith(
      invoice: invoiceWithSupplier,
      originalInvoice: invoiceWithSupplier.copyWith(),
      supplier: supplier,
      resetAbstractFailure: true,
      isLoadingInvoiceOnObserve: false,
      fosInvoiceOnObserveOption: optionOf(fos),
    ));
    emit(state.copyWith(fosInvoiceOnObserveOption: none()));

    add(SetInitialControllerEvent());
  }

  Future<void> _onGetIncomingInvoice(GetIncomingInvoiceEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    emit(state.copyWith(isLoadingInvoiceOnObserve: true));

    final fos = await _incomingInvoiceRepository.getIncomingInvoice(event.id);
    fos.fold(
      (failure) => emit(state.copyWith(abstractFailure: failure)),
      (loadedInvoice) {
        emit(state.copyWith(invoice: loadedInvoice, resetAbstractFailure: true));
      },
    );

    emit(state.copyWith(isLoadingInvoiceOnObserve: false, fosInvoiceOnObserveOption: optionOf(fos)));
    emit(state.copyWith(fosInvoiceOnObserveOption: none()));
  }

  Future<void> _onCreateIncomingInvoice(CreateIncomingInvoiceEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    emit(state.copyWith(isLoadingInvoiceOnCreate: true));

    final fos = await _incomingInvoiceRepository.createIncomingInvoice(state.invoice!);
    fos.fold(
      (failure) => null,
      (loadedInvoice) {
        emit(state.copyWith(invoice: loadedInvoice, resetAbstractFailure: true));
      },
    );

    emit(state.copyWith(isLoadingInvoiceOnCreate: false, fosInvoiceOnCreateOption: optionOf(fos)));
    emit(state.copyWith(fosInvoiceOnCreateOption: none()));
  }

  Future<void> _onUpdateIncomingInvoice(UpdateIncomingInvoiceEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    emit(state.copyWith(isLoadingInvoiceOnUpdate: true));

    // final fos = await _incomingInvoiceRepository.getIncomingInvoice(event.id);
    // fos.fold(
    //   (failure) => emit(state.copyWith(abstractFailure: failure)),
    //   (loadedInvoice) {
    //     emit(state.copyWith(invoice: loadedInvoice, resetAbstractFailure: true));
    //   },
    // );

    // emit(state.copyWith(isLoadingInvoiceOnUpdate: false, fosInvoiceOnUpdateOption: optionOf(fos)));
    // emit(state.copyWith(fosInvoiceOnUpdateOption: none()));
  }

  void _onInvoiceNumberControllerChanged(OnInvoiceNumberControllerChangedEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    emit(state.copyWith(invoice: state.invoice!.copyWith(invoiceNumber: state.invoiceNumberController.text)));
  }

  void _oDiscountPercentageControllerChanged(OnDiscountPercentageControllerChangedEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    emit(state.copyWith(invoice: state.invoice!.copyWith(discountPercentage: state.discountPercentageController.text.toMyDouble())));
  }

  void _onDiscountAmountControllerChanged(OnDiscountAmountControllerChangedEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    emit(state.copyWith(invoice: state.invoice!.copyWith(discountAmount: state.discountAmountController.text.toMyDouble())));
  }

  void _onEarlyPaymentControllerChanged(OnEarlyPaymentControllerChangedEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    emit(state.copyWith(invoice: state.invoice!.copyWith(earlyPaymentDiscount: state.earlyPaymentDiscountController.text.toMyDouble())));
  }

  void _onDiscountPercentageChanged(OnDiscountPercentageChangedEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    emit(state.copyWith(invoice: state.invoice!.copyWith(discountPercentage: event.value.toMyDouble())));
  }

  void _onDiscountAmountChanged(OnDiscountAmountChangedEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    emit(state.copyWith(invoice: state.invoice!.copyWith(discountAmount: event.value.toMyDouble())));
  }

  void _onCurrencyChanged(OnCurrencyChangedEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    emit(state.copyWith(invoice: state.invoice!.copyWith(currency: event.currency)));
  }

  void _onPaymentMethodChanged(OnPaymentMethodChangedEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    emit(state.copyWith(invoice: state.invoice!.copyWith(paymentMethod: event.paymentMethod)));
  }

  void _onEarlyPaymentDiscountDateChanged(OnEarlyPaymentDiscountDateChangedEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    emit(state.copyWith(invoice: state.invoice!.copyWith(discountDeadline: event.date, resetDiscountDeadline: event.date == null)));
  }

  void _onInvoiceDateChanged(OnInvoiceDateChangedEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    emit(state.copyWith(invoice: state.invoice!.copyWith(invoiceDate: event.date)));
  }

  void _onBookingDateChanged(OnBookingDateChangedEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    emit(state.copyWith(invoice: state.invoice!.copyWith(bookingDate: event.date, resetBookingDate: event.date == null)));
  }

  void _onDueDateChanged(OnDueDateChangedEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    emit(state.copyWith(invoice: state.invoice!.copyWith(dueDate: event.date, resetDueDate: event.date == null)));
  }

  void _onDeliveryDateChanged(OnDeliveryDateChangedEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    emit(state.copyWith(invoice: state.invoice!.copyWith(deliveryDate: event.date, resetDeliveryDate: event.date == null)));
  }

  //* ############################################################################################################################
  //* Incoming Invoice FILES

  void _onAddFilesToList(OnAddFilesToListEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    List<IncomingInvoiceFile> listOfFiles =
        state.invoice!.listOfIncomingInvoiceFiles != null ? List.from(state.invoice!.listOfIncomingInvoiceFiles!) : [];

    for (final file in event.listOfFiles) {
      final newFile = file.copyWith(sortId: listOfFiles.length + 1);
      listOfFiles.add(newFile);
    }

    emit(state.copyWith(invoice: state.invoice!.copyWith(listOfIncomingInvoiceFiles: listOfFiles)));
  }

  void _onRemoveFileFromList(OnRemoveFileFromListEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    final stateFiles = state.invoice!.listOfIncomingInvoiceFiles;
    if (stateFiles == null || stateFiles.isEmpty || stateFiles.length < event.index - 1) return;

    List<IncomingInvoiceFile> listOfFiles = List.from(stateFiles);

    listOfFiles.removeAt(event.index);

    emit(state.copyWith(invoice: state.invoice!.copyWith(listOfIncomingInvoiceFiles: listOfFiles)));
  }

  void _onUpdateFileName(OnUpdateFileNameEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    final stateFiles = state.invoice!.listOfIncomingInvoiceFiles;
    if (stateFiles == null || stateFiles.isEmpty || stateFiles.length < event.index - 1) return;

    List<IncomingInvoiceFile> listOfFiles = List.from(stateFiles);

    listOfFiles[event.index] = listOfFiles[event.index].copyWith(name: event.name);

    emit(state.copyWith(invoice: state.invoice!.copyWith(listOfIncomingInvoiceFiles: listOfFiles)));
  }

  //* ############################################################################################################################
  //* Incoming Invoice ITEMS

  void _onAddNewItemToList(OnAddNewItemToListEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    List<IncomingInvoiceItem> listOfItems = List.from(state.invoice!.listOfIncomingInvoiceItems);

    final newItem = IncomingInvoiceItem.empty().copyWith(
      sortId: listOfItems.length + 1,
      itemType: event.itemType,
      taxRate: state.supplier!.tax.taxRate,
    );
    listOfItems.add(newItem);

    state.scrollController.animateTo(
      state.scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );

    emit(state.copyWith(invoice: state.invoice!.copyWith(listOfIncomingInvoiceItems: listOfItems)));
  }

  void _onAddNewItemsFromReorder(OnAddNewItemsFromReorderEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    List<IncomingInvoiceItem> listOfItems = List.from(state.invoice!.listOfIncomingInvoiceItems);

    if (listOfItems.length == 1 && listOfItems[0] == IncomingInvoiceItem.empty()) listOfItems = [];

    for (final reorderProduct in event.reorder.listOfReorderProducts) {
      final newItem = IncomingInvoiceItem(
        id: '',
        sortId: listOfItems.length + 1,
        accountNumber: '',
        accountName: '',
        title: reorderProduct.name,
        quantity: reorderProduct.quantity,
        unitPriceNet: reorderProduct.wholesalePriceNet,
        taxRate: reorderProduct.tax.taxRate,
        discountType: DiscountType.amount,
        discount: 0.0,
        itemType: ItemType.position,
      );

      listOfItems.add(newItem);
    }

    emit(state.copyWith(invoice: state.invoice!.copyWith(listOfIncomingInvoiceItems: listOfItems)));
  }

  void _onRemoveItemFromList(OnRemoveItemFromListEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    List<IncomingInvoiceItem> listOfItems = List.from(state.invoice!.listOfIncomingInvoiceItems);

    listOfItems.removeAt(event.index);

    emit(state.copyWith(invoice: state.invoice!.copyWith(listOfIncomingInvoiceItems: listOfItems)));
  }

  void _onRemoveAllItemsFromList(OnRemoveAllItemsFromListEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    emit(state.copyWith(invoice: state.invoice!.copyWith(listOfIncomingInvoiceItems: [])));
  }

  void _onItemGLAccountChanged(OnItemGLAccountChangedEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    List<IncomingInvoiceItem> listOfItems = List.from(state.invoice!.listOfIncomingInvoiceItems);

    final parts = event.gLAccount.split(' ');
    final number = parts[0];
    final name = event.gLAccount.substring(event.gLAccount.indexOf(' ') + 1);

    listOfItems[event.index] = listOfItems[event.index].copyWith(accountNumber: number, accountName: name);

    emit(state.copyWith(invoice: state.invoice!.copyWith(listOfIncomingInvoiceItems: listOfItems)));
  }

  void _onItemItemTitleChanged(OnItemItemTitleChangedEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    List<IncomingInvoiceItem> listOfItems = List.from(state.invoice!.listOfIncomingInvoiceItems);

    listOfItems[event.index] = listOfItems[event.index].copyWith(title: event.value);

    emit(state.copyWith(invoice: state.invoice!.copyWith(listOfIncomingInvoiceItems: listOfItems)));
  }

  void _onItemQuantityChanged(OnItemQuantityChangedEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    List<IncomingInvoiceItem> listOfItems = List.from(state.invoice!.listOfIncomingInvoiceItems);

    listOfItems[event.index] = listOfItems[event.index].copyWith(quantity: event.value.toMyInt());

    emit(state.copyWith(invoice: state.invoice!.copyWith(listOfIncomingInvoiceItems: listOfItems)));
  }

  void _onItemTaxChanged(OnItemTaxChangedEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    List<IncomingInvoiceItem> listOfItems = List.from(state.invoice!.listOfIncomingInvoiceItems);

    listOfItems[event.index] = listOfItems[event.index].copyWith(taxRate: event.value.toMyInt());

    emit(state.copyWith(invoice: state.invoice!.copyWith(listOfIncomingInvoiceItems: listOfItems)));
  }

  void _onItemUnitNetPriceChanged(OnItemUnitNetPriceChangedEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    List<IncomingInvoiceItem> listOfItems = List.from(state.invoice!.listOfIncomingInvoiceItems);

    listOfItems[event.index] = listOfItems[event.index].copyWith(unitPriceNet: event.value.toMyDouble());

    emit(state.copyWith(invoice: state.invoice!.copyWith(listOfIncomingInvoiceItems: listOfItems)));
  }

  void _onItemDiscountChanged(OnItemDiscountChangedEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    List<IncomingInvoiceItem> listOfItems = List.from(state.invoice!.listOfIncomingInvoiceItems);

    listOfItems[event.index] = listOfItems[event.index].copyWith(discount: event.value.toMyDouble());

    emit(state.copyWith(invoice: state.invoice!.copyWith(listOfIncomingInvoiceItems: listOfItems)));
  }

  void _onItemDiscountTypeChanged(OnItemDiscountTypeChangedEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    List<IncomingInvoiceItem> listOfItems = List.from(state.invoice!.listOfIncomingInvoiceItems);

    listOfItems[event.index] = listOfItems[event.index].copyWith(discountType: event.discountType);

    emit(state.copyWith(invoice: state.invoice!.copyWith(listOfIncomingInvoiceItems: listOfItems)));
  }

  void _onItemsMassEditing(OnItemsMassEditingEvent event, Emitter<IncomingInvoiceDetailState> emit) async {
    List<IncomingInvoiceItem> listOfItems = List.from(state.invoice!.listOfIncomingInvoiceItems);
    if (listOfItems.isEmpty) return;

    for (int i = 0; i < listOfItems.length; i++) {
      if (event.gLAccount != null) {
        final parts = event.gLAccount!.split(' ');
        final number = parts[0];
        final name = event.gLAccount!.substring(event.gLAccount!.indexOf(' ') + 1);

        listOfItems[i] = listOfItems[i].copyWith(accountNumber: number, accountName: name);
      }

      if (event.taxRate != null) {
        listOfItems[i] = listOfItems[i].copyWith(taxRate: event.taxRate!);
      }
    }

    emit(state.copyWith(invoice: state.invoice!.copyWith(listOfIncomingInvoiceItems: listOfItems)));
  }
}
