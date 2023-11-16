import 'package:dartz/dartz.dart';

import '../../../core/firebase_failures.dart';
import '../../entities/receipt/receipt.dart';
import '../../entities/stat_dashboard.dart';

abstract class DashboardRepository {
  Future<Either<FirebaseFailure, StatDashboard>> getStatDashboard();

  Future<Either<FirebaseFailure, List<StatDashboard>>> getLast13StatDashboards();

  Future<Either<FirebaseFailure, List<Receipt>>> getAppointmentsOfTodayAndTomorrow();
}
