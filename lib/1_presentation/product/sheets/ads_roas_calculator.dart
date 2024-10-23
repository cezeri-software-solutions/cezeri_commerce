import 'dart:math';

import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../3_domain/entities/product/product.dart';
import '../../../constants.dart';
import '../../incoming_invoice/incoming_invoice_detail/functions/functions.dart';

void showProductAdsRoasCalculatorSheet(BuildContext context, Product product) {
  const title = Padding(
    padding: EdgeInsets.only(left: 24, top: 20),
    child: Text('ADS ROI Rechner', style: TextStyles.h2),
  );

  final closeButton = Padding(
    padding: const EdgeInsets.only(right: 8),
    child: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
  );

  WoltModalSheet.show<void>(
    context: context,
    enableDrag: false,
    useSafeArea: false,
    pageListBuilder: (context) => [
      WoltModalSheetPage(
        leadingNavBarWidget: title,
        trailingNavBarWidget: closeButton,
        child: _AdsRoasCalculator(product: product),
      ),
    ],
  );
}

class _AdsRoasCalculator extends StatefulWidget {
  final Product product;

  const _AdsRoasCalculator({required this.product});

  @override
  State<_AdsRoasCalculator> createState() => _AdsRoasCalculatorState();
}

class _AdsRoasCalculatorState extends State<_AdsRoasCalculator> {
  final _paymentFeePercentageController = TextEditingController(text: '3.4');
  final _paymentFeeAmountController = TextEditingController(text: '0.25');
  late TextEditingController _shippingCostCustomerController;
  final _shippingCostMeController = TextEditingController(text: '4.84');
  final _packagingBoxCostsController = TextEditingController(text: '0.66');
  final _packagingMaterialCostsController = TextEditingController(text: '0.10');

  late double _productNetPrice;
  late double _productGrossPrice;

  int _taxRate = 20;

  @override
  void initState() {
    super.initState();

    if (widget.product.specificPrice != null) {
      _productNetPrice = widget.product.specificPrice!.discountedPriceNet;
    } else {
      _productNetPrice = widget.product.netPrice;
    }

    if (widget.product.specificPrice != null) {
      _productGrossPrice = widget.product.specificPrice!.discountedPriceGross;
    } else {
      _productGrossPrice = widget.product.grossPrice;
    }

    _shippingCostCustomerController = TextEditingController(text: _productGrossPrice > 39 ? '0.0' : '4.16');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: max(MediaQuery.paddingOf(context).bottom, 24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.product.name, style: TextStyles.h3BoldPrimary),
          Gaps.h8,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Einkaufs-Preis Netto', style: TextStyles.infoOnTextFieldSmall),
                  Text('${widget.product.wholesalePrice.toMyCurrencyStringToShow()} €'),
                ],
              ),
              SizedBox(
                width: 160,
                child: MyDropdownButtonSmall(
                  value: _taxRate.toString(),
                  itemAsString: (val) => 'Vorsteuer $val%',
                  onChanged: (val) => setState(() => _taxRate = val.toMyInt()),
                  fieldTitle: 'Steuer',
                  cacheItems: false,
                  showSearch: false,
                  loadItems: (filter, loadProps) async => await incomingInvoiceDetailLoadTaxRates(),
                  itemBuilder: (context, item, isSelected, isDisabled) {
                    return ListTile(
                      dense: true,
                      title: Text('Vorsteuer $item%', style: isDisabled ? TextStyles.defaultBold : null),
                      selected: isDisabled,
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                    );
                  },
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Verkaufs-Preis Netto', style: TextStyles.infoOnTextFieldSmall),
                  Text('${_productNetPrice.toMyCurrencyStringToShow()} €'),
                ],
              ),
            ],
          ),
          Gaps.h8,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MyTextFormFieldSmall(
                  controller: _paymentFeePercentageController,
                  fieldTitle: 'Zahlungsgebuhr (%)',
                  inputType: FieldInputType.double,
                  suffix: const Text('%'),
                ),
              ),
              Gaps.w10,
              Expanded(
                child: MyTextFormFieldSmall(
                  controller: _paymentFeeAmountController,
                  fieldTitle: 'Zahlungsgebuhr (€)',
                  inputType: FieldInputType.double,
                  suffix: const Text('€'),
                ),
              ),
            ],
          ),
          Gaps.h8,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MyTextFormFieldSmall(
                  controller: _shippingCostCustomerController,
                  fieldTitle: 'Versandkosten Kunde zahlt (€)',
                  inputType: FieldInputType.double,
                  suffix: const Text('€'),
                ),
              ),
              Gaps.w10,
              Expanded(
                child: MyTextFormFieldSmall(
                  controller: _shippingCostMeController,
                  fieldTitle: 'Versandkosten Ich zahle (€)',
                  inputType: FieldInputType.double,
                  suffix: const Text('€'),
                ),
              ),
            ],
          ),
          Gaps.h8,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MyTextFormFieldSmall(
                  controller: _packagingBoxCostsController,
                  fieldTitle: 'Verpackungskarton',
                  inputType: FieldInputType.double,
                  suffix: const Text('€'),
                ),
              ),
              Gaps.w10,
              Expanded(
                child: MyTextFormFieldSmall(
                  controller: _packagingMaterialCostsController,
                  fieldTitle: 'Restliche Verpackungskosten',
                  inputType: FieldInputType.double,
                  suffix: const Text('€'),
                ),
              ),
            ],
          ),
          Gaps.h8,
          Center(child: FilledButton(onPressed: () => setState(() {}), child: const Text('Berechnen'))),
          Gaps.h8,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Produktkosten + Versand', style: TextStyles.infoOnTextFieldSmall),
                  Text('${_getCostsInclShipping().toMyCurrencyStringToShow()} €'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Gebühr Zahlungsart', style: TextStyles.infoOnTextFieldSmall),
                  Text('${_getPaymentMethodFee().toMyCurrencyStringToShow()} €'),
                ],
              ),
            ],
          ),
          Gaps.h8,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Gesamtkosten + Verpackung', style: TextStyles.infoOnTextFieldSmall),
                  Text('${_getCostsInclShippingInclPackaging().toMyCurrencyStringToShow()} €'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Gesamtkosten in %', style: TextStyles.infoOnTextFieldSmall),
                  Text('${((_getCostsInclShippingInclPackaging() / _productNetPrice) * 100).toMyCurrencyStringToShow()} %'),
                ],
              ),
            ],
          ),
          Gaps.h8,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Gewinn pro Bestellung:', style: TextStyles.defaultBold.copyWith(color: _getProfit() > 0 ? Colors.green : Colors.red)),
              Text('${_getProfit().toMyCurrencyStringToShow()} €'),
            ],
          ),
          Gaps.h8,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Break Even ROAS:', style: TextStyles.h3BoldPrimary),
              Text(_getROAS().toMyCurrencyStringToShow(), style: TextStyles.h3BoldPrimary),
            ],
          ),
        ],
      ),
    );
  }

  double _getPaymentMethodFee() {
    return _getPaymentMethodFeeGlobal(
      _productNetPrice,
      _shippingCostCustomerController.text.toMyDouble(),
      _taxRate,
      _paymentFeePercentageController.text.toMyDouble(),
      _paymentFeeAmountController.text.toMyDouble(),
    );
  }

  double _getCostsInclShipping() {
    return _getCostsInclShippingGlobal(
      widget.product.wholesalePrice,
      _getPaymentMethodFee(),
      _shippingCostMeController.text.toMyDouble(),
      _shippingCostCustomerController.text.toMyDouble(),
    );
  }

  double _getCostsInclShippingInclPackaging() {
    return _getCostsInclShippingInclPackagingGlobal(
      _getCostsInclShipping(),
      _packagingBoxCostsController.text.toMyDouble(),
      _packagingMaterialCostsController.text.toMyDouble(),
    );
  }

  double _getProfit() {
    return _getProfitGlobal(
      _productNetPrice,
      _getCostsInclShippingInclPackaging(),
    );
  }

  double _getROAS() {
    return _getROASGlobal(_productGrossPrice, _getProfit()).toMyRoundedDouble();
  }
}

double _getPaymentMethodFeeGlobal(
    double productNetPrice, double shippingCostCustomer, int taxRate, double paymentFeePercentage, double paymentFeeAmount) {
  final netPriceWithShipping = productNetPrice + shippingCostCustomer;
  final grossPriceWithShipping = netPriceWithShipping * taxToCalc(taxRate);
  final paymentFee = (grossPriceWithShipping * ((paymentFeePercentage / 100) + 1) - grossPriceWithShipping);
  final paymentFeeSum = paymentFee + paymentFeeAmount;

  return paymentFeeSum;
}

double _getCostsInclShippingGlobal(double wholesalePrice, double paymentMethodFee, double shippingCostMe, double shippingCostCustomer) {
  return wholesalePrice + paymentMethodFee + (shippingCostMe - shippingCostCustomer);
}

double _getCostsInclShippingInclPackagingGlobal(double costsInclShipping, double packagingBoxCosts, double packagingMaterialCosts) {
  return costsInclShipping + packagingBoxCosts + packagingMaterialCosts;
}

double _getProfitGlobal(double productGrossPrice, double costsInclShippingInclPackaging) {
  return productGrossPrice - costsInclShippingInclPackaging;
}

double _getROASGlobal(double productGrossPrice, double profit) {
  return (productGrossPrice / profit).toMyRoundedDouble();
}

class ProductRoasQuickView extends StatelessWidget {
  final Product product;
  final bool isGermany;

  const ProductRoasQuickView({super.key, required this.product, this.isGermany = false});

  @override
  Widget build(BuildContext context) {
    final productNetPrice = product.specificPrice != null ? product.specificPrice!.discountedPriceNet : product.netPrice;
    final productGrossPrice = product.specificPrice != null ? product.specificPrice!.discountedPriceGross : product.grossPrice;

    final shippingCostCustomer = isGermany
        ? productGrossPrice > 49.99
            ? 0.0
            : 4.16
        : productGrossPrice > 39
            ? 0.0
            : 4.16;
    final shippingCostMe = isGermany ? 7.58 : 4.84;

    const paymentFeePercentage = 3.4;
    const paymentFeeAmount = 0.25;
    const packagingBoxCosts = 0.66;
    const packagingMaterialCosts = 0.10;

    const taxRate = 20;

    final paymentMethodFee = _getPaymentMethodFeeGlobal(productNetPrice, shippingCostCustomer, taxRate, paymentFeePercentage, paymentFeeAmount);
    final costsInclShipping = _getCostsInclShippingGlobal(product.wholesalePrice, paymentMethodFee, shippingCostMe, shippingCostCustomer);
    final costsInclShippingInclPackaging = _getCostsInclShippingInclPackagingGlobal(costsInclShipping, packagingBoxCosts, packagingMaterialCosts);
    final profit = _getProfitGlobal(productNetPrice, costsInclShippingInclPackaging);
    final roas = _getROASGlobal(productGrossPrice, profit);

    return Text(roas.toMyCurrencyStringToShow(), style: TextStyles.defaultBoldPrimary.copyWith(color: roas <= 0.0 ? Colors.red : null));
  }
}
