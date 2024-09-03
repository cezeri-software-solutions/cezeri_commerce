part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {}

class SetDashboardStatesToInitial extends DashboardEvent {}

class GetStatSalesBetweenDatesThisMonth extends DashboardEvent {}

//* ############################## START ###################################

class GetStatSalesBetweenDatesMainPeriod extends DashboardEvent {}

class SetStatSalesBetweenDatesTimeRangeEvent extends DashboardEvent {
  final DateTimeRange dateRange;

  SetStatSalesBetweenDatesTimeRangeEvent({required this.dateRange});
}

//* ############################## END ###################################

class GetCurStatDashboardEvent extends DashboardEvent {}

class GetListOfStatDashboardsEvent extends DashboardEvent {}

//* ############################## START ###################################

class GetListOfProductSalesByBrandEvent extends DashboardEvent {}

class SetProductSalesDateTimeRangeEvent extends DashboardEvent {
  final DateTimeRange dateRange;

  SetProductSalesDateTimeRangeEvent({required this.dateRange});
}

//* ############################## END ###################################
//* ############################## START ###################################

class GetListOfReceiptsGroupsEvent extends DashboardEvent {}

class SetGroupsDateTimeRangeEvent extends DashboardEvent {
  final DateTimeRange dateRange;

  SetGroupsDateTimeRangeEvent({required this.dateRange});
}

//* ############################## END ###################################