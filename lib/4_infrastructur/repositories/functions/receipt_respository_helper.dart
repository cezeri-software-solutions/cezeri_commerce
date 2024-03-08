import 'package:logger/logger.dart';

import '/3_domain/entities/address.dart';
import '/3_domain/entities/customer/customer.dart';
import '/3_domain/repositories/firebase/customer_repository.dart';

final logger = Logger();

Future<Customer?> getCustomerByMarketplaceId(CustomerRepository customerRepository, String marketplaceId, int customerIdMarketplace) async {
  Customer? loadedCustomer;
  final fosCustomer = await customerRepository.getCustomerByCustomerIdInMarketplace(marketplaceId, customerIdMarketplace);
  fosCustomer.fold(
    (failure) =>
        logger.i('Kunde mit der Marktplatz ID: $customerIdMarketplace konte nicht in der Firestore Datenbank gefunden werden. \n Error: $failure'),
    (customer) => loadedCustomer = customer,
  );

  return loadedCustomer;
}

Future<Customer?> createCustomerFromMarketplace(CustomerRepository customerRepository, Customer customer) async {
  Customer? createdCustomer;
  final fosCustomer = await customerRepository.createCustomer(customer);
  fosCustomer.fold(
    (failure) => logger.e('Kunde: ${customer.name} konte nicht in der Firestore Datenbank angelegt werden. \n Error: $failure'),
    (customer) => createdCustomer = customer,
  );

  return createdCustomer;
}

Future<Customer?> checkCustomerAddressIsUpToDateOrUpdateThem(
  CustomerRepository customerRepository,
  Customer customer,
  Address addressInvoice,
  Address addressDelivery,
) async {
  final indexOfStoredInvoiceAddress = customer.listOfAddress.indexWhere((e) => e == addressInvoice);
  final indexOfStoredDeliveryAddress = customer.listOfAddress.indexWhere((e) => e == addressDelivery);

  bool updateRequired = false;

  // Wenn die Rechnungsadresse vorhanden ist, aber isDefault false ist
  if (indexOfStoredInvoiceAddress != -1 && !customer.listOfAddress[indexOfStoredInvoiceAddress].isDefault) {
    customer.listOfAddress[indexOfStoredInvoiceAddress] = customer.listOfAddress[indexOfStoredInvoiceAddress].copyWith(isDefault: true);
    updateRequired = true;
  }

  // Wenn die Lieferadresse vorhanden ist, aber isDefault false ist
  if (indexOfStoredDeliveryAddress != -1 && !customer.listOfAddress[indexOfStoredDeliveryAddress].isDefault) {
    customer.listOfAddress[indexOfStoredDeliveryAddress] = customer.listOfAddress[indexOfStoredDeliveryAddress].copyWith(isDefault: true);
    updateRequired = true;
  }

  // Wenn die Rechnungsadresse nicht vorhanden ist
  if (indexOfStoredInvoiceAddress == -1) {
    customer.listOfAddress.add(addressInvoice.copyWith(isDefault: true));
    updateRequired = true;
  }

  // Wenn die Lieferadresse nicht vorhanden ist
  if (indexOfStoredDeliveryAddress == -1) {
    customer.listOfAddress.add(addressDelivery.copyWith(isDefault: true));
    updateRequired = true;
  }

  // Setzen Sie isDefault für alle anderen Adressen auf false
  for (int i = 0; i < customer.listOfAddress.length; i++) {
    if (i != indexOfStoredInvoiceAddress && i != indexOfStoredDeliveryAddress) {
      customer.listOfAddress[i] = customer.listOfAddress[i].copyWith(isDefault: false);
    }
  }

  Customer? updatedCustomer;

  if (updateRequired) {
    final fosCustomer = await customerRepository.updateCustomer(customer);
    fosCustomer.fold(
      (failure) =>
          logger.e('Adressen des Kunden: ${customer.name} konte nicht in der Firestore Datenbank aktualisiert werden werden. \n Error: $failure'),
      (customer) => updatedCustomer = customer,
    );
  } else {
    updatedCustomer = customer;
  }

  updatedCustomer ??= customer;

  return updatedCustomer;
}

