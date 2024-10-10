import '../../../../3_domain/entities/my_file.dart';

class ProductPrestaImage {
  final int productId;
  final MyFile imageFile;

  const ProductPrestaImage({required this.productId, required this.imageFile});

  factory ProductPrestaImage.empty() {
    return ProductPrestaImage(productId: 0, imageFile: MyFile.empty());
  }

  ProductPrestaImage copyWith({
    int? productId,
    MyFile? imageFile,
  }) {
    return ProductPrestaImage(
      productId: productId ?? this.productId,
      imageFile: imageFile ?? this.imageFile,
    );
  }

  @override
  String toString() => 'ProductPrestaImage(productId: $productId, imageFile: $imageFile)';
}
