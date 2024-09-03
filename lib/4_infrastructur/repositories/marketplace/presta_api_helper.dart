import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../../../constants.dart';
import '../../../failures/presta_failure.dart';

enum PrestaApiResource {
  addresses,
  attachments,
  attachmentsFile,
  carriers,
  cartRules,
  carts,
  categories,
  combinations,
  configurations,
  contacts,
  contentManagementSystem,
  countries,
  currencies,
  customerMessages,
  customerThreads,
  customers,
  customizations,
  deliveries,
  employees,
  groups,
  guests,
  imageTypes,
  images,
  imagesGeneralHeader,
  imagesGeneralMail,
  imagesGeneralInvoice,
  imagesGeneralStoreIcon,
  imagesProducts,
  imagesCategories,
  imagesManufacturers,
  imagesSuppliers,
  imagesStores,
  imagesCustomizations,
  languages,
  manufacturers,
  messages,
  orderCarriers,
  orderDetails,
  orderHistories,
  orderInvoices,
  orderPayments,
  orderSlip,
  orderStates,
  orders,
  priceRanges,
  productCustomizationFields,
  productFeatureValues,
  productFeatures,
  productOptionValues,
  productOptions,
  productSuppliers,
  products,
  search,
  shopGroups,
  shopUrls,
  shops,
  stockAvailables,
  stockMovementReasons,
  stockMovements,
  stocks,
  stores,
  suppliers,
  supplyOrderDetails,
  supplyOrderHistories,
  supplyOrderReceiptHistories,
  supplyOrderStates,
  supplyOrders,
  tags,
  taxRuleGroups,
  taxRules,
  taxes,
  translatedConfigurations,
  warehouseProductLocations,
  warehouses,
  weightRanges,
  zones,
}

String prestaApiToString(PrestaApiResource prestaApiResource) {
  return switch (prestaApiResource) {
    PrestaApiResource.addresses => 'addresses',
    PrestaApiResource.attachments => 'attachments',
    PrestaApiResource.attachmentsFile => 'attachments/file',
    PrestaApiResource.carriers => 'carriers',
    PrestaApiResource.cartRules => 'cart_rules',
    PrestaApiResource.carts => 'carts',
    PrestaApiResource.categories => 'categories',
    PrestaApiResource.combinations => 'combinations',
    PrestaApiResource.configurations => 'configurations',
    PrestaApiResource.contacts => 'contacts',
    PrestaApiResource.contentManagementSystem => 'content_management_system',
    PrestaApiResource.countries => 'countries',
    PrestaApiResource.currencies => 'currencies',
    PrestaApiResource.customerMessages => 'customer_messages',
    PrestaApiResource.customerThreads => 'customer_threads',
    PrestaApiResource.customers => 'customers',
    PrestaApiResource.customizations => 'customizations',
    PrestaApiResource.deliveries => 'deliveries',
    PrestaApiResource.employees => 'employees',
    PrestaApiResource.groups => 'groups',
    PrestaApiResource.guests => 'guests',
    PrestaApiResource.imageTypes => 'image_types',
    PrestaApiResource.images => 'images',
    PrestaApiResource.imagesGeneralHeader => 'images_general_header',
    PrestaApiResource.imagesGeneralMail => 'images/generalmail',
    PrestaApiResource.imagesGeneralInvoice => 'images/general/invoice',
    PrestaApiResource.imagesGeneralStoreIcon => 'images/general/store_icon',
    PrestaApiResource.imagesProducts => 'images/products',
    PrestaApiResource.imagesCategories => 'images/categories',
    PrestaApiResource.imagesManufacturers => 'images/manufacturers',
    PrestaApiResource.imagesSuppliers => 'images/suppliers',
    PrestaApiResource.imagesStores => 'images/stores',
    PrestaApiResource.imagesCustomizations => 'images/customizations',
    PrestaApiResource.languages => 'languages',
    PrestaApiResource.manufacturers => 'manufacturers',
    PrestaApiResource.messages => 'messages',
    PrestaApiResource.orderCarriers => 'order_carriers',
    PrestaApiResource.orderDetails => 'order_details',
    PrestaApiResource.orderHistories => 'order_histories',
    PrestaApiResource.orderInvoices => 'order_invoices',
    PrestaApiResource.orderPayments => 'order_payments',
    PrestaApiResource.orderSlip => 'order_slip',
    PrestaApiResource.orderStates => 'order_states',
    PrestaApiResource.orders => 'orders',
    PrestaApiResource.priceRanges => 'price_ranges',
    PrestaApiResource.productCustomizationFields => 'product_customization_fields',
    PrestaApiResource.productFeatureValues => 'product_feature_values',
    PrestaApiResource.productFeatures => 'product_features',
    PrestaApiResource.productOptionValues => 'product_option_values',
    PrestaApiResource.productOptions => 'product_options',
    PrestaApiResource.productSuppliers => 'product_suppliers',
    PrestaApiResource.products => 'products',
    PrestaApiResource.search => 'search',
    PrestaApiResource.shopGroups => 'shop_groups',
    PrestaApiResource.shopUrls => 'shop_urls',
    PrestaApiResource.shops => 'shops',
    PrestaApiResource.stockAvailables => 'stock_availables',
    PrestaApiResource.stockMovementReasons => 'stock_movement_reasons',
    PrestaApiResource.stockMovements => 'stock_movements',
    PrestaApiResource.stocks => 'stocks',
    PrestaApiResource.stores => 'stores',
    PrestaApiResource.suppliers => 'suppliers',
    PrestaApiResource.supplyOrderDetails => 'supply_order_details',
    PrestaApiResource.supplyOrderHistories => 'supply_order_histories',
    PrestaApiResource.supplyOrderReceiptHistories => 'supply_order_receipt_histories',
    PrestaApiResource.supplyOrderStates => 'supply_order_states',
    PrestaApiResource.supplyOrders => 'supply_orders',
    PrestaApiResource.tags => 'tags',
    PrestaApiResource.taxRuleGroups => 'tax_rule_groups',
    PrestaApiResource.taxRules => 'tax_rules',
    PrestaApiResource.taxes => 'taxes',
    PrestaApiResource.translatedConfigurations => 'translated_configurations',
    PrestaApiResource.warehouseProductLocations => 'warehouse_product_locations',
    PrestaApiResource.warehouses => 'warehouses',
    PrestaApiResource.weightRanges => 'weight_ranges',
    PrestaApiResource.zones => 'zone',
  };
}

Future<Either<PrestaGeneralFailure, XmlDocument>> getResourcesFromPresta({
  required String fullUrl,
  required PrestaApiResource prestaApiResource,
  required String key,
}) async {
  final uri = '$fullUrl${prestaApiToString(prestaApiResource)}/';

  try {
    final response = await http.get(
      Uri.parse(uri),
      headers: {'Authorization': 'Basic ${base64Encode(utf8.encode('$key:'))}'},
    );

    if (response.statusCode == 200) {
      return right(XmlDocument.parse(response.body));
    } else {
      return left(PrestaGeneralFailure());
    }
  } catch (e) {
    return left(PrestaGeneralFailure());
  }
}

Future<Either<PrestaGeneralFailure, XmlDocument>> getResourcesFromPrestaById({
  required String fullUrl,
  required PrestaApiResource prestaApiResource,
  required String key,
  required int id,
}) async {
  final uri = '$fullUrl${prestaApiToString(prestaApiResource)}/$id';

  try {
    final response = await http.get(
      Uri.parse(uri),
      headers: {'Authorization': 'Basic ${base64Encode(utf8.encode('$key:'))}'},
    );
    logger.i(response.body);

    if (response.statusCode == 200) {
      return right(XmlDocument.parse(response.body));
    } else {
      return left(PrestaGeneralFailure());
    }
  } catch (e) {
    logger.e(e);
    return left(PrestaGeneralFailure());
  }
}

Future<Either<PrestaGeneralFailure, XmlDocument>> getResourcesFromPrestaByHref({
  required String href,
  required String key,
}) async {
  final uri = href;

  try {
    final response = await http.get(
      Uri.parse(uri),
      headers: {'Authorization': 'Basic ${base64Encode(utf8.encode('$key:'))}'},
    );
    logger.i(response.body);

    if (response.statusCode == 200) {
      return right(XmlDocument.parse(response.body));
    } else {
      return left(PrestaGeneralFailure());
    }
  } catch (e) {
    return left(PrestaGeneralFailure());
  }
}

Future<Either<PrestaGeneralFailure, XmlDocument>> getResourcesFromPrestaByFilterLiteral({
  required String fullUrl,
  required PrestaApiResource prestaApiResource,
  required String key,
  required String filterKey,
  required String filterValue,
}) async {
  final uri = '$fullUrl${prestaApiToString(prestaApiResource)}/?filter[$filterKey]=[$filterValue]';

  try {
    final response = await http.get(
      Uri.parse(uri),
      headers: {'Authorization': 'Basic ${base64Encode(utf8.encode('$key:'))}'},
    );

    if (response.statusCode == 200) {
      return right(XmlDocument.parse(response.body));
    } else {
      return left(PrestaGeneralFailure());
    }
  } catch (e) {
    return left(PrestaGeneralFailure());
  }
}

// Future<List<LanguagePresta>?> getMarketplaceLanguages(Marketplace marketplace) async {
//   final uri = '${marketplace.fullUrl}languages/?output_format=JSON&display=full';
//   final response = await http.get(
//     Uri.parse(uri),
//     headers: {'Authorization': 'Basic ${base64Encode(utf8.encode('${marketplace.key}:'))}'},
//   );

//   if (response.statusCode == 200) {
//     final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
//     final List<dynamic> languageList = jsonResponse['languages'];

//     List<LanguagePresta> shopLanguages = languageList
//         .map((e) => LanguagePresta(
//               id: e['id'] as int,
//               name: e['name'] as String,
//               isoCode: e['iso_code'] as String,
//               locale: e['locale'] as String,
//               languageCode: e['language_code'] as String,
//               active: e['active'] == '1',
//               isRtl: e['is_rtl'] == '1',
//               dateFormatLite: e['date_format_lite'] as String,
//               dateFormatFull: e['date_format_full'] as String,
//               isDefault: false,
//             ))
//         .toList();
//     return shopLanguages;
//   } else {
//     return null;
//   }
// }
