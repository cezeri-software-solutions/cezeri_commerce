part of 'receipt_detail_bloc.dart';

@immutable
class ReceiptDetailState {
  final Receipt receipt;
  final List<ReceiptProduct> listOfReceiptProducts;
  final List<Tax> taxRulesListFromSettings;
  //* Helper ProductsTotal
  final double productsTotalNet;
  final double procutsTotalGross;
  final double discountPercentage;
  final double discountPercentageAmountGross;
  final double discountAmountGross;
  final double shippingAmountGross;
  final double additionalAmountGross;
  final double taxAmount;
  final double totalGross;
  //* Controller ProductsTotal
  final TextEditingController discountPercentageController;
  final TextEditingController discountAmountGrossController;
  final TextEditingController shippingAmountGrossController;
  final TextEditingController additionalAmountGrossController;
  //* Helper Products
  final bool isInScanMode;
  final double posDiscountPercent;
  final double posDiscountPercentAmount;
  final List<bool> isEditable;
  final List<Tax> taxRulesList;
  //* Controller Products
  final TextEditingController barcodeScannerController;
  final List<TextEditingController> articleNumberControllers;
  final List<TextEditingController> articleNameControllers;
  final List<TextEditingController> quantityControllers;
  final List<TextEditingController> unitPriceNetControllers;
  final List<TextEditingController> posDiscountPercentControllers;
  final List<TextEditingController> unitPriceGrossControllers;

  ReceiptDetailState({
    required this.receipt,
    required this.listOfReceiptProducts,
    required this.taxRulesListFromSettings,
    required this.discountPercentage,
    required this.discountAmountGross,
    required this.shippingAmountGross,
    required this.additionalAmountGross,
    required this.discountPercentageController,
    required this.discountAmountGrossController,
    required this.shippingAmountGrossController,
    required this.additionalAmountGrossController,
    required this.isInScanMode,
    required this.posDiscountPercent,
    required this.isEditable,
    required this.taxRulesList,
    required this.barcodeScannerController,
    required this.articleNumberControllers,
    required this.articleNameControllers,
    required this.quantityControllers,
    required this.unitPriceNetControllers,
    required this.posDiscountPercentControllers,
    required this.unitPriceGrossControllers,
  })  : productsTotalNet = _calcProductsTotalNet(listOfReceiptProducts),
        procutsTotalGross = _calcProductsTotalGross(listOfReceiptProducts),
        posDiscountPercentAmount = _calcPosDiscountPercentAmount(listOfReceiptProducts, posDiscountPercent),
        discountPercentageAmountGross = _calcDiscountPercentageAmount(listOfReceiptProducts, discountPercentage),
        taxAmount = _calcTaxAmount(
          receipt.tax,
          _calcProductsTotalNet(listOfReceiptProducts),
          _calcProductsTotalGross(listOfReceiptProducts),
          _calcPosDiscountPercentAmount(listOfReceiptProducts, posDiscountPercent),
          _calcDiscountPercentageAmount(listOfReceiptProducts, discountPercentage),
          discountAmountGross,
          shippingAmountGross,
          additionalAmountGross,
        ),
        totalGross = _calcProductsTotalGross(listOfReceiptProducts) -
            _calcPosDiscountPercentAmount(listOfReceiptProducts, posDiscountPercent) -
            _calcDiscountPercentageAmount(listOfReceiptProducts, discountPercentage) -
            discountAmountGross +
            shippingAmountGross +
            additionalAmountGross;

  static double _calcProductsTotalNet(List<ReceiptProduct> receiptProducts) {
    return receiptProducts.map((e) => e.unitPriceNet * e.quantity).toList().reduce((value, element) => value + element);
  }

  static double _calcProductsTotalGross(List<ReceiptProduct> receiptProducts) {
    return receiptProducts.map((e) => e.unitPriceGross * e.quantity).toList().reduce((value, element) => value + element);
  }

  static double _calcDiscountPercentageAmount(List<ReceiptProduct> receiptProducts, double discountPercentage) {
    return calcPercentageAmount(_calcProductsTotalGross(receiptProducts), discountPercentage);
  }

  static double _calcPosDiscountPercentAmount(List<ReceiptProduct> receiptProducts, double posDiscountPercent) {
    double posPercentAmount = 0;
    for (final product in receiptProducts) {
      posPercentAmount += calcPercentageAmount(product.unitPriceGross * product.quantity, product.discountPercent);
    }
    return posPercentAmount;
  }

  static double _calcTaxAmount(
    int tax,
    double productsTotalNet,
    double procutsTotalGross,
    double posDiscountPercentAmount,
    double discountPercentageAmountGross,
    double discountAmountGross,
    double shippingAmountGross,
    double additionalAmountGross,
  ) {
    return (procutsTotalGross - productsTotalNet) +
        calcTaxAmount(posDiscountPercentAmount, tax) +
        calcTaxAmount(discountPercentageAmountGross, tax) +
        calcTaxAmount(discountAmountGross, tax) +
        calcTaxAmount(shippingAmountGross, tax) +
        calcTaxAmount(additionalAmountGross, tax);
  }

  factory ReceiptDetailState.initial() => ReceiptDetailState(
        receipt: Receipt.empty(),
        listOfReceiptProducts: [ReceiptProduct.empty()],
        taxRulesListFromSettings: const [],
        discountPercentage: 0,
        discountAmountGross: 0,
        shippingAmountGross: 0,
        additionalAmountGross: 0,
        discountPercentageController: TextEditingController(text: '0'),
        discountAmountGrossController: TextEditingController(text: '0'),
        shippingAmountGrossController: TextEditingController(text: '0'),
        additionalAmountGrossController: TextEditingController(text: '0'),
        isInScanMode: false,
        posDiscountPercent: 0,
        isEditable: const [],
        taxRulesList: const [],
        barcodeScannerController: TextEditingController(),
        articleNumberControllers: const [],
        articleNameControllers: const [],
        quantityControllers: const [],
        unitPriceNetControllers: const [],
        posDiscountPercentControllers: const [],
        unitPriceGrossControllers: const [],
      );

  ReceiptDetailState copyWith({
    Receipt? receipt,
    List<ReceiptProduct>? listOfReceiptProducts,
    List<Tax>? taxRulesListFromSettings,
    double? productsTotalNet,
    double? procutsTotalGross,
    double? discountPercentage,
    double? discountPercentageAmountGross,
    double? discountAmountGross,
    double? shippingAmountGross,
    double? additionalAmountGross,
    double? taxAmount,
    double? totalGross,
    TextEditingController? discountPercentageController,
    TextEditingController? discountAmountGrossController,
    TextEditingController? shippingAmountGrossController,
    TextEditingController? additionalAmountGrossController,
    bool? isInScanMode,
    double? posDiscountPercent,
    List<bool>? isEditable,
    List<Tax>? taxRulesList,
    TextEditingController? barcodeScannerController,
    List<TextEditingController>? articleNumberControllers,
    List<TextEditingController>? articleNameControllers,
    List<TextEditingController>? quantityControllers,
    List<TextEditingController>? unitPriceNetControllers,
    List<TextEditingController>? posDiscountPercentControllers,
    List<TextEditingController>? unitPriceGrossControllers,
  }) {
    return ReceiptDetailState(
      receipt: receipt ?? this.receipt,
      listOfReceiptProducts: listOfReceiptProducts ?? this.listOfReceiptProducts,
      taxRulesListFromSettings: taxRulesListFromSettings ?? this.taxRulesListFromSettings,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      discountAmountGross: discountAmountGross ?? this.discountAmountGross,
      shippingAmountGross: shippingAmountGross ?? this.shippingAmountGross,
      additionalAmountGross: additionalAmountGross ?? this.additionalAmountGross,
      discountPercentageController: discountPercentageController ?? this.discountPercentageController,
      discountAmountGrossController: discountAmountGrossController ?? this.discountAmountGrossController,
      shippingAmountGrossController: shippingAmountGrossController ?? this.shippingAmountGrossController,
      additionalAmountGrossController: additionalAmountGrossController ?? this.additionalAmountGrossController,
      isInScanMode: isInScanMode ?? this.isInScanMode,
      posDiscountPercent: posDiscountPercent ?? this.posDiscountPercent,
      isEditable: isEditable ?? this.isEditable,
      taxRulesList: taxRulesList ?? this.taxRulesList,
      barcodeScannerController: barcodeScannerController ?? this.barcodeScannerController,
      articleNumberControllers: articleNumberControllers ?? this.articleNumberControllers,
      articleNameControllers: articleNameControllers ?? this.articleNameControllers,
      quantityControllers: quantityControllers ?? this.quantityControllers,
      unitPriceNetControllers: unitPriceNetControllers ?? this.unitPriceNetControllers,
      posDiscountPercentControllers: posDiscountPercentControllers ?? this.posDiscountPercentControllers,
      unitPriceGrossControllers: unitPriceGrossControllers ?? this.unitPriceGrossControllers,
    );
  }
}
