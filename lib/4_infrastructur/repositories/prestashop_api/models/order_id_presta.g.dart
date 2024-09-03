// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_id_presta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdersIdPresta _$OrdersIdPrestaFromJson(Map<String, dynamic> json) =>
    OrdersIdPresta(
      items: (json['orders'] as List<dynamic>)
          .map((e) => OrderIdPresta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrdersIdPrestaToJson(OrdersIdPresta instance) =>
    <String, dynamic>{
      'orders': instance.items,
    };

OrderIdPresta _$OrderIdPrestaFromJson(Map<String, dynamic> json) =>
    OrderIdPresta(
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$OrderIdPrestaToJson(OrderIdPresta instance) =>
    <String, dynamic>{
      'id': instance.id,
    };
