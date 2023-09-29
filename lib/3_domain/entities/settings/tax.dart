import 'package:json_annotation/json_annotation.dart';

part 'tax.g.dart';

@JsonSerializable()
class Tax {
  final String taxId;
  final String taxName;
  final int taxRate;
  final String country;
  final String countryIsoCode;
  final bool isDefault;

  const Tax({
    required this.taxId,
    required this.taxName,
    required this.taxRate,
    required this.country,
    required this.countryIsoCode,
    required this.isDefault,
  });

  factory Tax.fromJson(Map<String, dynamic> json) => _$TaxFromJson(json);

  Map<String, dynamic> toJson() => _$TaxToJson(this);

  factory Tax.empty() {
    return const Tax(
      taxId: '',
      taxName: '',
      taxRate: 0,
      country: '',
      countryIsoCode: '',
      isDefault: false,
    );
  }

  Tax copyWith({
    String? taxId,
    String? taxName,
    int? taxRate,
    String? country,
    String? countryIsoCode,
    bool? isDefault,
  }) {
    return Tax(
      taxId: taxId ?? this.taxId,
      taxName: taxName ?? this.taxName,
      taxRate: taxRate ?? this.taxRate,
      country: country ?? this.country,
      countryIsoCode: countryIsoCode ?? this.countryIsoCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  String toString() {
    return 'Tax(taxId: $taxId, taxName: $taxName, taxRate: $taxRate, country: $country, countryIsoCode: $countryIsoCode, isDefault: $isDefault)';
  }
}
