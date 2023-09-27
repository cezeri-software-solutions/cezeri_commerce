import 'package:json_annotation/json_annotation.dart';

part 'customer_marketplace.g.dart';

@JsonSerializable()
class CustomerMarketplace {
  final String marketplaceId;
  final String marketplaceName;
  final int customerIdMarketplace;

  const CustomerMarketplace({
    required this.marketplaceId,
    required this.marketplaceName,
    required this.customerIdMarketplace,
  });

  factory CustomerMarketplace.fromJson(Map<String, dynamic> json) => _$CustomerMarketplaceFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerMarketplaceToJson(this);

  factory CustomerMarketplace.empty() {
    return const CustomerMarketplace(
      marketplaceId: '',
      marketplaceName: '',
      customerIdMarketplace: 0,
    );
  }

  CustomerMarketplace copyWith({
    String? marketplaceId,
    String? marketplaceName,
    int? customerIdMarketplace,
  }) {
    return CustomerMarketplace(
      marketplaceId: marketplaceId ?? this.marketplaceId,
      marketplaceName: marketplaceName ?? this.marketplaceName,
      customerIdMarketplace: customerIdMarketplace ?? this.customerIdMarketplace,
    );
  }

  @override
  String toString() =>
      'CustomerMarketplace(marketplaceId: $marketplaceId, marketplaceName: $marketplaceName, customerIdMarketplace: $customerIdMarketplace)';
}
