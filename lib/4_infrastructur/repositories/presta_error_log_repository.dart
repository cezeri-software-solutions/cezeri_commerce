import 'package:cezeri_commerce/3_domain/entities/prestashop_error.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';

import '../../3_domain/entities/product/product.dart';

Future<void> createErrorLog({
  required DocumentReference<Map<String, dynamic>> docRef,
  required Response response,
  required String marketplaceName,
  required PrestaErrorOn prestaErrorOn,
  String? message,
  Product? currentProduct,
  Product? newProduct,
}) async {
  final prestashopError = PrestashopError(
    request: response.request.toString(),
    responseBody: response.body,
    responseStatusCode: response.statusCode,
    message: message ?? '',
    prestaErrorOn: prestaErrorOn,
    marketplaceName: marketplaceName,
    currentProduct: currentProduct,
    newProduct: newProduct,
    isNew: true,
  );

  await docRef.set(prestashopError.toJson());
}
