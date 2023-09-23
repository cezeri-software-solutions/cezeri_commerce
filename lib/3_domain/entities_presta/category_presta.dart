// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'product_presta.dart';

class CategoryPresta {
  int? idParent;
  int? levelDepth;
  int? nbProductsRecursive;
  bool? active;
  int? idShopDefault;
  bool? isRootCategory;
  int? position;
  DateTime? dateAdd;
  DateTime? dateUpd;
  String? name;
  String? linkRewrite;
  String? description;
  String? metaTitle;
  String? metaDescription;
  String? metaKeywords;
  List<CategoryPresta>? categories;
  List<ProductPresta>? products;

  CategoryPresta({
    this.idParent,
    this.levelDepth,
    this.nbProductsRecursive,
    this.active,
    this.idShopDefault,
    this.isRootCategory,
    this.position,
    this.dateAdd,
    this.dateUpd,
    this.name,
    this.linkRewrite,
    this.description,
    this.metaTitle,
    this.metaDescription,
    this.metaKeywords,
    this.categories,
    this.products,
  });
}
