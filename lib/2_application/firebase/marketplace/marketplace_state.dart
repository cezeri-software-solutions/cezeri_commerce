part of 'marketplace_bloc.dart';

@immutable
class MarketplaceState {
  final Marketplace? marketplace;
  final List<Marketplace>? listOfMarketplace;
  final FirebaseFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingMarketplaceOnObserve;
  final bool isLoadingMarketplacesOnObserve;
  final bool isLoadingMarketplaceOnCreate;
  final bool isLoadingMarketplaceOnUpdate;
  final bool isLoadingMarketplaceOnDelete;
  final Option<Either<FirebaseFailure, Marketplace>> fosMarketplaceOnObserveOption;
  final Option<Either<FirebaseFailure, List<Marketplace>>> fosMarketplacesOnObserveOption;
  final Option<Either<FirebaseFailure, Unit>> fosMarketplaceOnCreateOption;
  final Option<Either<FirebaseFailure, Unit>> fosMarketplaceOnUpdateOption;
  final Option<Either<FirebaseFailure, Unit>> fosMarketplaceOnDeleteOption;

  const MarketplaceState({
    required this.marketplace,
    required this.listOfMarketplace,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingMarketplaceOnObserve,
    required this.isLoadingMarketplacesOnObserve,
    required this.isLoadingMarketplaceOnCreate,
    required this.isLoadingMarketplaceOnUpdate,
    required this.isLoadingMarketplaceOnDelete,
    required this.fosMarketplaceOnObserveOption,
    required this.fosMarketplacesOnObserveOption,
    required this.fosMarketplaceOnCreateOption,
    required this.fosMarketplaceOnUpdateOption,
    required this.fosMarketplaceOnDeleteOption,
  });

  factory MarketplaceState.initial() => MarketplaceState(
        marketplace: null,
        listOfMarketplace: null,
        firebaseFailure: null,
        isAnyFailure: false,
        isLoadingMarketplaceOnObserve: false,
        isLoadingMarketplacesOnObserve: true,
        isLoadingMarketplaceOnCreate: false,
        isLoadingMarketplaceOnUpdate: false,
        isLoadingMarketplaceOnDelete: false,
        fosMarketplaceOnObserveOption: none(),
        fosMarketplacesOnObserveOption: none(),
        fosMarketplaceOnCreateOption: none(),
        fosMarketplaceOnUpdateOption: none(),
        fosMarketplaceOnDeleteOption: none(),
      );

  MarketplaceState copyWith({
    Marketplace? marketplace,
    List<Marketplace>? listOfMarketplace,
    FirebaseFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingMarketplaceOnObserve,
    bool? isLoadingMarketplacesOnObserve,
    bool? isLoadingMarketplaceOnCreate,
    bool? isLoadingMarketplaceOnUpdate,
    bool? isLoadingMarketplaceOnDelete,
    Option<Either<FirebaseFailure, Marketplace>>? fosMarketplaceOnObserveOption,
    Option<Either<FirebaseFailure, List<Marketplace>>>? fosMarketplacesOnObserveOption,
    Option<Either<FirebaseFailure, Unit>>? fosMarketplaceOnCreateOption,
    Option<Either<FirebaseFailure, Unit>>? fosMarketplaceOnUpdateOption,
    Option<Either<FirebaseFailure, Unit>>? fosMarketplaceOnDeleteOption,
  }) {
    return MarketplaceState(
      marketplace: marketplace ?? this.marketplace,
      listOfMarketplace: listOfMarketplace ?? this.listOfMarketplace,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingMarketplaceOnObserve: isLoadingMarketplaceOnObserve ?? this.isLoadingMarketplaceOnObserve,
      isLoadingMarketplacesOnObserve: isLoadingMarketplacesOnObserve ?? this.isLoadingMarketplacesOnObserve,
      isLoadingMarketplaceOnCreate: isLoadingMarketplaceOnCreate ?? this.isLoadingMarketplaceOnCreate,
      isLoadingMarketplaceOnUpdate: isLoadingMarketplaceOnUpdate ?? this.isLoadingMarketplaceOnUpdate,
      isLoadingMarketplaceOnDelete: isLoadingMarketplaceOnDelete ?? this.isLoadingMarketplaceOnDelete,
      fosMarketplaceOnObserveOption: fosMarketplaceOnObserveOption ?? this.fosMarketplaceOnObserveOption,
      fosMarketplacesOnObserveOption: fosMarketplacesOnObserveOption ?? this.fosMarketplacesOnObserveOption,
      fosMarketplaceOnCreateOption: fosMarketplaceOnCreateOption ?? this.fosMarketplaceOnCreateOption,
      fosMarketplaceOnUpdateOption: fosMarketplaceOnUpdateOption ?? this.fosMarketplaceOnUpdateOption,
      fosMarketplaceOnDeleteOption: fosMarketplaceOnDeleteOption ?? this.fosMarketplaceOnDeleteOption,
    );
  }
}
