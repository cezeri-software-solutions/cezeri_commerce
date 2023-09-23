import 'dart:convert';

import 'package:cezeri_commerce/3_domain/entities/marketplace.dart';
import 'package:cezeri_commerce/3_domain/entities/product/product.dart';
import 'package:cezeri_commerce/core/presta_failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../../3_domain/entities/prestashop_error.dart';
import '../../../../3_domain/entities/product/product_marketplace.dart';
import '../../../../3_domain/repositories/prestashop/product/product_edit_repository.dart';
import '../../presta_error_log_repository.dart';

class ProductEditRepositoryImpl implements ProductEditRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;

  ProductEditRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<PrestaFailure, Unit>> setProdcutPrestaQuantity(Product product, int newQuantity) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(PrestaGeneralFailure());

    try {
      for (ProductMarketplace productMarketplace in product.productMarketplaces) {
        //if (!productMarketplace.active!) continue;

        final currentUserUid = firebaseAuth.currentUser!.uid;
        final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(productMarketplace.idMarketplace);

        final marketplaceSnapshot = await docRef.get();
        final marketplace = Marketplace.fromJson(marketplaceSnapshot.data()!);

        final readResponse = await http.get(
          Uri.parse(productMarketplace.stockAvailables!.first.href!),
          headers: {'Authorization': 'Basic ${base64Encode(utf8.encode('${marketplace.key}:'))}'},
        );

        if (readResponse.statusCode == 200) {
          final XmlDocument document = XmlDocument.parse(readResponse.body);
          final XmlElement productPresta = document.findAllElements('stock_available').first;

          updateXmlElementText(productPresta.findElements('quantity').first, newQuantity.toString());

          final updateResponse = await http.put(
            Uri.parse(productMarketplace.stockAvailables!.first.href!),
            headers: {
              'Authorization': 'Basic ${base64Encode(utf8.encode('${marketplace.key}:'))}',
              'Content-Type': 'application/xml',
            },
            body: document.toXmlString(),
          );

          if (updateResponse.statusCode == 200) {
            print('${marketplace.marketplaceType}: Bestand erfolgreich aktualisiert!');
          } else {
            print('${marketplace.marketplaceType}: Fehler beim Aktualisieren des Bestands. Statuscode: ${updateResponse.statusCode}');
            createErrorLog(
              docRef: db.collection(currentUserUid).doc(currentUserUid).collection('ErrorLogPresta').doc(),
              response: readResponse,
              marketplaceName: marketplace.marketplaceType,
              prestaErrorOn: PrestaErrorOn.updateProductQuantity,
              message: '${marketplace.marketplaceType}: Fehler beim Aktualisieren des Bestands. Statuscode: ${updateResponse.statusCode}',
              currentProduct: product,
            );
          }
        } else {
          print('${marketplace.marketplaceType}: Bestand konnte nicht ausgelesen werden. Statuscode: ${readResponse.statusCode}');
          createErrorLog(
            docRef: db.collection(currentUserUid).doc(currentUserUid).collection('ErrorLogPresta').doc(),
            response: readResponse,
            marketplaceName: marketplace.marketplaceType,
            prestaErrorOn: PrestaErrorOn.getProduct,
            message: '${marketplace.marketplaceType}: Bestand konnte nicht ausgelesen werden. Statuscode: ${readResponse.statusCode}',
            currentProduct: product,
          );
        }
      }
      return right(unit);
    } catch (e) {
      return left(PrestaGeneralFailure());
    }
  }

  @override
//   Future<Either<PrestaFailure, Unit>> editProdcutPresta(Product product) async {
//     final isConnected = await checkInternetConnection();
//     if (!isConnected) return left(PrestaGeneralFailure());

//     late XmlDocument document;

//     try {
//       for (var productMarketplace in product.productMarketplaces) {
//         final currentUserUid = firebaseAuth.currentUser!.uid;
//         final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(productMarketplace.idMarketplace);

//         final marketplaceSnapshot = await docRef.get();
//         final marketplace = Marketplace.fromJson(marketplaceSnapshot.data()!);

//         final fosDocumentStockAvailable = await getResourcesFromPrestaByHref(
//           href: productMarketplace.stockAvailables!.first.href!,
//           key: marketplace.key,
//         );

//         fosDocumentStockAvailable.fold(
//           (failure) => left(failure),
//           (doc) => document = doc,
//         );
//         print('----------------------------------------------------------------');
//         print(document);
//         print('----------------------------------------------------------------');

//         final updateResponse = await http.put(
//           Uri.parse(productMarketplace.stockAvailables!.first.href!),
//           headers: {
//             'Authorization': 'Basic ${base64Encode(utf8.encode('${marketplace.key}:'))}',
//             'Content-Type': 'application/xml',
//           },
//           body: xmlBody,
//         );
//         print(updateResponse.body);
//         print(updateResponse.statusCode);
//         if (updateResponse.statusCode == 200) {
//           print('Bestand erfolgreich aktualisiert!');
//           return right(unit);
//         } else {
//           print('Fehler beim Aktualisieren des Bestands. Statuscode: ${updateResponse.statusCode}');
//         }
//       }
//       return right(unit);
//     } catch (e) {
//       return left(PrestaGeneralFailure());
//     }
//   }
// }

  Future<Either<PrestaFailure, Unit>> editProdcutPresta(Product product) async {
    //   final currentUserUid = firebaseAuth.currentUser!.uid;
    //   final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(product.productMarketplaces[0].idMarketplace);

    //   final marketplaceSnapshot = await docRef.get();
    //   final marketplace = Marketplace.fromJson(marketplaceSnapshot.data()!);
    //   final url = product.productMarketplaces[0].href;

    //   final response = await http.get(
    //     Uri.parse(url!),
    //     headers: {'Authorization': 'Basic ${base64Encode(utf8.encode('${marketplace.key}:'))}'},
    //   );

    //   print(response.body);

    //   if (response.statusCode == 200) {
    //     // final document = XmlDocument.parse(response.body);
    //     // final nameElement = document
    //     //     .findAllElements('language')
    //     //     .firstWhere((element) => element.getAttribute('id') == '3'); // Hier nehmen wir an, dass die ID '1' für die gewünschte Sprache steht.

    //     // // Entfernen Sie alle vorhandenen Kinder des nameElement und fügen Sie den neuen Text hinzu
    //     // nameElement.children.clear();
    //     // nameElement.children.add(XmlText('Hello World'));

    //     /* final builder = XmlBuilder();

    //     builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    //     builder.element('prestashop', attributes: {'xmlns:xlink': 'http://www.w3.org/1999/xlink'}, nest: () {
    //       builder.element('product', nest: () {
    //         builder.element('id', nest: () {
    //           builder.cdata('42');
    //         });
    //         builder.element('name', nest: () {
    //           builder.cdata('Koch Chemie - Finish-Schwamm schwarz - 130mmm');
    //         });
    //         builder.element('price', nest: () {
    //           builder.cdata(product.netPrice);
    //         });
    //       });
    //     });

    //     final document = builder.buildDocument();
    //     print(document.toXmlString(pretty: true)); */

    //     final XmlDocument document = XmlDocument.parse(response.body);
    //     final XmlElement productPresta = document.findAllElements('product').first;

    //     // Felder aktualisieren
    //     ////updateXmlElementText(productPresta.findElements('reference').first, '9990033');
    //     //updateXmlElementCDATAContent(productPresta.findElements('name').first.findElements('language').first, 'John');
    //     final manufacturerNameElement = productPresta.findElements('manufacturer_name').firstOrNull;
    //     if (manufacturerNameElement != null) {
    //       productPresta.children.remove(manufacturerNameElement);
    //     }
    //     final quantityElement = productPresta.findElements('quantity').firstOrNull;
    //     if (quantityElement != null) {
    //       productPresta.children.remove(quantityElement);
    //     }

    //     print('---------------------- 2 -----------------------');
    //     print(document.toXmlString());

    //     await Future.delayed(const Duration(seconds: 5));

    //     final putResponse = await http.put(
    //       Uri.parse(url),
    //       headers: {
    //         'Authorization': 'Basic ${base64Encode(utf8.encode('${marketplace.key}:'))}',
    //         'Content-Type': 'text/xml',
    //       },
    //       body: document.toXmlString(), // Das aktualisierte XmlDocument wird hier zurückgegeben.
    //     );

    //     if (putResponse.statusCode == 200) {
    //       print('Product name updated successfully!');
    //       return right(unit);
    //     } else {
    //       print(putResponse.body);
    //       print(putResponse.persistentConnection);
    //       print(putResponse.reasonPhrase);
    //       print(putResponse.statusCode);
    //       print('Failed to update product name.');
    //     }
    //     return right(unit);
    //   } else {
    //     print('Failed to fetch product details.');
    //     return left(PrestaGeneralFailure());
    //   }
    // }
    return left(PrestaGeneralFailure());
  }

  void updateXmlElementText(XmlElement element, String newText) {
    final cdataNode = element.children.whereType<XmlCDATA>().firstOrNull;
    if (cdataNode != null) cdataNode.text = newText;
  }

  void updateXmlElementCDATAContent(XmlElement element, String newText) {
    // Finden Sie den CDATA-Knoten innerhalb des Elements
    final cdataNode = element.children.whereType<XmlCDATA>().firstOrNull;

    if (cdataNode != null) {
      // Ersetzen Sie den Inhalt des CDATA-Knotens
      cdataNode.text = newText;
    }
  }
}
