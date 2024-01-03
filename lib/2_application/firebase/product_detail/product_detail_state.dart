part of 'product_detail_bloc.dart';

class ProductDetailState {
  final Product? product;
  final List<Supplier>? listOfSuppliers;
  final List<Marketplace>? listOfNotSynchronizedMarketplaces;
  final MainSettings? mainSettings;
  final FirebaseFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingProductOnObserve;
  final bool isLoadingProductOnUpdate;
  final bool isLoadingProductOnUpdateImages;
  final bool isLoadingProductOnUploadImages;
  final bool isLoadingProductOnDelete;
  final bool isLoadingProductSuppliersOnObseve;
  final bool isLoadingProductMarketplacesOnObseve;
  final bool isLoadingProductOnCreateInMarketplaces;
  final Option<Either<FirebaseFailure, Product>> fosProductOnObserveOption;
  final Option<Either<FirebaseFailure, Unit>> fosProductOnUpdateOption;
  final Option<Either<FirebaseFailure, Product>> fosProductOnUpdateImagesOption;
  final Option<Either<FirebaseFailure, Unit>> fosProductOnDeleteOption;
  final Option<Either<FirebaseFailure, List<Supplier>>> fosProductSuppliersOnObserveOption;
  final Option<Either<FirebaseFailure, List<Marketplace>>> fosProductMarketplacesOnObserveOption;
  final Option<Either<PrestaFailure, Unit>> fosProductOnUploadImagesInMarketplaceOption;
  final Option<Either<PrestaFailure, Unit>> fosProductOnUpdateInMarketplaceOption;
  final Option<Either<PrestaFailure, ProductPresta>> fosProductOnCreateInMarketplaceOption;

  //* Chart
  final List<StatProduct>? listOfStatProducts;
  final bool isShowingSalesVolumeOnChart;
  final bool isLoadingStatProductsOnObserve;
  final FirebaseFailure? firebaseFailureChart;
  //* Helpers
  final bool isDescriptionSetFirstTime;
  final bool isDescriptionChanged;
  final bool showHtmlTexts;
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

  ProductDetailState({
    required this.product,
    required this.listOfSuppliers,
    required this.listOfNotSynchronizedMarketplaces,
    required this.mainSettings,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingProductOnObserve,
    required this.isLoadingProductOnUpdate,
    required this.isLoadingProductOnUpdateImages,
    required this.isLoadingProductOnUploadImages,
    required this.isLoadingProductOnDelete,
    required this.isLoadingProductSuppliersOnObseve,
    required this.isLoadingProductMarketplacesOnObseve,
    required this.isLoadingProductOnCreateInMarketplaces,
    required this.fosProductOnObserveOption,
    required this.fosProductOnUpdateOption,
    required this.fosProductOnUpdateImagesOption,
    required this.fosProductOnDeleteOption,
    required this.fosProductSuppliersOnObserveOption,
    required this.fosProductMarketplacesOnObserveOption,
    required this.fosProductOnUploadImagesInMarketplaceOption,
    required this.fosProductOnUpdateInMarketplaceOption,
    required this.fosProductOnCreateInMarketplaceOption,
    required this.listOfStatProducts,
    required this.isShowingSalesVolumeOnChart,
    required this.isLoadingStatProductsOnObserve,
    required this.firebaseFailureChart,
    required this.isDescriptionSetFirstTime,
    required this.isDescriptionChanged,
    required this.showHtmlTexts,
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

  factory ProductDetailState.initial() {
    return ProductDetailState(
      product: null,
      listOfSuppliers: null,
      listOfNotSynchronizedMarketplaces: null,
      mainSettings: null,
      firebaseFailure: null,
      isAnyFailure: false,
      isLoadingProductOnObserve: false,
      isLoadingProductOnUpdate: false,
      isLoadingProductOnUpdateImages: false,
      isLoadingProductOnUploadImages: false,
      isLoadingProductOnDelete: false,
      isLoadingProductSuppliersOnObseve: false,
      isLoadingProductMarketplacesOnObseve: false,
      isLoadingProductOnCreateInMarketplaces: false,
      fosProductOnObserveOption: none(),
      fosProductOnUpdateOption: none(),
      fosProductOnUpdateImagesOption: none(),
      fosProductOnDeleteOption: none(),
      fosProductSuppliersOnObserveOption: none(),
      fosProductMarketplacesOnObserveOption: none(),
      fosProductOnUploadImagesInMarketplaceOption: none(),
      fosProductOnUpdateInMarketplaceOption: none(),
      fosProductOnCreateInMarketplaceOption: none(),
      listOfStatProducts: null,
      isShowingSalesVolumeOnChart: true,
      isLoadingStatProductsOnObserve: false,
      firebaseFailureChart: null,
      isDescriptionSetFirstTime: true,
      isDescriptionChanged: false,
      showHtmlTexts: false,
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

  ProductDetailState copyWith({
    Product? product,
    List<Supplier>? listOfSuppliers,
    List<Marketplace>? listOfNotSynchronizedMarketplaces,
    MainSettings? mainSettings,
    FirebaseFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingProductOnObserve,
    bool? isLoadingProductOnUpdate,
    bool? isLoadingProductOnUpdateImages,
    bool? isLoadingProductOnUploadImages,
    bool? isLoadingProductOnDelete,
    bool? isLoadingProductSuppliersOnObseve,
    bool? isLoadingProductMarketplacesOnObseve,
    bool? isLoadingProductOnCreateInMarketplaces,
    Option<Either<FirebaseFailure, Product>>? fosProductOnObserveOption,
    Option<Either<FirebaseFailure, Unit>>? fosProductOnUpdateOption,
    Option<Either<FirebaseFailure, Product>>? fosProductOnUpdateImagesOption,
    Option<Either<FirebaseFailure, Unit>>? fosProductOnDeleteOption,
    Option<Either<FirebaseFailure, List<Supplier>>>? fosProductSuppliersOnObserveOption,
    Option<Either<FirebaseFailure, List<Marketplace>>>? fosProductMarketplacesOnObserveOption,
    Option<Either<PrestaFailure, Unit>>? fosProductOnUploadImagesInMarketplaceOption,
    Option<Either<PrestaFailure, Unit>>? fosProductOnUpdateInMarketplaceOption,
    Option<Either<PrestaFailure, ProductPresta>>? fosProductOnCreateInMarketplaceOption,
    List<StatProduct>? listOfStatProducts,
    bool? isShowingSalesVolumeOnChart,
    bool? isLoadingStatProductsOnObserve,
    FirebaseFailure? firebaseFailureChart,
    bool? isDescriptionSetFirstTime,
    bool? isDescriptionChanged,
    bool? showHtmlTexts,
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
    return ProductDetailState(
      product: product ?? this.product,
      listOfSuppliers: listOfSuppliers ?? this.listOfSuppliers,
      listOfNotSynchronizedMarketplaces: listOfNotSynchronizedMarketplaces ?? this.listOfNotSynchronizedMarketplaces,
      mainSettings: mainSettings ?? this.mainSettings,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingProductOnObserve: isLoadingProductOnObserve ?? this.isLoadingProductOnObserve,
      isLoadingProductOnUpdate: isLoadingProductOnUpdate ?? this.isLoadingProductOnUpdate,
      isLoadingProductOnUpdateImages: isLoadingProductOnUpdateImages ?? this.isLoadingProductOnUpdateImages,
      isLoadingProductOnUploadImages: isLoadingProductOnUploadImages ?? this.isLoadingProductOnUploadImages,
      isLoadingProductOnDelete: isLoadingProductOnDelete ?? this.isLoadingProductOnDelete,
      isLoadingProductSuppliersOnObseve: isLoadingProductSuppliersOnObseve ?? this.isLoadingProductSuppliersOnObseve,
      isLoadingProductMarketplacesOnObseve: isLoadingProductMarketplacesOnObseve ?? this.isLoadingProductMarketplacesOnObseve,
      isLoadingProductOnCreateInMarketplaces: isLoadingProductOnCreateInMarketplaces ?? this.isLoadingProductOnCreateInMarketplaces,
      fosProductOnObserveOption: fosProductOnObserveOption ?? this.fosProductOnObserveOption,
      fosProductOnUpdateOption: fosProductOnUpdateOption ?? this.fosProductOnUpdateOption,
      fosProductOnUpdateImagesOption: fosProductOnUpdateImagesOption ?? this.fosProductOnUpdateImagesOption,
      fosProductOnDeleteOption: fosProductOnDeleteOption ?? this.fosProductOnDeleteOption,
      fosProductSuppliersOnObserveOption: fosProductSuppliersOnObserveOption ?? this.fosProductSuppliersOnObserveOption,
      fosProductMarketplacesOnObserveOption: fosProductMarketplacesOnObserveOption ?? this.fosProductMarketplacesOnObserveOption,
      fosProductOnUploadImagesInMarketplaceOption: fosProductOnUploadImagesInMarketplaceOption ?? this.fosProductOnUploadImagesInMarketplaceOption,
      fosProductOnUpdateInMarketplaceOption: fosProductOnUpdateInMarketplaceOption ?? this.fosProductOnUpdateInMarketplaceOption,
      fosProductOnCreateInMarketplaceOption: fosProductOnCreateInMarketplaceOption ?? this.fosProductOnCreateInMarketplaceOption,
      listOfStatProducts: listOfStatProducts ?? this.listOfStatProducts,
      isShowingSalesVolumeOnChart: isShowingSalesVolumeOnChart ?? this.isShowingSalesVolumeOnChart,
      isLoadingStatProductsOnObserve: isLoadingStatProductsOnObserve ?? this.isLoadingStatProductsOnObserve,
      firebaseFailureChart: firebaseFailureChart ?? this.firebaseFailureChart,
      isDescriptionSetFirstTime: isDescriptionSetFirstTime ?? this.isDescriptionSetFirstTime,
      isDescriptionChanged: isDescriptionChanged ?? this.isDescriptionChanged,
      showHtmlTexts: showHtmlTexts ?? this.showHtmlTexts,
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
