part of 'dashboard_bloc.dart';

@immutable
class DashboardState {
  final StatDashboard? curStatDashboard;
  final List<StatDashboard>? listOfStatDashboards;
  final List<Receipt>? listOfAppointments;
  final List<Receipt>? listOfAppointmentsToday;
  final List<Receipt>? listOfAppointmentsTomorrow;
  final bool isLoadingOnObserve;
  final bool isAnyFailure;
  final bool isAnyFailureReceipts;
  final AbstractFailure? firebaseFailure;
  final AbstractFailure? firebaseFailureReceipts;
  final Option<Either<AbstractFailure, StatDashboard>> fosDashboardOption;
  final Option<Either<AbstractFailure, List<StatDashboard>>> fosListOfStatDashboardsOption;

  //* StatBrand Verkaufzahlen nach Hersteller
  final List<StatBrand>? listOfProductSalesByBrand;
  final bool isLoadingProductSalesByBrand;
  final bool isFailureOnProductSalesByBrand;

  const DashboardState({
    required this.curStatDashboard,
    required this.listOfStatDashboards,
    required this.listOfAppointments,
    required this.listOfAppointmentsToday,
    required this.listOfAppointmentsTomorrow,
    required this.isLoadingOnObserve,
    required this.isAnyFailure,
    required this.isAnyFailureReceipts,
    required this.firebaseFailure,
    required this.firebaseFailureReceipts,
    required this.fosDashboardOption,
    required this.fosListOfStatDashboardsOption,
    required this.listOfProductSalesByBrand,
    required this.isLoadingProductSalesByBrand,
    required this.isFailureOnProductSalesByBrand,
  });

  factory DashboardState.initial() => DashboardState(
        curStatDashboard: StatDashboard.empty(),
        listOfStatDashboards: const [],
        listOfAppointments: const [],
        listOfAppointmentsToday: const [],
        listOfAppointmentsTomorrow: const [],
        isLoadingOnObserve: true,
        isAnyFailure: false,
        isAnyFailureReceipts: false,
        firebaseFailure: null,
        firebaseFailureReceipts: null,
        fosDashboardOption: none(),
        fosListOfStatDashboardsOption: none(),
        listOfProductSalesByBrand: const [],
        isLoadingProductSalesByBrand: false,
        isFailureOnProductSalesByBrand: false,
      );

  DashboardState copyWith({
    StatDashboard? curStatDashboard,
    List<StatDashboard>? listOfStatDashboards,
    List<Receipt>? listOfAppointments,
    List<Receipt>? listOfAppointmentsToday,
    List<Receipt>? listOfAppointmentsTomorrow,
    bool? isLoadingOnObserve,
    bool? isAnyFailure,
    bool? isAnyFailureReceipts,
    AbstractFailure? firebaseFailure,
    AbstractFailure? firebaseFailureReceipts,
    Option<Either<AbstractFailure, StatDashboard>>? fosDashboardOption,
    Option<Either<AbstractFailure, List<StatDashboard>>>? fosListOfStatDashboardsOption,
    List<StatBrand>? listOfProductSalesByBrand,
    bool? isLoadingProductSalesByBrand,
    bool? isFailureOnProductSalesByBrand,
  }) {
    return DashboardState(
      curStatDashboard: curStatDashboard ?? this.curStatDashboard,
      listOfStatDashboards: listOfStatDashboards ?? this.listOfStatDashboards,
      listOfAppointments: listOfAppointments ?? this.listOfAppointments,
      listOfAppointmentsToday: listOfAppointmentsToday ?? this.listOfAppointmentsToday,
      listOfAppointmentsTomorrow: listOfAppointmentsTomorrow ?? this.listOfAppointmentsTomorrow,
      isLoadingOnObserve: isLoadingOnObserve ?? this.isLoadingOnObserve,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isAnyFailureReceipts: isAnyFailureReceipts ?? this.isAnyFailureReceipts,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      firebaseFailureReceipts: firebaseFailureReceipts ?? this.firebaseFailureReceipts,
      fosDashboardOption: fosDashboardOption ?? this.fosDashboardOption,
      fosListOfStatDashboardsOption: fosListOfStatDashboardsOption ?? this.fosListOfStatDashboardsOption,
      listOfProductSalesByBrand: listOfProductSalesByBrand ?? this.listOfProductSalesByBrand,
      isLoadingProductSalesByBrand: isLoadingProductSalesByBrand ?? this.isLoadingProductSalesByBrand,
      isFailureOnProductSalesByBrand: isFailureOnProductSalesByBrand ?? this.isFailureOnProductSalesByBrand,
    );
  }
}
