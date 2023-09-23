part of 'main_settings_bloc.dart';

@immutable
class MainSettingsState {
  final MainSettings? mainSettings;
  final FirebaseFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingMainSettingsOnObserve;
  final bool isLoadingMainSettingsOnCreate;
  final bool isLoadingMainSettingsOnUpdate;
  final Option<Either<FirebaseFailure, MainSettings>> fosMainSettingsOnObserveOption;
  final Option<Either<FirebaseFailure, Unit>> fosMainSettingsOnCreateOption;
  final Option<Either<FirebaseFailure, Unit>> fosMainSettingsOnUpdateOption;

  const MainSettingsState({
    required this.mainSettings,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingMainSettingsOnObserve,
    required this.isLoadingMainSettingsOnCreate,
    required this.isLoadingMainSettingsOnUpdate,
    required this.fosMainSettingsOnObserveOption,
    required this.fosMainSettingsOnCreateOption,
    required this.fosMainSettingsOnUpdateOption,
  });

  factory MainSettingsState.initial() => MainSettingsState(
        mainSettings: null,
        firebaseFailure: null,
        isAnyFailure: false,
        isLoadingMainSettingsOnObserve: false,
        isLoadingMainSettingsOnCreate: false,
        isLoadingMainSettingsOnUpdate: false,
        fosMainSettingsOnObserveOption: none(),
        fosMainSettingsOnCreateOption: none(),
        fosMainSettingsOnUpdateOption: none(),
      );

  MainSettingsState copyWith({
    MainSettings? mainSettings,
    FirebaseFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingMainSettingsOnObserve,
    bool? isLoadingMainSettingsOnCreate,
    bool? isLoadingMainSettingsOnUpdate,
    Option<Either<FirebaseFailure, MainSettings>>? fosMainSettingsOnObserveOption,
    Option<Either<FirebaseFailure, Unit>>? fosMainSettingsOnCreateOption,
    Option<Either<FirebaseFailure, Unit>>? fosMainSettingsOnUpdateOption,
  }) {
    return MainSettingsState(
      mainSettings: mainSettings ?? this.mainSettings,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingMainSettingsOnObserve: isLoadingMainSettingsOnObserve ?? this.isLoadingMainSettingsOnObserve,
      isLoadingMainSettingsOnCreate: isLoadingMainSettingsOnCreate ?? this.isLoadingMainSettingsOnCreate,
      isLoadingMainSettingsOnUpdate: isLoadingMainSettingsOnUpdate ?? this.isLoadingMainSettingsOnUpdate,
      fosMainSettingsOnObserveOption: fosMainSettingsOnObserveOption ?? this.fosMainSettingsOnObserveOption,
      fosMainSettingsOnCreateOption: fosMainSettingsOnCreateOption ?? this.fosMainSettingsOnCreateOption,
      fosMainSettingsOnUpdateOption: fosMainSettingsOnUpdateOption ?? this.fosMainSettingsOnUpdateOption,
    );
  }
}
