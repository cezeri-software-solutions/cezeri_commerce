import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../2_application/firebase/dashboard/dashboard_bloc.dart';
import '../../core/firebase_failures.dart';
import '../../injection.dart';
import '../app_drawer.dart';
import '../core/functions/my_scaffold_messanger.dart';
import '../core/widgets/my_circular_progress_indicator.dart';
import 'dahsboard_page.dart';

@RoutePage()
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardBloc = sl<DashboardBloc>()..add(GetListOfStatDashboardsEvent());

    return BlocProvider(
      create: (context) => dashboardBloc,
      child: BlocListener<DashboardBloc, DashboardState>(
        listenWhen: (p, c) => p.fosListOfStatDashboardsOption != c.fosListOfStatDashboardsOption,
        listener: (context, state) {
          state.fosListOfStatDashboardsOption.fold(
            () => null,
            (a) => a.fold(
              (failure) => myScaffoldMessenger(context, failure, null, null, null),
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
      return switch (state.firebaseFailure.runtimeType) {
        EmptyFailure => const Center(child: Text('Es existieren aktuell keine Dashboard-Daten.')),
        _ => Center(child: Text(mapFirebaseFailureMessage(state.firebaseFailure!))),
      };
    }

    if (state.curStatDashboard == null || state.listOfStatDashboards == null) return const Center(child: MyCircularProgressIndicator());

    return DashboardPage(dashboardBloc: dashboardBloc);
  }
}
