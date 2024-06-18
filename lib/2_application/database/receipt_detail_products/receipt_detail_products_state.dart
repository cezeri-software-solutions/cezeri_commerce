part of 'receipt_detail_products_bloc.dart';

@immutable
class ReceiptDetailProductsState {
  final Receipt receipt;
  final List<ReceiptProduct> listOfReceiptProducts;
  final List<Tax> taxRulesListFromSettings;
  //* Helper ProductsTotal
  final double productsTotalNet;
  final double productsTotalGross;
  final double discountPercentageAmountGross;
  final double taxAmount;
  final double totalGross;
  //* Controller ProductsTotal
  final TextEditingController discountPercentageController;
  final TextEditingController discountAmountGrossController;
  final TextEditingController shippingAmountGrossController;
  final TextEditingController additionalAmountGrossController;
  //* Helper Products
  final bool isInScanMode;
  final double posDiscountPercentAmount;
  final List<bool> isEditable;
  //* Controller Products
  final TextEditingController barcodeScannerController;
  final List<TextEditingController> articleNumberControllers;
  final List<TextEditingController> articleNameControllers;
  final List<TextEditingController> quantityControllers;
  final List<TextEditingController> unitPriceNetControllers;
  final List<TextEditingController> posDiscountPercentControllers;
  final List<TextEditingController> unitPriceGrossControllers;

  ReceiptDetailProductsState({
    required this.receipt,
    required this.listOfReceiptProducts,
    required this.taxRulesListFromSettings,
    required this.discountPercentageController,
    required this.discountAmountGrossController,
    required this.shippingAmountGrossController,
    required this.additionalAmountGrossController,
    required this.isInScanMode,
    required this.isEditable,
    required this.barcodeScannerController,
    required this.articleNumberControllers,
    required this.articleNameControllers,
    required this.quantityControllers,
    required this.unitPriceNetControllers,
    required this.posDiscountPercentControllers,
    required this.unitPriceGrossControllers,
  })  : productsTotalNet = _calcProductsTotalNet(listOfReceiptProducts),
        productsTotalGross = _calcProductsTotalGross(listOfReceiptProducts),
        posDiscountPercentAmount = _calcPosDiscountPercentAmount(listOfReceiptProducts),
        discountPercentageAmountGross = _calcDiscountPercentageAmount(listOfReceiptProducts, receipt.discountPercent),
        taxAmount = _calcTaxAmount(
          receipt.tax.taxRate,
          _calcProductsTotalNet(listOfReceiptProducts),
          _calcProductsTotalGross(listOfReceiptProducts),
          _calcPosDiscountPercentAmount(listOfReceiptProducts),
          _calcDiscountPercentageAmount(listOfReceiptProducts, receipt.discountPercent),
          receipt.discountGross,
          receipt.totalShippingGross,
          receipt.additionalAmountGross,
        ),
        totalGross = _calcProductsTotalGross(listOfReceiptProducts) -
            _calcPosDiscountPercentAmount(listOfReceiptProducts) -
            _calcDiscountPercentageAmount(listOfReceiptProducts, receipt.discountPercent) -
            receipt.discountGross +
            receipt.totalShippingGross +
            receipt.additionalAmountGross;

  static double _calcProductsTotalNet(List<ReceiptProduct> receiptProducts) {
    return (receiptProducts.map((e) => e.unitPriceNet * e.quantity).toList().reduce((value, element) => value + element)).toMyRoundedDouble();
  }

  static double _calcProductsTotalGross(List<ReceiptProduct> receiptProducts) {
    return (receiptProducts.map((e) => e.unitPriceGross * e.quantity).toList().reduce((value, element) => value + element)).toMyRoundedDouble();
  }

  static double _calcPosDiscountPercentAmount(List<ReceiptProduct> receiptProducts) {
    double posPercentAmount = 0;
    for (final product in receiptProducts) {
      posPercentAmount += (calcPercentageAmount(product.unitPriceGross * product.quantity, product.discountPercent)).toMyRoundedDouble();
    }
    return posPercentAmount;
  }

  static double _calcDiscountPercentageAmount(List<ReceiptProduct> receiptProducts, double discountPercentage) {
    return (calcPercentageAmount(_calcProductsTotalGross(receiptProducts), discountPercentage)).toMyRoundedDouble();
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
    return (procutsTotalGross - productsTotalNet) -
        calcTaxAmountFromGross(posDiscountPercentAmount, tax).toMyRoundedDouble() -
        calcTaxAmountFromGross(discountPercentageAmountGross, tax).toMyRoundedDouble() -
        calcTaxAmountFromGross(discountAmountGross, tax).toMyRoundedDouble() +
        calcTaxAmountFromGross(shippingAmountGross, tax).toMyRoundedDouble() +
        calcTaxAmountFromGross(additionalAmountGross, tax).toMyRoundedDouble();
  }

  factory ReceiptDetailProductsState.initial() => ReceiptDetailProductsState(
        receipt: Receipt.empty(),
        listOfReceiptProducts: [ReceiptProduct.empty()],
        taxRulesListFromSettings: const [],
        discountPercentageController: TextEditingController(text: '0'),
        discountAmountGrossController: TextEditingController(text: '0'),
        shippingAmountGrossController: TextEditingController(text: '0'),
        additionalAmountGrossController: TextEditingController(text: '0'),
        isInScanMode: false,
        isEditable: const [],
        barcodeScannerController: TextEditingController(),
        articleNumberControllers: const [],
        articleNameControllers: const [],
        quantityControllers: const [],
        unitPriceNetControllers: const [],
        posDiscountPercentControllers: const [],
        unitPriceGrossControllers: const [],
      );

  ReceiptDetailProductsState copyWith({
    Receipt? receipt,
    List<ReceiptProduct>? listOfReceiptProducts,
    List<Tax>? taxRulesListFromSettings,
    double? productsTotalNet,
    double? procutsTotalGross,
    double? discountPercentageAmountGross,
    double? taxAmount,
    double? totalGross,
    TextEditingController? discountPercentageController,
    TextEditingController? discountAmountGrossController,
    TextEditingController? shippingAmountGrossController,
    TextEditingController? additionalAmountGrossController,
    bool? isInScanMode,
    List<bool>? isEditable,
    TextEditingController? barcodeScannerController,
    List<TextEditingController>? articleNumberControllers,
    List<TextEditingController>? articleNameControllers,
    List<TextEditingController>? quantityControllers,
    List<TextEditingController>? unitPriceNetControllers,
    List<TextEditingController>? posDiscountPercentControllers,
    List<TextEditingController>? unitPriceGrossControllers,
  }) {
    return ReceiptDetailProductsState(
      receipt: receipt ?? this.receipt,
      listOfReceiptProducts: listOfReceiptProducts ?? this.listOfReceiptProducts,
      taxRulesListFromSettings: taxRulesListFromSettings ?? this.taxRulesListFromSettings,
      discountPercentageController: discountPercentageController ?? this.discountPercentageController,
      discountAmountGrossController: discountAmountGrossController ?? this.discountAmountGrossController,
      shippingAmountGrossController: shippingAmountGrossController ?? this.shippingAmountGrossController,
      additionalAmountGrossController: additionalAmountGrossController ?? this.additionalAmountGrossController,
      isInScanMode: isInScanMode ?? this.isInScanMode,
      isEditable: isEditable ?? this.isEditable,
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
