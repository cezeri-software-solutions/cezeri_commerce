import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../3_domain/entities/marketplace.dart';
import '../../../3_domain/repositories/firebase/marketplace_repository.dart';
import '../../../core/firebase_failures.dart';

part 'marketplace_event.dart';
part 'marketplace_state.dart';

class MarketplaceBloc extends Bloc<MarketplaceEvent, MarketplaceState> {
  final MarketplaceRepository marketplaceRepository;

  MarketplaceBloc({required this.marketplaceRepository}) : super(MarketplaceState.initial()) {
//? #########################################################################

    on<SetMarketplaceStateToInitialEvent>((event, emit) {
      emit(MarketplaceState.initial());
    });

//? #########################################################################

    on<GetAllMarketplacesEvent>((event, emit) async {
      emit(state.copyWith(isLoadingMarketplacesOnObserve: true));

      final failureOrSuccess = await marketplaceRepository.getListOfMarketplaces();
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfMarketplace) => emit(state.copyWith(listOfMarketplace: listOfMarketplace, firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingMarketplacesOnObserve: false,
        fosMarketplacesOnObserveOption: optionOf(failureOrSuccess),
      ));
    });

//? #########################################################################

    on<GetMarketplaceEvent>((event, emit) async {
      emit(state.copyWith(isLoadingMarketplaceOnObserve: true));

      final failureOrSuccess = await marketplaceRepository.getMarketplace(event.id);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (marketplace) => emit(state.copyWith(marketplace: marketplace, firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingMarketplaceOnObserve: false,
        fosMarketplaceOnObserveOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosMarketplaceOnObserveOption: none()));
    });

//? #########################################################################

    on<CreateMarketplaceEvent>((event, emit) async {
      emit(state.copyWith(isLoadingMarketplaceOnCreate: true));

      final failureOrSuccess = await marketplaceRepository.createMarketplace(event.marketplace);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (marketplace) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingMarketplaceOnCreate: false,
        fosMarketplaceOnCreateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosMarketplaceOnCreateOption: none()));
    });

//? #########################################################################

    on<UpdateMarketplaceEvent>((event, emit) async {
      emit(state.copyWith(isLoadingMarketplaceOnUpdate: true));

      final failureOrSuccess = await marketplaceRepository.updateMarketplace(event.marketplace);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (unit) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingMarketplaceOnUpdate: false,
        fosMarketplaceOnUpdateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosMarketplaceOnUpdateOption: none()));
    });

//? #########################################################################

    on<DeleteMarketplaceEvent>((event, emit) async {
      emit(state.copyWith(isLoadingMarketplaceOnDelete: true));

      final failureOrSuccess = await marketplaceRepository.deleteMarketplace(event.id);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (unit) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingMarketplaceOnDelete: false,
        fosMarketplaceOnDeleteOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosMarketplaceOnDeleteOption: none()));
    });

//? #########################################################################
  }
}
