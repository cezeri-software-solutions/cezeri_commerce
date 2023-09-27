import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

@JsonSerializable(explicitToJson: true)
class Country {
  final String id; 
  final String isoCode;
  final String name;

  const Country({
    required this.id,
    required this.isoCode,
    required this.name,
  });

  factory Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);

  factory Country.empty() {
    return const Country(
      id: '',
      isoCode: '',
      name: '',
    );
  }

  Country copyWith({
    String? id,
    String? isoCode,
    String? name,
  }) {
    return Country(
      id: id ?? this.id,
      isoCode: isoCode ?? this.isoCode,
      name: name ?? this.name,
    );
  }

  @override
  String toString() => 'Country(id: $id, isoCode: $isoCode, name: $name)';
}
