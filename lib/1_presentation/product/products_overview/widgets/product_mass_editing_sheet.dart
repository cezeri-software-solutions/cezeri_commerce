import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:cezeri_commerce/failures/abstract_failure.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '/2_application/database/product/product_bloc.dart';
import '/3_domain/entities/marketplace/abstract_marketplace.dart';
import '/3_domain/entities/reorder/supplier.dart';
import '/constants.dart';
import '/routes/router.gr.dart';
import '../../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../../3_domain/entities/marketplace/marketplace_shopify.dart';
import '../../../../3_domain/repositories/database/marketplace_repository.dart';
import '../../../../3_domain/repositories/database/supplier_repository.dart';
import '../../../../3_domain/repositories/marketplace/marketplace_import_repository.dart';
import '../../../../4_infrastructur/repositories/prestashop_api/models/models.dart';
import '../../../../4_infrastructur/repositories/shopify_api/shopify.dart';

enum MassEditingOption { purchase, weightAndDimensions, addCategories, removeCategories }

void showProductMassEditingSheet(BuildContext context, ProductBloc productBloc) async {
  final pageIndexNotifier = ValueNotifier<int>(0);
  final selectedMarketplacesNotifier = ValueNotifier<List<AbstractMarketplace>>([]);
  final massEditingOptionNotifier = ValueNotifier<MassEditingOption>(MassEditingOption.purchase);

  void onMarketplacesSelected(List<AbstractMarketplace> listOfMarketplaces) {
    selectedMarketplacesNotifier.value = listOfMarketplaces;
    pageIndexNotifier.value = 1;
  }

  void onMassEditingOptionSelected(MassEditingOption massEditingOption) {
    massEditingOptionNotifier.value = massEditingOption;
    pageIndexNotifier.value = switch (massEditingOption) {
      MassEditingOption.purchase => 2,
      MassEditingOption.weightAndDimensions => 3,
      MassEditingOption.addCategories => 4,
      MassEditingOption.removeCategories => 5,
    };
  }

  Widget leadingWidget(int pageIndex) => Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => pageIndexNotifier.value = pageIndex,
        ),
      );

  if (!context.mounted) return;
  WoltModalSheet.show(
    context: context,
    useSafeArea: false,
    showDragHandle: false,
    pageIndexNotifier: pageIndexNotifier,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          topBarTitle: const Text('Marktplätze auswählen', style: TextStyles.h3Bold),
          isTopBarLayerAlwaysVisible: true,
          child: _SelectMarketplaces(productBloc: productBloc, onMarketplacesSelected: onMarketplacesSelected),
        ),
        WoltModalSheetPage(
          topBarTitle: const Text('Bearbeitungsmöglichkeiten', style: TextStyles.h3Bold),
          isTopBarLayerAlwaysVisible: true,
          leadingNavBarWidget: leadingWidget(0),
          child: ValueListenableBuilder(
            valueListenable: selectedMarketplacesNotifier,
            builder: (context, selectedMarketplaces, child) {
              return _SelectEditingOptions(
                productBloc: productBloc,
                selectedMarketplaces: selectedMarketplaces,
                onMassEditingOptionSelected: onMassEditingOptionSelected,
              );
            },
          ),
        ),
        WoltModalSheetPage(
          topBarTitle: const Text('Einkauf', style: TextStyles.h3Bold),
          isTopBarLayerAlwaysVisible: true,
          leadingNavBarWidget: leadingWidget(1),
          child: ValueListenableBuilder(
            valueListenable: selectedMarketplacesNotifier,
            builder: (context, selectedMarketplaces, child) {
              return _EditPurchasePage(productBloc: productBloc, selectedMarketplaces: selectedMarketplaces);
            },
          ),
        ),
        WoltModalSheetPage(
          topBarTitle: const Text('Gewicht & Abmessungen', style: TextStyles.h3Bold),
          isTopBarLayerAlwaysVisible: true,
          leadingNavBarWidget: leadingWidget(1),
          child: ValueListenableBuilder(
            valueListenable: selectedMarketplacesNotifier,
            builder: (context, selectedMarketplaces, child) {
              return _EditWeightAndDimensionsPage(productBloc: productBloc, selectedMarketplaces: selectedMarketplaces);
            },
          ),
        ),
        WoltModalSheetPage(
          topBarTitle: const Text('Kategorien hinzufügen', style: TextStyles.h3Bold),
          isTopBarLayerAlwaysVisible: true,
          forceMaxHeight: true,
          leadingNavBarWidget: leadingWidget(1),
          child: ValueListenableBuilder(
            valueListenable: selectedMarketplacesNotifier,
            builder: (context, selectedMarketplaces, child) => switch (selectedMarketplaces.first.marketplaceType) {
              MarketplaceType.prestashop => _SelectMarketplaceCategoriesPresta(
                  productBloc: productBloc,
                  marketplace: selectedMarketplaces.first as MarketplacePresta,
                  isAddCategories: true,
                ),
              MarketplaceType.shopify => _SelectMarketplaceCategoriesShopify(
                  productBloc: productBloc,
                  marketplace: selectedMarketplaces.first as MarketplaceShopify,
                  isAddCategories: true,
                ),
              MarketplaceType.shop => throw Exception('Ladengeschäft kann keine Kategorien haben.'),
            },
          ),
        ),
        WoltModalSheetPage(
          topBarTitle: const Text('Kategorien entfernen', style: TextStyles.h3Bold),
          isTopBarLayerAlwaysVisible: true,
          forceMaxHeight: true,
          leadingNavBarWidget: leadingWidget(1),
          child: ValueListenableBuilder(
            valueListenable: selectedMarketplacesNotifier,
            builder: (context, selectedMarketplaces, child) => switch (selectedMarketplaces.first.marketplaceType) {
              MarketplaceType.prestashop => _SelectMarketplaceCategoriesPresta(
                  productBloc: productBloc,
                  marketplace: selectedMarketplaces.first as MarketplacePresta,
                  isAddCategories: false,
                ),
              MarketplaceType.shopify => _SelectMarketplaceCategoriesShopify(
                  productBloc: productBloc,
                  marketplace: selectedMarketplaces.first as MarketplaceShopify,
                  isAddCategories: false,
                ),
              MarketplaceType.shop => throw Exception('Ladengeschäft kann keine Kategorien haben.'),
            },
          ),
        ),
      ];
    },
  );
}

//? ########################################################################################################################################
//? ########################################################################################################################################
//? ########################################################################################################################################

class _SelectMarketplaces extends StatefulWidget {
  final ProductBloc productBloc;
  final void Function(List<AbstractMarketplace>) onMarketplacesSelected;

  const _SelectMarketplaces({required this.productBloc, required this.onMarketplacesSelected});

  @override
  State<_SelectMarketplaces> createState() => __SelectMarketplacesState();
}

class __SelectMarketplacesState extends State<_SelectMarketplaces> {
  AbstractFailure? _abstractFailure;
  List<AbstractMarketplace>? _listOfMarketplaces;
  final List<AbstractMarketplace> _selectedMarketplaces = [];

  @override
  void initState() {
    super.initState();
    _getMarketplaces();
  }

  @override
  Widget build(BuildContext context) {
    if (_abstractFailure != null) {
      return const SizedBox(height: 300, child: Center(child: Text('Beim Laden der Marktplätze ist ein Fehler aufgetreten!')));
    }

    if (_listOfMarketplaces == null) return const SizedBox(height: 300, child: Center(child: MyCircularProgressIndicator()));

    _listOfMarketplaces = _listOfMarketplaces!.where((element) => element.marketplaceType != MarketplaceType.shop).toList();

    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: max(MediaQuery.paddingOf(context).bottom, 16) + 16),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Wenn du Kategorien in einem Marktplatz hinzufügen oder entfernen möchtest, musst du genau einen Marktplatz auswählen.'),
                Text('Ansonsten wird diese Option im nächsten Fenster nicht angezeigt.'),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _listOfMarketplaces!.length + 1,
            itemBuilder: (context, index) {
              if (index == _listOfMarketplaces!.length) {
                final value = _listOfMarketplaces!.every((e) => _selectedMarketplaces.any((f) => e.id == f.id));

                return ListTile(
                  title: const Text('Alle Marktplätze', style: TextStyles.h3Bold),
                  trailing: Checkbox.adaptive(
                    value: value,
                    onChanged: (_) {
                      setState(() => value ? _selectedMarketplaces.clear() : _selectedMarketplaces.addAll(_listOfMarketplaces!));
                    },
                  ),
                );
              }

              final marketplace = _listOfMarketplaces![index];
              final selectedIndex = _selectedMarketplaces.indexWhere((e) => e.id == marketplace.id);
              final isInList = selectedIndex != -1;

              return ListTile(
                title: Text(marketplace.name),
                trailing: Checkbox.adaptive(
                  value: isInList,
                  onChanged: (_) {
                    if (isInList) {
                      setState(() => _selectedMarketplaces.removeAt(selectedIndex));
                    } else {
                      setState(() => _selectedMarketplaces.add(marketplace));
                    }
                  },
                ),
              );
            },
          ),
          Gaps.h32,
          MyOutlinedButton(buttonText: 'Weiter', onPressed: () => widget.onMarketplacesSelected(_selectedMarketplaces)),
        ],
      ),
    );
  }

  void _getMarketplaces() async {
    final marketplaceRepository = GetIt.I<MarketplaceRepository>();
    final fos = await marketplaceRepository.getListOfMarketplaces();
    fos.fold(
      (failure) => setState(() => _abstractFailure = failure),
      (marketplaces) => setState(() => _listOfMarketplaces = marketplaces),
    );
  }
}

//? ########################################################################################################################################
//? ########################################################################################################################################
//? ########################################################################################################################################

class _SelectEditingOptions extends StatelessWidget {
  final ProductBloc productBloc;
  final List<AbstractMarketplace> selectedMarketplaces;
  final void Function(MassEditingOption) onMassEditingOptionSelected;

  const _SelectEditingOptions({required this.productBloc, required this.selectedMarketplaces, required this.onMassEditingOptionSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: max(MediaQuery.paddingOf(context).bottom, 16) + 16),
      child: Column(
        children: [
          MyOutlinedButton(
            buttonText: 'Einkauf',
            onPressed: () => onMassEditingOptionSelected(MassEditingOption.purchase),
          ),
          Gaps.h10,
          MyOutlinedButton(
            buttonText: 'Gewicht & Abmessungen',
            onPressed: () => onMassEditingOptionSelected(MassEditingOption.weightAndDimensions),
          ),
          if (selectedMarketplaces.length == 1) ...[
            Gaps.h10,
            MyOutlinedButton(
              buttonText: 'Kategorien hinzufügen',
              onPressed: () => onMassEditingOptionSelected(MassEditingOption.addCategories),
            ),
            Gaps.h10,
            MyOutlinedButton(
              buttonText: 'Kategorien entfernen',
              onPressed: () => onMassEditingOptionSelected(MassEditingOption.removeCategories),
            ),
          ],
        ],
      ),
    );
  }
}

//? ########################################################################################################################################
//? ########################################################################################################################################
//? ########################################################################################################################################

class _EditPurchasePage extends StatefulWidget {
  final ProductBloc productBloc;
  final List<AbstractMarketplace> selectedMarketplaces;

  const _EditPurchasePage({required this.productBloc, required this.selectedMarketplaces});

  @override
  State<_EditPurchasePage> createState() => _EditPurchasePageState();
}

class _EditPurchasePageState extends State<_EditPurchasePage> {
  final _wholesalePriceController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _minimumReorderQuantityController = TextEditingController();
  final _packagingUnitOnReorderController = TextEditingController();
  final _minimumStockController = TextEditingController();

  Supplier _supplier = Supplier.empty();
  List<Supplier>? _listOfSuppliers;

  bool _isWholesalePriceSelected = false;
  bool _isManufacturerSelected = false;
  bool _isSupplierSelected = false;
  bool _isMinimumReorderQuantitySelected = false;
  bool _isPackagingUnitOnReorderSelected = false;
  bool _isMinimumStockSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: max(MediaQuery.paddingOf(context).bottom, 16) + 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: MyTextFormFieldSmall(
                  fieldTitle: 'EK-Preis',
                  controller: _wholesalePriceController,
                  maxWidth: 100,
                  inputType: FieldInputType.double,
                ),
              ),
              Checkbox.adaptive(value: _isWholesalePriceSelected, onChanged: (value) => setState(() => _isWholesalePriceSelected = value!))
            ],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: MyButtonSmall(
                  labelText: 'Lieferant',
                  onTap: _listOfSuppliers == null
                      ? () => _getSuppliers()
                      : () => showDialog(
                            context: context,
                            builder: (_) => MyDialogSuppliers(
                              listOfSuppliers: _listOfSuppliers!,
                              onChanged: (supplier) => setState(() => _supplier = supplier),
                            ),
                          ),
                  child: Text(_supplier.company),
                ),
              ),
              Gaps.w16,
              Checkbox.adaptive(value: _isSupplierSelected, onChanged: (value) => setState(() => _isSupplierSelected = value!))
            ],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(child: MyTextFormFieldSmall(fieldTitle: 'Hersteller', controller: _manufacturerController)),
              Gaps.w16,
              Checkbox.adaptive(value: _isManufacturerSelected, onChanged: (value) => setState(() => _isManufacturerSelected = value!))
            ],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: MyTextFormFieldSmall(
                  fieldTitle: 'Mindestnachbestellmenge',
                  controller: _minimumReorderQuantityController,
                  inputType: FieldInputType.double,
                  maxWidth: 100,
                ),
              ),
              Checkbox.adaptive(
                value: _isMinimumReorderQuantitySelected,
                onChanged: (value) => setState(() => _isMinimumReorderQuantitySelected = value!),
              )
            ],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: MyTextFormFieldSmall(
                  fieldTitle: 'Verpackungseinheit',
                  controller: _packagingUnitOnReorderController,
                  inputType: FieldInputType.double,
                  maxWidth: 100,
                ),
              ),
              Checkbox.adaptive(
                value: _isPackagingUnitOnReorderSelected,
                onChanged: (value) => setState(() => _isPackagingUnitOnReorderSelected = value!),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                  child: MyTextFormFieldSmall(
                fieldTitle: 'Mindestbestand',
                controller: _minimumStockController,
                inputType: FieldInputType.double,
                maxWidth: 100,
              )),
              Checkbox.adaptive(value: _isMinimumStockSelected, onChanged: (value) => setState(() => _isMinimumStockSelected = value!))
            ],
          ),
          const Divider(),
          Gaps.h32,
          MyOutlinedButton(
            buttonText: 'Übernehmen',
            buttonBackgroundColor: Colors.green,
            onPressed: () {
              context.router.popUntilRouteWithName(ProductsOverviewRoute.name);
              widget.productBloc.add(
                ProductsMassEditingPurchaceUpdatedEvent(
                  selectedMarketplaces: widget.selectedMarketplaces,
                  wholesalePrice: _wholesalePriceController.text.toMyDouble(),
                  manufacturer: _manufacturerController.text,
                  supplier: _supplier,
                  minimumReorderQuantity: _minimumReorderQuantityController.text.toMyInt(),
                  packagingUnitOnReorder: _packagingUnitOnReorderController.text.toMyInt(),
                  minimumStock: _minimumStockController.text.toMyInt(),
                  isWholesalePriceSelected: _isWholesalePriceSelected,
                  isManufacturerSelected: _isManufacturerSelected,
                  isSupplierSelected: _isSupplierSelected,
                  isMinimumReorderQuantitySelected: _isMinimumReorderQuantitySelected,
                  isPackagingUnitOnReorderSelected: _isPackagingUnitOnReorderSelected,
                  isMinimumStockSelected: _isMinimumStockSelected,
                ),
              );
              showMyDialogLoading(context: context, text: 'Änderungen werden übernommen...', canPop: true);
            },
          ),
        ],
      ),
    );
  }

  void _getSuppliers() async {
    final supplierRepository = GetIt.I<SupplierRepository>();
    final fos = await supplierRepository.getListOfSuppliers();
    fos.fold(
      (failure) => setState(() => _listOfSuppliers = []),
      (suppliers) => setState(() => _listOfSuppliers = suppliers),
    );

    _showSelectSupplierDialog();
  }

  void _showSelectSupplierDialog() {
    showDialog(
      context: context,
      builder: (_) => MyDialogSuppliers(
        listOfSuppliers: _listOfSuppliers!,
        onChanged: (supplier) => setState(() => _supplier = supplier),
      ),
    );
  }
}

//? ########################################################################################################################################
//? ########################################################################################################################################
//? ########################################################################################################################################

class _EditWeightAndDimensionsPage extends StatefulWidget {
  final ProductBloc productBloc;
  final List<AbstractMarketplace> selectedMarketplaces;

  const _EditWeightAndDimensionsPage({required this.productBloc, required this.selectedMarketplaces});

  @override
  State<_EditWeightAndDimensionsPage> createState() => __EditWeightAndDimensionsPageState();
}

class __EditWeightAndDimensionsPageState extends State<_EditWeightAndDimensionsPage> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _depthController = TextEditingController();
  final _widthController = TextEditingController();

  bool _isWeightSelected = false;
  bool _isHeightSelected = false;
  bool _isDepthSelected = false;
  bool _isWidthSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: max(MediaQuery.paddingOf(context).bottom, 16) + 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: MyTextFormFieldSmall(
                fieldTitle: 'Gewicht kg',
                controller: _weightController,
                inputType: FieldInputType.double,
                maxWidth: 100,
              )),
              Checkbox.adaptive(value: _isWeightSelected, onChanged: (value) => setState(() => _isWeightSelected = value!))
            ],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                  child: MyTextFormFieldSmall(
                fieldTitle: 'Höhe cm',
                controller: _heightController,
                inputType: FieldInputType.double,
                maxWidth: 100,
              )),
              Checkbox.adaptive(value: _isHeightSelected, onChanged: (value) => setState(() => _isHeightSelected = value!))
            ],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                  child: MyTextFormFieldSmall(
                fieldTitle: 'Länge cm',
                controller: _depthController,
                inputType: FieldInputType.double,
                maxWidth: 100,
              )),
              Checkbox.adaptive(value: _isDepthSelected, onChanged: (value) => setState(() => _isDepthSelected = value!))
            ],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                  child: MyTextFormFieldSmall(
                fieldTitle: 'Breite cm',
                controller: _widthController,
                inputType: FieldInputType.double,
                maxWidth: 100,
              )),
              Checkbox.adaptive(value: _isWidthSelected, onChanged: (value) => setState(() => _isWidthSelected = value!))
            ],
          ),
          const Divider(),
          Gaps.h32,
          MyOutlinedButton(
            buttonText: 'Übernehmen',
            buttonBackgroundColor: Colors.green,
            onPressed: () {
              context.router.popUntilRouteWithName(ProductsOverviewRoute.name);
              widget.productBloc.add(
                ProductsMassEditingWeightAndDimensionsUpdatedEvent(
                  selectedMarketplaces: widget.selectedMarketplaces,
                  weight: _weightController.text.toMyDouble(),
                  height: _heightController.text.toMyDouble(),
                  depth: _depthController.text.toMyDouble(),
                  width: _widthController.text.toMyDouble(),
                  isWeightSelected: _isWeightSelected,
                  isHeightSelected: _isHeightSelected,
                  isDepthSelected: _isDepthSelected,
                  isWidthSelected: _isWidthSelected,
                ),
              );
              showMyDialogLoading(context: context, text: 'Änderungen werden übernommen...', canPop: true);
            },
          ),
        ],
      ),
    );
  }
}

//? ########################################################################################################################################
//? ########################################################################################################################################
//? ########################################################################################################################################

class _SelectMarketplaceCategoriesShopify extends StatefulWidget {
  final ProductBloc productBloc;
  final MarketplaceShopify marketplace;
  // Wenn true werden die ausgewählten Kategorien den Produkten hinzugefügt, ansonsten entfernt
  final bool isAddCategories;

  const _SelectMarketplaceCategoriesShopify({required this.productBloc, required this.marketplace, required this.isAddCategories});

  @override
  State<_SelectMarketplaceCategoriesShopify> createState() => __SelectMarketplaceCategoriesShopifyState();
}

class __SelectMarketplaceCategoriesShopifyState extends State<_SelectMarketplaceCategoriesShopify> {
  final _searchController = SearchController();

  AbstractFailure? _abstractFailure;
  List<CustomCollectionShopify>? _listOfAllCategories;
  final List<CustomCollectionShopify> _listOfSelectedCategories = [];
  List<CustomCollectionShopify> _listOfFilteredCategories = [];

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    if (_abstractFailure != null) {
      return const SizedBox(height: 300, child: Center(child: Text('Beim Laden der Marktplatzkategorien ist ein Fehler aufgetreten!')));
    }

    if (_listOfAllCategories == null) return const SizedBox(height: 300, child: Center(child: MyCircularProgressIndicator()));

    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: max(MediaQuery.paddingOf(context).bottom, 16) + 16),
      child: Column(
        children: [
          _SelectCategoriesHeader(
            marketplace: widget.marketplace,
            controller: _searchController,
            onSearchControllerChanged: _onSearchControllerChanged,
            onSearchControllerCleared: _onSearchControllerCleared,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _listOfSelectedCategories.length,
            itemBuilder: (context, index) {
              final category = _listOfSelectedCategories[index];
              return ListTile(
                leading: Checkbox.adaptive(
                  value: _listOfSelectedCategories.any((e) => e.id == category.id),
                  onChanged: (value) => _onCategoryIsSelectedChanged(value!, category.id),
                ),
                title: Text(category.title),
              );
            },
          ),
          if (_listOfSelectedCategories.isNotEmpty) ...[
            const Divider(),
            MyOutlinedButton(buttonText: 'Übernehmen', buttonBackgroundColor: Colors.green, onPressed: _onSavePressed),
            const Divider(),
          ],
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _listOfFilteredCategories.length,
            itemBuilder: (context, index) {
              final category = _listOfFilteredCategories[index];
              return ListTile(
                leading: Checkbox.adaptive(
                  value: _listOfSelectedCategories.any((e) => e.id == category.id),
                  onChanged: (value) => _onCategoryIsSelectedChanged(value!, category.id),
                ),
                title: Text(category.title),
              );
            },
          ),
        ],
      ),
    );
  }

  void _getCategories() async {
    final marketplaceImportRepository = GetIt.I<MarketplaceImportRepository>();
    final fos = await marketplaceImportRepository.getAllMarketplaceCategories(widget.marketplace);
    fos.fold(
      (failure) => setState(() => _abstractFailure = failure),
      (categories) => setState(() {
        _listOfAllCategories = (categories as List<CustomCollectionShopify>);
        _listOfFilteredCategories = categories;
      }),
    );
  }

  void _onSearchControllerChanged() {
    final nonSelectedList = _listOfAllCategories!.where((e) => !_listOfSelectedCategories.any((selected) => selected.id == e.id)).toList();
    final filteredList = nonSelectedList.where((e) => e.title.toLowerCase().contains(_searchController.text.toLowerCase())).toList();

    setState(() => _listOfFilteredCategories = filteredList);
  }

  void _onSearchControllerCleared() {
    _searchController.clear();
    final nonSelectedList = _listOfAllCategories!.where((e) => !_listOfSelectedCategories.any((selected) => selected.id == e.id)).toList();

    setState(() => _listOfFilteredCategories = nonSelectedList);
  }

  void _onCategoryIsSelectedChanged(bool value, int id) {
    if (value) {
      _listOfSelectedCategories.add(_listOfAllCategories!.where((e) => e.id == id).first);
    } else {
      _listOfSelectedCategories.remove(_listOfAllCategories!.where((e) => e.id == id).first);
    }

    if (_searchController.text.isEmpty) {
      _onSearchControllerCleared();
    } else {
      _onSearchControllerChanged();
    }
  }

  void _onSavePressed() {
    context.router.popUntilRouteWithName(ProductsOverviewRoute.name);
    widget.productBloc.add(
      ProductsMassEditingAddOrRemoveCategoriesShopifyEvent(
        marketplace: widget.marketplace,
        selectedCustomCollections: _listOfSelectedCategories,
        isAddCategories: widget.isAddCategories,
      ),
    );

    showMyDialogLoading(context: context, text: 'Änderungen werden übernommen...', canPop: true);
  }
}

//? ########################################################################################################################################

class _SelectMarketplaceCategoriesPresta extends StatefulWidget {
  final ProductBloc productBloc;
  final MarketplacePresta marketplace;
  // Wenn true werden die ausgewählten Kategorien den Produkten hinzugefügt, ansonsten entfernt
  final bool isAddCategories;

  const _SelectMarketplaceCategoriesPresta({required this.productBloc, required this.marketplace, required this.isAddCategories});

  @override
  State<_SelectMarketplaceCategoriesPresta> createState() => __SelectMarketplaceCategoriesPrestaState();
}

class __SelectMarketplaceCategoriesPrestaState extends State<_SelectMarketplaceCategoriesPresta> {
  final _searchController = SearchController();

  AbstractFailure? _abstractFailure;
  List<CategoryPresta>? _listOfAllCategories;
  final List<CategoryPresta> _listOfSelectedCategories = [];
  List<CategoryPresta> _listOfFilteredCategories = [];

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    if (_abstractFailure != null) {
      return const SizedBox(height: 300, child: Center(child: Text('Beim Laden der Marktplatzkategorien ist ein Fehler aufgetreten!')));
    }

    if (_listOfAllCategories == null) return const SizedBox(height: 300, child: Center(child: MyCircularProgressIndicator()));

    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: max(MediaQuery.paddingOf(context).bottom, 16) + 16),
      child: Column(
        children: [
          _SelectCategoriesHeader(
            marketplace: widget.marketplace,
            controller: _searchController,
            onSearchControllerChanged: _onSearchControllerChanged,
            onSearchControllerCleared: _onSearchControllerCleared,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _listOfSelectedCategories.length,
            itemBuilder: (context, index) {
              final category = _listOfSelectedCategories[index];
              return ListTile(
                leading: Checkbox.adaptive(
                  value: _listOfSelectedCategories.any((e) => e.id == category.id),
                  onChanged: (value) => _onCategoryIsSelectedChanged(value!, category.id),
                ),
                title: Text(category.name),
              );
            },
          ),
          if (_listOfSelectedCategories.isNotEmpty) ...[
            const Divider(),
            MyOutlinedButton(buttonText: 'Übernehmen', buttonBackgroundColor: Colors.green, onPressed: _onSavePressed),
            const Divider(),
          ],
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _listOfFilteredCategories.length,
            itemBuilder: (context, index) {
              final category = _listOfFilteredCategories[index];
              return ListTile(
                leading: Checkbox.adaptive(
                  value: _listOfSelectedCategories.any((e) => e.id == category.id),
                  onChanged: (value) => _onCategoryIsSelectedChanged(value!, category.id),
                ),
                title: Text(category.name),
              );
            },
          ),
        ],
      ),
    );
  }

  void _getCategories() async {
    final marketplaceImportRepository = GetIt.I<MarketplaceImportRepository>();
    final fos = await marketplaceImportRepository.getAllMarketplaceCategories(widget.marketplace);
    fos.fold(
      (failure) => setState(() => _abstractFailure = failure),
      (categories) => setState(() {
        _listOfAllCategories = (categories as List<CategoryPresta>);
        _listOfFilteredCategories = categories;
      }),
    );
  }

  void _onSearchControllerChanged() {
    final nonSelectedList = _listOfAllCategories!.where((e) => !_listOfSelectedCategories.any((selected) => selected.id == e.id)).toList();
    final filteredList = nonSelectedList.where((e) => e.name.toLowerCase().contains(_searchController.text.toLowerCase())).toList();

    setState(() => _listOfFilteredCategories = filteredList);
  }

  void _onSearchControllerCleared() {
    _searchController.clear();
    final nonSelectedList = _listOfAllCategories!.where((e) => !_listOfSelectedCategories.any((selected) => selected.id == e.id)).toList();

    setState(() => _listOfFilteredCategories = nonSelectedList);
  }

  void _onCategoryIsSelectedChanged(bool value, int id) {
    if (value) {
      _listOfSelectedCategories.add(_listOfAllCategories!.where((e) => e.id == id).first);
    } else {
      _listOfSelectedCategories.remove(_listOfAllCategories!.where((e) => e.id == id).first);
    }

    if (_searchController.text.isEmpty) {
      _onSearchControllerCleared();
    } else {
      _onSearchControllerChanged();
    }
  }

  void _onSavePressed() {
    context.router.popUntilRouteWithName(ProductsOverviewRoute.name);
    widget.productBloc.add(
      ProductsMassEditingAddOrRemoveCategoriesPrestaEvent(
        marketplace: widget.marketplace,
        selectedCategoriesPresta: _listOfSelectedCategories,
        isAddCategories: widget.isAddCategories,
      ),
    );

    showMyDialogLoading(context: context, text: 'Änderungen werden übernommen...', canPop: true);
  }
}

//? ########################################################################################################################################

class _SelectCategoriesHeader extends StatelessWidget {
  final AbstractMarketplace marketplace;
  final SearchController controller;
  final VoidCallback onSearchControllerChanged;
  final VoidCallback onSearchControllerCleared;

  const _SelectCategoriesHeader({
    required this.marketplace,
    required this.controller,
    required this.onSearchControllerChanged,
    required this.onSearchControllerCleared,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(height: 40, width: 40, child: SvgPicture.asset(getMarketplaceLogoAsset(marketplace.marketplaceType))),
              Gaps.w16,
              Text(marketplace.name, style: TextStyles.h3Bold),
            ],
          ),
          Gaps.h16,
          CupertinoSearchTextField(
            controller: controller,
            onChanged: (_) => onSearchControllerChanged(),
            onSuffixTap: onSearchControllerCleared,
          ),
        ],
      ),
    );
  }
}
