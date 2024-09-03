import 'package:json_annotation/json_annotation.dart';

part 'product_image.g.dart';

@JsonSerializable()
class ProductImage {
  final int sortId;
  final String fileName;
  final String fileUrl;
  final String seoText;
  final bool isDefault;

  ProductImage({required this.sortId, required this.fileName, required this.fileUrl, required this.seoText, required this.isDefault});

  factory ProductImage.empty() {
    return ProductImage(sortId: 0, fileName: '', fileUrl: '', seoText: '', isDefault: false);
  }

  factory ProductImage.fromJson(Map<String, dynamic> json) => _$ProductImageFromJson(json);

  Map<String, dynamic> toJson() => _$ProductImageToJson(this);

  ProductImage copyWith({
    int? sortId,
    String? fileName,
    String? fileUrl,
    String? seoText,
    bool? isDefault,
  }) {
    return ProductImage(
      sortId: sortId ?? this.sortId,
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      seoText: seoText ?? this.seoText,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  String toString() {
    return 'ProductImage(sortId: $sortId, fileName: $fileName, fileUrl: $fileUrl, seoText: $seoText, isDefault: $isDefault)';
  }
}
