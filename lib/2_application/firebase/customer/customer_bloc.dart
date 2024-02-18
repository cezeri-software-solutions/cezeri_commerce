import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../core/abstract_failure.dart';
import '/3_domain/entities/address.dart';
import '/3_domain/entities/customer/customer.dart';
import '/3_domain/entities/settings/main_settings.dart';
import '/3_domain/entities/settings/tax.dart';
import '/3_domain/repositories/firebase/customer_repository.dart';
import '/3_domain/repositories/firebase/main_settings_respository.dart';

part 'customer_event.dart';
part 'customer_state.dart';

final logger = Logger();

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository _customerRepository;
  final MainSettingsRepository _mainSettingsRepository;

  CustomerBloc({
    required CustomerRepository customerRepository,
    required MainSettingsRepository mainSettingsRepository,
  })  : _customerRepository = customerRepository,
        _mainSettingsRepository = mainSettingsRepository,
        super(CustomerState.initial()) {
    on<SetCustomerStateToInitialEvent>(_onSetCustomerStateToInitial);
    on<GetAllCustomersEvent>(_onGetAllCustomers);
    on<GetCustomerEvent>(_onGetCustomer);
    on<SetEmptyCustomerOnCreateNewCustomerEvent>(_onSetEmptyCustomerOnCreateNewCustomer);
    on<CreateCustomerEvent>(_onCreateCustomer);
    on<UpdateCustomerEvent>(_onUpdateCustomer);
    on<SetSearchFieldTextEvent>(_onSetSearchFieldText);
    on<OnSearchFieldSubmittedEvent>(_onSearchFieldSubmitted);
    on<OnSelectAllCustomersEvent>(_onSelectAllCustomers);
    on<OnCustomerSelectedEvent>(_onCustomerSelected);
    on<SetCustomerTaxEvent>(_onSetCustomerTax);
    on<OnCustomerInvoiceTypeChangedEvent>(_onCustomerInvoiceTypeChanged);
    on<OnAddEditCustomerAddressEvent>(_onAddEditCustomerAddress);
    on<SetCustomerControllerEvent>(_onSetCustomerController);
    on<OnCustomerControllerChangedEvent>(_onCustomerControllerChanged);
  }

  void _onSetCustomerStateToInitial(SetCustomerStateToInitialEvent event, Emitter<CustomerState> emit) async {
    emit(CustomerState.initial());
  }

  Future<void> _onGetAllCustomers(GetAllCustomersEvent event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(isLoadingCustomersOnObserve: true));

    final failureOrCustomers = await _customerRepository.getListOfCustomers();
    failureOrCustomers.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
      (customers) {
        emit(state.copyWith(listOfAllCustomers: customers, selectedCustomers: [], firebaseFailure: null, isAnyFailure: false));
        add(OnSearchFieldSubmittedEvent());
      },
    );

    emit(state.copyWith(
      isLoadingCustomersOnObserve: false,
      fosCustomersOnObserveOption: optionOf(failureOrCustomers),
    ));
    emit(state.copyWith(fosCustomersOnObserveOption: none()));
  }

  Future<void> _onGetCustomer(GetCustomerEvent event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(isLoadingCustomerOnObserve: true));

    final failureOrCustomer = await _customerRepository.getCustomer(event.customer.id);
    failureOrCustomer.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
      (customer) {
        emit(state.copyWith(customer: customer, firebaseFailure: null, isAnyFailure: false));
        add(SetCustomerControllerEvent());
      },
    );

    emit(state.copyWith(
      isLoadingCustomerOnObserve: false,
      fosCustomerOnObserveOption: optionOf(failureOrCustomer),
    ));
    emit(state.copyWith(fosCustomerOnObserveOption: none()));
  }

  Future<void> _onSetEmptyCustomerOnCreateNewCustomer(SetEmptyCustomerOnCreateNewCustomerEvent event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(isLoadingCustomerMainSettingsOnObserve: true));

    final fos = await _mainSettingsRepository.getSettings();
    fos.fold(
      (failure) => null,
      (settings) {
        emit(state.copyWith(customer: Customer.empty().copyWith(customerNumber: settings.nextCustomerNumber)));
        add(SetCustomerControllerEvent());
      },
    );

    emit(state.copyWith(
      isLoadingCustomerMainSettingsOnObserve: false,
      fosCustomerMainSettingsOnObserveOption: optionOf(fos),
    ));
    emit(state.copyWith(fosCustomerMainSettingsOnObserveOption: none()));
  }

  Future<void> _onCreateCustomer(CreateCustomerEvent event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(isLoadingCustomerOnCreate: true));

    final failureOrSuccess = await _customerRepository.createCustomer(state.customer!);
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
      (customer) => emit(state.copyWith(customer: customer, firebaseFailure: null, isAnyFailure: false)),
    );

    emit(state.copyWith(
      isLoadingCustomerOnCreate: false,
      fosCustomerOnCreateOption: optionOf(failureOrSuccess),
    ));
    emit(state.copyWith(fosCustomerOnCreateOption: none()));
  }

  Future<void> _onUpdateCustomer(UpdateCustomerEvent event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(isLoadingCustomerOnUpdate: true));

    final failureOrSuccess = await _customerRepository.updateCustomer(state.customer!);
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
      (customer) => emit(state.copyWith(customer: customer, firebaseFailure: null, isAnyFailure: false)),
    );

    emit(state.copyWith(
      isLoadingCustomerOnUpdate: false,
      fosCustomerOnUpdateOption: optionOf(failureOrSuccess),
    ));
    emit(state.copyWith(fosCustomerOnObserveOption: none()));
  }

  Future<void> _onSetSearchFieldText(SetSearchFieldTextEvent event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(customerSearchText: event.searchText));
    add(OnSearchFieldSubmittedEvent());
  }

  Future<void> _onSearchFieldSubmitted(OnSearchFieldSubmittedEvent event, Emitter<CustomerState> emit) async {
    final searchText = state.customerSearchText.toLowerCase();
    final filteredCustomers = switch (searchText) {
      '' => state.listOfAllCustomers,
      _ => state.listOfAllCustomers!.where((customer) {
          final searchInName = customer.name.toLowerCase().contains(searchText);
          final searchInCompany = customer.company?.toLowerCase().contains(searchText) ?? false;
          final searchInEmail = customer.email.toLowerCase().contains(searchText);
          return searchInName || searchInCompany || searchInEmail;
        }).toList()
    };

    if (filteredCustomers != null && filteredCustomers.isNotEmpty) filteredCustomers.sort((a, b) => b.customerNumber.compareTo(a.customerNumber));
    emit(state.copyWith(listOfFilteredCustomers: filteredCustomers));
  }

  Future<void> _onSelectAllCustomers(OnSelectAllCustomersEvent event, Emitter<CustomerState> emit) async {
    if (event.isSelected) {
      emit(state.copyWith(selectedCustomers: state.listOfFilteredCustomers!, isAllCustomersSelected: true));
    } else {
      emit(state.copyWith(selectedCustomers: [], isAllCustomersSelected: false));
    }
  }

  Future<void> _onCustomerSelected(OnCustomerSelectedEvent event, Emitter<CustomerState> emit) async {
    final isSelected = state.selectedCustomers.any((e) => e.id == event.customer.id);
    List<Customer> updatedSelectedCustomers = List.from(state.selectedCustomers);

    if (isSelected) {
      updatedSelectedCustomers.removeWhere((e) => e.id == event.customer.id);
    } else {
      updatedSelectedCustomers.add(event.customer);
    }

    emit(state.copyWith(selectedCustomers: updatedSelectedCustomers));
  }

  Future<void> _onSetCustomerTax(SetCustomerTaxEvent event, Emitter<CustomerState> emit) async {
    final updatedCustomer = state.customer?.copyWith(tax: event.tax);
    emit(state.copyWith(customer: updatedCustomer));
  }

  Future<void> _onCustomerInvoiceTypeChanged(OnCustomerInvoiceTypeChangedEvent event, Emitter<CustomerState> emit) async {
    final updatedCustomer = state.customer?.copyWith(customerInvoiceType: event.customerInvoiceType);
    emit(state.copyWith(customer: updatedCustomer));
  }

  Future<void> _onAddEditCustomerAddress(OnAddEditCustomerAddressEvent event, Emitter<CustomerState> emit) async {
    logger.i(event.address);
    logger.i(event.address.addressType);
    final List<Address> currentAddresses = List.from(state.customer!.listOfAddress);
    final int addressIndex = currentAddresses.indexWhere((address) => address.id == event.address.id);

    if (addressIndex == -1) {
      print('adresse NEU');
      _addNewAddress(event.address, currentAddresses, emit);
    } else {
      print('adresse VORHANDEN');
      _editExistingAddress(addressIndex, event.address, currentAddresses, emit);
    }
  }

  void _addNewAddress(Address newAddress, List<Address> currentAddresses, Emitter<CustomerState> emit) {
    _ensureOnlyOneDefaultAddress(newAddress, currentAddresses);
    currentAddresses.add(newAddress);

    _addComplementaryAddressIfNeeded(newAddress, currentAddresses);

    emit(state.copyWith(customer: state.customer!.copyWith(listOfAddress: currentAddresses)));
  }

  void _editExistingAddress(int index, Address updatedAddress, List<Address> currentAddresses, Emitter<CustomerState> emit) {
    currentAddresses[index] = updatedAddress;
    _ensureOnlyOneDefaultAddress(updatedAddress, currentAddresses);
    logger.i(currentAddresses);

    emit(state.copyWith(customer: state.customer!.copyWith(listOfAddress: currentAddresses)));
  }

  void _ensureOnlyOneDefaultAddress(Address address, List<Address> addresses) {
    if (address.isDefault) {
      for (var i = 0; i < addresses.length; i++) {
        if (addresses[i].isDefault && addresses[i].addressType == address.addressType && addresses[i] != address) {
          addresses[i] = addresses[i].copyWith(isDefault: false);
        }
      }
    }
  }

  void _addComplementaryAddressIfNeeded(Address address, List<Address> addresses) {
    if ((address.addressType == AddressType.delivery && !addresses.any((a) => a.addressType == AddressType.invoice)) ||
        (address.addressType == AddressType.invoice && !addresses.any((a) => a.addressType == AddressType.delivery))) {
      addresses.add(address.copyWith(
        addressType: address.addressType == AddressType.delivery ? AddressType.invoice : AddressType.delivery,
        isDefault: true,
      ));
    }
  }

  Future<void> _onSetCustomerController(SetCustomerControllerEvent event, Emitter<CustomerState> emit) async {
    final customer = state.customer ?? Customer.empty();
    emit(state.copyWith(
      companyNameController: TextEditingController(text: customer.company ?? ''),
      firstNameController: TextEditingController(text: customer.firstName),
      lastNameController: TextEditingController(text: customer.lastName),
      emailController: TextEditingController(text: customer.email),
      phoneController: TextEditingController(text: customer.phone),
      phoneMobileController: TextEditingController(text: customer.phoneMobile),
      uidNumberController: TextEditingController(text: customer.uidNumber),
      taxNumberController: TextEditingController(text: customer.taxNumber),
    ));
  }

  Future<void> _onCustomerControllerChanged(OnCustomerControllerChangedEvent event, Emitter<CustomerState> emit) async {
    final updatedCustomer = state.customer?.copyWith(
      company: state.companyNameController.text,
      firstName: state.firstNameController.text,
      lastName: state.lastNameController.text,
      name: '${state.firstNameController.text} ${state.lastNameController.text}',
      email: state.emailController.text,
      phone: state.phoneController.text,
      phoneMobile: state.phoneMobileController.text,
      uidNumber: state.uidNumberController.text,
      taxNumber: state.taxNumberController.text,
    );

    emit(state.copyWith(customer: updatedCustomer));
  }
}

// import 'package:bloc/bloc.dart';
// import 'package:cezeri_commerce/core/firebase_failures.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';

// import '../../../3_domain/entities/address.dart';
// import '../../../3_domain/entities/customer/customer.dart';
// import '../../../3_domain/entities/settings/main_settings.dart';
// import '../../../3_domain/entities/settings/tax.dart';
// import '../../../3_domain/repositories/firebase/customer_repository.dart';
// import '../../../3_domain/repositories/firebase/main_settings_respository.dart';

// part 'customer_event.dart';
// part 'customer_state.dart';

// final logger = Logger();

// class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
//   final CustomerRepository customerRepository;
//   final MainSettingsRepository mainSettingsRepository;

//   CustomerBloc({required this.customerRepository, required this.mainSettingsRepository}) : super(CustomerState.initial()) {
// //? #########################################################################

//     on<SetCustomerStateToInitialEvent>((event, emit) {
//       emit(CustomerState.initial());
//     });

// //? #########################################################################

//     on<GetAllCustomersEvent>((event, emit) async {
//       emit(state.copyWith(isLoadingCustomersOnObserve: true));

//       final failureOrSuccess = await customerRepository.getListOfCustomers();
//       failureOrSuccess.fold(
//         (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
//         (listOfCustomer) {
//           emit(state.copyWith(listOfAllCustomers: listOfCustomer, selectedCustomers: [], firebaseFailure: null, isAnyFailure: false));
//           add(OnSearchFieldSubmittedEvent());
//         },
//       );

//       add(OnSearchFieldSubmittedEvent());

//       emit(state.copyWith(
//         isLoadingCustomersOnObserve: false,
//         fosCustomersOnObserveOption: optionOf(failureOrSuccess),
//       ));
//     });

// //? #########################################################################

//     on<GetCustomerEvent>((event, emit) async {
//       emit(state.copyWith(isLoadingCustomerOnObserve: true));

//       final failureOrSuccess = await customerRepository.getCustomer(event.customer.id);
//       failureOrSuccess.fold(
//         (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
//         (customer) {
//           emit(state.copyWith(customer: customer, firebaseFailure: null, isAnyFailure: false));
//           add(SetCustomerControllerEvent());
//         },
//       );

//       emit(state.copyWith(
//         isLoadingCustomerOnObserve: false,
//         fosCustomerOnObserveOption: optionOf(failureOrSuccess),
//       ));
//       emit(state.copyWith(fosCustomerOnObserveOption: none()));
//     });

// //? #########################################################################

//     on<SetEmptyCustomerOnCreateNewCustomerEvent>((event, emit) async {
//       emit(state.copyWith(isLoadingCustomerMainSettingsOnObserve: true));

//       final fos = await mainSettingsRepository.getSettings();
//       fos.fold(
//         (failure) => null,
//         (settings) {
//           emit(state.copyWith(customer: Customer.empty().copyWith(customerNumber: settings.nextCustomerNumber)));
//           add(SetCustomerControllerEvent());
//         },
//       );

//       emit(state.copyWith(
//         isLoadingCustomerMainSettingsOnObserve: false,
//         fosCustomerMainSettingsOnObserveOption: optionOf(fos),
//       ));
//       emit(state.copyWith(fosCustomerMainSettingsOnObserveOption: none()));
//     });

// //? #########################################################################

//     on<CreateCustomerEvent>((event, emit) async {
//       emit(state.copyWith(isLoadingCustomerOnCreate: true));

//       final failureOrSuccess = await customerRepository.createCustomer(state.customer!);
//       failureOrSuccess.fold(
//         (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
//         (customer) => emit(state.copyWith(customer: customer, firebaseFailure: null, isAnyFailure: false)),
//       );

//       emit(state.copyWith(
//         isLoadingCustomerOnCreate: false,
//         fosCustomerOnCreateOption: optionOf(failureOrSuccess),
//       ));
//       emit(state.copyWith(fosCustomerOnCreateOption: none()));
//     });

// //? #########################################################################

//     on<UpdateCustomerEvent>((event, emit) async {
//       emit(state.copyWith(isLoadingCustomerOnUpdate: true));

//       final failureOrSuccess = await customerRepository.updateCustomer(state.customer!);
//       failureOrSuccess.fold(
//         (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
//         (customer) => emit(state.copyWith(customer: customer, firebaseFailure: null, isAnyFailure: false)),
//       );

//       emit(state.copyWith(
//         isLoadingCustomerOnUpdate: false,
//         fosCustomerOnUpdateOption: optionOf(failureOrSuccess),
//       ));
//       emit(state.copyWith(fosCustomerOnObserveOption: none()));
//     });

// //? #########################################################################

//     on<SetSearchFieldTextEvent>((event, emit) async {
//       emit(state.copyWith(customerSearchText: event.searchText));

//       add(OnSearchFieldSubmittedEvent());
//     });

//     on<OnSearchFieldSubmittedEvent>((event, emit) async {
//       final listOfCustomers = switch (state.customerSearchText) {
//         '' => state.listOfAllCustomers,
//         (_) => state.listOfAllCustomers!
//             .where((e) => e.company != null
//                 ? e.name.toLowerCase().contains(state.customerSearchText.toLowerCase()) ||
//                     e.company!.toLowerCase().contains(state.customerSearchText.toLowerCase()) ||
//                     e.email.toLowerCase().contains(state.customerSearchText.toLowerCase())
//                 : e.name.toLowerCase().contains(state.customerSearchText.toLowerCase()) ||
//                     e.email.toLowerCase().contains(state.customerSearchText.toLowerCase()))
//             .toList()
//       };
//       if (listOfCustomers != null && listOfCustomers.isNotEmpty) listOfCustomers.sort((a, b) => b.customerNumber.compareTo(a.customerNumber));
//       emit(state.copyWith(listOfFilteredCustomers: listOfCustomers));
//     });

// //? #########################################################################

//     on<OnSelectAllCustomersEvent>((event, emit) async {
//       List<Customer> customers = [];
//       bool isSelectedAll = false;
//       if (event.isSelected) {
//         isSelectedAll = true;
//         customers = List.from(state.listOfFilteredCustomers!);
//       }
//       emit(state.copyWith(isAllCustomersSelected: isSelectedAll, selectedCustomers: customers));
//     });

// //? #########################################################################

//     on<OnCustomerSelectedEvent>((event, emit) async {
//       List<Customer> customers = List.from(state.selectedCustomers);
//       if (customers.any((e) => e.id == event.customer.id)) {
//         customers.removeWhere((e) => e.id == event.customer.id);
//       } else {
//         customers.add(event.customer);
//       }
//       emit(state.copyWith(
//         isAllCustomersSelected:
//             state.isAllCustomersSelected && customers.length < state.selectedCustomers.length ? false : state.isAllCustomersSelected,
//         selectedCustomers: customers,
//       ));
//     });

// //? #########################################################################

//     on<SetCustomerTaxEvent>((event, emit) async {
//       emit(state.copyWith(customer: state.customer!.copyWith(tax: event.tax)));
//     });

// //? #########################################################################

//     on<OnCustomerInvoiceTypeChangedEvent>((event, emit) async {
//       emit(state.copyWith(customer: state.customer!.copyWith(customerInvoiceType: event.customerInvoiceType)));
//     });

// //? #########################################################################

//     on<OnAddEditCustomerAddressEvent>((event, emit) async {
//       final index = state.customer!.listOfAddress.indexWhere((e) => e.id == event.address.id);
//       logger.i(event.address);
//       logger.i(state.customer!.listOfAddress);

//       if (index == -1) {
//         //* if new Address (Add Address)
//         Address newAddress = event.address;
//         List<Address> newListOfAddress = state.customer!.listOfAddress;
//         if (newAddress.isDefault && state.customer!.listOfAddress.any((e) => e.isDefault)) {
//           final idOfOldDefault = state.customer!.listOfAddress.where((e) => e.isDefault).first.id;
//           final indexOfOldDefault = newListOfAddress.indexWhere((e) => e.id == idOfOldDefault);
//           if (indexOfOldDefault == -1) return;
//           if (newListOfAddress[indexOfOldDefault].addressType != newAddress.addressType) return;
//           newListOfAddress[indexOfOldDefault] = newListOfAddress[indexOfOldDefault].copyWith(isDefault: false);
//         }
//         newListOfAddress = newListOfAddress..add(newAddress);
//         if (newAddress.addressType == AddressType.delivery &&
//             state.customer!.listOfAddress.where((e) => e.addressType == AddressType.invoice).firstOrNull == null) {
//           newListOfAddress.add(newAddress.copyWith(addressType: AddressType.invoice, isDefault: true));
//         }
//         if (newAddress.addressType == AddressType.invoice &&
//             state.customer!.listOfAddress.where((e) => e.addressType == AddressType.delivery).firstOrNull == null) {
//           newListOfAddress.add(newAddress.copyWith(addressType: AddressType.delivery, isDefault: true));
//         }
//         emit(state.copyWith(customer: state.customer!.copyWith(listOfAddress: newListOfAddress)));
//       } else {
//         //* if edit Address
//         List<Address> newListOfAddress = List.from(state.customer!.listOfAddress);
//         newListOfAddress[index] = event.address;
//         final listOfAddressIsDefault = newListOfAddress.where((e) => e.isDefault).toList();
//         if (event.address.isDefault && listOfAddressIsDefault.length > 1) {
//           for (int i = 0; i < newListOfAddress.length; i++) {
//             if (newListOfAddress[i].id == event.address.id) continue;
//             newListOfAddress[i] = newListOfAddress[i].copyWith(isDefault: false);
//           }
//         }
//         emit(state.copyWith(customer: state.customer!.copyWith(listOfAddress: newListOfAddress)));
//       }
//     });

// //? #########################################################################

//     on<SetCustomerControllerEvent>((event, emit) async {
//       Customer? customer = state.customer;
//       if (customer == null) {
//         emit(state.copyWith(customer: Customer.empty()));
//       }
//       emit(state.copyWith(
//         companyNameController: TextEditingController(text: customer!.company ?? ''),
//         firstNameController: TextEditingController(text: customer.firstName),
//         lastNameController: TextEditingController(text: customer.lastName),
//         emailController: TextEditingController(text: customer.email),
//         phoneController: TextEditingController(text: customer.phone),
//         phoneMobileController: TextEditingController(text: customer.phoneMobile),
//         uidNumberController: TextEditingController(text: customer.uidNumber),
//         taxNumberController: TextEditingController(text: customer.taxNumber),
//       ));
//     });

// //? #########################################################################

//     on<OnCustomerControllerChangedEvent>((event, emit) async {
//       Customer? customer = state.customer;
//       if (customer == null) {
//         emit(state.copyWith(customer: Customer.empty()));
//       }
//       emit(state.copyWith(
//         customer: state.customer!.copyWith(
//           company: state.companyNameController.text,
//           firstName: state.firstNameController.text,
//           lastName: state.lastNameController.text,
//           name: '${state.firstNameController.text} ${state.lastNameController.text}',
//           email: state.emailController.text,
//           phone: state.phoneController.text,
//           phoneMobile: state.phoneMobileController.text,
//           uidNumber: state.uidNumberController.text,
//           taxNumber: state.taxNumberController.text,
//         ),
//       ));
//     });

// //? #########################################################################
//   }
// }
