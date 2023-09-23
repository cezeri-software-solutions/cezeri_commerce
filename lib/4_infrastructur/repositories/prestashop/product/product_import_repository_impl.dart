import 'package:cezeri_commerce/3_domain/entities/marketplace.dart';
import 'package:cezeri_commerce/3_domain/entities_presta/product_presta.dart';
import 'package:cezeri_commerce/4_infrastructur/repositories/prestashop/presta_api_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../../../../3_domain/repositories/prestashop/product/product_import_repository.dart';
import '../../../../core/presta_failure.dart';

class ProductImportRepositoryImpl implements ProductImportRepository {
  @override
  Future<Either<PrestaFailure, List<ProductPresta>>> getAllProductsFromPrestashop() async {
    try {
      final response = await http.get(
        Uri.parse('https://ccf-autopflege.at/api/products?ws_key=L2YILL715KNNT469R5L1GU9MMLAVNGYG'),
        headers: {'Content-Type': 'application/xml'},
      );

      final document = XmlDocument.parse(response.body);
      final productsXml = document.findAllElements('product');

      List<ProductPresta> products = [];
      for (int i = 0; i < 20; i++) {
        final href = productsXml.elementAt(i).getAttribute('xlink:href') ?? '';
        print('Produktdetails URL: $href');
        final productDetails = await fetchDetailsOfMultipleProducts('$href&ws_key=L2YILL715KNNT469R5L1GU9MMLAVNGYG');

        products.add(productDetails);
      }
      return right(products);
    } catch (e) {
      print(e);
      return left(PrestaGeneralFailure());
    }
  }

  Future<ProductPresta> fetchDetailsOfMultipleProducts(String href) async {
    final response = await http.get(
      Uri.parse(href),
      headers: {'Content-Type': 'application/xml'},
    );

    if (response.statusCode == 200) {
      final document = XmlDocument.parse(response.body);
      final id = int.parse(document.findAllElements('id').first.text);
      final productName = document.findAllElements('name').first.text;
      final productPrice = double.parse(document.findAllElements('price').first.text);
      final productDescription = document.findAllElements('description').first.text;
      final quantity = int.parse(document.findAllElements('quantity').first.text);
      // Fügen Sie hier weitere Felder hinzu, je nachdem, welche Informationen Sie benötigen

      return ProductPresta(
        id: id,
        name: productName,
        price: productPrice, // Setzen Sie den tatsächlichen Preis hier
        description: productDescription,
        quantity: quantity,
      );
    } else {
      throw Exception('Fehler beim Laden der Produktdetails. Status: ${response.statusCode}, Antwort: ${response.body}');
    }
  }

  @override
  Future<Either<PrestaFailure, ProductPresta>> getProductByIdFromPrestashop(int id, Marketplace marketplace) async {
    late XmlDocument documentProduct;
    late XmlDocument documentProductQuantity;

    final fosDocumentProduct = await getResourcesFromPrestaById(
      fullUrl: marketplace.fullUrl,
      prestaApiResource: PrestaApiResource.products,
      key: marketplace.key,
      id: id,
    );

    fosDocumentProduct.fold(
      (failure) => left(failure),
      (document) => documentProduct = document,
    );

    final prestaLanguages = await getMarketplaceLanguages(marketplace);
    if (prestaLanguages == null) return left(PrestaGeneralFailure());

    try {
      // final productPresta = getProductPresta(documentProduct, '${marketplace.fullUrl}products/$id');
      final productPresta = ProductPresta.fromXml(documentProduct, prestaLanguages);
      final fosDocumentProductQuantity = await getResourcesFromPrestaByHref(href: productPresta.stockAvailables!.first.href!, key: marketplace.key);

      fosDocumentProductQuantity.fold(
        (failure) => left(failure),
        (document) => documentProductQuantity = document,
      );

      final realQuantity = int.tryParse(documentProductQuantity.findAllElements('quantity').first.text)!;
      final finalProductPresta = productPresta.copyWith(quantity: realQuantity);

      return right(finalProductPresta);
    } catch (e) {
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