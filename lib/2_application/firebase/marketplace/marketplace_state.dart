part of 'marketplace_bloc.dart';

@immutable
class MarketplaceState {
  final AbstractMarketplace? marketplace;
  final List<AbstractMarketplace>? listOfMarketplace;
  final AbstractFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingMarketplaceOnObserve;
  final bool isLoadingMarketplacesOnObserve;
  final bool isLoadingMarketplaceOnCreate;
  final bool isLoadingMarketplaceOnUpdate;
  final bool isLoadingMarketplaceOnDelete;
  final Option<Either<AbstractFailure, AbstractMarketplace>> fosMarketplaceOnObserveOption;
  final Option<Either<AbstractFailure, List<AbstractMarketplace>>> fosMarketplacesOnObserveOption;
  final Option<Either<AbstractFailure, Unit>> fosMarketplaceOnCreateOption;
  final Option<Either<AbstractFailure, Unit>> fosMarketplaceOnUpdateOption;
  final Option<Either<AbstractFailure, Unit>> fosMarketplaceOnDeleteOption;

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
    AbstractMarketplace? marketplace,
    List<AbstractMarketplace>? listOfMarketplace,
    AbstractFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingMarketplaceOnObserve,
    bool? isLoadingMarketplacesOnObserve,
    bool? isLoadingMarketplaceOnCreate,
    bool? isLoadingMarketplaceOnUpdate,
    bool? isLoadingMarketplaceOnDelete,
    Option<Either<AbstractFailure, AbstractMarketplace>>? fosMarketplaceOnObserveOption,
    Option<Either<AbstractFailure, List<AbstractMarketplace>>>? fosMarketplacesOnObserveOption,
    Option<Either<AbstractFailure, Unit>>? fosMarketplaceOnCreateOption,
    Option<Either<AbstractFailure, Unit>>? fosMarketplaceOnUpdateOption,
    Option<Either<AbstractFailure, Unit>>? fosMarketplaceOnDeleteOption,
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
