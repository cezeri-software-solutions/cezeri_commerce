// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingProduct _$BookingProductFromJson(Map<String, dynamic> json) =>
    BookingProduct(
      id: json['id'] as String,
      productId: json['productId'] as String,
      reorderId: json['reorderId'] as String,
      reorderNumber: json['reorderNumber'] as String,
      name: json['name'] as String,
      articleNumber: json['articleNumber'] as String,
      ean: json['ean'] as String,
      quantity: (json['quantity'] as num).toInt(),
      toBookQuantity: (json['toBookQuantity'] as num).toInt(),
      bookedQuantity: (json['bookedQuantity'] as num).toInt(),
      warehouseStock: (json['warehouseStock'] as num).toInt(),
      availableStock: (json['availableStock'] as num).toInt(),
      isFromDatabase: json['isFromDatabase'] as bool,
    );

Map<String, dynamic> _$BookingProductToJson(BookingProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'reorderId': instance.reorderId,
      'reorderNumber': instance.reorderNumber,
      'name': instance.name,
      'articleNumber': instance.articleNumber,
      'ean': instance.ean,
      'quantity': instance.quantity,
      'toBookQuantity': instance.toBookQuantity,
      'bookedQuantity': instance.bookedQuantity,
      'warehouseStock': instance.warehouseStock,
      'availableStock': instance.availableStock,
      'isFromDatabase': instance.isFromDatabase,
    };
