import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '/1_presentation/core/core.dart';
import '/3_domain/entities/marketplace/abstract_marketplace.dart';
import '/3_domain/entities/product/marketplace_product.dart';
import '/3_domain/entities/product/product.dart';
import '/3_domain/entities/product/product_presta.dart';
import '../../../../3_domain/entities/my_file.dart';
import '../../../../3_domain/repositories/database/product_repository.dart';
import '../../../../3_domain/repositories/marketplace/marketplace_edit_repository.dart';
import '../../../../constants.dart';
import '../../../../failures/failures.dart';
import '../../shopify_api/shopify.dart';

Future<Either<AbstractFailure, List<Product>>> updateProductQuantityInDbAndMps({
  required String productId,
  required int incQuantity,
  required bool updateOnlyAvailableQuantity,
  AbstractMarketplace? marketplaceToSkip,
}) async {
  final productRepository = GetIt.I<ProductRepository>();
  final marketplaceEditRepository = GetIt.I<MarketplaceEditRepository>();

  //* Update Product stocks
  final fosUpdateProductStock = await productRepository.updateProductQuantity(
    productId,
    incQuantity,
    updateOnlyAvailableQuantity,
  );
  if (fosUpdateProductStock.isLeft()) return Left(fosUpdateProductStock.getLeft());
  final listOfToUpdateProducts = fosUpdateProductStock.getRight();

  //* Duplikate aus der Liste entfernen
  List<Product> newListOfUpdatedProducts = [];
  for (final product in listOfToUpdateProducts) {
    final index = newListOfUpdatedProducts.indexWhere((e) => e.id == product.id);
    if (index == -1) {
      newListOfUpdatedProducts.add(product);
    } else {
      newListOfUpdatedProducts[index] = product;
    }
  }

  print('--------------------------------------------------------------------------------------------');
  for (int i = 0; i < newListOfUpdatedProducts.length; i++) {
    print('Name: ${listOfToUpdateProducts[i].name} / Bestand: ${listOfToUpdateProducts[i].availableStock}');
  }
  print('--------------------------------------------------------------------------------------------');

  //* Update Product stocks in Marketplaces
  for (final updatedProduct in newListOfUpdatedProducts) {
    await marketplaceEditRepository.setQuantityMPInAllProductMarketplaces(updatedProduct, updatedProduct.availableStock, marketplaceToSkip);
  }
  return Right(newListOfUpdatedProducts);
}

Future<Either<AbstractFailure, Product>> handleNewSetProduct({
  required Product product,
  required Product originalProduct,
  required String ownerId,
}) async {
  //* Alle Einzelartikel des Set-Artikel laden und in eine Liste speichern
  final listOfSetPartProducts = await getPartProductsOfSetProduct(ownerId: ownerId, setProduct: product);
  if (listOfSetPartProducts == null) {
    final errorMessage = 'Beim Aktualisieren des Artikels: "${product.name}" konnte mindestens ein Einzelartikel nicht geladen werden.';
    return Left(GeneralFailure(customMessage: errorMessage));
  }

  //* Alle Einzelartikel, die nicht mehr Bestandteil des Set-Artikel sind identitfizieren
  final noMorePartOfSetIds = identifyNoMorePartOfSetProducts(
    listOfSetPartProducts: listOfSetPartProducts,
    originalProduct: originalProduct,
  );
  //* Alle Einzelartikel, die nicht mehr Bestandteil des Set-Artikel sind aus dem Set-Artikel Entfernen
  final fosRemovePartProducts = await removePartProductsFromSet(noMorePartOfSetIds: noMorePartOfSetIds, ownerId: ownerId, product: product);
  fosRemovePartProducts.fold(
    (failure) => Left(failure),
    (r) => null,
  );

  //* Alle Einzelartikel, wo der Set-Artikel noch nicht eingetragen ist in Firestore updaten
  await addSetProductIdToPartProducts(ownerId: ownerId, setProduct: product, listOfSetPartProducts: listOfSetPartProducts);

  if (product.isSetArticle) {
    //* Berechne Menge des Set-Artikels
    final quantitySetArticle = calcSetArticleAvailableQuantity(product, listOfSetPartProducts);

    //* Update Set-Article
    final difference = product.warehouseStock - product.availableStock;
    final setArticle = product.copyWith(availableStock: quantitySetArticle, warehouseStock: quantitySetArticle + difference);
    await supabase.from('d_products').update(setArticle.toJson()).eq('ownerId', ownerId).eq('id', setArticle.id);
    return Right(setArticle);
  } else {
    await supabase.from('d_products').update(product.toJson()).eq('ownerId', ownerId).eq('id', product.id);
    return Right(product);
  }
}

List<String> identifyNoMorePartOfSetProducts({
  required List<Product> listOfSetPartProducts,
  required Product? originalProduct,
}) {
  if (originalProduct == null) return [];

  final newPartArticleIds = listOfSetPartProducts.map((e) => e.id).toList();
  final originalPartArticleIds = originalProduct.listOfProductIdWithQuantity.map((e) => e.productId).toList();
  final noMorePartOfSetIds = <String>[];

  for (final originalId in originalPartArticleIds) {
    if (!newPartArticleIds.any((e) => e == originalId)) {
      noMorePartOfSetIds.add(originalId);
    }
  }

  return noMorePartOfSetIds;
}

Future<Either<AbstractFailure, Unit>> removePartProductsFromSet({
  required List<String> noMorePartOfSetIds,
  required String ownerId,
  required Product product,
}) async {
  for (final noMorePartId in noMorePartOfSetIds) {
    Product? noMorePartProduct;
    final fosNoMorePartProduct = await GetIt.I.get<ProductRepository>().getProduct(noMorePartId);
    fosNoMorePartProduct.fold(
      (failure) => left(failure),
      (loadedProduct) => noMorePartProduct = loadedProduct,
    );

    final index = noMorePartProduct!.listOfIsPartOfSetIds.indexWhere((e) => e == product.id);
    if (index == -1) continue;

    noMorePartProduct!.listOfIsPartOfSetIds.removeAt(index);
    supabase.from('d_products').update(noMorePartProduct!.toJson()).eq('ownerId', ownerId).eq('id', noMorePartId);
  }

  return right(unit);
}

Future<List<Product>?> getPartProductsOfSetProduct({
  required String ownerId,
  required Product setProduct,
  Product? alreadyLoadedPartProduct,
}) async {
  final List<Product> listOfSetPartProducts = [];
  for (final partProductIdWithQuantity in setProduct.listOfProductIdWithQuantity) {
    if (alreadyLoadedPartProduct != null && partProductIdWithQuantity.productId == alreadyLoadedPartProduct.id) {
      listOfSetPartProducts.add(alreadyLoadedPartProduct);
      continue;
    }
    final partProductResponse =
        await supabase.from('d_products').select().eq('ownerId', ownerId).eq('id', partProductIdWithQuantity.productId).single();
    if (partProductResponse.isEmpty) return Future.value(null);
    Product partProduct = Product.fromJson(partProductResponse);
    listOfSetPartProducts.add(partProduct);
  }
  return listOfSetPartProducts;
}

Future<void> addSetProductIdToPartProducts({
  required String ownerId,
  required Product setProduct,
  required List<Product> listOfSetPartProducts,
}) async {
  for (final partOfSetProduct in listOfSetPartProducts) {
    if (partOfSetProduct.listOfIsPartOfSetIds.any((e) => e == setProduct.id)) continue;
    final updatedProduct = partOfSetProduct.copyWith(listOfIsPartOfSetIds: partOfSetProduct.listOfIsPartOfSetIds..add(setProduct.id));

    supabase.from('d_products').update(updatedProduct.toJson()).eq('ownerId', ownerId).eq('id', partOfSetProduct.id);
  }
}

Future<List<MyFile>> getImageFilesFromMarketplace({required MarketplaceProduct marketplaceProduct}) async {
  final List<MyFile> listOfImageFiles = [];
  switch (marketplaceProduct.marketplaceType) {
    case MarketplaceType.prestashop:
      {
        final productPresta = marketplaceProduct as ProductPresta;
        if (productPresta.imageFiles != null) {
          // TODO: e.imageFile wurde zu e.imageFile! damit der Fehler weg ist
          // TODO: Muss für Flutter Web noch angepasst werden
          final imageFiles = productPresta.imageFiles!.map((e) => e.imageFile).toList();
          listOfImageFiles.addAll(imageFiles);
        }
      }
    case MarketplaceType.shopify:
      {
        final productShopify = marketplaceProduct as ProductShopify;
        //*  Für Flutter Web umschreiben
        if (productShopify.images.isNotEmpty) {
          for (final shopifyImage in productShopify.images) {
            // HTTP-Anfrage, um die Bilddaten als Bytes zu erhalten
            final response = await http.get(Uri.parse(shopifyImage.src));
            if (response.statusCode == 200) {
              // Erhalten des temporären Verzeichnisses
              final directory = await getTemporaryDirectory();
              // Erstellen eines Dateipfads im temporären Verzeichnis
              final filePath = '${directory.path}/product_${shopifyImage.id}_${shopifyImage.productId}.jpg';
              // Datei mit den Bilddaten erstellen
              final file = File(filePath);

              // Schreiben der Byte-Daten in die Datei und Rückgabe der Datei
              final imageFile = await file.writeAsBytes(response.bodyBytes);
              final imageName = '${sanitizeFileName(productShopify.title ?? 'product')}_${shopifyImage.productId}_${shopifyImage.id}.jpg';
              final myFile = MyFile(fileBytes: response.bodyBytes, name: imageName);
              listOfImageFiles.add(myFile);
            }
          }
        }
      }
    case MarketplaceType.shop:
      throw Exception('Aus einem Ladengeschäft können keine Artikelbilder importieret werden.');
  }

  return listOfImageFiles;
}
