part of 'reorder_detail_bloc.dart';

class ReorderDetailState {
  final Reorder? reorder;
  final List<Product>? listOfProducts;
  final List<Product>? listOfFilteredProducts;
  final FirebaseFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingReorderDetailOnObserve;
  final bool isLoadingOnCreateReorder;
  final bool isLoadingOnUpdateReorder;
  final bool isLoadingOnObserveReorderDetailProducts;
  final Option<Either<FirebaseFailure, Unit>> fosReorderDetailOnObserveOption;
  final Option<Either<FirebaseFailure, Reorder>> fosReorderDetailOnCreateOption;
  final Option<Either<FirebaseFailure, Reorder>> fosReorderDetailOnOUpdateOption;
  final Option<Either<FirebaseFailure, List<Product>>> fosReorderDetailOnObserveProductsOption;

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
    required this.listOfProducts,
    required this.listOfFilteredProducts,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingReorderDetailOnObserve,
    required this.isLoadingOnCreateReorder,
    required this.isLoadingOnUpdateReorder,
    required this.isLoadingOnObserveReorderDetailProducts,
    required this.fosReorderDetailOnObserveOption,
    required this.fosReorderDetailOnCreateOption,
    required this.fosReorderDetailOnOUpdateOption,
    required this.fosReorderDetailOnObserveProductsOption,
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
      listOfProducts: null,
      listOfFilteredProducts: null,
      firebaseFailure: null,
      isAnyFailure: false,
      isLoadingReorderDetailOnObserve: false,
      isLoadingOnCreateReorder: false,
      isLoadingOnUpdateReorder: false,
      isLoadingOnObserveReorderDetailProducts: false,
      fosReorderDetailOnObserveOption: none(),
      fosReorderDetailOnCreateOption: none(),
      fosReorderDetailOnOUpdateOption: none(),
      fosReorderDetailOnObserveProductsOption: none(),
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
    List<Product>? listOfProducts,
    List<Product>? listOfFilteredProducts,
    FirebaseFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingReorderDetailOnObserve,
    bool? isLoadingOnCreateReorder,
    bool? isLoadingOnUpdateReorder,
    bool? isLoadingOnObserveReorderDetailProducts,
    Option<Either<FirebaseFailure, Unit>>? fosReorderDetailOnObserveOption,
    Option<Either<FirebaseFailure, Reorder>>? fosReorderDetailOnCreateOption,
    Option<Either<FirebaseFailure, Reorder>>? fosReorderDetailOnOUpdateOption,
    Option<Either<FirebaseFailure, List<Product>>>? fosReorderDetailOnObserveProductsOption,
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
      listOfProducts: listOfProducts ?? this.listOfProducts,
      listOfFilteredProducts: listOfFilteredProducts ?? this.listOfFilteredProducts,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingReorderDetailOnObserve: isLoadingReorderDetailOnObserve ?? this.isLoadingReorderDetailOnObserve,
      isLoadingOnCreateReorder: isLoadingOnCreateReorder ?? this.isLoadingOnCreateReorder,
      isLoadingOnUpdateReorder: isLoadingOnUpdateReorder ?? this.isLoadingOnUpdateReorder,
      isLoadingOnObserveReorderDetailProducts: isLoadingOnObserveReorderDetailProducts ?? this.isLoadingOnObserveReorderDetailProducts,
      fosReorderDetailOnObserveOption: fosReorderDetailOnObserveOption ?? this.fosReorderDetailOnObserveOption,
      fosReorderDetailOnCreateOption: fosReorderDetailOnCreateOption ?? this.fosReorderDetailOnCreateOption,
      fosReorderDetailOnOUpdateOption: fosReorderDetailOnOUpdateOption ?? this.fosReorderDetailOnOUpdateOption,
      fosReorderDetailOnObserveProductsOption: fosReorderDetailOnObserveProductsOption ?? this.fosReorderDetailOnObserveProductsOption,
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
