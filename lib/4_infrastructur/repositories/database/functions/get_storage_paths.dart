String getProductImagesStoragePath(String ownerId, String productId) {
  return '$ownerId/$productId';
}

String getShippingLabelStoragePath(String ownerId, String receiptId) {
  return '$ownerId/$receiptId';
}

String getMarketplaceStoragePath(String ownerId, String marketplaceId) {
  return '$ownerId/$marketplaceId';
}