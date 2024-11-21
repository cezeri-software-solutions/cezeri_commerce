part of 'product_detail_bloc.dart';

class ProductDetailState {
  final Product? product;
  final Product? originalProduct;
  final List<AbstractMarketplace>? listOfNotSynchronizedMarketplaces;
  final MainSettings? mainSettings;
  final AbstractFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingProductOnObserve;
  final bool isLoadingProductsOnObserve;
  final bool isLoadingProductOnCreate;
  final bool isLoadingProductOnUpdate;
  final bool isLoadingProductOnUpdateImages;
  final bool isLoadingProductOnUploadImages;
  final bool isLoadingProductOnDelete;
  final bool isLoadingProductMarketplacesOnObseve;
  final bool isLoadingProductOnCreateInMarketplaces;
  final bool isLoadingOnDeleteMarketplaceFromProduct; // Aktuelle nicht genutz (Artikel wird im Marktplatz nicht gelöscht)
  final Option<Either<AbstractFailure, Product>> fosProductOnObserveOption;
  final Option<Either<AbstractFailure, List<Product>>> fosProductsOnObserveOption;
  final Option<Either<AbstractFailure, Product>> fosProductOnCreateOption;
  final Option<Either<AbstractFailure, Product>> fosProductOnUpdateOption;
  final Option<Either<AbstractFailure, Product>> fosProductOnUpdateImagesOption;
  final Option<Either<AbstractFailure, Unit>> fosProductOnDeleteOption;
  final Option<Either<AbstractFailure, List<AbstractMarketplace>>> fosProductMarketplacesOnObserveOption;
  final Option<Either<List<AbstractFailure>, Unit>> fosProductOnUploadImagesInMarketplaceOption;
  final Option<Either<List<AbstractFailure>, Unit>> fosProductOnUpdateInMarketplaceOption;
  final Option<Either<AbstractFailure, MarketplaceProduct>> fosProductOnCreateInMarketplaceOption;
  final Option<Either<List<AbstractFailure>, Unit>> fosProductAbstractFailuresOption;

  //* Chart
  final List<StatProduct>? listOfStatProducts;
  final List<ProductSalesData>? listOfProductSalesData;
  final bool isShowingSalesVolumeOnChart;
  final bool isLoadingStatProductsOnObserve;
  final AbstractFailure? firebaseFailureChart;
  //* Helpers
  final bool isDescriptionSetFirstTime;
  final bool isDescriptionChanged;
  final bool showHtmlTexts;
  final bool isSpecificPriceChanged;
  //* Set Article
  final ValueNotifier<int> pageIndexNotifierSetArticles;
  final bool isAllSetProductsSelected;
  final List<ProductIdWithQuantity> listOfSelectedProducts;
  final List<Product> listOfPartOfSetProducts;
  final List<Product>? listOfAllProducts;
  final List<Product>? listOfSetPartProducts;
  final List<Product> listOfFilteredProducts;
  final SearchController partOfSetProductSearchController;
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

  ProductDetailState({
    required this.product,
    required this.originalProduct,
    required this.listOfNotSynchronizedMarketplaces,
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
    required this.isLoadingProductMarketplacesOnObseve,
    required this.isLoadingProductOnCreateInMarketplaces,
    required this.isLoadingOnDeleteMarketplaceFromProduct,
    required this.fosProductOnObserveOption,
    required this.fosProductsOnObserveOption,
    required this.fosProductOnCreateOption,
    required this.fosProductOnUpdateOption,
    required this.fosProductOnUpdateImagesOption,
    required this.fosProductOnDeleteOption,
    required this.fosProductMarketplacesOnObserveOption,
    required this.fosProductOnUploadImagesInMarketplaceOption,
    required this.fosProductOnUpdateInMarketplaceOption,
    required this.fosProductOnCreateInMarketplaceOption,
    required this.fosProductAbstractFailuresOption,
    required this.listOfStatProducts,
    required this.listOfProductSalesData,
    required this.isShowingSalesVolumeOnChart,
    required this.isLoadingStatProductsOnObserve,
    required this.firebaseFailureChart,
    required this.isDescriptionSetFirstTime,
    required this.isDescriptionChanged,
    required this.showHtmlTexts,
    required this.isSpecificPriceChanged,
    required this.pageIndexNotifierSetArticles,
    required this.isAllSetProductsSelected,
    required this.listOfSelectedProducts,
    required this.listOfPartOfSetProducts,
    required this.listOfAllProducts,
    required this.listOfSetPartProducts,
    required this.listOfFilteredProducts,
    required this.partOfSetProductSearchController,
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
  });

  factory ProductDetailState.initial() {
    return ProductDetailState(
      product: null,
      originalProduct: null,
      listOfNotSynchronizedMarketplaces: null,
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
      isLoadingProductMarketplacesOnObseve: false,
      isLoadingProductOnCreateInMarketplaces: false,
      isLoadingOnDeleteMarketplaceFromProduct: false,
      fosProductOnObserveOption: none(),
      fosProductsOnObserveOption: none(),
      fosProductOnCreateOption: none(),
      fosProductOnUpdateOption: none(),
      fosProductOnUpdateImagesOption: none(),
      fosProductOnDeleteOption: none(),
      fosProductMarketplacesOnObserveOption: none(),
      fosProductOnUploadImagesInMarketplaceOption: none(),
      fosProductOnUpdateInMarketplaceOption: none(),
      fosProductOnCreateInMarketplaceOption: none(),
      fosProductAbstractFailuresOption: none(),
      listOfStatProducts: null,
      listOfProductSalesData: null,
      isShowingSalesVolumeOnChart: true,
      isLoadingStatProductsOnObserve: false,
      firebaseFailureChart: null,
      isDescriptionSetFirstTime: true,
      isDescriptionChanged: false,
      showHtmlTexts: false,
      isSpecificPriceChanged: false,
      pageIndexNotifierSetArticles: ValueNotifier(0),
      isAllSetProductsSelected: false,
      listOfSelectedProducts: [],
      listOfPartOfSetProducts: [],
      listOfAllProducts: null,
      listOfSetPartProducts: null,
      listOfFilteredProducts: [],
      partOfSetProductSearchController: SearchController(),
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
    );
  }

  ProductDetailState copyWith({
    Product? product,
    Product? originalProduct,
    List<AbstractMarketplace>? listOfNotSynchronizedMarketplaces,
    MainSettings? mainSettings,
    AbstractFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingProductOnObserve,
    bool? isLoadingProductsOnObserve,
    bool? isLoadingProductOnCreate,
    bool? isLoadingProductOnUpdate,
    bool? isLoadingProductOnUpdateImages,
    bool? isLoadingProductOnUploadImages,
    bool? isLoadingProductOnDelete,
    bool? isLoadingProductMarketplacesOnObseve,
    bool? isLoadingProductOnCreateInMarketplaces,
    bool? isLoadingOnDeleteMarketplaceFromProduct,
    Option<Either<AbstractFailure, Product>>? fosProductOnObserveOption,
    Option<Either<AbstractFailure, List<Product>>>? fosProductsOnObserveOption,
    Option<Either<AbstractFailure, Product>>? fosProductOnCreateOption,
    Option<Either<AbstractFailure, Product>>? fosProductOnUpdateOption,
    Option<Either<AbstractFailure, Product>>? fosProductOnUpdateImagesOption,
    Option<Either<AbstractFailure, Unit>>? fosProductOnDeleteOption,
    Option<Either<AbstractFailure, List<AbstractMarketplace>>>? fosProductMarketplacesOnObserveOption,
    Option<Either<List<AbstractFailure>, Unit>>? fosProductOnUploadImagesInMarketplaceOption,
    Option<Either<List<AbstractFailure>, Unit>>? fosProductOnUpdateInMarketplaceOption,
    Option<Either<AbstractFailure, MarketplaceProduct>>? fosProductOnCreateInMarketplaceOption,
    Option<Either<List<AbstractFailure>, Unit>>? fosProductAbstractFailuresOption,
    List<StatProduct>? listOfStatProducts,
    List<ProductSalesData>? listOfProductSalesData,
    bool? isShowingSalesVolumeOnChart,
    bool? isLoadingStatProductsOnObserve,
    AbstractFailure? firebaseFailureChart,
    bool? isDescriptionSetFirstTime,
    bool? isDescriptionChanged,
    bool? showHtmlTexts,
    bool? isSpecificPriceChanged,
    ValueNotifier<int>? pageIndexNotifierSetArticles,
    bool? isAllSetProductsSelected,
    List<ProductIdWithQuantity>? listOfSelectedProducts,
    List<Product>? listOfPartOfSetProducts,
    List<Product>? listOfAllProducts,
    List<Product>? listOfSetPartProducts,
    List<Product>? listOfFilteredProducts,
    SearchController? partOfSetProductSearchController,
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
  }) {
    return ProductDetailState(
      product: product ?? this.product,
      originalProduct: originalProduct ?? this.originalProduct,
      listOfNotSynchronizedMarketplaces: listOfNotSynchronizedMarketplaces ?? this.listOfNotSynchronizedMarketplaces,
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
      isLoadingProductMarketplacesOnObseve: isLoadingProductMarketplacesOnObseve ?? this.isLoadingProductMarketplacesOnObseve,
      isLoadingProductOnCreateInMarketplaces: isLoadingProductOnCreateInMarketplaces ?? this.isLoadingProductOnCreateInMarketplaces,
      isLoadingOnDeleteMarketplaceFromProduct: isLoadingOnDeleteMarketplaceFromProduct ?? this.isLoadingOnDeleteMarketplaceFromProduct,
      fosProductOnObserveOption: fosProductOnObserveOption ?? this.fosProductOnObserveOption,
      fosProductsOnObserveOption: fosProductsOnObserveOption ?? this.fosProductsOnObserveOption,
      fosProductOnCreateOption: fosProductOnCreateOption ?? this.fosProductOnCreateOption,
      fosProductOnUpdateOption: fosProductOnUpdateOption ?? this.fosProductOnUpdateOption,
      fosProductOnUpdateImagesOption: fosProductOnUpdateImagesOption ?? this.fosProductOnUpdateImagesOption,
      fosProductOnDeleteOption: fosProductOnDeleteOption ?? this.fosProductOnDeleteOption,
      fosProductMarketplacesOnObserveOption: fosProductMarketplacesOnObserveOption ?? this.fosProductMarketplacesOnObserveOption,
      fosProductOnUploadImagesInMarketplaceOption: fosProductOnUploadImagesInMarketplaceOption ?? this.fosProductOnUploadImagesInMarketplaceOption,
      fosProductOnUpdateInMarketplaceOption: fosProductOnUpdateInMarketplaceOption ?? this.fosProductOnUpdateInMarketplaceOption,
      fosProductOnCreateInMarketplaceOption: fosProductOnCreateInMarketplaceOption ?? this.fosProductOnCreateInMarketplaceOption,
      fosProductAbstractFailuresOption: fosProductAbstractFailuresOption ?? this.fosProductAbstractFailuresOption,
      listOfStatProducts: listOfStatProducts ?? this.listOfStatProducts,
      listOfProductSalesData: listOfProductSalesData ?? this.listOfProductSalesData,
      isShowingSalesVolumeOnChart: isShowingSalesVolumeOnChart ?? this.isShowingSalesVolumeOnChart,
      isLoadingStatProductsOnObserve: isLoadingStatProductsOnObserve ?? this.isLoadingStatProductsOnObserve,
      firebaseFailureChart: firebaseFailureChart ?? this.firebaseFailureChart,
      isDescriptionSetFirstTime: isDescriptionSetFirstTime ?? this.isDescriptionSetFirstTime,
      isDescriptionChanged: isDescriptionChanged ?? this.isDescriptionChanged,
      showHtmlTexts: showHtmlTexts ?? this.showHtmlTexts,
      isSpecificPriceChanged: isSpecificPriceChanged ?? this.isSpecificPriceChanged,
      pageIndexNotifierSetArticles: pageIndexNotifierSetArticles ?? this.pageIndexNotifierSetArticles,
      isAllSetProductsSelected: isAllSetProductsSelected ?? this.isAllSetProductsSelected,
      listOfSelectedProducts: listOfSelectedProducts ?? this.listOfSelectedProducts,
      listOfPartOfSetProducts: listOfPartOfSetProducts ?? this.listOfPartOfSetProducts,
      listOfAllProducts: listOfAllProducts ?? this.listOfAllProducts,
      listOfSetPartProducts: listOfSetPartProducts ?? this.listOfSetPartProducts,
      listOfFilteredProducts: listOfFilteredProducts ?? this.listOfFilteredProducts,
      partOfSetProductSearchController: partOfSetProductSearchController ?? this.partOfSetProductSearchController,
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
    );
  }
}
