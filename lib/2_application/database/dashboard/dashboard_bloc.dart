import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '/1_presentation/core/core.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/statistic/stat_brand.dart';
import '../../../3_domain/entities/statistic/stat_dashboard.dart';
import '../../../3_domain/entities/statistic/stat_sales_grouped.dart';
import '../../../3_domain/entities/statistic/stat_sales_per_day.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../3_domain/repositories/firebase/receipt_repository.dart';
import '../../../3_domain/repositories/firebase/stat_dashboard_repository.dart';
import '../../../failures/abstract_failure.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final StatDashboardRepository dashboardRepository;
  final ReceiptRepository receiptRepository;
  DashboardBloc({required this.dashboardRepository, required this.receiptRepository}) : super(DashboardState.initial()) {
//? ######################################################################################################

    on<GetStatSalesBetweenDatesThisMonth>((event, emit) async {
      emit(state.copyWith(isLoadingStatSalesBetweenDatesThisMonth: true));

      final fosThisMonth = await dashboardRepository.getStatSalesBetweenDates(state.dateRangeStatSalesBetweenDatesThisMonth);
      final start = state.dateRangeStatSalesBetweenDatesThisMonth.start;
      final end = state.dateRangeStatSalesBetweenDatesThisMonth.end;
      final dateRangeLastMonth = DateTimeRange(start: DateTime(start.year, start.month - 1, 1), end: DateTime(end.year, end.month - 1, end.day));
      final fosLastMonth = await dashboardRepository.getStatSalesBetweenDates(dateRangeLastMonth);

      fosThisMonth.fold(
        (failure) => emit(state.copyWith(isFailureStatSalesBetweenDatesThisMonth: true)),
        (data) {
          final completedData = _fillMissingDays(data);
          emit(state.copyWith(listOfStatSalesBetweenDatesThisMonth: completedData, isFailureStatSalesBetweenDatesThisMonth: false));
        },
      );

      fosLastMonth.fold(
        (failure) => emit(state.copyWith(isFailureStatSalesBetweenDatesThisMonth: true)),
        (data) {
          final completedData = _fillMissingDays(data);
          emit(state.copyWith(listOfStatSalesBetweenDatesLastMonth: completedData, isFailureStatSalesBetweenDatesThisMonth: false));
        },
      );

      emit(state.copyWith(isLoadingStatSalesBetweenDatesThisMonth: false));
    });

//? ######################################################################################################

    on<GetStatSalesBetweenDatesMainPeriod>((event, emit) async {
      emit(state.copyWith(isLoadingStatSalesBetweenDatesMainPeriod: true));

      final fosMainPeriod = await dashboardRepository.getStatSalesBetweenDates(state.dateRangeStatSalesBetweenDatesMainPeriod);
      final dateRangeComparePeriod = state.dateRangeStatSalesBetweenDatesMainPeriod.toCompareDateRange();
      print('mainPeriod: ${state.dateRangeStatSalesBetweenDatesMainPeriod}');
      print('comparePeriod: $dateRangeComparePeriod');
      final fosComparePeriod = await dashboardRepository.getStatSalesBetweenDates(dateRangeComparePeriod);

      fosMainPeriod.fold(
        (failure) => emit(state.copyWith(isFailureStatSalesBetweenDatesMainPeriod: true)),
        (data) {
          final completedData = _fillMissingDays(data);
          emit(state.copyWith(listOfStatSalesBetweenDatesMainPeriod: completedData, isFailureStatSalesBetweenDatesMainPeriod: false));
        },
      );

      fosComparePeriod.fold(
        (failure) => emit(state.copyWith(isFailureStatSalesBetweenDatesMainPeriod: true)),
        (data) {
          final completedData = _fillMissingDays(data);
          emit(state.copyWith(listOfStatSalesBetweenDatesComparePeriod: completedData, isFailureStatSalesBetweenDatesMainPeriod: false));
        },
      );

      emit(state.copyWith(isLoadingStatSalesBetweenDatesMainPeriod: false));
    });

//? ######################################################################################################

    on<SetStatSalesBetweenDatesTimeRangeEvent>((event, emit) async {
      emit(state.copyWith(dateRangeStatSalesBetweenDatesMainPeriod: DateTimeRange(start: event.dateRange.start, end: event.dateRange.end)));
      add(GetStatSalesBetweenDatesMainPeriod());
    });

//? ######################################################################################################

    on<GetCurStatDashboardEvent>((event, emit) async {
      emit(state.copyWith(isLoadingOnObserve: true));
      final Either<AbstractFailure, StatDashboard> failureOrSuccess;

      failureOrSuccess = await dashboardRepository.getStatDashboard();

      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (statDashboard) => emit(state.copyWith(curStatDashboard: statDashboard, firebaseFailure: null, isAnyFailure: false)),
      );

      emit(
        state.copyWith(
          isLoadingOnObserve: false,
          fosDashboardOption: optionOf(failureOrSuccess),
        ),
      );
    });

//? ######################################################################################################

    on<GetListOfStatDashboardsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingOnObserve: true));
      final Either<AbstractFailure, List<StatDashboard>> failureOrSuccessStatDashboard;
      final Either<AbstractFailure, List<Receipt>> failureOrSuccessReceipt;

      failureOrSuccessStatDashboard = await dashboardRepository.getLast13StatDashboards();

      failureOrSuccessStatDashboard.fold(
        (failure) => emit(state.copyWith(
          listOfStatDashboards: [],
          curStatDashboard: StatDashboard.empty(),
          firebaseFailure: failure,
          isAnyFailure: true,
        )),
        (listOfStatDashboards) {
          final now = DateTime.now();
          emit(state.copyWith(
            listOfStatDashboards: listOfStatDashboards,
            curStatDashboard: listOfStatDashboards.where((e) => e.month == now.toConvertedYearMonth()).isNotEmpty
                ? listOfStatDashboards.where((e) => e.month == now.toConvertedYearMonth()).first
                : StatDashboard.empty(),
            firebaseFailure: null,
            isAnyFailure: false,
          ));
        },
      );

      failureOrSuccessReceipt = await dashboardRepository.getAppointmentsOfTodayAndTomorrow();

      failureOrSuccessReceipt.fold(
        (failure) => emit(state.copyWith(
          listOfAppointmentsToday: [],
          listOfAppointmentsTomorrow: [],
          firebaseFailureReceipts: failure,
          isAnyFailureReceipts: true,
        )),
        (listOfAppointments) {
          DateTime now = DateTime.now();

          emit(state.copyWith(
            listOfAppointments: listOfAppointments,
            listOfAppointmentsToday: listOfAppointments.isNotEmpty
                ? listOfAppointments
                    .where((e) =>
                        DateTime(e.creationDateMarektplace.year, e.creationDateMarektplace.month, e.creationDateMarektplace.day) ==
                        DateTime(now.year, now.month, now.day))
                    .toList()
                : [],
            listOfAppointmentsTomorrow: listOfAppointments.isNotEmpty
                ? listOfAppointments
                    .where((e) =>
                        DateTime(e.creationDateMarektplace.year, e.creationDateMarektplace.month, e.creationDateMarektplace.day) ==
                        DateTime(now.year, now.month, now.day + 1))
                    .toList()
                : [],
            firebaseFailureReceipts: null,
            isAnyFailureReceipts: false,
          ));
        },
      );

      emit(state.copyWith(
        isLoadingOnObserve: false,
        fosListOfStatDashboardsOption: optionOf(failureOrSuccessStatDashboard),
      ));
    });

//? ######################################################################################################

    on<GetListOfProductSalesByBrandEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductSalesByBrand: true));

      final fos = await dashboardRepository.getStatProductsByBrand(state.dateRangeBrands);

      fos.fold(
        (failure) => emit(state.copyWith(isFailureOnProductSalesByBrand: true, isLoadingProductSalesByBrand: false)),
        (list) {
          // Initiale Summenberechnung
          double totalSales = 0.0;
          double totalProfit = 0.0;

          for (final brand in list) {
            totalSales += brand.netSales;
            totalProfit += brand.profit;
          }

          // Liste aktualisieren mit berechneten Prozentwerten
          List<StatBrand> updatedList = list.map((brand) {
            double totalSalesPercent = (brand.netSales * 100) / totalSales;
            double totalProfitPercent = (brand.profit * 100) / totalProfit;
            return brand.copyWith(
              totalSalesPercent: totalSalesPercent,
              totalProfitPercent: totalProfitPercent,
            );
          }).toList();

          emit(state.copyWith(listOfProductSalesByBrand: updatedList, isLoadingProductSalesByBrand: false));
        },
      );
    });

//? ######################################################################################################

    on<SetProductSalesDateTimeRangeEvent>((event, emit) async {
      emit(state.copyWith(dateRangeBrands: DateTimeRange(start: event.dateRange.start, end: event.dateRange.end)));
      add(GetListOfProductSalesByBrandEvent());
    });

//? ######################################################################################################

    on<GetListOfReceiptsGroupsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingGroups: true));

      final fosCountry = await dashboardRepository.getSalesVolumeInvoicesGroupedByCountry(state.dateRangeGroups);
      final fosMarketplace = await dashboardRepository.getSalesVolumeInvoicesGroupedByMarketplace(state.dateRangeGroups);
      final fosMarketplaceAndCountry = await dashboardRepository.getSalesVolumeInvoicesGroupedByMarketplaceAndCountry(state.dateRangeGroups);

      fosCountry.fold(
        (failure) => emit(state.copyWith(isFailureOnGroups: true)),
        (response) {
          final sortedList = response..sort((a, b) => b.netGroupedSum.compareTo(a.netGroupedSum));
          emit(state.copyWith(salesVolumeGroupedByCountry: sortedList, isFailureOnGroups: false));
        },
      );

      fosMarketplace.fold(
        (failure) => emit(state.copyWith(isFailureOnGroups: true)),
        (response) {
          final sortedList = response..sort((a, b) => b.netGroupedSum.compareTo(a.netGroupedSum));
          emit(state.copyWith(salesVolumeGroupedByMarketplace: sortedList, isFailureOnGroups: false));
        },
      );

      fosMarketplaceAndCountry.fold(
        (failure) => emit(state.copyWith(isFailureOnGroups: true)),
        (response) {
          final sortedList = response..forEach((e) => e.countries..sort((a, b) => b.netGroupedSum.compareTo(a.netGroupedSum)));
          emit(state.copyWith(salesVolumeGroupedByMarketplaceAndCountry: sortedList, isFailureOnGroups: false));
        },
      );

      emit(state.copyWith(isLoadingGroups: false));
    });

//? ######################################################################################################

    on<SetGroupsDateTimeRangeEvent>((event, emit) async {
      emit(state.copyWith(dateRangeGroups: DateTimeRange(start: event.dateRange.start, end: event.dateRange.end)));
      add(GetListOfReceiptsGroupsEvent());
    });

//? ######################################################################################################
  }
}

StatSalesBetweenDates _fillMissingDays(StatSalesBetweenDates data) {
  if (data.dateRange == null) return data;

  final start = data.dateRange!.start;
  final end = data.dateRange!.end;
  final daysInRange = end.difference(start).inDays + 1;

  final completedList = List<StatSalesPerDay>.from(data.listOfStatSalesPerDay);

  for (int i = 0; i < daysInRange; i++) {
    final currentDate = start.add(Duration(days: i));
    final existingEntry = completedList.firstWhere(
      (element) => element.date.year == currentDate.year && element.date.month == currentDate.month && element.date.day == currentDate.day,
      orElse: () => StatSalesPerDay(
        listOfStatSalesPerDayPerMarketplace: [],
        date: currentDate,
      ),
    );

    if (!completedList.contains(existingEntry)) {
      completedList.add(existingEntry);
    }
  }

  // Sortiere die Liste nach Datum
  completedList.sort((a, b) => a.date.compareTo(b.date));

  return StatSalesBetweenDates(
    listOfStatSalesPerDay: completedList,
    dateRange: data.dateRange,
  );
}
