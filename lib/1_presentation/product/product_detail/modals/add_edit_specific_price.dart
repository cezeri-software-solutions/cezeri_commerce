import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../../2_application/database/product_detail/product_detail_bloc.dart';
import '../../../../3_domain/entities/product/product.dart';
import '../../../../3_domain/entities/product/product_marketplace.dart';
import '../../../../3_domain/entities/product/product_presta.dart';
import '../../../../3_domain/entities/product/specific_price.dart';
import '../../../../4_infrastructur/repositories/shopify_api/shopify.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';
import '../../widgets/product_profit_text.dart';

void addEditSpecificPrice(BuildContext context, ProductDetailBloc productDetailBloc, Product product) {
  const title = Padding(
    padding: EdgeInsets.only(left: 24, top: 20),
    child: Text('Artikelrabatt', style: TextStyles.h2),
  );

  final closeButton = Padding(
    padding: const EdgeInsets.only(right: 8),
    child: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
  );

  WoltModalSheet.show<void>(
    context: context,
    barrierDismissible: false,
    enableDrag: false,
    useSafeArea: false,
    pageListBuilder: (context) => [
      WoltModalSheetPage(
        leadingNavBarWidget: title,
        trailingNavBarWidget: closeButton,
        child: _AddEditSpecificPrice(productDetailBloc: productDetailBloc, product: product),
      ),
    ],
  );
}

class _AddEditSpecificPrice extends StatefulWidget {
  final ProductDetailBloc productDetailBloc;
  final Product product;

  const _AddEditSpecificPrice({required this.productDetailBloc, required this.product});

  @override
  State<_AddEditSpecificPrice> createState() => __AddEditSpecificPriceState();
}

class __AddEditSpecificPriceState extends State<_AddEditSpecificPrice> {
  final _now = DateTime.now();

  late TextEditingController _titleController;
  late TextEditingController _fromQuantityController;
  late TextEditingController _valueController;

  late DateTime _startDate;
  late DateTime? _endDate;

  late FixedReductionType _fixedReductionType;
  late ReductionType _reductionType;

  late bool _isActive;
  late bool _isDiscountInternal;

  late double _discountedPriceNet;
  late double _discountedPriceGross;

  late List<SpecificPriceMarketplace> _listOfSpecificPriceMarketplaces;
  late List<SpecificPriceMarketplace> _listOfSpecificPriceMarketplacesOriginal;

  @override
  void initState() {
    super.initState();

    if (widget.product.specificPrice == null) {
      _titleController = TextEditingController();
      _fromQuantityController = TextEditingController(text: '1');
      _valueController = TextEditingController(text: '0');

      _startDate = DateTime(_now.year, _now.month, _now.day);
      _endDate = null;

      _fixedReductionType = FixedReductionType.gross;
      _reductionType = ReductionType.percent;

      _isActive = true;
      _isDiscountInternal = false;

      _listOfSpecificPriceMarketplaces = [];
      _listOfSpecificPriceMarketplacesOriginal = [];
    } else {
      _titleController = TextEditingController(text: widget.product.specificPrice!.title);
      _fromQuantityController = TextEditingController(text: widget.product.specificPrice!.fromQuantity.toString());
      _valueController = TextEditingController(text: widget.product.specificPrice!.value.toString());

      _startDate = widget.product.specificPrice!.startDate;
      _endDate = widget.product.specificPrice!.endDate;

      _fixedReductionType = widget.product.specificPrice!.fixedReductionType;
      _reductionType = widget.product.specificPrice!.reductionType;

      _isActive = widget.product.specificPrice!.isActive;
      _isDiscountInternal = widget.product.specificPrice!.isDiscountInternal;

      _listOfSpecificPriceMarketplaces = List.from(widget.product.specificPrice!.listOfSpecificPriceMarketplaces);
      _listOfSpecificPriceMarketplacesOriginal = List.from(widget.product.specificPrice!.listOfSpecificPriceMarketplaces);
    }

    _calculateDiscountedPrice();
  }

  final reductionTypes = ['Preis', 'Prozent'];
  final fixedReductionTypes = ['Netto (zzgl. MwSt.)', 'Brutto (inkl. MwSt.)'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: max(MediaQuery.paddingOf(context).bottom, 16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Switch.adaptive(value: _isActive, onChanged: (val) => setState(() => _isActive = val)),
          ),
          MyTextFormFieldSmall(
            fieldTitle: 'Titel',
            controller: _titleController,
            onChanged: (_) {},
          ),
          Gaps.h8,
          Row(
            children: [
              Expanded(
                child: MyTextFormFieldSmall(
                  fieldTitle: 'Ab-Stückzahl',
                  controller: _fromQuantityController,
                  inputType: FieldInputType.integer,
                  onChanged: (_) {},
                ),
              ),
              Gaps.w8,
              Expanded(
                child: MyTextFormFieldSmall(
                  fieldTitle: 'Rabatt-Wert',
                  suffix: Text(_reductionType == ReductionType.percent ? '%' : '€'),
                  controller: _valueController,
                  inputType: FieldInputType.double,
                  onChanged: (_) => setState(_calculateDiscountedPrice),
                ),
              ),
            ],
          ),
          Gaps.h8,
          Row(
            children: [
              Expanded(
                child: MyButtonSmall(
                  labelText: 'Gültig von',
                  onTap: () async {
                    final newDate = await _showDatePicker(_startDate, 'Startdatum');
                    if (newDate != null) setState(() => _startDate = newDate);
                  },
                  child: Text(_startDate.toFormattedDayMonthYear(), style: TextStyles.s13),
                ),
              ),
              Gaps.w8,
              Expanded(
                child: MyButtonSmall(
                  labelText: 'Gültig bis',
                  onTap: () async {
                    final newDate = await _showDatePicker(_endDate ?? _now, 'Enddatum');
                    if (newDate != null) setState(() => _endDate = newDate);
                  },
                  trailing: const Icon(CupertinoIcons.clear_circled_solid, size: 20, color: Colors.grey),
                  onTrailingTap: () => setState(() => _endDate = null),
                  child: _endDate != null ? Text(_endDate!.toFormattedDayMonthYear()) : const Text('tt.mm.yyyy', style: TextStyles.infoOnTextField),
                ),
              ),
            ],
          ),
          Gaps.h8,
          Row(
            children: [
              Expanded(
                child: MyDropdownButtonSmall(
                  labelText: 'Rabatt-Typ:',
                  value: _reductionType == ReductionType.fixed ? reductionTypes[0] : reductionTypes[1],
                  onChanged: (value) => {
                    if (value == reductionTypes[0])
                      setState(() {
                        _reductionType = ReductionType.fixed;
                        _calculateDiscountedPrice();
                      }),
                    if (value == reductionTypes[1])
                      setState(() {
                        _reductionType = ReductionType.percent;
                        _calculateDiscountedPrice();
                      }),
                  },
                  items: reductionTypes,
                ),
              ),
              Gaps.w8,
              if (_reductionType == ReductionType.fixed)
                Expanded(
                  child: MyDropdownButtonSmall(
                    labelText: 'inkl. oder zzgl. MwSt:',
                    value: _fixedReductionType == FixedReductionType.net ? fixedReductionTypes[0] : fixedReductionTypes[1],
                    onChanged: (value) => {
                      if (value == fixedReductionTypes[0])
                        setState(() {
                          _fixedReductionType = FixedReductionType.net;
                          _calculateDiscountedPrice();
                        }),
                      if (value == fixedReductionTypes[1])
                        setState(() {
                          _fixedReductionType = FixedReductionType.gross;
                          _calculateDiscountedPrice();
                        }),
                    },
                    items: fixedReductionTypes,
                  ),
                )
              else
                const Expanded(child: SizedBox()),
            ],
          ),
          Gaps.h8,
          Row(
            children: [
              Expanded(
                child: MyTextFormFieldSmall(
                  fieldTitle: 'Preis zzgl. MwSt.',
                  suffix: const Text('€'),
                  hintText: widget.product.netPrice.toMyCurrencyString(),
                  fillColor: Colors.grey[100],
                  readOnly: true,
                ),
              ),
              Gaps.w8,
              Expanded(
                child: MyTextFormFieldSmall(
                  fieldTitle: 'Preis inkl. MwSt.',
                  suffix: const Text('€'),
                  hintText: widget.product.grossPrice.toMyCurrencyString(),
                  fillColor: Colors.grey[100],
                  readOnly: true,
                ),
              ),
            ],
          ),
          Gaps.h8,
          Row(
            children: [
              Expanded(
                child: MyTextFormFieldSmall(
                  fieldTitle: 'Rabattiert zzgl. MwSt.',
                  suffix: const Text('€'),
                  hintText: _discountedPriceNet.toMyCurrencyString(),
                  fillColor: Colors.grey[100],
                  readOnly: true,
                ),
              ),
              Gaps.w8,
              Expanded(
                child: MyTextFormFieldSmall(
                  fieldTitle: 'Rabattiert inkl. MwSt.',
                  suffix: const Text('€'),
                  hintText: _discountedPriceGross.toMyCurrencyString(),
                  fillColor: Colors.grey[100],
                  readOnly: true,
                ),
              ),
            ],
          ),
          Gaps.h16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Gewinn vor Rabatt:'),
              ProductProfitText(netPrice: widget.product.netPrice, wholesalePrice: widget.product.wholesalePrice),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Gewinn nach Rabatt:'),
              ProductProfitText(netPrice: _discountedPriceNet, wholesalePrice: widget.product.wholesalePrice),
            ],
          ),
          Gaps.h16,
          Row(
            children: [
              Checkbox.adaptive(value: _isDiscountInternal, onChanged: (val) => setState(() => _isDiscountInternal = val!)),
              const Text('Rabatt auch in Cezeri Commerce anwenden'),
            ],
          ),
          Gaps.h16,
          const Text('Marktplätze auswählen', style: TextStyles.h3Bold),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.product.productMarketplaces.length,
            itemBuilder: (context, index) {
              final productMarketplaces = widget.product.productMarketplaces;
              final productMarketplace = productMarketplaces[index];

              if (index == 0) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Checkbox.adaptive(
                          value: productMarketplaces.every((e) => _listOfSpecificPriceMarketplaces.any((f) => f.marketplaceId == e.idMarketplace)),
                          onChanged: (val) {
                            if (val!) {
                              for (var e in productMarketplaces) {
                                _addMarketplace(e.idMarketplace);
                              }
                            } else {
                              for (var e in productMarketplaces) {
                                _removeMarketplace(e.idMarketplace);
                              }
                            }
                          },
                        ),
                        const Text('In allen Marktplätze aktivieren'),
                      ],
                    ),
                    _MarketplaceTile(
                      productMarketplace: productMarketplace,
                      listOfSpecificPriceMarketplaces: _listOfSpecificPriceMarketplaces,
                      addMarketplace: _addMarketplace,
                      removeMarketplace: _removeMarketplace,
                    ),
                  ],
                );
              }

              return _MarketplaceTile(
                productMarketplace: productMarketplace,
                listOfSpecificPriceMarketplaces: _listOfSpecificPriceMarketplaces,
                addMarketplace: _addMarketplace,
                removeMarketplace: _removeMarketplace,
              );
            },
          ),
          Gaps.h32,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    widget.productDetailBloc.add(OnDeleteProductSpecificPriceEvent());

                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.delete, color: Colors.red)),
              Row(
                children: [
                  OutlinedButton(child: const Text('Abbrechen'), onPressed: () => Navigator.of(context).pop()),
                  Gaps.w16,
                  FilledButton(onPressed: _onSavePressed, child: const Text('Speichern')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<DateTime?> _showDatePicker(DateTime initialDate, String helpText) async {
    final newDate = await showDatePicker(
      helpText: helpText,
      context: context,
      initialDate: initialDate,
      firstDate: _startDate,
      lastDate: initialDate.add(const Duration(days: 1000)),
    );

    if (newDate == null) return null;
    return newDate;
  }

  void _calculateDiscountedPrice() {
    final tax = widget.product.tax.taxRate;
    final priceNet = widget.product.netPrice;
    final priceGross = widget.product.grossPrice;

    if (_reductionType == ReductionType.fixed) {
      if (_fixedReductionType == FixedReductionType.net) {
        setState(() => _discountedPriceNet = priceNet - _valueController.text.toMyDouble());
        setState(() => _discountedPriceGross = _discountedPriceNet * taxToCalc(tax));
      } else {
        setState(() => _discountedPriceGross = priceGross - _valueController.text.toMyDouble());
        setState(() => _discountedPriceNet = _discountedPriceGross / taxToCalc(tax));
      }
    }

    if (_reductionType == ReductionType.percent) {
      setState(() => _discountedPriceNet = priceNet - (priceNet * _valueController.text.toMyDouble() / 100));
      setState(() => _discountedPriceGross = _discountedPriceNet * taxToCalc(tax));
    }
  }

  void _addMarketplace(String marketplaceId) {
    final index = _listOfSpecificPriceMarketplacesOriginal.indexWhere((e) => e.marketplaceId == marketplaceId);
    if (index == -1) {
      setState(() => _listOfSpecificPriceMarketplaces.add((marketplaceId: marketplaceId, specificPriceId: null)));
    } else {
      setState(() => _listOfSpecificPriceMarketplaces.add(_listOfSpecificPriceMarketplacesOriginal[index]));
    }
  }

  void _removeMarketplace(String marketplaceId) {
    setState(() => _listOfSpecificPriceMarketplaces.removeWhere((e) => e.marketplaceId == marketplaceId));
  }


  void _onSavePressed() {
    final now = DateTime.now();

    final newSpecificPrice = SpecificPrice(
      id: widget.product.specificPrice == null ? const Uuid().v4() : widget.product.specificPrice!.id,
      title: _titleController.text,
      fromQuantity: _fromQuantityController.text.toMyInt(),
      value: _valueController.text.toMyDouble(),
      reductionType: _reductionType,
      fixedReductionType: _fixedReductionType,
      isActive: _isActive,
      isDiscountInternal: _isDiscountInternal,
      startDate: _startDate,
      endDate: _endDate,
      createdAt: widget.product.specificPrice == null ? now : widget.product.specificPrice!.createdAt,
      updatedAt: now,
      discountedPriceNet: _discountedPriceNet,
      discountedPriceGross: _discountedPriceGross,
      listOfSpecificPriceMarketplaces: _listOfSpecificPriceMarketplaces,
    );

    widget.productDetailBloc.add(OnAddEditProductSpecificPriceEvent(specificPrice: newSpecificPrice));

    Navigator.of(context).pop();
  }
}

class _MarketplaceTile extends StatelessWidget {
  final ProductMarketplace productMarketplace;
  final List<({String marketplaceId, String? specificPriceId})> listOfSpecificPriceMarketplaces;
  final Function(String) addMarketplace;
  final Function(String) removeMarketplace;

  const _MarketplaceTile({
    required this.productMarketplace,
    required this.listOfSpecificPriceMarketplaces,
    required this.addMarketplace,
    required this.removeMarketplace,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox.adaptive(
              value: listOfSpecificPriceMarketplaces.any((e) => e.marketplaceId == productMarketplace.idMarketplace),
              onChanged: (val) {
                val! ? addMarketplace(productMarketplace.idMarketplace) : removeMarketplace(productMarketplace.idMarketplace);
              },
            ),
            Text(productMarketplace.nameMarketplace),
          ],
        ),
        Row(
          children: [
            Text(productMarketplace.shortNameMarketplace),
            Gaps.w16,
            Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                color: switch (productMarketplace.marketplaceProduct) {
                  ProductPresta p => p.active == '1' ? Colors.green : Colors.grey,
                  ProductShopify p => p.status == ProductShopifyStatus.active ? Colors.green : Colors.grey,
                  _ => Colors.grey,
                },
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
