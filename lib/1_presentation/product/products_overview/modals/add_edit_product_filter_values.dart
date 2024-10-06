import 'dart:math';

import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../../2_application/database/product/product_bloc.dart';
import '../../../../3_domain/entities/product/product.dart';
import '../../../../constants.dart';

void addEditProductFilterValues(BuildContext context, ProductBloc productBloc, ProductsFilterValues productsFilterValues) {
  const title = Padding(
    padding: EdgeInsets.only(left: 24, top: 20),
    child: Text('Filteroptionen', style: TextStyles.h2),
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
        child: _AddEditProductsFilterValues(productBloc: productBloc, productsFilterValues: productsFilterValues),
      ),
    ],
  );
}

class _AddEditProductsFilterValues extends StatefulWidget {
  final ProductBloc productBloc;
  final ProductsFilterValues productsFilterValues;

  const _AddEditProductsFilterValues({required this.productBloc, required this.productsFilterValues});

  @override
  State<_AddEditProductsFilterValues> createState() => __AddEditProductsFilterValuesState();
}

class __AddEditProductsFilterValuesState extends State<_AddEditProductsFilterValues> {
  late bool _isManufacturerSelected;
  late TextEditingController _manufacturerController;

  late bool _isSupplierSelected;
  late TextEditingController _supplierController;

  late bool _isOutletSelected;
  late bool _isOutlet;

  late bool _isSetSelected;
  late bool _isSet;

  late bool _isPartOfSetSelected;
  late bool _isPartOfSet;

  late bool _isSaleSelected;
  late bool _isSale;

  late bool _isActiveSelected;
  late bool _isActive;

  @override
  void initState() {
    super.initState();

    _isManufacturerSelected = widget.productsFilterValues.manufacturer != null ? true : false;
    _manufacturerController = TextEditingController(text: widget.productsFilterValues.manufacturer);

    _isSupplierSelected = widget.productsFilterValues.supplier != null ? true : false;
    _supplierController = TextEditingController(text: widget.productsFilterValues.supplier);

    _isOutletSelected = widget.productsFilterValues.isOutlet != null ? true : false;
    _isOutlet = widget.productsFilterValues.isOutlet ?? true;

    _isSetSelected = widget.productsFilterValues.isSet != null ? true : false;
    _isSet = widget.productsFilterValues.isSet ?? true;

    _isPartOfSetSelected = widget.productsFilterValues.isPartOfSet != null ? true : false;
    _isPartOfSet = widget.productsFilterValues.isPartOfSet ?? true;

    _isSaleSelected = widget.productsFilterValues.isSale != null ? true : false;
    _isSale = widget.productsFilterValues.isSale ?? true;

    _isActiveSelected = widget.productsFilterValues.isActive != null ? true : false;
    _isActive = widget.productsFilterValues.isActive ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: max(MediaQuery.paddingOf(context).bottom, 24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox.adaptive(
                value: _isManufacturerSelected,
                onChanged: (value) => setState(() => _isManufacturerSelected = value!),
              ),
              const Text('Hersteller', style: TextStyles.defaultBold),
            ],
          ),
          MyAnimatedExpansionContainer(
            isExpanded: _isManufacturerSelected,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: MyTextFormFieldSmall(controller: _manufacturerController),
            ),
          ),
          Row(
            children: [
              Checkbox.adaptive(
                value: _isSupplierSelected,
                onChanged: (value) => setState(() => _isSupplierSelected = value!),
              ),
              const Text('Lieferant', style: TextStyles.defaultBold),
            ],
          ),
          MyAnimatedExpansionContainer(
            isExpanded: _isSupplierSelected,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: MyTextFormFieldSmall(controller: _supplierController),
            ),
          ),
          Row(
            children: [
              Checkbox.adaptive(
                value: _isOutletSelected,
                onChanged: (value) => setState(() => _isOutletSelected = value!),
              ),
              const Text('Auslaufartikel', style: TextStyles.defaultBold),
            ],
          ),
          MyAnimatedExpansionContainer(
            isExpanded: _isOutletSelected,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(_isOutlet ? 'Es werden ausschließlich Auslaufartikel angezeigt' : 'Auslaufartikel werden ausgeblendet')),
                  Switch.adaptive(value: _isOutlet, onChanged: (value) => setState(() => _isOutlet = value)),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Checkbox.adaptive(
                value: _isSetSelected,
                onChanged: (value) => setState(() => _isSetSelected = value!),
              ),
              const Text('Set-Artikel', style: TextStyles.defaultBold),
            ],
          ),
          MyAnimatedExpansionContainer(
            isExpanded: _isSetSelected,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(_isSet ? 'Es werden ausschließlich Set-Artikel angezeigt' : 'Set-Artikel werden ausgeblendet')),
                  Switch.adaptive(value: _isSet, onChanged: (value) => setState(() => _isSet = value)),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Checkbox.adaptive(
                value: _isPartOfSetSelected,
                onChanged: (value) => setState(() => _isPartOfSetSelected = value!),
              ),
              const Text('Set-Bestandteil-Artikel', style: TextStyles.defaultBold),
            ],
          ),
          MyAnimatedExpansionContainer(
            isExpanded: _isPartOfSetSelected,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(_isPartOfSet
                          ? 'Es werden ausschließlich Set-Bestandteil-Artikel angezeigt'
                          : 'Set-Bestandteil-Artikel werden ausgeblendet')),
                  Switch.adaptive(value: _isPartOfSet, onChanged: (value) => setState(() => _isPartOfSet = value)),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Checkbox.adaptive(
                value: _isSaleSelected,
                onChanged: (value) => setState(() => _isSaleSelected = value!),
              ),
              const Text('Rabattierte Artikel', style: TextStyles.defaultBold),
            ],
          ),
          MyAnimatedExpansionContainer(
            isExpanded: _isSaleSelected,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(_isSale ? 'Es werden ausschließlich Rabattierte Artikel angezeigt' : 'Rabattierte Artikel werden ausgeblendet')),
                  Switch.adaptive(value: _isSale, onChanged: (value) => setState(() => _isSale = value)),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Checkbox.adaptive(
                value: _isActiveSelected,
                onChanged: (value) => setState(() => _isActiveSelected = value!),
              ),
              const Text('Aktive Artikel', style: TextStyles.defaultBold),
            ],
          ),
          MyAnimatedExpansionContainer(
            isExpanded: _isActiveSelected,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(_isActive ? 'Es werden ausschließlich aktive Artikel angezeigt' : 'Aktive Artikel werden ausgeblendet')),
                  Switch.adaptive(value: _isActive, onChanged: (value) => setState(() => _isActive = value)),
                ],
              ),
            ),
          ),
          Gaps.h32,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      widget.productBloc.add(GetProductsPerPageEvent(
                        isFirstLoad: false,
                        calcCount: true,
                        currentPage: 1,
                        productsFilterValues: ProductsFilterValues.empty(),
                      ));
            
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
          ),
        ],
      ),
    );
  }

  void _onSavePressed() {
    final newFilters = ProductsFilterValues(
      manufacturer: _isManufacturerSelected && _manufacturerController.text.isNotEmpty ? _manufacturerController.text : null,
      supplier: _isSupplierSelected && _supplierController.text.isNotEmpty ? _supplierController.text : null,
      isOutlet: _isOutletSelected ? _isOutlet : null,
      isSet: _isSetSelected ? _isSet : null,
      isPartOfSet: _isPartOfSetSelected ? _isPartOfSet : null,
      isSale: _isSaleSelected ? _isSale : null,
      isActive: _isActiveSelected ? _isActive : null,
    );

    widget.productBloc.add(GetProductsPerPageEvent(isFirstLoad: false, calcCount: true, currentPage: 1, productsFilterValues: newFilters));

    Navigator.of(context).pop();
  }
}
