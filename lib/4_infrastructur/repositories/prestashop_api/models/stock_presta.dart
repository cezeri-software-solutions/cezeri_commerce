



class StockPresta {
  int? idWarehouse; // Warehouse ID
  int? idProduct; // Product ID
  int? idProductAttribute; // Product attribute ID
  int? realQuantity; // Real quantity
  String? reference; // Reference
  String? ean13; // EAN13
  String? isbn; // ISBN
  String? upc; // UPC
  String? mpn; // MPN
  int? physicalQuantity; // Physical quantity
  int? usableQuantity; // Usable quantity
  double? priceTe; // Price excluding tax

  StockPresta({
    this.idWarehouse,
    this.idProduct,
    this.idProductAttribute,
    this.realQuantity,
    this.reference,
    this.ean13,
    this.isbn,
    this.upc,
    this.mpn,
    this.physicalQuantity,
    this.usableQuantity,
    this.priceTe,
  });
}
