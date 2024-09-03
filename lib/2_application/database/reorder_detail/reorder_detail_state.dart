part of 'reorder_detail_bloc.dart';

class ReorderDetailState {
  final Reorder? reorder;
  final Supplier? supplier;
  final List<Product>? listOfProducts;
  final List<Product>? listOfFilteredProducts;
  final List<AbstractMarketplace>? listOfMarketplaces;
  final List<ProductSalesData>? listOfProductSalesData;
  final List<ProductSalesData>? listOfProductSalesDataInklOpen;
  final AbstractFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingReorderDetailOnObserve;
  final bool isLoadingOnCreateReorder;
  final bool isLoadingOnUpdateReorder;
  final bool isLoadingOnObserveReorderDetailProducts;
  final bool isLoadingPdfData;
  final Option<Either<AbstractFailure, Unit>> fosReorderDetailOnObserveOption;
  final Option<Either<AbstractFailure, Reorder>> fosReorderDetailOnCreateOption;
  final Option<Either<AbstractFailure, Reorder>> fosReorderDetailOnOUpdateOption;
  final Option<Either<AbstractFailure, List<Product>>> fosReorderDetailOnObserveProductsOption;
  final Option<Either<AbstractFailure, List<AbstractMarketplace>>> fosReorderDetailOnPdfDataOption;

  //* Helper
  final DateTimeRange? statProductDateRange;
  final bool reloadProducts;
  final bool getAllProducts;

  //* Controllers
  final TextEditingController discountPercentController;
  final TextEditingController discountAmountGrossController;
  final TextEditingController additionalAmountGrossController;
  final TextEditingController shippingPriceGrossController;

  final TextEditingController reorderNumberInternalController;

  //* Controllers Products
  final List<bool> isEditable;
  final List<Tax> taxRulesList;
  final List<TextEditingController> articleNumberControllers;
  final List<TextEditingController> articleNameControllers;
  final List<TextEditingController> quantityControllers;
  final List<TextEditingController> wholesalePriceNetControllers;

  final TextEditingController productSearchController;

  const ReorderDetailState({
    required this.reorder,
    required this.supplier,
    required this.listOfProducts,
    required this.listOfFilteredProducts,
    required this.listOfMarketplaces,
    required this.listOfProductSalesData,
    required this.listOfProductSalesDataInklOpen,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingReorderDetailOnObserve,
    required this.isLoadingOnCreateReorder,
    required this.isLoadingOnUpdateReorder,
    required this.isLoadingOnObserveReorderDetailProducts,
    required this.isLoadingPdfData,
    required this.fosReorderDetailOnObserveOption,
    required this.fosReorderDetailOnCreateOption,
    required this.fosReorderDetailOnOUpdateOption,
    required this.fosReorderDetailOnObserveProductsOption,
    required this.fosReorderDetailOnPdfDataOption,
    required this.statProductDateRange,
    required this.reloadProducts,
    required this.getAllProducts,
    required this.discountPercentController,
    required this.discountAmountGrossController,
    required this.additionalAmountGrossController,
    required this.shippingPriceGrossController,
    required this.reorderNumberInternalController,
    required this.isEditable,
    required this.taxRulesList,
    required this.articleNumberControllers,
    required this.articleNameControllers,
    required this.quantityControllers,
    required this.wholesalePriceNetControllers,
    required this.productSearchController,
  });

  factory ReorderDetailState.initial() {
    return ReorderDetailState(
      reorder: null,
      supplier: null,
      listOfProducts: null,
      listOfFilteredProducts: null,
      listOfMarketplaces: null,
      listOfProductSalesData: null,
      listOfProductSalesDataInklOpen: null,
      firebaseFailure: null,
      isAnyFailure: false,
      isLoadingReorderDetailOnObserve: false,
      isLoadingOnCreateReorder: false,
      isLoadingOnUpdateReorder: false,
      isLoadingOnObserveReorderDetailProducts: false,
      isLoadingPdfData: false,
      fosReorderDetailOnObserveOption: none(),
      fosReorderDetailOnCreateOption: none(),
      fosReorderDetailOnOUpdateOption: none(),
      fosReorderDetailOnObserveProductsOption: none(),
      fosReorderDetailOnPdfDataOption: none(),
      statProductDateRange: null,
      reloadProducts: false,
      getAllProducts: false,
      discountPercentController: TextEditingController(),
      discountAmountGrossController: TextEditingController(),
      additionalAmountGrossController: TextEditingController(),
      shippingPriceGrossController: TextEditingController(),
      reorderNumberInternalController: TextEditingController(),
      isEditable: [],
      taxRulesList: [],
      articleNumberControllers: [],
      articleNameControllers: [],
      quantityControllers: [],
      wholesalePriceNetControllers: [],
      productSearchController: TextEditingController(),
    );
  }

  ReorderDetailState copyWith({
    Reorder? reorder,
    Supplier? supplier,
    List<Product>? listOfProducts,
    List<Product>? listOfFilteredProducts,
    List<AbstractMarketplace>? listOfMarketplaces,
    List<ProductSalesData>? listOfProductSalesData,
    List<ProductSalesData>? listOfProductSalesDataInklOpen,
    AbstractFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingReorderDetailOnObserve,
    bool? isLoadingOnCreateReorder,
    bool? isLoadingOnUpdateReorder,
    bool? isLoadingOnObserveReorderDetailProducts,
    bool? isLoadingPdfData,
    Option<Either<AbstractFailure, Unit>>? fosReorderDetailOnObserveOption,
    Option<Either<AbstractFailure, Reorder>>? fosReorderDetailOnCreateOption,
    Option<Either<AbstractFailure, Reorder>>? fosReorderDetailOnOUpdateOption,
    Option<Either<AbstractFailure, List<Product>>>? fosReorderDetailOnObserveProductsOption,
    Option<Either<AbstractFailure, List<AbstractMarketplace>>>? fosReorderDetailOnPdfDataOption,
    DateTimeRange? statProductDateRange,
    bool? reloadProducts,
    bool? getAllProducts,
    TextEditingController? discountPercentController,
    TextEditingController? discountAmountGrossController,
    TextEditingController? additionalAmountGrossController,
    TextEditingController? shippingPriceGrossController,
    TextEditingController? reorderNumberInternalController,
    List<bool>? isEditable,
    List<Tax>? taxRulesList,
    List<TextEditingController>? articleNumberControllers,
    List<TextEditingController>? articleNameControllers,
    List<TextEditingController>? quantityControllers,
    List<TextEditingController>? wholesalePriceNetControllers,
    TextEditingController? productSearchController,
  }) {
    return ReorderDetailState(
      reorder: reorder ?? this.reorder,
      supplier: supplier ?? this.supplier,
      listOfProducts: listOfProducts ?? this.listOfProducts,
      listOfFilteredProducts: listOfFilteredProducts ?? this.listOfFilteredProducts,
      listOfMarketplaces: listOfMarketplaces ?? this.listOfMarketplaces,
      listOfProductSalesData: listOfProductSalesData ?? this.listOfProductSalesData,
      listOfProductSalesDataInklOpen: listOfProductSalesDataInklOpen ?? this.listOfProductSalesDataInklOpen,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingReorderDetailOnObserve: isLoadingReorderDetailOnObserve ?? this.isLoadingReorderDetailOnObserve,
      isLoadingOnCreateReorder: isLoadingOnCreateReorder ?? this.isLoadingOnCreateReorder,
      isLoadingOnUpdateReorder: isLoadingOnUpdateReorder ?? this.isLoadingOnUpdateReorder,
      isLoadingOnObserveReorderDetailProducts: isLoadingOnObserveReorderDetailProducts ?? this.isLoadingOnObserveReorderDetailProducts,
      isLoadingPdfData: isLoadingPdfData ?? this.isLoadingPdfData,
      fosReorderDetailOnObserveOption: fosReorderDetailOnObserveOption ?? this.fosReorderDetailOnObserveOption,
      fosReorderDetailOnCreateOption: fosReorderDetailOnCreateOption ?? this.fosReorderDetailOnCreateOption,
      fosReorderDetailOnOUpdateOption: fosReorderDetailOnOUpdateOption ?? this.fosReorderDetailOnOUpdateOption,
      fosReorderDetailOnObserveProductsOption: fosReorderDetailOnObserveProductsOption ?? this.fosReorderDetailOnObserveProductsOption,
      fosReorderDetailOnPdfDataOption: fosReorderDetailOnPdfDataOption ?? this.fosReorderDetailOnPdfDataOption,
      statProductDateRange: statProductDateRange ?? this.statProductDateRange,
      reloadProducts: reloadProducts ?? this.reloadProducts,
      getAllProducts: getAllProducts ?? this.getAllProducts,
      discountPercentController: discountPercentController ?? this.discountPercentController,
      discountAmountGrossController: discountAmountGrossController ?? this.discountAmountGrossController,
      additionalAmountGrossController: additionalAmountGrossController ?? this.additionalAmountGrossController,
      shippingPriceGrossController: shippingPriceGrossController ?? this.shippingPriceGrossController,
      reorderNumberInternalController: reorderNumberInternalController ?? this.reorderNumberInternalController,
      isEditable: isEditable ?? this.isEditable,
      taxRulesList: taxRulesList ?? this.taxRulesList,
      articleNumberControllers: articleNumberControllers ?? this.articleNumberControllers,
      articleNameControllers: articleNameControllers ?? this.articleNameControllers,
      quantityControllers: quantityControllers ?? this.quantityControllers,
      wholesalePriceNetControllers: wholesalePriceNetControllers ?? this.wholesalePriceNetControllers,
      productSearchController: productSearchController ?? this.productSearchController,
    );
  }
}
