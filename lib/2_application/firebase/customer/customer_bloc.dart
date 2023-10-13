import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../3_domain/entities/customer/customer.dart';
import '../../../3_domain/repositories/firebase/customer_repository.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository customerRepository;

  CustomerBloc({required this.customerRepository}) : super(CustomerState.initial()) {
//? #########################################################################

    on<SetCustomerStateToInitialEvent>((event, emit) {
      emit(CustomerState.initial());
    });

//? #########################################################################

    on<GetAllCustomersEvenet>((event, emit) async {
      emit(state.copyWith(isLoadingCustomersOnObserve: true));

      final failureOrSuccess = await customerRepository.getListOfCustomers();
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfCustomer) {
          emit(state.copyWith(listOfAllCustomers: listOfCustomer, selecetedCustomers: [], firebaseFailure: null, isAnyFailure: false));
          add(OnSearchFieldSubmittedEvent());
        },
      );

      add(OnSearchFieldSubmittedEvent());

      emit(state.copyWith(
        isLoadingCustomersOnObserve: false,
        fosCustomersOnObserveOption: optionOf(failureOrSuccess),
      ));
    });

//? #########################################################################

    on<GetCustomerEvent>((event, emit) async {
      emit(state.copyWith(isLoadingCustomerOnObserve: true));

      final failureOrSuccess = await customerRepository.getCustomer(event.customer);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (customer) => emit(state.copyWith(customer: customer, firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingCustomerOnObserve: false,
        fosCustomerOnObserveOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosCustomerOnObserveOption: none()));
    });

//? #########################################################################

    on<SetSearchFieldTextEvent>((event, emit) async {
      emit(state.copyWith(customerSearchText: event.searchText));
    });

    on<OnSearchFieldSubmittedEvent>((event, emit) async {
      final listOfCustomers = switch (state.customerSearchText) {
        '' => state.listOfAllCustomers,
        (_) => state.listOfAllCustomers!
            .where((e) => e.company != null
                ? e.name.toLowerCase().contains(state.customerSearchText.toLowerCase())
                : e.name.toLowerCase().contains(state.customerSearchText.toLowerCase()) ||
                    e.company!.toLowerCase().contains(state.customerSearchText.toLowerCase()))
            .toList()
      };
      if (listOfCustomers != null && listOfCustomers.isNotEmpty) listOfCustomers.sort((a, b) => a.name.compareTo(b.name));
      emit(state.copyWith(listOfFilteredCustomers: listOfCustomers));
    });

//? #########################################################################
  }
}
