part of 'product_bloc.dart';

@immutable
class ProductState {
  final Product? product;
  final List<Product>? listOfAllProducts;
  final List<Product>? listOfFilteredProducts; // Der State, der im presentation layer ausgegeben wird, egal ob Suchfeld leer oder nicht
  final List<Product> selectedProducts; // Ausgewählte Produkte zum löschen oder für Massenbearbeitung
  final List<Supplier>? listOfSuppliers;
  final List<Product> listOfNotUpdatedProductsOnMassEditing;
  final MainSettings? mainSettings;
  final FirebaseFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingProductOnObserve;
  final bool isLoadingProductsOnObserve;
  final bool isLoadingProductOnCreate;
  final bool isLoadingProductOnUpdate;
  final bool isLoadingProductOnUpdateImages;
  final bool isLoadingProductOnUploadImages;
  final bool isLoadingProductOnDelete;
  final bool isLoadingProductSuppliersOnObseve;
  final bool isLoadingProductOnMassEditing;
  final Option<Either<FirebaseFailure, Product>> fosProductOnObserveOption;
  final Option<Either<FirebaseFailure, List<Product>>> fosProductsOnObserveOption;
  final Option<Either<FirebaseFailure, Product>> fosProductOnCreateOption;
  final Option<Either<FirebaseFailure, Unit>> fosProductOnUpdateOption;
  final Option<Either<FirebaseFailure, Product>> fosProductOnUpdateImagesOption;
  final Option<Either<PrestaFailure, Unit>> fosProductOnUploadImagesOption;
  final Option<Either<FirebaseFailure, Unit>> fosProductOnDeleteOption;
  final Option<Either<FirebaseFailure, List<Supplier>>> fosProductSuppliersOnObserveOption;

  final bool isLoadingOnMassEditActivateProductMarketplace;
  final Option<Either<FirebaseFailure, Product>> fosProductOnUpdateQuantityOption;
  final Option<Either<FirebaseFailure, Unit>> fosMassEditActivateProductMarketplaceOption;
  final Option<Either<FirebaseFailure, Unit>> fosMassEditProductsOption;

  //* Prestashop States
  final Option<Either<PrestaFailure, Unit>> fosProductOnEditQuantityPrestaOption;
  //* Chart
  final List<StatProduct>? listOfStatProducts;
  final bool isShowingSalesVolumeOnChart;
  final bool isLoadingStatProductsOnObserve;
  final FirebaseFailure? firebaseFailureChart;
  //* Helpers
  final TextEditingController productSearchController;
  final bool isDescriptionSetFirstTime;
  final bool isDescriptionChanged;
  final bool triggerPop;
  final bool isWidthSearchActive;
  final bool isSelectedAllProducts;
  final bool showHtmlTexts;
  final int htmlTabValue;
  //* Product Images
  final bool isProductImagesEdited;
  final bool isSelectedAllImages;
  final List<ProductImage> selectedProductImages;
  final List<ProductImage> listOfProductImages;
  //* Controllers
  final TextEditingController articleNumberController;
  final TextEditingController eanController;
  final TextEditingController nameController;
  final TextEditingController wholesalePriceController;
  final TextEditingController supplierArticleNumberController;
  final TextEditingController manufacturerController;
  final TextEditingController minimumStockController;
  final TextEditingController minimumReorderQuantityController;
  final TextEditingController packagingUnitOnReorderController;
  final TextEditingController netPriceController;
  final TextEditingController grossPriceController;
  final TextEditingController recommendedRetailPriceController;
  final TextEditingController unityController;
  final TextEditingController unitPriceController;
  final TextEditingController weightController;
  final TextEditingController widthController;
  final TextEditingController heightController;
  final TextEditingController depthController;

  final HtmlEditorController descriptionController;
  final HtmlEditorController descriptionShortController;

  const ProductState({
    required this.product,
    required this.listOfAllProducts,
    required this.listOfFilteredProducts,
    required this.selectedProducts,
    required this.listOfSuppliers,
    required this.listOfNotUpdatedProductsOnMassEditing,
    required this.mainSettings,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingProductOnObserve,
    required this.isLoadingProductsOnObserve,
    required this.isLoadingProductOnCreate,
    required this.isLoadingProductOnUpdate,
    required this.isLoadingProductOnUpdateImages,
    required this.isLoadingProductOnUploadImages,
    required this.isLoadingProductOnDelete,
    required this.isLoadingProductSuppliersOnObseve,
    required this.isLoadingProductOnMassEditing,
    required this.fosProductOnObserveOption,
    required this.fosProductsOnObserveOption,
    required this.fosProductOnCreateOption,
    required this.fosProductOnUpdateOption,
    required this.fosProductOnUpdateImagesOption,
    required this.fosProductOnUploadImagesOption,
    required this.fosProductOnDeleteOption,
    required this.fosProductSuppliersOnObserveOption,
    required this.isLoadingOnMassEditActivateProductMarketplace,
    required this.fosProductOnUpdateQuantityOption,
    required this.fosMassEditActivateProductMarketplaceOption,
    required this.fosMassEditProductsOption,
    required this.fosProductOnEditQuantityPrestaOption,
    required this.listOfStatProducts,
    required this.isShowingSalesVolumeOnChart,
    required this.isLoadingStatProductsOnObserve,
    required this.firebaseFailureChart,
    required this.productSearchController,
    required this.isDescriptionSetFirstTime,
    required this.isDescriptionChanged,
    required this.triggerPop,
    required this.isWidthSearchActive,
    required this.isSelectedAllProducts,
    required this.showHtmlTexts,
    required this.htmlTabValue,
    required this.isProductImagesEdited,
    required this.isSelectedAllImages,
    required this.selectedProductImages,
    required this.listOfProductImages,
    required this.articleNumberController,
    required this.eanController,
    required this.nameController,
    required this.wholesalePriceController,
    required this.supplierArticleNumberController,
    required this.manufacturerController,
    required this.minimumStockController,
    required this.minimumReorderQuantityController,
    required this.packagingUnitOnReorderController,
    required this.netPriceController,
    required this.grossPriceController,
    required this.recommendedRetailPriceController,
    required this.unityController,
    required this.unitPriceController,
    required this.weightController,
    required this.widthController,
    required this.heightController,
    required this.depthController,
    required this.descriptionController,
    required this.descriptionShortController,
  });

  factory ProductState.initial() {
    return ProductState(
      product: null,
      listOfAllProducts: null,
      listOfFilteredProducts: null,
      selectedProducts: const [],
      listOfSuppliers: null,
      listOfNotUpdatedProductsOnMassEditing: const [],
      mainSettings: null,
      firebaseFailure: null,
      isAnyFailure: false,
      isLoadingProductOnObserve: false,
      isLoadingProductsOnObserve: false,
      isLoadingProductOnCreate: false,
      isLoadingProductOnUpdate: false,
      isLoadingProductOnUpdateImages: false,
      isLoadingProductOnUploadImages: false,
      isLoadingProductOnDelete: false,
      isLoadingProductSuppliersOnObseve: false,
      isLoadingProductOnMassEditing: false,
      fosProductOnObserveOption: none(),
      fosProductsOnObserveOption: none(),
      fosProductOnCreateOption: none(),
      fosProductOnUpdateOption: none(),
      fosProductOnUpdateImagesOption: none(),
      fosProductOnUploadImagesOption: none(),
      fosProductOnDeleteOption: none(),
      fosProductSuppliersOnObserveOption: none(),
      isLoadingOnMassEditActivateProductMarketplace: false,
      fosProductOnUpdateQuantityOption: none(),
      fosMassEditActivateProductMarketplaceOption: none(),
      fosMassEditProductsOption: none(),
      fosProductOnEditQuantityPrestaOption: none(),
      listOfStatProducts: null,
      isShowingSalesVolumeOnChart: true,
      isLoadingStatProductsOnObserve: false,
      firebaseFailureChart: null,
      productSearchController: TextEditingController(),
      isDescriptionSetFirstTime: true,
      isDescriptionChanged: false,
      triggerPop: false,
      isWidthSearchActive: false,
      isSelectedAllProducts: false,
      showHtmlTexts: false,
      htmlTabValue: 0,
      isProductImagesEdited: false,
      isSelectedAllImages: false,
      selectedProductImages: const [],
      listOfProductImages: const [],
      articleNumberController: TextEditingController(),
      eanController: TextEditingController(),
      nameController: TextEditingController(),
      wholesalePriceController: TextEditingController(),
      supplierArticleNumberController: TextEditingController(),
      manufacturerController: TextEditingController(),
      minimumStockController: TextEditingController(),
      minimumReorderQuantityController: TextEditingController(),
      packagingUnitOnReorderController: TextEditingController(),
      netPriceController: TextEditingController(),
      grossPriceController: TextEditingController(),
      recommendedRetailPriceController: TextEditingController(),
      unityController: TextEditingController(),
      unitPriceController: TextEditingController(),
      weightController: TextEditingController(),
      widthController: TextEditingController(),
      heightController: TextEditingController(),
      depthController: TextEditingController(),
      descriptionController: HtmlEditorController(),
      descriptionShortController: HtmlEditorController(),
    );
  }

  ProductState copyWith({
    Product? product,
    List<Product>? listOfAllProducts,
    List<Product>? listOfFilteredProducts,
    List<Product>? selectedProducts,
    List<Supplier>? listOfSuppliers,
    List<Product>? listOfNotUpdatedProductsOnMassEditing,
    MainSettings? mainSettings,
    FirebaseFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingProductOnObserve,
    bool? isLoadingProductsOnObserve,
    bool? isLoadingProductOnCreate,
    bool? isLoadingProductOnUpdate,
    bool? isLoadingProductOnUpdateImages,
    bool? isLoadingProductOnUploadImages,
    bool? isLoadingProductOnDelete,
    bool? isLoadingProductSuppliersOnObseve,
    bool? isLoadingProductOnMassEditing,
    Option<Either<FirebaseFailure, Product>>? fosProductOnObserveOption,
    Option<Either<FirebaseFailure, List<Product>>>? fosProductsOnObserveOption,
    Option<Either<FirebaseFailure, Product>>? fosProductOnCreateOption,
    Option<Either<FirebaseFailure, Unit>>? fosProductOnUpdateOption,
    Option<Either<FirebaseFailure, Product>>? fosProductOnUpdateImagesOption,
    Option<Either<PrestaFailure, Unit>>? fosProductOnUploadImagesOption,
    Option<Either<FirebaseFailure, Unit>>? fosProductOnDeleteOption,
    Option<Either<FirebaseFailure, List<Supplier>>>? fosProductSuppliersOnObserveOption,
    bool? isLoadingOnMassEditActivateProductMarketplace,
    Option<Either<FirebaseFailure, Product>>? fosProductOnUpdateQuantityOption,
    Option<Either<FirebaseFailure, Unit>>? fosMassEditActivateProductMarketplaceOption,
    Option<Either<FirebaseFailure, Unit>>? fosMassEditProductsOption,
    Option<Either<PrestaFailure, Unit>>? fosProductOnEditQuantityPrestaOption,
    List<StatProduct>? listOfStatProducts,
    bool? isShowingSalesVolumeOnChart,
    bool? isLoadingStatProductsOnObserve,
    FirebaseFailure? firebaseFailureChart,
    TextEditingController? productSearchController,
    bool? isDescriptionSetFirstTime,
    bool? isDescriptionChanged,
    bool? triggerPop,
    bool? isWidthSearchActive,
    bool? isSelectedAllProducts,
    bool? showHtmlTexts,
    int? htmlTabValue,
    bool? isProductImagesEdited,
    bool? isSelectedAllImages,
    List<ProductImage>? selectedProductImages,
    List<ProductImage>? listOfProductImages,
    TextEditingController? articleNumberController,
    TextEditingController? eanController,
    TextEditingController? nameController,
    TextEditingController? wholesalePriceController,
    TextEditingController? supplierArticleNumberController,
    TextEditingController? manufacturerController,
    TextEditingController? minimumStockController,
    TextEditingController? minimumReorderQuantityController,
    TextEditingController? packagingUnitOnReorderController,
    TextEditingController? netPriceController,
    TextEditingController? grossPriceController,
    TextEditingController? recommendedRetailPriceController,
    TextEditingController? unityController,
    TextEditingController? unitPriceController,
    TextEditingController? weightController,
    TextEditingController? widthController,
    TextEditingController? heightController,
    TextEditingController? depthController,
    HtmlEditorController? descriptionController,
    HtmlEditorController? descriptionShortController,
  }) {
    return ProductState(
      product: product ?? this.product,
      listOfAllProducts: listOfAllProducts ?? this.listOfAllProducts,
      listOfFilteredProducts: listOfFilteredProducts ?? this.listOfFilteredProducts,
      selectedProducts: selectedProducts ?? this.selectedProducts,
      listOfSuppliers: listOfSuppliers ?? this.listOfSuppliers,
      listOfNotUpdatedProductsOnMassEditing: listOfNotUpdatedProductsOnMassEditing ?? this.listOfNotUpdatedProductsOnMassEditing,
      mainSettings: mainSettings ?? this.mainSettings,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingProductOnObserve: isLoadingProductOnObserve ?? this.isLoadingProductOnObserve,
      isLoadingProductsOnObserve: isLoadingProductsOnObserve ?? this.isLoadingProductsOnObserve,
      isLoadingProductOnCreate: isLoadingProductOnCreate ?? this.isLoadingProductOnCreate,
      isLoadingProductOnUpdate: isLoadingProductOnUpdate ?? this.isLoadingProductOnUpdate,
      isLoadingProductOnUpdateImages: isLoadingProductOnUpdateImages ?? this.isLoadingProductOnUpdateImages,
      isLoadingProductOnUploadImages: isLoadingProductOnUploadImages ?? this.isLoadingProductOnUploadImages,
      isLoadingProductOnDelete: isLoadingProductOnDelete ?? this.isLoadingProductOnDelete,
      isLoadingProductSuppliersOnObseve: isLoadingProductSuppliersOnObseve ?? this.isLoadingProductSuppliersOnObseve,
      isLoadingProductOnMassEditing: isLoadingProductOnMassEditing ?? this.isLoadingProductOnMassEditing,
      fosProductOnObserveOption: fosProductOnObserveOption ?? this.fosProductOnObserveOption,
      fosProductsOnObserveOption: fosProductsOnObserveOption ?? this.fosProductsOnObserveOption,
      fosProductOnCreateOption: fosProductOnCreateOption ?? this.fosProductOnCreateOption,
      fosProductOnUpdateOption: fosProductOnUpdateOption ?? this.fosProductOnUpdateOption,
      fosProductOnUpdateImagesOption: fosProductOnUpdateImagesOption ?? this.fosProductOnUpdateImagesOption,
      fosProductOnUploadImagesOption: fosProductOnUploadImagesOption ?? this.fosProductOnUploadImagesOption,
      fosProductOnDeleteOption: fosProductOnDeleteOption ?? this.fosProductOnDeleteOption,
      fosProductSuppliersOnObserveOption: fosProductSuppliersOnObserveOption ?? this.fosProductSuppliersOnObserveOption,
      isLoadingOnMassEditActivateProductMarketplace:
          isLoadingOnMassEditActivateProductMarketplace ?? this.isLoadingOnMassEditActivateProductMarketplace,
      fosProductOnUpdateQuantityOption: fosProductOnUpdateQuantityOption ?? this.fosProductOnUpdateQuantityOption,
      fosMassEditActivateProductMarketplaceOption: fosMassEditActivateProductMarketplaceOption ?? this.fosMassEditActivateProductMarketplaceOption,
      fosMassEditProductsOption: fosMassEditProductsOption ?? this.fosMassEditProductsOption,
      fosProductOnEditQuantityPrestaOption: fosProductOnEditQuantityPrestaOption ?? this.fosProductOnEditQuantityPrestaOption,
      listOfStatProducts: listOfStatProducts ?? this.listOfStatProducts,
      isShowingSalesVolumeOnChart: isShowingSalesVolumeOnChart ?? this.isShowingSalesVolumeOnChart,
      isLoadingStatProductsOnObserve: isLoadingStatProductsOnObserve ?? this.isLoadingStatProductsOnObserve,
      firebaseFailureChart: firebaseFailureChart ?? this.firebaseFailureChart,
      productSearchController: productSearchController ?? this.productSearchController,
      isDescriptionSetFirstTime: isDescriptionSetFirstTime ?? this.isDescriptionSetFirstTime,
      isDescriptionChanged: isDescriptionChanged ?? this.isDescriptionChanged,
      triggerPop: triggerPop ?? this.triggerPop,
      isWidthSearchActive: isWidthSearchActive ?? this.isWidthSearchActive,
      isSelectedAllProducts: isSelectedAllProducts ?? this.isSelectedAllProducts,
      showHtmlTexts: showHtmlTexts ?? this.showHtmlTexts,
      htmlTabValue: htmlTabValue ?? this.htmlTabValue,
      isProductImagesEdited: isProductImagesEdited ?? this.isProductImagesEdited,
      isSelectedAllImages: isSelectedAllImages ?? this.isSelectedAllImages,
      selectedProductImages: selectedProductImages ?? this.selectedProductImages,
      listOfProductImages: listOfProductImages ?? this.listOfProductImages,
      articleNumberController: articleNumberController ?? this.articleNumberController,
      eanController: eanController ?? this.eanController,
      nameController: nameController ?? this.nameController,
      wholesalePriceController: wholesalePriceController ?? this.wholesalePriceController,
      supplierArticleNumberController: supplierArticleNumberController ?? this.supplierArticleNumberController,
      manufacturerController: manufacturerController ?? this.manufacturerController,
      minimumStockController: minimumStockController ?? this.minimumStockController,
      minimumReorderQuantityController: minimumReorderQuantityController ?? this.minimumReorderQuantityController,
      packagingUnitOnReorderController: packagingUnitOnReorderController ?? this.packagingUnitOnReorderController,
      netPriceController: netPriceController ?? this.netPriceController,
      grossPriceController: grossPriceController ?? this.grossPriceController,
      recommendedRetailPriceController: recommendedRetailPriceController ?? this.recommendedRetailPriceController,
      unityController: unityController ?? this.unityController,
      unitPriceController: unitPriceController ?? this.unitPriceController,
      weightController: weightController ?? this.weightController,
      widthController: widthController ?? this.widthController,
      heightController: heightController ?? this.heightController,
      depthController: depthController ?? this.depthController,
      descriptionController: descriptionController ?? this.descriptionController,
      descriptionShortController: descriptionShortController ?? this.descriptionShortController,
    );
  }
}
