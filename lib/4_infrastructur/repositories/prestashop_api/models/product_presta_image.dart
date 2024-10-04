import 'dart:io';
import 'dart:typed_data';

class ProductPrestaImage {
  final int productId;
  final File? imageFile;
  final Uint8List? imageData;

  const ProductPrestaImage({required this.productId, this.imageFile, this.imageData});

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
