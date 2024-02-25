import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'carrier_presta.g.dart';

@JsonSerializable()
class CarriersPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  @JsonKey(name: 'carriers')
  final List<CarrierPresta> items;

  const CarriersPresta({required this.items});

  factory CarriersPresta.fromJson(Map<String, dynamic> json) => _$CarriersPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$CarriersPrestaToJson(this);

  List<Object?> get props => [items];

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable()
class CarrierPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  final int id;
  final String deleted;
  @JsonKey(name: 'is_module')
  final String isModule;
  @JsonKey(name: 'id_tax_rules_group', fromJson: _idTaxRulesGroupFromJson)
  final int idTaxRulesGroup;
  @JsonKey(name: 'id_reference')
  final String idReference;
  final String name;
  final String active;
  @JsonKey(name: 'is_free')
  final String isFree;
  final String url;
  @JsonKey(name: 'shipping_handling')
  final String shippingHandling;
  @JsonKey(name: 'shipping_external')
  final String shippingExternal;
  @JsonKey(name: 'range_behavior')
  final String rangeBehavior;
  @JsonKey(name: 'shipping_method')
  final String shippingMethod;
  @JsonKey(name: 'max_width')
  final String maxWidth;
  @JsonKey(name: 'max_height')
  final String maxHeight;
  @JsonKey(name: 'max_depth')
  final String maxDepth;
  @JsonKey(name: 'max_weight')
  final String maxWeight;
  final String grade;
  @JsonKey(name: 'external_module_name')
  final String externalModuleName;
  @JsonKey(name: 'need_range')
  final String needRange;
  final String position;
  //final String delay;

  const CarrierPresta({
    required this.id,
    required this.deleted,
    required this.isModule,
    required this.idTaxRulesGroup,
    required this.idReference,
    required this.name,
    required this.active,
    required this.isFree,
    required this.url,
    required this.shippingHandling,
    required this.shippingExternal,
    required this.rangeBehavior,
    required this.shippingMethod,
    required this.maxWidth,
    required this.maxHeight,
    required this.maxDepth,
    required this.maxWeight,
    required this.grade,
    required this.externalModuleName,
    required this.needRange,
    required this.position,
    //required this.delay,
  });

  static int _idTaxRulesGroupFromJson(dynamic idTaxRulesGroup) {
    if (idTaxRulesGroup is int) {
      return idTaxRulesGroup;
    }
    return int.parse(idTaxRulesGroup);
  }

  factory CarrierPresta.fromJson(Map<String, dynamic> json) => _$CarrierPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$CarrierPrestaToJson(this);

  List<Object?> get props => [id];

  @override
  String toString() => _encoder.convert(toJson());
}
