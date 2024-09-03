part of 'user_data_form_bloc.dart';

@immutable
class UserDataFormState {
  final Client client;
  final bool isLoading;
  final Option<Either<AbstractFailure, Unit>> failureOrSuccessClientOption;

  const UserDataFormState({
    required this.client,
    required this.isLoading,
    required this.failureOrSuccessClientOption,
  });

  factory UserDataFormState.initial() => UserDataFormState(
        client: Client.empty(),
        isLoading: false,
        failureOrSuccessClientOption: none(),
      );

  UserDataFormState copyWith({
    Client? client,
    bool? isLoading,
    Option<Either<AbstractFailure, Unit>>? failureOrSuccessClientOption,
  }) {
    return UserDataFormState(
      client: client ?? this.client,
      isLoading: isLoading ?? this.isLoading,
      failureOrSuccessClientOption: failureOrSuccessClientOption ?? this.failureOrSuccessClientOption,
    );
  }

  @override
  String toString() => 'UserDataFormState(client: $client, isLoading: $isLoading, failureOrSuccessClientOption: $failureOrSuccessClientOption)';
}
