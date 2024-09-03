import 'package:json_annotation/json_annotation.dart';

part 'patch_marketplace_logger.g.dart';

enum LoggerType { product, order }

enum LoggerActionType { setStocks, uploadProductImages, updateProduct, updateOrderStatus }

@JsonSerializable(explicitToJson: true)
class PatchMarketplaceLogger {
  final String id;
  final LoggerType loggerType;
  final LoggerActionType loggerActionType;
  final bool isSeen;
  final String marketplaceId;
  final String marketplaceName;
  final String? productId;
  final String? productName;
  final String? productArticleNumber;
  final String? orderId;
  final String errorMessage;
  final DateTime creationDate;

  PatchMarketplaceLogger({
    required this.id,
    required this.loggerType,
    required this.loggerActionType,
    required this.isSeen,
    required this.marketplaceId,
    required this.marketplaceName,
    required this.productId,
    required this.productName,
    required this.productArticleNumber,
    required this.orderId,
    required this.errorMessage,
    required this.creationDate,
  });

  factory PatchMarketplaceLogger.fromJson(Map<String, dynamic> json) => _$PatchMarketplaceLoggerFromJson(json);
  Map<String, dynamic> toJson() => _$PatchMarketplaceLoggerToJson(this);

  factory PatchMarketplaceLogger.empty() {
    return PatchMarketplaceLogger(
      id: '',
      loggerType: LoggerType.product,
      loggerActionType: LoggerActionType.setStocks,
      isSeen: false,
      marketplaceId: '',
      marketplaceName: '',
      productId: null,
      productName: null,
      productArticleNumber: null,
      orderId: null,
      errorMessage: '',
      creationDate: DateTime.now(),
    );
  }

  PatchMarketplaceLogger copyWith({
    String? id,
    LoggerType? loggerType,
    LoggerActionType? loggerActionType,
    bool? isSeen,
    String? marketplaceId,
    String? marketplaceName,
    String? productId,
    String? productName,
    String? productArticleNumber,
    String? orderId,
    String? errorMessage,
    DateTime? creationDate,
  }) {
    return PatchMarketplaceLogger(
      id: id ?? this.id,
      loggerType: loggerType ?? this.loggerType,
      loggerActionType: loggerActionType ?? this.loggerActionType,
      isSeen: isSeen ?? this.isSeen,
      marketplaceId: marketplaceId ?? this.marketplaceId,
      marketplaceName: marketplaceName ?? this.marketplaceName,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productArticleNumber: productArticleNumber ?? this.productArticleNumber,
      orderId: orderId ?? this.orderId,
      errorMessage: errorMessage ?? this.errorMessage,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  @override
  String toString() {
    return 'PatchMarketplaceLogger(id: $id, loggerType: $loggerType, loggerActionType: $loggerActionType, isSeen: $isSeen, marketplaceId: $marketplaceId, marketplaceName: $marketplaceName, productId: $productId, productName: $productName, productArticleNumber: $productArticleNumber, orderId: $orderId, errorMessage: $errorMessage, creationDate: $creationDate)';
  }
}
