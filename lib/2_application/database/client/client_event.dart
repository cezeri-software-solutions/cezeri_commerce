part of 'client_bloc.dart';

@immutable
abstract class ClientEvent {}

class SetClientStateToInitialEvnet extends ClientEvent {}

class GetCurrentClientEvent extends ClientEvent {}
