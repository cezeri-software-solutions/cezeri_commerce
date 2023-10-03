import 'dart:io';

class ProductPrestaImage {
  final int? productId;
  final File? imageFile;

  const ProductPrestaImage({this.productId, this.imageFile});

  factory ProductPrestaImage.empty() {
    return const ProductPrestaImage(productId: null, imageFile: null);
  }

  ProductPrestaImage copyWith({
    int? productId,
    File? imageFile,
  }) {
    return ProductPrestaImage(
      productId: productId ?? this.productId,
      imageFile: imageFile ?? this.imageFile,
    );
  }

  @override
  String toString() => 'ProductPrestaImage(productId: $productId, imageFile: $imageFile)';
}
