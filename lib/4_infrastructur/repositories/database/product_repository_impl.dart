import 'package:cezeri_commerce/3_domain/entities/product/product_marketplace.dart';
import 'package:cezeri_commerce/failures/firebase_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/1_presentation/core/core.dart';
import '/3_domain/entities/product/product.dart';
import '/3_domain/entities/product/product_image.dart';
import '/3_domain/entities/reorder/supplier.dart';
import '/3_domain/repositories/marketplace/marketplace_edit_repository.dart';
import '../../../2_application/database/product/product_bloc.dart';
import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../3_domain/entities/my_file.dart';
import '../../../3_domain/entities/product/marketplace_product.dart';
import '../../../3_domain/entities/product/product_stock_difference.dart';
import '../../../3_domain/repositories/database/marketplace_repository.dart';
import '../../../3_domain/repositories/database/product_repository.dart';
import '../../../constants.dart';
import '../../../failures/abstract_failure.dart';
import 'functions/get_storage_paths.dart';
import 'functions/product_repository_helper.dart';
import 'functions/utils_repository_impl.dart';

class ProductRepositoryImpl implements ProductRepository {
  final MarketplaceEditRepository marketplaceEditRepository;
  final MarketplaceRepository marketplaceRepository;

  const ProductRepositoryImpl({
    required this.marketplaceEditRepository,
    required this.marketplaceRepository,
  });

  @override
  Future<Either<FirebaseFailure, Product>> createProduct(Product product, MarketplaceProduct? marketplaceProduct) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final productJson = product.toJson();
      productJson.addEntries([MapEntry('ownerId', ownerId)]);
      final productResponse = await supabase.from('d_products').insert(productJson).select('*').single();
      final createdProduct = Product.fromJson(productResponse);

      if (marketplaceProduct != null) {
        final listOfImageFiles = await getImageFilesFromMarketplace(marketplaceProduct: marketplaceProduct);
        if (listOfImageFiles.isEmpty) return Right(createdProduct);

        final List<ProductImage> listOfProductImages = await uploadImageFilesToStorageFromFlutter(
          createdProduct.listOfProductImages,
          listOfImageFiles,
          getProductImagesStoragePath(ownerId, createdProduct.id),
        );

        final toUpdatePrdouct = createdProduct.copyWith(listOfProductImages: listOfProductImages);
        await supabase.from('d_products').update(toUpdatePrdouct.toJson()).eq('ownerId', ownerId).eq('id', toUpdatePrdouct.id);

        return Right(toUpdatePrdouct);
      }

      return Right(createdProduct);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Erstellen des Artikels ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Product>>> getListOfProducts(bool onlyActive) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    const limit = 990; // Anzahl der Zeilen pro Abfrage
    int offset = 0; // Startposition
    final allProducts = <Product>[];

    try {
      while (true) {
        final response = switch (onlyActive) {
          true => await supabase
              .from('d_products')
              .select()
              .eq('ownerId', ownerId)
              .eq('isActive', onlyActive)
              .order('name')
              .range(offset, offset + limit - 1),
          false => await supabase.from('d_products').select().eq('ownerId', ownerId).order('name').range(offset, offset + limit - 1),
        };

        if (response.isEmpty) break;

        final listOfProducts = response.map((e) => Product.fromJson(e)).toList();
        allProducts.addAll(listOfProducts);

        offset += limit; // Offset für die nächste Abfrage erhöhen
      }
      return Right(allProducts);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Artikel ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, int>> getNumerOfAllProducts({bool? onlyActive = false}) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.rpc('get_d_products_count', params: {'owner_id': ownerId, 'only_active': onlyActive});

      return Right(response);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Artikel ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Product>>> getListOfProductsPerPage({
    required int currentPage,
    required int itemsPerPage,
    bool? onlyActive = false,
  }) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final start = (currentPage - 1) * itemsPerPage;
    final end = start + itemsPerPage - 1;
    const maxItemsPerRequest = 990; // Supabase limit
    int currentStart = start;
    int currentEnd = (start + maxItemsPerRequest - 1).clamp(start, end); // Ensure it does not exceed the requested end
    List<Product> allProducts = [];

    try {
      while (currentStart <= end && allProducts.length < itemsPerPage) {
        final response = onlyActive!
            ? await supabase
                .from('d_products')
                .select()
                .eq('ownerId', ownerId)
                .eq('isActive', onlyActive)
                .order('name', ascending: true)
                .range(currentStart, currentEnd)
            : await supabase.from('d_products').select().eq('ownerId', ownerId).order('name', ascending: true).range(currentStart, currentEnd);

        if (response.isEmpty) break;

        final listOfProducts = response.map((e) => Product.fromJson(e)).toList();
        allProducts.addAll(listOfProducts);

        // Update the start and end for the next batch
        currentStart = currentEnd + 1;
        currentEnd = (currentStart + maxItemsPerRequest - 1);

        // Ensure currentEnd does not exceed the requested end
        if (currentEnd > end) {
          currentEnd = end;
        }

        // Ensure we do not load more than the required itemsPerPage
        if (allProducts.length + maxItemsPerRequest > itemsPerPage) {
          currentEnd = currentStart + (itemsPerPage - allProducts.length) - 1;
        }
      }

      // Ensure we return exactly the requested number of items
      allProducts = allProducts.take(itemsPerPage).toList();

      return Right(allProducts);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Artikel ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, int>> getNumberOfFilteredSortedProductsBySearchText({
    required String searchText,
    required ProductsFilterValues productsFilterValues,
  }) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.rpc('get_products_count_filtered_sorted_by_search_text', params: {
        'owner_id': ownerId,
        'search_text': searchText,
        'filter_manufacturer': productsFilterValues.manufacturer,
        'filter_supplier': productsFilterValues.supplier,
        'filter_is_outlet': productsFilterValues.isOutlet,
        'filter_is_set': productsFilterValues.isSet,
        'filter_is_part_of_set': productsFilterValues.isPartOfSet,
        'filter_is_sale': productsFilterValues.isSale,
        'filter_is_active': productsFilterValues.isActive,
      });

      return Right(response);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Artikel ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Product>>> getListOfFilteredSortedProductsBySearchText({
    required String searchText,
    required int currentPage,
    required int itemsPerPage,
    required bool isSortedAsc,
    required ProductsSortValue productsSortValue,
    required ProductsFilterValues productsFilterValues,
  }) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.rpc('get_products_filtered_sorted_by_search_text', params: {
        'owner_id': ownerId,
        'search_text': searchText,
        'current_page': currentPage,
        'items_per_page': itemsPerPage,
        'sort_column': productsSortValue.name.toString(),
        'sort_order': isSortedAsc ? 'asc' : 'desc',
        'filter_manufacturer': productsFilterValues.manufacturer,
        'filter_supplier': productsFilterValues.supplier,
        'filter_is_outlet': productsFilterValues.isOutlet,
        'filter_is_set': productsFilterValues.isSet,
        'filter_is_part_of_set': productsFilterValues.isPartOfSet,
        'filter_is_sale': productsFilterValues.isSale,
        'filter_is_active': productsFilterValues.isActive,
      });

      if (response.isEmpty) return const Right([]);

      final listOfProducts = (response as List<dynamic>).map((e) {
        final item = e as Map<String, dynamic>;
        return Product.fromJson(item);
      }).toList();

      return Right(listOfProducts);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Artikel ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Product>>> getListOfProductsByIds(List<String> productIds) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    List<Product> listOfProducts = [];

    try {
      for (final productId in productIds) {
        if (productId.isEmpty || productId.startsWith('00000')) continue;
        final response = await supabase.from('d_products').select().eq('ownerId', ownerId).eq('id', productId).single();
        if (response.isNotEmpty) listOfProducts.add(Product.fromJson(response));
      }

      return Right(listOfProducts);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Artikel ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Product>>> getListOfProductsBySupplierName({required bool onlyActive, required Supplier supplier}) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final request =
        supabase.from('d_products').select().eq('ownerId', ownerId).eq('isActive', true).eq('isSetArticle', false).eq('supplier', supplier.company);

    try {
      final response = await request;
      if (response.isEmpty) return const Right([]);

      final listOfProducts = response.map((e) => Product.fromJson(e)).toList();

      return Right(listOfProducts);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Artikel ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Product>>> getListOfSoldOutOutletProducts() async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final request = supabase.from('d_products').select().eq('ownerId', ownerId).eq('isActive', true).eq('isOutlet', true).eq('warehouseStock', 0);

    try {
      final response = await request;
      if (response.isEmpty) return const Right([]);

      final listOfProducts = response.map((e) => Product.fromJson(e)).toList();

      return Right(listOfProducts);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der ausverkauften Artikel ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Product>>> getListOfSoldOutProducts() async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final request = supabase.from('d_products').select().eq('ownerId', ownerId).eq('isActive', true).eq('availableStock', 0);

    try {
      final response = await request;
      if (response.isEmpty) return const Right([]);

      final listOfProducts = response.map((e) => Product.fromJson(e)).toList();

      return Right(listOfProducts);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Artikel ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Product>>> getListOfUnderMinimumQuantityProducts() async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final request = supabase.from('d_products').select().eq('ownerId', ownerId).eq('isActive', true).eq('isUnderMinimumStock', true);

    try {
      final response = await request;
      if (response.isEmpty) return const Right([]);

      final listOfProducts = response.map((e) => Product.fromJson(e)).toList();

      return Right(listOfProducts);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Artikel, die unter dem Mindestbestand sind ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<ProductStockDifference>>> getListOfProductSalesAndStockDiff() async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final endDate = DateTime.now().add(const Duration(days: 1));
    final endDateFormatted = endDate.toConvertedYearMonthDay();

    try {
      final response = await supabase.rpc('get_product_sales_and_stock_diff', params: {
        'owner_id': ownerId,
        'start_date': '2023-05-01',
        'end_date': endDateFormatted,
      });

      final listOfProductStockDifferences = (response as List<dynamic>).map((e) {
        final item = e as Map<String, dynamic>;
        return ProductStockDifference.fromJson(item);
      }).toList();

      return Right(listOfProductStockDifferences);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Bestandsaweichungen konnten nicht geladen werden.'));
    }
  }

  @override
  Future<Either<AbstractFailure, Product>> getProduct(String productId, {String? ownerId}) async {
    if (ownerId == null) {
      if (!await checkInternetConnection()) return Left(NoConnectionFailure());
      ownerId = await getOwnerId();
      if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));
    }

    try {
      final response = await supabase.from('d_products').select().eq('ownerId', ownerId).eq('id', productId).single();

      return Right(Product.fromJson(response));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden des Artikels ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> getProductByArticleNumber(String articleNumber) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.from('d_products').select().eq('ownerId', ownerId).eq('articleNumber', articleNumber);

      if (response.isEmpty) return Left(GeneralFailure(customMessage: 'Beim Laden des Artikels ist ein Fehler aufgetreten.'));

      return Right(Product.fromJson(response.first));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden des Artikels ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> getProductByEan(String ean) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.from('d_products').select().eq('ownerId', ownerId).eq('ean', ean);

      print(response);

      if (response.isEmpty) return Left(EmptyFailure());

      return Right(Product.fromJson(response.first));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden des Artikels ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> getProductByName(String name) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.from('d_products').select().eq('ownerId', ownerId).eq('name', name);

      if (response.isEmpty) {
        return Left(GeneralFailure(customMessage: 'In der Datenbank konnte kein Artikel mit dem Namen: "$name" gefunden werden.'));
      }

      return Right(Product.fromJson(response.first));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden des Artikels: "$name" ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> getProductWithSameProductMarketplaceAndSameManufacturer(
    Product product,
    ProductMarketplace productMarketplace,
  ) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.from('d_products').select().eq('ownerId', ownerId).eq('manufacturer', product.manufacturer);
      if (response.isEmpty) return Left(EmptyFailure());
      final products = response.map((e) => Product.fromJson(e)).toList();

      final productSameMarketplace =
          products.where((e) => e.productMarketplaces.any((f) => f.idMarketplace == productMarketplace.idMarketplace)).firstOrNull;
      if (productSameMarketplace == null) return Left(GeneralFailure());

      return Right(productSameMarketplace);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden des Artikels ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Product>> updateProduct(Product product) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      await supabase.from('d_products').update(product.toJson()).eq('ownerId', ownerId).eq('id', product.id);

      return Right(product);
    } catch (e) {
      logger.e(e);
      return Left(
        GeneralFailure(customMessage: 'Beim Aktualisieren des Bestandes vom Artikel: "${product.name}" ist ein Fehler aufgetreten. Error: $e'),
      );
    }
  }

  @override
  Future<Either<AbstractFailure, Product>> updateProductAndSets(Product product) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final fosOriginalProduct = await getProduct(product.id);
    if (fosOriginalProduct.isLeft()) return Left(fosOriginalProduct.getLeft());
    final originalProduct = fosOriginalProduct.getRight();

    try {
      if (product.isSetArticle ||
          originalProduct.isSetArticle && (product.listOfProductIdWithQuantity != originalProduct.listOfProductIdWithQuantity)) {
        Either<AbstractFailure, Product>? fosHandleNewSetProduct;
        //* Wenn der Artikel entweder davor ein Set-Artikel war oder jetzt ein Set-Artikel ist
        fosHandleNewSetProduct = await handleNewSetProduct(product: product, originalProduct: originalProduct, ownerId: ownerId);

        if (fosHandleNewSetProduct.isLeft()) return Left(fosHandleNewSetProduct.getLeft());
        return Right(fosHandleNewSetProduct.getRight());
      } else {
        await supabase.from('d_products').update(product.toJson()).eq('ownerId', ownerId).eq('id', product.id);

        return Right(product);
      }
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Aktualisieren des Artikels: "${product.name}" ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> updateProductAddImages(Product product, List<PlatformFile> imageFiles) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final myFiles = await convertPlatfomFilesToMyFiles(imageFiles);

      final List<ProductImage> listOfProductImages =
          await uploadImageFilesToStorageFromFlutter(product.listOfProductImages, myFiles, getProductImagesStoragePath(ownerId, product.id));

      final List<ProductImage> newListOfProductImages = List.from(product.listOfProductImages);
      newListOfProductImages.addAll(listOfProductImages);

      final updatedProduct = product.copyWith(listOfProductImages: newListOfProductImages);

      await supabase.from('d_products').update(updatedProduct.toJson()).eq('ownerId', ownerId).eq('id', product.id);

      return Right(updatedProduct);
    } catch (e) {
      logger.e(e);
      return Left(
        GeneralFailure(customMessage: 'Beim Aktualisieren der Artikelbilder des Artikels: ${product.name} ist ein Fehler aufgetreten. Error: $e'),
      );
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> updateProductRemoveImages(
    Product product,
    List<ProductImage> listOfProductImages,
  ) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final List<ProductImage> updatedListOfProductImages = List.from(product.listOfProductImages);
    for (final image in listOfProductImages) {
      try {
        final filePath = extractPathFromUrl(image.fileUrl);
        await supabase.storage.from('product-images').remove([filePath]);
        updatedListOfProductImages.removeWhere((e) => e.fileUrl == image.fileUrl);
      } on StorageException catch (e) {
        logger.e(e.message);
        updatedListOfProductImages.removeWhere((e) => e.fileUrl == image.fileUrl);
      } catch (e) {
        logger.e('Artikelbild: "${image.fileName}" konnte nicht aus dem Storage gelöscht werden.');
      }
    }

    try {
      final List<ProductImage> newListOfProductImages = [];
      for (int i = 0; i < updatedListOfProductImages.length; i++) {
        final productImage = updatedListOfProductImages[i].copyWith(isDefault: i == 0 ? true : false, sortId: i + 1);
        newListOfProductImages.add(productImage);
      }

      final updatedProduct = product.copyWith(listOfProductImages: newListOfProductImages);

      await supabase.from('d_products').update(updatedProduct.toJson()).eq('ownerId', ownerId).eq('id', product.id);

      return Right(updatedProduct);
    } catch (e) {
      logger.e(e);
      return Left(
        GeneralFailure(customMessage: 'Beim Löschen der Artikelbilder des Artikels: ${product.name} ist ein Fehler aufgetreten. Error: $e'),
      );
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> deleteProduct(String id, String? ownerId) async {
    if (ownerId == null) {
      if (!await checkInternetConnection()) return Left(NoConnectionFailure());
      ownerId = await getOwnerId();
      if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));
    }

    final fosProduct = await getProduct(id);
    if (fosProduct.isLeft()) {
      return Left(fosProduct.getLeft());
    }
    final loadedProduct = fosProduct.getRight();

    try {
      final List<ProductImage> listOfProductImages = List.from(loadedProduct.listOfProductImages);
      for (final image in listOfProductImages) {
        final filePath = extractPathFromUrl(image.fileUrl);
        await supabase.storage.from('product-images').remove([filePath]);
      }

      await supabase.from('d_products').delete().eq('ownerId', ownerId).eq('id', id);

      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return Left(
        GeneralFailure(customMessage: 'Beim Löschen des Artikels: "${loadedProduct.name}" ist ein Fehler aufgetreten. Error: $e'),
      );
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> deleteListOfProducts(List<Product> products) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    List<Product> errorOnDeleteProducts = [];

    for (final product in products) {
      final fosDelete = await deleteProduct(product.id, ownerId);
      if (fosDelete.isLeft()) errorOnDeleteProducts.add(product);
    }

    if (errorOnDeleteProducts.isNotEmpty) {
      final errorOnDeleteProductNames = errorOnDeleteProducts.map((e) => e.name).toList();
      return Left(GeneralFailure(customMessage: 'Beim Löschen der folgenden Produkte ist ein Fehler aufgetrete: $errorOnDeleteProductNames'));
    }

    return const Right(unit);
  }

  @override
  Future<Either<FirebaseFailure, Unit>> activateMarketplaceInSelectedProducts(List<Product> selectedProducts, MarketplacePresta marketplace) async {
    // final isConnected = await checkInternetConnection();
    // if (!isConnected) return Left(NoConnectionFailure());

    // final currentUserUid = firebaseAuth.currentUser!.uid;

    // try {
    //   final prestaLanguages = await getMarketplaceLanguages(marketplace);
    //   if (prestaLanguages == null) return Left(GeneralFailure());

    //   for (final product in selectedProducts) {
    //     final uri = '${marketplace.fullUrl}products/?filter[reference]=[${product.articleNumber}]&display=full';
    //     // final uri = '${marketplace.fullUrl}products/?filter[reference]=[${product.articleNumber}]&output_format=JSON&display=full';
    //     // final uri = '${marketplace.fullUrl}products/?filter[reference]=[EL-1420313]&output_format=JSON&display=full';
    //     // final uri = '${marketplace.fullUrl}languages/?output_format=JSON&display=full';
    //     // final uri = '${marketplace.fullUrl}languages/?display=full';
    //     final response = await http.get(
    //       Uri.parse(uri),
    //       headers: {'Authorization': 'Basic ${base64Encode(utf8.encode('${marketplace.key}:'))}'},
    //     );

    //     final responseBody = XmlDocument.parse(response.body);
    //     final isProductInMarketplace = responseBody.findAllElements('products').first;
    //     if (isProductInMarketplace.children.whereType<XmlElement>().isEmpty) continue;

    //     if (response.statusCode == 200) {
    //       final productDocument = XmlDocument.parse(response.body);
    //       final productPresta = ProductPrestaOld.fromXml(productDocument, prestaLanguages);
    //       final productMarketplace = ProductMarketplace.fromProductPresta(productPresta, marketplace);
    //       List<ProductMarketplace> productMarketplaces = List.from(product.productMarketplaces);
    //       if (!productMarketplaces.any((e) => e.idMarketplace == productMarketplace.idMarketplace)) {
    //         productMarketplaces.add(productMarketplace);
    //       }
    //       final docRef = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);
    //       final updatedProdukt = product.copyWith(productMarketplaces: productMarketplaces);
    //       await docRef.update(updatedProdukt.toJson());
    //     }
    //   }
    //   return Right(unit);
    // } on FirebaseException {
    //   return Left(GeneralFailure());
    // }
    throw UnimplementedError();
  }

  @override
  Future<Either<AbstractFailure, List<Product>>> updateProductQuantity(String productId, int incQuantity, bool updateOnlyAvailableQuantity) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.rpc('update_product_stock', params: {
        'owner_id_input': ownerId,
        'product_id_input': productId,
        'quantity_input': incQuantity,
        'update_only_available_quantity_input': updateOnlyAvailableQuantity,
      });

      if (response.isEmpty) return const Right([]);

      final listOfProducts = (response as List<dynamic>).map((e) {
        final item = e as Map<String, dynamic>;
        return Product.fromJson(item);
      }).toList();

      return Right(listOfProducts);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Aktualisieren des Artikelbestandes ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> updateProductWarehouseStock(String productId, int incQuantity) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      await supabase.rpc('update_product_warehouse_stock', params: {
        'owner_id_input': ownerId,
        'product_id_input': productId,
        'quantity_input': incQuantity,
      });

      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Aktualisieren des Artikelbestandes ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Product>> updateAllQuantityOfProductAbsolut(
    Product product,
    int newQuantity,
    bool updateOnlyAvailableQuantity,
  ) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      Product? updatedProduct;
      List<Product> listOfUpdatedSetProducts = [];
      final loadedProductsResponse = await supabase.from('d_products').select().eq('ownerId', ownerId).single();

      if (loadedProductsResponse.isEmpty) {
        return Left(GeneralFailure(customMessage: 'Der Artikel "${product.name}" konnte nicht aus der Datenbank geladen werden.'));
      }
      final loadedProduct = Product.fromJson(loadedProductsResponse);

      updatedProduct = loadedProduct.copyWith(
        availableStock: newQuantity,
        warehouseStock:
            updateOnlyAvailableQuantity ? loadedProduct.warehouseStock : loadedProduct.warehouseStock - (loadedProduct.availableStock - newQuantity),
        isUnderMinimumStock: newQuantity <= loadedProduct.minimumStock ? true : false,
      );

      if (loadedProduct.listOfIsPartOfSetIds.isNotEmpty) {
        final updatedSetProducts = await updateQuantityOfSetProducts(product: updatedProduct, ownerId: ownerId);

        listOfUpdatedSetProducts.addAll(updatedSetProducts!);
      }

      await supabase.from('d_products').update(updatedProduct.toJson()).eq('ownerId', ownerId).eq('id', product.id);

      for (final updatedSetProduct in listOfUpdatedSetProducts) {
        await marketplaceEditRepository.setQuantityMPInAllProductMarketplaces(updatedSetProduct, updatedSetProduct.availableStock, null);
      }
      await marketplaceEditRepository.setQuantityMPInAllProductMarketplaces(updatedProduct, updatedProduct.availableStock, null);
      return Right(updatedProduct);
    } catch (e) {
      logger.e(e);
      return Left(
        GeneralFailure(customMessage: 'Beim Aktualisieren des Bestandes vom Artikel: "${product.name}" ist ein Fehler aufgetreten. Error $e'),
      );
    }
  }

  @override
  Future<Either<AbstractFailure, Product>> updateAvailableQuantityOfProductInremental(
    Product product,
    int newQuantityIncremental,
    MarketplacePresta? marketplaceToSkip,
  ) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      Product? updatedProduct;
      List<Product> listOfUpdatedSetProducts = [];

      final newAvailableStock = product.availableStock + newQuantityIncremental;
      updatedProduct = product.copyWith(
        availableStock: newAvailableStock,
        isUnderMinimumStock: newAvailableStock <= product.minimumStock ? true : false,
      );

      if (product.listOfIsPartOfSetIds.isNotEmpty) {
        final updatedSetProducts = await updateQuantityOfSetProducts(product: updatedProduct, ownerId: ownerId);

        listOfUpdatedSetProducts.addAll(updatedSetProducts!);
      }

      await supabase.from('d_products').update(updatedProduct.toJson()).eq('ownerId', ownerId).eq('id', product.id);

      for (final updatedSetProduct in listOfUpdatedSetProducts) {
        await marketplaceEditRepository.setQuantityMPInAllProductMarketplaces(updatedSetProduct, updatedSetProduct.availableStock, null);
      }
      await marketplaceEditRepository.setQuantityMPInAllProductMarketplaces(updatedProduct, updatedProduct.availableStock, marketplaceToSkip);
      return Right(updatedProduct);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(
        customMessage: 'Beim inkrementellen Aktualisieren des Bestandes vom Artikel: "${product.name}" ist ein Fehler aufgetreten. Error: $e',
      ));
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> updateWarehouseQuantityOfNewProductOnImportIncremental(
    Product product,
    int newQuantityIncremental, {
    bool updateSets = false,
  }) async {
    //! Wenn diese Funktion bearbeitet wird muss auch die Funktion (receipt_repository_impl)(updateProductWarehouseQuantityIncremental) geupdatet werden
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final database = supabase.from('d_products');

    try {
      final updatedProduct = product.copyWith(
        warehouseStock: product.warehouseStock + newQuantityIncremental,
        isUnderMinimumStock: product.availableStock <= product.minimumStock ? true : false,
      );
      await database.update(updatedProduct.toJson()).eq('ownerId', ownerId).eq('id', product.id);

      if (updateSets && product.isSetArticle && product.listOfProductIdWithQuantity.isNotEmpty) {
        for (final productIdWithQuantity in product.listOfProductIdWithQuantity) {
          final fosSetProduct = await getProduct(productIdWithQuantity.productId);
          if (fosSetProduct.isLeft()) continue;
          final setProduct = fosSetProduct.getRight();
          final updatedSetProduct = setProduct.copyWith(
            warehouseStock: setProduct.warehouseStock + (newQuantityIncremental * productIdWithQuantity.quantity),
          );

          await database.update(updatedSetProduct.toJson()).eq('ownerId', ownerId).eq('id', setProduct.id);
        }
      }

      return Right(updatedProduct);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(
        customMessage: 'Beim inkrementellen Aktualisieren des  Lagerbestandes vom Artikel: "${product.name}" ist ein Fehler aufgetreten. Error: $e',
      ));
    }
  }
}

Future<List<Product>?> updateQuantityOfSetProducts({
  required Product product,
  required String ownerId,
}) async {
  List<Product> listOfUpdatedSetProducts = [];
  //* Set-Artikel laden, wo dieser Artikel ein Bestandteil ist
  final listOfSetProducts = await getSetProductsOfPartProduct(ownerId, product);

  //* Bestand bei allen Set-Artikeln anpassen
  for (final setProduct in listOfSetProducts!) {
    final listOfSetPartProducts = await getPartProductsOfSetProduct(
      ownerId: ownerId,
      setProduct: setProduct,
      alreadyLoadedPartProduct: product,
    );
    if (listOfSetPartProducts == null) return Future.value(null);

    final quantitySetArticle = calcSetArticleAvailableQuantity(setProduct, listOfSetPartProducts);
    final difference = setProduct.warehouseStock - setProduct.availableStock;
    final updatedSetProduct = setProduct.copyWith(availableStock: quantitySetArticle, warehouseStock: quantitySetArticle + difference);

    //TODO: Transactions require all reads to be executed before all writes. transaction.update(docRefSetProduct, updatedSetProduct.toJson());
    await supabase.from('d_products').update(updatedSetProduct.toJson()).eq('ownerId', ownerId).eq('id', setProduct.id);
    listOfUpdatedSetProducts.add(updatedSetProduct);
  }
  return listOfUpdatedSetProducts;
}

Future<List<Product>?> getSetProductsOfPartProduct(String ownerId, Product product) async {
  final List<Product> listOfSetProducts = [];
  for (final setProductId in product.listOfIsPartOfSetIds) {
    final setProductResponse = await supabase.from('d_products').select().eq('ownerId', ownerId).eq('id', setProductId).single();
    //* Wenn die Liste einen null Wert enthält, wird das Programm nicht unterbrochen, aber es kann ein Fehler geworfen werden, dass es mindestens bei einem Set-Artikel nicht geklappt hat.
    if (setProductResponse.isEmpty) {
      // listOfSetProducts.add(null);
      return Future.value(null);
    } else {
      final setProduct = Product.fromJson(setProductResponse);
      listOfSetProducts.add(setProduct);
    }
  }
  return listOfSetProducts;
}
