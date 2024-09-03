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

  //* StatSalesBetweenDates Verkaufzahlen pro Tag pro Marktplatz
  final StatSalesBetweenDates? listOfStatSalesBetweenDatesThisMonth;
  final StatSalesBetweenDates? listOfStatSalesBetweenDatesLastMonth;
  final StatSalesBetweenDates? listOfStatSalesBetweenDatesMainPeriod;
  final StatSalesBetweenDates? listOfStatSalesBetweenDatesComparePeriod;
  final bool isLoadingStatSalesBetweenDatesThisMonth;
  final bool isLoadingStatSalesBetweenDatesMainPeriod;
  final bool isFailureStatSalesBetweenDatesThisMonth;
  final bool isFailureStatSalesBetweenDatesMainPeriod;
  final DateTimeRange dateRangeStatSalesBetweenDatesThisMonth;
  final DateTimeRange dateRangeStatSalesBetweenDatesMainPeriod;

  //* StatBrand Verkaufzahlen nach Hersteller
  final List<StatBrand>? listOfProductSalesByBrand;
  final bool isLoadingProductSalesByBrand;
  final bool isFailureOnProductSalesByBrand;
  final DateTimeRange dateRangeBrands;

  //* Verkaufszahlen nach Gruppierung wie (Land, Marktplatz, etc.)
  final List<StatSalesGrouped>? salesVolumeGroupedByCountry;
  final List<StatSalesGrouped>? salesVolumeGroupedByMarketplace;
  final List<StatSalesGroupedByMarketplace>? salesVolumeGroupedByMarketplaceAndCountry;
  final bool isLoadingGroups;
  final bool isFailureOnGroups;
  final DateTimeRange dateRangeGroups;

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
    required this.listOfStatSalesBetweenDatesThisMonth,
    required this.listOfStatSalesBetweenDatesLastMonth,
    required this.listOfStatSalesBetweenDatesMainPeriod,
    required this.listOfStatSalesBetweenDatesComparePeriod,
    required this.isLoadingStatSalesBetweenDatesThisMonth,
    required this.isLoadingStatSalesBetweenDatesMainPeriod,
    required this.isFailureStatSalesBetweenDatesThisMonth,
    required this.isFailureStatSalesBetweenDatesMainPeriod,
    required this.dateRangeStatSalesBetweenDatesThisMonth,
    required this.dateRangeStatSalesBetweenDatesMainPeriod,
    required this.listOfProductSalesByBrand,
    required this.isLoadingProductSalesByBrand,
    required this.isFailureOnProductSalesByBrand,
    required this.dateRangeBrands,
    required this.salesVolumeGroupedByCountry,
    required this.salesVolumeGroupedByMarketplace,
    required this.salesVolumeGroupedByMarketplaceAndCountry,
    required this.isLoadingGroups,
    required this.isFailureOnGroups,
    required this.dateRangeGroups,
  });

  factory DashboardState.initial() {
    final now = DateTime.now();
    return DashboardState(
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
      listOfStatSalesBetweenDatesThisMonth: StatSalesBetweenDates.empty(),
      listOfStatSalesBetweenDatesLastMonth: StatSalesBetweenDates.empty(),
      listOfStatSalesBetweenDatesMainPeriod: StatSalesBetweenDates.empty(),
      listOfStatSalesBetweenDatesComparePeriod: StatSalesBetweenDates.empty(),
      isLoadingStatSalesBetweenDatesThisMonth: false,
      isLoadingStatSalesBetweenDatesMainPeriod: false,
      isFailureStatSalesBetweenDatesThisMonth: false,
      isFailureStatSalesBetweenDatesMainPeriod: false,
      dateRangeStatSalesBetweenDatesThisMonth: DateRangeType.thisMonth.toDateRange(),
      dateRangeStatSalesBetweenDatesMainPeriod: DateRangeType.last30Days.toDateRange(),
      listOfProductSalesByBrand: const [],
      isLoadingProductSalesByBrand: false,
      isFailureOnProductSalesByBrand: false,
      dateRangeBrands: DateTimeRange(start: now.subtract(const Duration(days: 30)), end: now),
      salesVolumeGroupedByCountry: const [],
      salesVolumeGroupedByMarketplace: const [],
      salesVolumeGroupedByMarketplaceAndCountry: const [],
      isLoadingGroups: false,
      isFailureOnGroups: false,
      dateRangeGroups: DateTimeRange(start: now.subtract(const Duration(days: 30)), end: now),
    );
  }

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
    StatSalesBetweenDates? listOfStatSalesBetweenDatesThisMonth,
    StatSalesBetweenDates? listOfStatSalesBetweenDatesLastMonth,
    StatSalesBetweenDates? listOfStatSalesBetweenDatesMainPeriod,
    StatSalesBetweenDates? listOfStatSalesBetweenDatesComparePeriod,
    bool? isLoadingStatSalesBetweenDatesThisMonth,
    bool? isLoadingStatSalesBetweenDatesMainPeriod,
    bool? isFailureStatSalesBetweenDatesThisMonth,
    bool? isFailureStatSalesBetweenDatesMainPeriod,
    DateTimeRange? dateRangeStatSalesBetweenDatesThisMonth,
    DateTimeRange? dateRangeStatSalesBetweenDatesMainPeriod,
    List<StatBrand>? listOfProductSalesByBrand,
    bool? isLoadingProductSalesByBrand,
    bool? isFailureOnProductSalesByBrand,
    DateTimeRange? dateRangeBrands,
    List<StatSalesGrouped>? salesVolumeGroupedByCountry,
    List<StatSalesGrouped>? salesVolumeGroupedByMarketplace,
    List<StatSalesGroupedByMarketplace>? salesVolumeGroupedByMarketplaceAndCountry,
    bool? isLoadingGroups,
    bool? isFailureOnGroups,
    DateTimeRange? dateRangeGroups,
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
      listOfStatSalesBetweenDatesThisMonth: listOfStatSalesBetweenDatesThisMonth ?? this.listOfStatSalesBetweenDatesThisMonth,
      listOfStatSalesBetweenDatesLastMonth: listOfStatSalesBetweenDatesLastMonth ?? this.listOfStatSalesBetweenDatesLastMonth,
      listOfStatSalesBetweenDatesMainPeriod: listOfStatSalesBetweenDatesMainPeriod ?? this.listOfStatSalesBetweenDatesMainPeriod,
      listOfStatSalesBetweenDatesComparePeriod: listOfStatSalesBetweenDatesComparePeriod ?? this.listOfStatSalesBetweenDatesComparePeriod,
      isLoadingStatSalesBetweenDatesThisMonth: isLoadingStatSalesBetweenDatesThisMonth ?? this.isLoadingStatSalesBetweenDatesThisMonth,
      isLoadingStatSalesBetweenDatesMainPeriod: isLoadingStatSalesBetweenDatesMainPeriod ?? this.isLoadingStatSalesBetweenDatesMainPeriod,
      isFailureStatSalesBetweenDatesThisMonth: isFailureStatSalesBetweenDatesThisMonth ?? this.isFailureStatSalesBetweenDatesThisMonth,
      isFailureStatSalesBetweenDatesMainPeriod: isFailureStatSalesBetweenDatesMainPeriod ?? this.isFailureStatSalesBetweenDatesMainPeriod,
      dateRangeStatSalesBetweenDatesThisMonth: dateRangeStatSalesBetweenDatesThisMonth ?? this.dateRangeStatSalesBetweenDatesThisMonth,
      dateRangeStatSalesBetweenDatesMainPeriod: dateRangeStatSalesBetweenDatesMainPeriod ?? this.dateRangeStatSalesBetweenDatesMainPeriod,
      listOfProductSalesByBrand: listOfProductSalesByBrand ?? this.listOfProductSalesByBrand,
      isLoadingProductSalesByBrand: isLoadingProductSalesByBrand ?? this.isLoadingProductSalesByBrand,
      isFailureOnProductSalesByBrand: isFailureOnProductSalesByBrand ?? this.isFailureOnProductSalesByBrand,
      dateRangeBrands: dateRangeBrands ?? this.dateRangeBrands,
      salesVolumeGroupedByCountry: salesVolumeGroupedByCountry ?? this.salesVolumeGroupedByCountry,
      salesVolumeGroupedByMarketplace: salesVolumeGroupedByMarketplace ?? this.salesVolumeGroupedByMarketplace,
      salesVolumeGroupedByMarketplaceAndCountry: salesVolumeGroupedByMarketplaceAndCountry ?? this.salesVolumeGroupedByMarketplaceAndCountry,
      isLoadingGroups: isLoadingGroups ?? this.isLoadingGroups,
      isFailureOnGroups: isFailureOnGroups ?? this.isFailureOnGroups,
      dateRangeGroups: dateRangeGroups ?? this.dateRangeGroups,
    );
  }
}
