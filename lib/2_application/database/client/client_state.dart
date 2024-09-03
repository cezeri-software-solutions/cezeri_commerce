part of 'client_bloc.dart';

@immutable
class ClientState {
  final Client? client;
  final AbstractFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingClientOnObserve;
  final Option<Either<AbstractFailure, Client>> fosClientOnObserveOption;

  const ClientState({
    required this.client,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingClientOnObserve,
    required this.fosClientOnObserveOption,
  });

  factory ClientState.initial() => ClientState(
        client: null,
        firebaseFailure: null,
        isAnyFailure: false,
        isLoadingClientOnObserve: true,
        fosClientOnObserveOption: none(),
      );

  ClientState copyWith({
    Client? client,
    AbstractFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingClientOnObserve,
    Option<Either<AbstractFailure, Client>>? fosClientOnObserveOption,
  }) {
    return ClientState(
      client: client ?? this.client,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingClientOnObserve: isLoadingClientOnObserve ?? this.isLoadingClientOnObserve,
      fosClientOnObserveOption: fosClientOnObserveOption ?? this.fosClientOnObserveOption,
    );
  }
}
