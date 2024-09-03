import 'package:json_annotation/json_annotation.dart';

import '../country.dart';

part 'carrier_product.g.dart';

@JsonSerializable(explicitToJson: true)
class CarrierProduct {
  final String id; // jedes Produkt hat eine ID direkt vom Versanddienstleister
  // @JsonKey(name: 'product_name')
  final String productName;
  // @JsonKey(name: 'is_default')
  final bool isDefault;
  // @JsonKey(name: 'is_return')
  final bool isReturn;
  // @JsonKey(name: 'is_active')
  final bool isActive;
  final Country country;

  const CarrierProduct({
    required this.id,
    required this.productName,
    required this.isDefault,
    required this.isReturn,
    required this.isActive,
    required this.country,
  });

  factory CarrierProduct.fromJson(Map<String, dynamic> json) => _$CarrierProductFromJson(json);

  Map<String, dynamic> toJson() => _$CarrierProductToJson(this);

  factory CarrierProduct.empty() {
    return CarrierProduct(
      id: '',
      productName: '',
      isDefault: false,
      isReturn: false,
      isActive: false,
      country: Country.empty(),
    );
  }

  CarrierProduct copyWith({
    String? id,
    String? productName,
    bool? isDefault,
    bool? isReturn,
    bool? isActive,
    Country? country,
  }) {
    return CarrierProduct(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      isDefault: isDefault ?? this.isDefault,
      isReturn: isReturn ?? this.isReturn,
      isActive: isActive ?? this.isActive,
      country: country ?? this.country,
    );
  }

  @override
  String toString() {
    return 'CarrierProduct(id: $id, productName: $productName, isDefault: $isDefault, isReturn: $isReturn, isActive: $isActive, country: $country)';
  }

  static List<CarrierProduct> carrierProductListAustrianPost = [
    CarrierProduct.empty(),
    CarrierProduct.empty().copyWith(id: '28', productName: 'Retourpaket'),
    CarrierProduct.empty().copyWith(id: '63', productName: 'Retourpaket International'),
    CarrierProduct.empty().copyWith(id: '14', productName: 'Premium light'),
    CarrierProduct.empty().copyWith(id: '30', productName: 'Premium Select'),
    CarrierProduct.empty().copyWith(id: '12', productName: 'Kleinpaket'),
    CarrierProduct.empty().copyWith(id: '65', productName: 'Next Day'),
    CarrierProduct.empty().copyWith(id: '10', productName: 'Paket Österreich'),
    CarrierProduct.empty().copyWith(id: '45', productName: 'Paket Premium International'),
    CarrierProduct.empty().copyWith(id: '47', productName: 'Combi-freight Österreich'),
    CarrierProduct.empty().copyWith(id: '49', productName: 'Combi-freight International'),
    CarrierProduct.empty().copyWith(id: '31', productName: 'Paket Premium Österreich B2B'),
    CarrierProduct.empty().copyWith(id: '01', productName: 'Post Express Österreich'),
    CarrierProduct.empty().copyWith(id: '46', productName: 'Post Express International'),
    CarrierProduct.empty().copyWith(id: '78', productName: 'Päckchen M mit Sendungsverfolgung'),
    CarrierProduct.empty().copyWith(id: '70', productName: 'Paket Plus Int. Outbound'),
    CarrierProduct.empty().copyWith(id: '69', productName: 'Paket Light Int. non boxable Outbound'),
    CarrierProduct.empty().copyWith(id: '96', productName: 'Kleinpaket 2000'),
    CarrierProduct.empty().copyWith(id: '16', productName: 'Kleinpaket 2000 Plus'),
  ];

  static List<CarrierProduct> carrierProductListDpd = [
    CarrierProduct.empty(),
  ];
}
