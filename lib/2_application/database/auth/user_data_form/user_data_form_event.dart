part of 'user_data_form_bloc.dart';

@immutable
abstract class UserDataFormEvent {}

class InitialUserDataFormEvent extends UserDataFormEvent {
  final Client? client;

  InitialUserDataFormEvent({this.client});
}

class SaveUserDataPressedEvent extends UserDataFormEvent {
  final Gender gender;
  final String companyName;
  final String firstName;
  final String lastName;
  final String name;
  final String tel1;
  final String tel2;
  final String email;
  final String street;
  final String postCode;
  final String city;
  final String country;

  SaveUserDataPressedEvent({
    required this.gender,
    required this.companyName,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.tel1,
    required this.tel2,
    required this.email,
    required this.street,
    required this.postCode,
    required this.city,
    required this.country,
  });
}

class UserDataCreateClientEvent extends UserDataFormEvent {
  final Gender gender;
  final String companyName;
  final String firstName;
  final String lastName;
  final String name;
  final String tel1;
  final String tel2;
  final String email;
  final String street;
  final String postCode;
  final String city;
  final String country;

  UserDataCreateClientEvent({
    required this.gender,
    required this.companyName,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.tel1,
    required this.tel2,
    required this.email,
    required this.street,
    required this.postCode,
    required this.city,
    required this.country,
  });
}
