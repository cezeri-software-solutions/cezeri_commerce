import '../../../3_domain/entities/address.dart';

Address getDefaultAddress(List<Address> addresses, AddressType type) {
  final defaultAddress = addresses.where((e) => e.addressType == type && e.isDefault).firstOrNull;
  if (defaultAddress != null) return defaultAddress;

  final otherTypeDefault = addresses.where((e) => e.isDefault).firstOrNull;
  if (otherTypeDefault != null) return otherTypeDefault;

  final typeAddress = addresses.where((e) => e.addressType == type).firstOrNull;
  if (typeAddress != null) return typeAddress;

  final anyOrEmptyAddress = addresses.isNotEmpty ? addresses.first : Address.empty();
  return anyOrEmptyAddress;
}
