import 'dart:math';

import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../3_domain/entities/product/product.dart';
import '../../../constants.dart';
import '../../incoming_invoice/incoming_invoice_detail/functions/functions.dart';

void showEbayProfitCalculatorSheet(BuildContext context, Product product) {
  const title = Padding(
    padding: EdgeInsets.only(left: 24, top: 20),
    child: Text('Ebay Gewinn-Rechner', style: TextStyles.h2),
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
        child: _EbayProfitCalculator(product: product),
      ),
    ],
  );
}

class _EbayProfitCalculator extends StatefulWidget {
  final Product product;

  const _EbayProfitCalculator({required this.product});

  @override
  State<_EbayProfitCalculator> createState() => __EbayProfitCalculatorState();
}

class __EbayProfitCalculatorState extends State<_EbayProfitCalculator> {
  final _ebayFeePercentageController = TextEditingController(text: '12');
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
                  controller: _ebayFeePercentageController,
                  fieldTitle: 'Zahlungsgebuhr (%)',
                  inputType: FieldInputType.double,
                  suffix: const Text('%'),
                ),
              ),
              Gaps.w10,
              const SizedBox(),
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
                  const Text('Produktkosten + Ebay-Gebühren + Versand', style: TextStyles.infoOnTextFieldSmall),
                  Text('${_getCostsInclShipping().toMyCurrencyStringToShow()} €'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Gebühr Ebay', style: TextStyles.infoOnTextFieldSmall),
                  Text('${_getEbayFee().toMyCurrencyStringToShow()} €'),
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
              Text('${_getProfit().toMyCurrencyStringToShow()} €', style: TextStyles.h3BoldPrimary),
            ],
          ),
        ],
      ),
    );
  }

  double _getEbayFee() {
    return _getEbayFeeGlobal(
      _productNetPrice,
      _shippingCostCustomerController.text.toMyDouble(),
      _taxRate,
      _ebayFeePercentageController.text.toMyDouble(),
    );
  }

  double _getCostsInclShipping() {
    return _getCostsInclShippingGlobal(
      widget.product.wholesalePrice,
      _getEbayFee(),
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
}

double _getEbayFeeGlobal(double productNetPrice, double shippingCostCustomer, int taxRate, double ebayFeePercentage) {
  final netPriceWithShipping = productNetPrice + shippingCostCustomer;
  final grossPriceWithShipping = netPriceWithShipping * taxToCalc(taxRate);
  final ebayFee = (grossPriceWithShipping * ((ebayFeePercentage / 100) + 1) - grossPriceWithShipping);

  return ebayFee;
}

double _getCostsInclShippingGlobal(double wholesalePrice, double ebayMethodFee, double shippingCostMe, double shippingCostCustomer) {
  return wholesalePrice + ebayMethodFee + (shippingCostMe - shippingCostCustomer);
}

double _getCostsInclShippingInclPackagingGlobal(double costsInclShipping, double packagingBoxCosts, double packagingMaterialCosts) {
  return costsInclShipping + packagingBoxCosts + packagingMaterialCosts;
}

double _getProfitGlobal(double productGrossPrice, double costsInclShippingInclPackaging) {
  return productGrossPrice - costsInclShippingInclPackaging;
}

class EbayProfitQuickView extends StatelessWidget {
  final Product product;
  final bool isGermany;

  const EbayProfitQuickView({super.key, required this.product, this.isGermany = false});

  @override
  Widget build(BuildContext context) {
    final productNetPrice = product.specificPrice != null ? product.specificPrice!.discountedPriceNet : product.netPrice;

    final shippingCostCustomer = isGermany ? 6.66 : 4.16;
    final shippingCostMe = isGermany ? 7.58 : 4.84;

    const ebayFeePercentage = 12.0;
    const packagingBoxCosts = 0.66;
    const packagingMaterialCosts = 0.10;

    const taxRate = 20;

    final ebayMethodFee = _getEbayFeeGlobal(productNetPrice, shippingCostCustomer, taxRate, ebayFeePercentage);
    final costsInclShipping = _getCostsInclShippingGlobal(product.wholesalePrice, ebayMethodFee, shippingCostMe, shippingCostCustomer);
    final costsInclShippingInclPackaging = _getCostsInclShippingInclPackagingGlobal(costsInclShipping, packagingBoxCosts, packagingMaterialCosts);
    final profit = _getProfitGlobal(productNetPrice, costsInclShippingInclPackaging);

    return Text(profit.toMyCurrencyStringToShow(), style: TextStyles.defaultBoldPrimary.copyWith(color: profit <= 0.0 ? Colors.red : null));
  }
}
