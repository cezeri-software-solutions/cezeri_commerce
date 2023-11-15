import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

import '../../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../../3_domain/entities_presta/product_presta.dart';
import '../../../../3_domain/repositories/prestashop/product/product_import_repository.dart';
import '../../../../core/presta_failure.dart';
import '../../prestashop_api/prestashop_api.dart';

class ProductImportRepositoryImpl implements ProductImportRepository {
  @override
  Future<Either<PrestaFailure, List<ProductPresta>>> getAllProductsFromPrestashop() async {
    // try {
    //   final response = await http.get(
    //     Uri.parse('https://ccf-autopflege.at/api/products?ws_key=L2YILL715KNNT469R5L1GU9MMLAVNGYG'),
    //     headers: {'Content-Type': 'application/xml'},
    //   );

    //   final document = XmlDocument.parse(response.body);
    //   final productsXml = document.findAllElements('product');

    //   List<ProductPrestaOld> products = [];
    //   for (int i = 0; i < 20; i++) {
    //     final href = productsXml.elementAt(i).getAttribute('xlink:href') ?? '';
    //     print('Produktdetails URL: $href');
    //     final productDetails = await fetchDetailsOfMultipleProducts('$href&ws_key=L2YILL715KNNT469R5L1GU9MMLAVNGYG');

    //     products.add(productDetails);
    //   }
    //   return right(products);
    // } catch (e) {
    //   print(e);
    //   return left(PrestaGeneralFailure());
    // }
    throw UnimplementedError();
  }

  Future<ProductPresta> fetchDetailsOfMultipleProducts(String href) async {
    // final response = await http.get(
    //   Uri.parse(href),
    //   headers: {'Content-Type': 'application/xml'},
    // );

    // if (response.statusCode == 200) {
    //   final document = XmlDocument.parse(response.body);
    //   final id = int.parse(document.findAllElements('id').first.text);
    //   final productName = document.findAllElements('name').first.text;
    //   final productPrice = (document.findAllElements('price').first.text).toMyDouble();
    //   final productDescription = document.findAllElements('description').first.text;
    //   final quantity = int.parse(document.findAllElements('quantity').first.text);
    //   // Fügen Sie hier weitere Felder hinzu, je nachdem, welche Informationen Sie benötigen

    //   return ProductPrestaOld(
    //     id: id,
    //     name: productName,
    //     price: productPrice, // Setzen Sie den tatsächlichen Preis hier
    //     description: productDescription,
    //     quantity: quantity,
    //   );
    // } else {
    //   throw Exception('Fehler beim Laden der Produktdetails. Status: ${response.statusCode}, Antwort: ${response.body}');
    // }
    throw UnimplementedError();
  }

  @override
  Future<Either<PrestaFailure, ProductPresta>> getProductByIdFromPrestashop(int id, Marketplace marketplace) async {
    // late XmlDocument documentProduct;
    // late XmlDocument documentProductQuantity;

    // final fosDocumentProduct = await getResourcesFromPrestaById(
    //   fullUrl: marketplace.fullUrl,
    //   prestaApiResource: PrestaApiResource.products,
    //   key: marketplace.key,
    //   id: id,
    // );

    // fosDocumentProduct.fold(
    //   (failure) => left(failure),
    //   (document) => documentProduct = document,
    // );

    // final prestaLanguages = await getMarketplaceLanguages(marketplace);
    // if (prestaLanguages == null) return left(PrestaGeneralFailure());

    // try {
    //   // final productPresta = getProductPresta(documentProduct, '${marketplace.fullUrl}products/$id');
    //   final productPresta = ProductPrestaOld.fromXml(documentProduct, prestaLanguages);
    //   final fosDocumentProductQuantity = await getResourcesFromPrestaByHref(href: productPresta.stockAvailables!.first.href!, key: marketplace.key);

    //   fosDocumentProductQuantity.fold(
    //     (failure) => left(failure),
    //     (document) => documentProductQuantity = document,
    //   );

    //   List<ProductPrestaImage> listOfImages = [];
    //   if (productPresta.imageIds != null) {
    //     for (final id in productPresta.imageIds!) {
    //       final uri = '${marketplace.fullUrl}images/products/${productPresta.id}/$id';
    //       final responseImage = await http.get(
    //         Uri.parse(uri),
    //         headers: {'Authorization': 'Basic ${base64Encode(utf8.encode('${marketplace.key}:'))}'},
    //       );
    //       if (responseImage.statusCode == 200) {
    //         final Directory directory = await getTemporaryDirectory();
    //         final File file = File('${directory.path}/product_${productPresta.id}_$id.jpg');
    //         final imageFile = await file.writeAsBytes(responseImage.bodyBytes);
    //         listOfImages.add(ProductPrestaImage(productId: id!, imageFile: imageFile));
    //       }
    //     }
    //   }

    //   final realQuantity = int.tryParse(documentProductQuantity.findAllElements('quantity').first.text)!;
    //   final finalProductPresta = productPresta.copyWith(quantity: realQuantity, imageFiles: listOfImages);

    //   return right(finalProductPresta);
    // } catch (e) {
    //   return left(PrestaGeneralFailure());
    // }
    throw UnimplementedError();
  }

  @override
  Future<Either<PrestaFailure, ProductPresta>> getProductByIdFromPrestashopAsJson(int id, Marketplace marketplace) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(PrestaGeneralFailure());
    final logger = Logger();

    // ProductPresta? phProductPresta;
    // StockAvailablePresta? stockAvailablesPresta;
    // List<LanguagePresta> listOfLanguagesPresta = [];

    final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

    try {
      final optionalProductPresta = await api.getProduct(id, marketplace);
      if (optionalProductPresta.isNotPresent) return left(PrestaGeneralFailure());
      final productPresta = optionalProductPresta.value;
      // phProductPresta = optionalProductPresta.value;

      // final isVariantProduct = phProductPresta.associations.associationsStockAvailables!.length > 1;
      // if (isVariantProduct) return left(PrestaGeneralFailure());

      // final idStockAvailable = phProductPresta.associations.associationsStockAvailables!.first.id;
      // final optionalStockAvailablesPresta = await api.getStockAvailable(idStockAvailable.toMyInt());
      // if (optionalStockAvailablesPresta.isNotPresent) return left(PrestaGeneralFailure());
      // stockAvailablesPresta = optionalStockAvailablesPresta.value;

      // if (phProductPresta.nameMultilanguage != null && phProductPresta.nameMultilanguage!.length > 1) {
      //   listOfLanguagesPresta = await api.getLanguages();
      //   if (listOfLanguagesPresta.isEmpty) return left(PrestaGeneralFailure());
      //   final germanLanguage = listOfLanguagesPresta.where((e) => e.isoCode.toUpperCase() == 'DE').firstOrNull;
      //   if (germanLanguage == null) return left(PrestaGeneralFailure());
      //   final germanLanguageId = germanLanguage.id.toString();

      //   phProductPresta = phProductPresta.copyWith(
      //     quantity: stockAvailablesPresta.quantity,
      //     deliveryInStock: phProductPresta.deliveryInStockMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      //     deliveryOutStock: phProductPresta.deliveryOutStockMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      //     metaDescription: phProductPresta.metaDescriptionMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      //     metaKeywords: phProductPresta.metaKeywordsMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      //     metaTitle: phProductPresta.metaTitleMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      //     linkRewrite: phProductPresta.linkRewriteMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      //     name: phProductPresta.nameMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      //     description: phProductPresta.descriptionMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      //     descriptionShort: phProductPresta.descriptionShortMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      //     availableNow: phProductPresta.availableNowMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      //     availableLater: phProductPresta.availableLaterMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      //   );
      // }

      // List<ProductPrestaImage> listOfImages = [];
      // if (phProductPresta.associations.associationsImages != null && phProductPresta.associations.associationsImages!.isNotEmpty) {
      //   for (final id in phProductPresta.associations.associationsImages!) {
      //     final uri = '${marketplace.fullUrl}images/products/${phProductPresta.id}/${id.id}';
      //     final responseImage = await http.get(
      //       Uri.parse(uri),
      //       headers: {'Authorization': 'Basic ${base64Encode(utf8.encode('${marketplace.key}:'))}'},
      //     );
      //     if (responseImage.statusCode == 200) {
      //       final Directory directory = await getTemporaryDirectory();
      //       final File file = File('${directory.path}/product_${phProductPresta.id}_${id.id}.jpg');
      //       final imageFile = await file.writeAsBytes(responseImage.bodyBytes);
      //       listOfImages.add(ProductPrestaImage(productId: id.id.toMyInt(), imageFile: imageFile));
      //     }
      //   }
      // }

      // final productPresta = phProductPresta.copyWith(
      //   quantity: stockAvailablesPresta.quantity,
      //   imageFiles: listOfImages.isNotEmpty ? listOfImages : phProductPresta.imageFiles,
      // );

      return right(productPresta);
    } catch (e) {
      logger.e(e);
      return left(PrestaGeneralFailure());
    }
  }
}


  //   final uri = '${marketplace.fullUrl}products/$id';
  //   // final uriStock = '${marketplace.fullUrl}stocks?filter[id_product]=$id&ws_key=${marketplace.key}:';
  //   // final uriStock = 'https://ccf-autopflege.at/api/stocks/?filter[id_product]=$id';
  //   // final uriStock = 'https://ccf-autopflege.at/api/stocks?filter[id_product]=$id';
  //   // final uriStock = '${marketplace.fullUrl}stock_availables?filter[id_product]=$id';
  //   final uriStock = '${marketplace.fullUrl}stock_availables/8264';
  //   // final uriStock = '${marketplace.fullUrl}images/products/$id';