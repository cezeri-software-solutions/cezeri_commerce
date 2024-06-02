import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/formatted_year_month.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/statistic/stat_dashboard.dart';
import '../../../3_domain/repositories/firebase/receipt_respository.dart';
import '../../../3_domain/repositories/firebase/stat_dashboard_repository.dart';
import '../../../failures/abstract_failure.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final StatDashboardRepository dashboardRepository;
  final ReceiptRepository receiptRepository;
  DashboardBloc({required this.dashboardRepository, required this.receiptRepository}) : super(DashboardState.initial()) {
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
          DateTime now = DateTime.now();
          print('${now.year}-${now.month}');
          emit(state.copyWith(
            listOfStatDashboards: listOfStatDashboards,
            curStatDashboard: listOfStatDashboards.where((e) => e.month == now.toFormattedYearMonth()).isNotEmpty
                ? listOfStatDashboards.where((e) => e.month == now.toFormattedYearMonth()).first
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
          print(listOfAppointments.length);
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
  }
}
