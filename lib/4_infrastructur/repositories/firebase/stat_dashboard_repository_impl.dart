import 'package:cezeri_commerce/1_presentation/core/extensions/formatted_year_month.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/statistic/stat_dashboard.dart';
import '../../../3_domain/repositories/firebase/stat_dashboard_repository.dart';
import '../../../constants.dart';
import '../../../failures/abstract_failure.dart';
import '../../../failures/firebase_failures.dart';
import '../functions/repository_functions.dart';

class StatDashboardRepositoryImpl implements StatDashboardRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;
  StatDashboardRepositoryImpl({required this.db, required this.firebaseAuth});

  //? #######################################################################################################################################

  @override
  Future<Either<AbstractFailure, StatDashboard>> getStatDashboard() async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final now = DateTime.now();

    final query = supabase.from('stat_dashboards').select().eq('owner_id', ownerId).eq('statDashboardId', now.toFormattedYearMonth()).single();

    try {
      final response = await query;

      return right(StatDashboard.fromJson(response));
    } catch (e) {
      logger.e(e);
      return right(StatDashboard.empty());
    }
  }

  //? #######################################################################################################################################

  @override
  Future<Either<AbstractFailure, List<StatDashboard>>> getLast13StatDashboards() async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final query = supabase.from('stat_dashboards').select().eq('owner_id', ownerId).order('creation_date', ascending: false).limit(13);

    try {
      final response = await query;
      if (response.isEmpty) return const Right([]);

      final listOfProducts = response.map((e) => StatDashboard.fromJson(e)).toList();

      return Right(listOfProducts);
    } catch (e) {
      logger.e(e);
      return left(GeneralFailure(customMessage: 'Beim Laden der Vertriebsauswertungen der letzten 13 Monate ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  //? #######################################################################################################################################

  @override
  Future<Either<AbstractFailure, List<Receipt>>> getAppointmentsOfTodayAndTomorrow() async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final DateTime now = DateTime.now();
    final DateTime dayFirst = DateTime(
      now.year,
      now.month,
      now.day -
          switch (now.weekday) {
            DateTime.monday => 3,
            DateTime.sunday => 2,
            _ => 1,
          },
    );

    final query = supabase
        .from('d_appointments')
        .select()
        .eq('ownerId', ownerId)
        .gte('creationDateMarektplace', dayFirst.toIso8601String())
        .or('appointmentStatus.eq.${AppointmentStatus.open.name},appointmentStatus.eq.${AppointmentStatus.partiallyCompleted.name}');

    try {
      var listOfAppointments = await query.then((list) => list.map((e) => Receipt.fromJson(e)).toList());

      return Right(listOfAppointments);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Vertriebsauswertungen von heute und morgen ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  //? #######################################################################################################################################
}
