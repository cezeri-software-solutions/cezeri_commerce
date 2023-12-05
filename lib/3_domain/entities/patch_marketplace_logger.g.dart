// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch_marketplace_logger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatchMarketplaceLogger _$PatchMarketplaceLoggerFromJson(
        Map<String, dynamic> json) =>
    PatchMarketplaceLogger(
      id: json['id'] as String,
      loggerType: $enumDecode(_$LoggerTypeEnumMap, json['loggerType']),
      loggerActionType:
          $enumDecode(_$LoggerActionTypeEnumMap, json['loggerActionType']),
      isSeen: json['isSeen'] as bool,
      marketplaceId: json['marketplaceId'] as String,
      marketplaceName: json['marketplaceName'] as String,
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      productArticleNumber: json['productArticleNumber'] as String?,
      orderId: json['orderId'] as String?,
      errorMessage: json['errorMessage'] as String,
      creationDate: DateTime.parse(json['creationDate'] as String),
    );

Map<String, dynamic> _$PatchMarketplaceLoggerToJson(
        PatchMarketplaceLogger instance) =>
    <String, dynamic>{
      'id': instance.id,
      'loggerType': _$LoggerTypeEnumMap[instance.loggerType]!,
      'loggerActionType': _$LoggerActionTypeEnumMap[instance.loggerActionType]!,
      'isSeen': instance.isSeen,
      'marketplaceId': instance.marketplaceId,
      'marketplaceName': instance.marketplaceName,
      'productId': instance.productId,
      'productName': instance.productName,
      'productArticleNumber': instance.productArticleNumber,
      'orderId': instance.orderId,
      'errorMessage': instance.errorMessage,
      'creationDate': instance.creationDate.toIso8601String(),
    };

const _$LoggerTypeEnumMap = {
  LoggerType.product: 'product',
  LoggerType.order: 'order',
};

const _$LoggerActionTypeEnumMap = {
  LoggerActionType.setStocks: 'setStocks',
  LoggerActionType.uploadProductImages: 'uploadProductImages',
  LoggerActionType.updateProduct: 'updateProduct',
  LoggerActionType.updateOrderStatus: 'updateOrderStatus',
};
