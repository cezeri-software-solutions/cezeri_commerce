import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import '../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/statistic/stat_dashboard.dart';
import '../../../3_domain/repositories/firebase/stat_dashboard_repository.dart';
import '../../../core/abstract_failure.dart';
import '../../../core/firebase_failures.dart';

final logger = Logger();

class StatDashboardRepositoryImpl implements StatDashboardRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;
  StatDashboardRepositoryImpl({required this.db, required this.firebaseAuth});

  //? #######################################################################################################################################

  @override
  Future<Either<AbstractFailure, StatDashboard>> getStatDashboard() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final now = DateTime.now();
    final curYear = now.year;
    final curMonth = now.month;

    final currentUserUid = firebaseAuth.currentUser!.uid;
    var docRef = db.collection('StatDashboard').doc(currentUserUid).collection('StatDashboard').doc('$curYear$curMonth');

    try {
      var statDashboard = await docRef.get();
      if (!statDashboard.exists) return right(StatDashboard.empty());

      return right(StatDashboard.fromJson(statDashboard.data()!));
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden der Vertriebsauswertungen für den aktuellen Monat ist ein Fehler aufgetreten', e: e));
    }
  }

  //? #######################################################################################################################################

  @override
  Future<Either<AbstractFailure, List<StatDashboard>>> getLast13StatDashboards() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('StatDashboard').doc(currentUserUid).collection('StatDashboard').orderBy('dateTime', descending: true).limit(13);

    try {
      final listOfStatDashboards = await docRef.get().then((value) => value.docs.map((document) => StatDashboard.fromJson(document.data())).toList());

      return right(listOfStatDashboards);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden der Vertriebsauswertungen der letzten 13 Monate ist ein Fehler aufgetreten', e: e));
    }
  }

  //? #######################################################################################################################################

  @override
  Future<Either<AbstractFailure, List<Receipt>>> getAppointmentsOfTodayAndTomorrow() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

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
    // final DateTime dayLast = DateTime(now.year, now.month, now.day + 2);

    final currentUserUid = firebaseAuth.currentUser!.uid;
    var docRef = db
        .collection('Receipts')
        .doc(currentUserUid)
        .collection('Appointments')
        .where('creationDateMarektplace', isGreaterThanOrEqualTo: dayFirst.toIso8601String())
        //.where('creationDateMarektplace', isLessThan: tomorrow.toIso8601String())
        .where('appointmentStatus', whereIn: [AppointmentStatus.open.name, AppointmentStatus.partiallyCompleted.name]);

    try {
      var listOfAppointments = await docRef.get().then(
            (value) => value.docs.map((document) => Receipt.fromJson(document.data())).toList(),
          );

      return right(listOfAppointments);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden der Vertriebsauswertungen von heute und morgen ist ein Fehler aufgetreten', e: e));
    }
  }

  //? #######################################################################################################################################
}
