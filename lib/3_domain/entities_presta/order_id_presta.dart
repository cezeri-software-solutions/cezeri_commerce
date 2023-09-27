import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'order_id_presta.g.dart';

@JsonSerializable()
class OrdersIdPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  @JsonKey(name: 'orders')
  final List<OrderIdPresta> items;

  const OrdersIdPresta({required this.items});

  factory OrdersIdPresta.fromJson(Map<String, dynamic> json) => _$OrdersIdPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$OrdersIdPrestaToJson(this);

  List<Object?> get props => [items];

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable()
class OrderIdPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  final int id;

  const OrderIdPresta({required this.id});

  factory OrderIdPresta.fromJson(Map<String, dynamic> json) => _$OrderIdPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$OrderIdPrestaToJson(this);

  List<Object?> get props => [id];

  @override
  String toString() => _encoder.convert(toJson());
}
