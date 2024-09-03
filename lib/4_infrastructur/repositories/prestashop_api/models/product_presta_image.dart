import 'dart:io';

class ProductPrestaImage {
  final int productId;
  final File imageFile;

  const ProductPrestaImage({required this.productId, required this.imageFile});

  factory ProductPrestaImage.empty() {
    return ProductPrestaImage(productId: 0, imageFile: File(''));
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
