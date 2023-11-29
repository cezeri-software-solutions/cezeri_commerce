part of 'product_bloc.dart';

@immutable
class ProductState {
  final Product? product;
  final List<Product>? listOfAllProducts;
  final List<Product>? listOfFilteredProducts; // Der State, der im presentation layer ausgegeben wird, egal ob Suchfeld leer oder nicht
  final List<Product> selectedProducts; // Ausgewählte Produkte zum löschen oder für Massenbearbeitung
  final FirebaseFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingProductOnObserve;
  final bool isLoadingProductsOnObserve;
  final bool isLoadingProductOnCreate;
  final bool isLoadingProductOnUpdate;
  final bool isLoadingProductOnUpdateImages;
  final bool isLoadingProductOnUploadImages;
  final bool isLoadingProductOnDelete;
  final Option<Either<FirebaseFailure, Product>> fosProductOnObserveOption;
  final Option<Either<FirebaseFailure, List<Product>>> fosProductsOnObserveOption;
  final Option<Either<FirebaseFailure, Product>> fosProductOnCreateOption;
  final Option<Either<FirebaseFailure, Unit>> fosProductOnUpdateOption;
  final Option<Either<FirebaseFailure, Product>> fosProductOnUpdateImagesOption;
  final Option<Either<PrestaFailure, Unit>> fosProductOnUploadImagesOption;
  final Option<Either<FirebaseFailure, Unit>> fosProductOnDeleteOption;

  final bool isLoadingOnMassEditActivateProductMarketplace;
  final Option<Either<FirebaseFailure, Product>> fosProductOnUpdateQuantityOption;
  final Option<Either<FirebaseFailure, Unit>> fosMassEditActivateProductMarketplaceOption;

  //* Prestashop States
  final Option<Either<PrestaFailure, Unit>> fosProductOnEditQuantityPrestaOption;
  //* Helpers
  final TextEditingController productSearchController;
  final bool isDescriptionSetFirstTime;
  final bool isDescriptionChanged;
  final bool triggerPop;
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
  final TextEditingController supplierController;
  final TextEditingController supplierArticleNumberController;
  final TextEditingController manufacturerController;
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

  const ProductState({
    required this.product,
    required this.listOfAllProducts,
    required this.listOfFilteredProducts,
    required this.selectedProducts,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingProductOnObserve,
    required this.isLoadingProductsOnObserve,
    required this.isLoadingProductOnCreate,
    required this.isLoadingProductOnUpdate,
    required this.isLoadingProductOnUpdateImages,
    required this.isLoadingProductOnUploadImages,
    required this.isLoadingProductOnDelete,
    required this.fosProductOnObserveOption,
    required this.fosProductsOnObserveOption,
    required this.fosProductOnCreateOption,
    required this.fosProductOnUpdateOption,
    required this.fosProductOnUpdateImagesOption,
    required this.fosProductOnUploadImagesOption,
    required this.fosProductOnDeleteOption,
    required this.isLoadingOnMassEditActivateProductMarketplace,
    required this.fosProductOnUpdateQuantityOption,
    required this.fosMassEditActivateProductMarketplaceOption,
    required this.fosProductOnEditQuantityPrestaOption,
    required this.productSearchController,
    required this.isDescriptionSetFirstTime,
    required this.isDescriptionChanged,
    required this.triggerPop,
    required this.isProductImagesEdited,
    required this.isSelectedAllImages,
    required this.selectedProductImages,
    required this.listOfProductImages,
    required this.articleNumberController,
    required this.eanController,
    required this.nameController,
    required this.wholesalePriceController,
    required this.supplierController,
    required this.supplierArticleNumberController,
    required this.manufacturerController,
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
  });

  factory ProductState.initial() {
    return ProductState(
      product: null,
      listOfAllProducts: null,
      listOfFilteredProducts: null,
      selectedProducts: const [],
      firebaseFailure: null,
      isAnyFailure: false,
      isLoadingProductOnObserve: false,
      isLoadingProductsOnObserve: false,
      isLoadingProductOnCreate: false,
      isLoadingProductOnUpdate: false,
      isLoadingProductOnUpdateImages: false,
      isLoadingProductOnUploadImages: false,
      isLoadingProductOnDelete: false,
      fosProductOnObserveOption: none(),
      fosProductsOnObserveOption: none(),
      fosProductOnCreateOption: none(),
      fosProductOnUpdateOption: none(),
      fosProductOnUpdateImagesOption: none(),
      fosProductOnUploadImagesOption: none(),
      fosProductOnDeleteOption: none(),
      isLoadingOnMassEditActivateProductMarketplace: false,
      fosProductOnUpdateQuantityOption: none(),
      fosMassEditActivateProductMarketplaceOption: none(),
      fosProductOnEditQuantityPrestaOption: none(),
      productSearchController: TextEditingController(),
      isDescriptionSetFirstTime: true,
      isDescriptionChanged: false,
      triggerPop: false,
      isProductImagesEdited: false,
      isSelectedAllImages: false,
      selectedProductImages: const [],
      listOfProductImages: const [],
      articleNumberController: TextEditingController(),
      eanController: TextEditingController(),
      nameController: TextEditingController(),
      wholesalePriceController: TextEditingController(),
      supplierController: TextEditingController(),
      supplierArticleNumberController: TextEditingController(),
      manufacturerController: TextEditingController(),
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
    );
  }

  ProductState copyWith({
    Product? product,
    List<Product>? listOfAllProducts,
    List<Product>? listOfFilteredProducts,
    List<Product>? selectedProducts,
    FirebaseFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingProductOnObserve,
    bool? isLoadingProductsOnObserve,
    bool? isLoadingProductsSubSearchOnObserve,
    bool? isLoadingProductOnCreate,
    bool? isLoadingProductOnUpdate,
    bool? isLoadingProductOnUpdateImages,
    bool? isLoadingProductOnUploadImages,
    bool? isLoadingProductOnDelete,
    Option<Either<FirebaseFailure, Product>>? fosProductOnObserveOption,
    Option<Either<FirebaseFailure, List<Product>>>? fosProductsOnObserveOption,
    Option<Either<FirebaseFailure, Product>>? fosProductOnCreateOption,
    Option<Either<FirebaseFailure, Unit>>? fosProductOnUpdateOption,
    Option<Either<FirebaseFailure, Product>>? fosProductOnUpdateImagesOption,
    Option<Either<PrestaFailure, Unit>>? fosProductOnUploadImagesOption,
    Option<Either<FirebaseFailure, Unit>>? fosProductOnDeleteOption,
    bool? isLoadingOnMassEditActivateProductMarketplace,
    Option<Either<FirebaseFailure, Product>>? fosProductOnUpdateQuantityOption,
    Option<Either<FirebaseFailure, Unit>>? fosMassEditActivateProductMarketplaceOption,
    Option<Either<PrestaFailure, Unit>>? fosProductOnEditQuantityPrestaOption,
    TextEditingController? productSearchController,
    bool? isDescriptionSetFirstTime,
    bool? isDescriptionChanged,
    bool? triggerPop,
    bool? isProductImagesEdited,
    bool? isSelectedAllImages,
    List<ProductImage>? selectedProductImages,
    List<ProductImage>? listOfProductImages,
    TextEditingController? articleNumberController,
    TextEditingController? eanController,
    TextEditingController? nameController,
    TextEditingController? wholesalePriceController,
    TextEditingController? supplierController,
    TextEditingController? supplierArticleNumberController,
    TextEditingController? manufacturerController,
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
  }) {
    return ProductState(
      product: product ?? this.product,
      listOfAllProducts: listOfAllProducts ?? this.listOfAllProducts,
      listOfFilteredProducts: listOfFilteredProducts ?? this.listOfFilteredProducts,
      selectedProducts: selectedProducts ?? this.selectedProducts,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingProductOnObserve: isLoadingProductOnObserve ?? this.isLoadingProductOnObserve,
      isLoadingProductsOnObserve: isLoadingProductsOnObserve ?? this.isLoadingProductsOnObserve,
      isLoadingProductOnCreate: isLoadingProductOnCreate ?? this.isLoadingProductOnCreate,
      isLoadingProductOnUpdate: isLoadingProductOnUpdate ?? this.isLoadingProductOnUpdate,
      isLoadingProductOnUpdateImages: isLoadingProductOnUpdateImages ?? this.isLoadingProductOnUpdateImages,
      isLoadingProductOnUploadImages: isLoadingProductOnUploadImages ?? this.isLoadingProductOnUploadImages,
      isLoadingProductOnDelete: isLoadingProductOnDelete ?? this.isLoadingProductOnDelete,
      fosProductOnObserveOption: fosProductOnObserveOption ?? this.fosProductOnObserveOption,
      fosProductsOnObserveOption: fosProductsOnObserveOption ?? this.fosProductsOnObserveOption,
      fosProductOnCreateOption: fosProductOnCreateOption ?? this.fosProductOnCreateOption,
      fosProductOnUpdateOption: fosProductOnUpdateOption ?? this.fosProductOnUpdateOption,
      fosProductOnUpdateImagesOption: fosProductOnUpdateImagesOption ?? this.fosProductOnUpdateImagesOption,
      fosProductOnUploadImagesOption: fosProductOnUploadImagesOption ?? this.fosProductOnUploadImagesOption,
      fosProductOnDeleteOption: fosProductOnDeleteOption ?? this.fosProductOnDeleteOption,
      isLoadingOnMassEditActivateProductMarketplace:
          isLoadingOnMassEditActivateProductMarketplace ?? this.isLoadingOnMassEditActivateProductMarketplace,
      fosProductOnUpdateQuantityOption: fosProductOnUpdateQuantityOption ?? this.fosProductOnUpdateQuantityOption,
      fosMassEditActivateProductMarketplaceOption: fosMassEditActivateProductMarketplaceOption ?? this.fosMassEditActivateProductMarketplaceOption,
      fosProductOnEditQuantityPrestaOption: fosProductOnEditQuantityPrestaOption ?? this.fosProductOnEditQuantityPrestaOption,
      productSearchController: productSearchController ?? this.productSearchController,
      isDescriptionSetFirstTime: isDescriptionSetFirstTime ?? this.isDescriptionSetFirstTime,
      isDescriptionChanged: isDescriptionChanged ?? this.isDescriptionChanged,
      triggerPop: triggerPop ?? this.triggerPop,
      isProductImagesEdited: isProductImagesEdited ?? this.isProductImagesEdited,
      isSelectedAllImages: isSelectedAllImages ?? this.isSelectedAllImages,
      selectedProductImages: selectedProductImages ?? this.selectedProductImages,
      listOfProductImages: listOfProductImages ?? this.listOfProductImages,
      articleNumberController: articleNumberController ?? this.articleNumberController,
      eanController: eanController ?? this.eanController,
      nameController: nameController ?? this.nameController,
      wholesalePriceController: wholesalePriceController ?? this.wholesalePriceController,
      supplierController: supplierController ?? this.supplierController,
      supplierArticleNumberController: supplierArticleNumberController ?? this.supplierArticleNumberController,
      manufacturerController: manufacturerController ?? this.manufacturerController,
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
    );
  }
}
