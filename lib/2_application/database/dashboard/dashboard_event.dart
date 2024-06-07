part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {}

class SetDashboardStatesToInitial extends DashboardEvent {}

class GetCurStatDashboardEvent extends DashboardEvent {}

class GetListOfStatDashboardsEvent extends DashboardEvent {}

class GetListOfProductSalesByBrandEvent extends DashboardEvent {
  final DateTimeRange dateRange;

  GetListOfProductSalesByBrandEvent({required this.dateRange});
}
