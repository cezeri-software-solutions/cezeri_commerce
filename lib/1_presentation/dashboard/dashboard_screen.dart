import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../2_application/database/dashboard/dashboard_bloc.dart';
import '../../injection.dart';
import '../app_drawer.dart';
import '../core/core.dart';
import 'dahsboard_page.dart';

@RoutePage()
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardBloc = sl<DashboardBloc>()
      ..add(GetStatSalesBetweenDatesThisMonth())
      ..add(GetStatSalesBetweenDatesMainPeriod())
      ..add(GetListOfStatDashboardsEvent())
      ..add(GetListOfProductSalesByBrandEvent())
      ..add(GetListOfReceiptsGroupsEvent());

    return BlocProvider(
      create: (context) => dashboardBloc,
      child: BlocListener<DashboardBloc, DashboardState>(
        listenWhen: (p, c) => p.fosListOfStatDashboardsOption != c.fosListOfStatDashboardsOption,
        listener: (context, state) {
          state.fosListOfStatDashboardsOption.fold(
            () => null,
            (a) => a.fold(
              (failure) => failureRenderer(context, [failure]),
              (r) => null,
            ),
          );
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return Scaffold(
              drawer: const AppDrawer(),
              appBar: AppBar(
                title: const Text('Dashboard'),
                actions: [IconButton(onPressed: () => dashboardBloc.add(GetListOfStatDashboardsEvent()), icon: const Icon(Icons.refresh))],
              ),
              body: SafeArea(child: DashboardScreenScaffoldBody(state: state, dashboardBloc: dashboardBloc)),
            );
          },
        ),
      ),
    );
  }
}

class DashboardScreenScaffoldBody extends StatelessWidget {
  final DashboardState state;
  final DashboardBloc dashboardBloc;

  const DashboardScreenScaffoldBody({super.key, required this.state, required this.dashboardBloc});

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingOnObserve) return const Center(child: MyCircularProgressIndicator());

    if (state.firebaseFailure != null && state.isAnyFailure) {
      return const Center(child: Text('Beim Laden der Dashboard-Daten ist ein Fehler aufgetreten.'));
    }

    if (state.curStatDashboard == null || state.listOfStatDashboards == null) return const Center(child: MyCircularProgressIndicator());
    if (state.listOfStatDashboards!.isEmpty) return const Text('Es existieren aktuell keine Dashboard-Daten.');

    return DashboardPage(dashboardBloc: dashboardBloc);
  }
}
