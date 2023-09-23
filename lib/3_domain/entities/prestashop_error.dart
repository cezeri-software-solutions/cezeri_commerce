import 'package:json_annotation/json_annotation.dart';

import 'product/product.dart';

part 'prestashop_error.g.dart';

enum PrestaErrorOn { empty, getProduct, updateProductQuantity }

@JsonSerializable(explicitToJson: true)
class PrestashopError {
  final String request;
  final String responseBody;
  final int responseStatusCode;
  final String message;
  final PrestaErrorOn prestaErrorOn;
  final String marketplaceName;
  final Product? currentProduct;
  final Product? newProduct;
  final bool isNew;

  const PrestashopError({
    required this.request,
    required this.responseBody,
    required this.responseStatusCode,
    required this.message,
    required this.prestaErrorOn,
    required this.marketplaceName,
    required this.currentProduct,
    required this.newProduct,
    required this.isNew,
  });

  factory PrestashopError.empty() {
    return PrestashopError(
      request: '',
      responseBody: '',
      responseStatusCode: 0,
      message: '',
      prestaErrorOn: PrestaErrorOn.empty,
      marketplaceName: '',
      currentProduct: Product.empty(),
      newProduct: Product.empty(),
      isNew: true,
    );
  }

  factory PrestashopError.fromJson(Map<String, dynamic> json) => _$PrestashopErrorFromJson(json);

  Map<String, dynamic> toJson() => _$PrestashopErrorToJson(this);

  PrestashopError copyWith({
    String? request,
    String? responseBody,
    int? responseStatusCode,
    String? message,
    PrestaErrorOn? prestaErrorOn,
    String? marketplaceName,
    Product? currentProduct,
    Product? newProduct,
    bool? isNew,
  }) {
    return PrestashopError(
      request: request ?? this.request,
      responseBody: responseBody ?? this.responseBody,
      responseStatusCode: responseStatusCode ?? this.responseStatusCode,
      message: message ?? this.message,
      prestaErrorOn: prestaErrorOn ?? this.prestaErrorOn,
      marketplaceName: marketplaceName ?? this.marketplaceName,
      currentProduct: currentProduct ?? this.currentProduct,
      newProduct: newProduct ?? this.newProduct,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  String toString() {
    return 'PrestashopError(request: $request, responseBody: $responseBody, responseStatusCode: $responseStatusCode, message: $message, prestaErrorOn: $prestaErrorOn, marketplaceName: $marketplaceName, currentProduct: $currentProduct, newProduct: $newProduct, isNew: $isNew)';
  }
}
