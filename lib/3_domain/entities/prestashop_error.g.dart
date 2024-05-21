// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prestashop_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrestashopError _$PrestashopErrorFromJson(Map<String, dynamic> json) =>
    PrestashopError(
      request: json['request'] as String,
      responseBody: json['responseBody'] as String,
      responseStatusCode: (json['responseStatusCode'] as num).toInt(),
      message: json['message'] as String,
      prestaErrorOn: $enumDecode(_$PrestaErrorOnEnumMap, json['prestaErrorOn']),
      marketplaceName: json['marketplaceName'] as String,
      currentProduct: json['currentProduct'] == null
          ? null
          : Product.fromJson(json['currentProduct'] as Map<String, dynamic>),
      newProduct: json['newProduct'] == null
          ? null
          : Product.fromJson(json['newProduct'] as Map<String, dynamic>),
      isNew: json['isNew'] as bool,
    );

Map<String, dynamic> _$PrestashopErrorToJson(PrestashopError instance) =>
    <String, dynamic>{
      'request': instance.request,
      'responseBody': instance.responseBody,
      'responseStatusCode': instance.responseStatusCode,
      'message': instance.message,
      'prestaErrorOn': _$PrestaErrorOnEnumMap[instance.prestaErrorOn]!,
      'marketplaceName': instance.marketplaceName,
      'currentProduct': instance.currentProduct?.toJson(),
      'newProduct': instance.newProduct?.toJson(),
      'isNew': instance.isNew,
    };

const _$PrestaErrorOnEnumMap = {
  PrestaErrorOn.empty: 'empty',
  PrestaErrorOn.getProduct: 'getProduct',
  PrestaErrorOn.updateProductQuantity: 'updateProductQuantity',
};
