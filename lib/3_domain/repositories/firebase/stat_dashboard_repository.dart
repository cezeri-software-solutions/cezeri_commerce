import 'package:dartz/dartz.dart';

import '../../../core/abstract_failure.dart';
import '../../entities/receipt/receipt.dart';
import '../../entities/statistic/stat_dashboard.dart';

abstract class StatDashboardRepository {
  Future<Either<AbstractFailure, StatDashboard>> getStatDashboard();

  Future<Either<AbstractFailure, List<StatDashboard>>> getLast13StatDashboards();

  Future<Either<AbstractFailure, List<Receipt>>> getAppointmentsOfTodayAndTomorrow();
}
