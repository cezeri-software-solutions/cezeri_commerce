import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/packing_station/packing_station_bloc.dart';
import '../../../core/core.dart';
import 'picklists_overview_page.dart';

@RoutePage()
class PicklistsOverviewScreen extends StatelessWidget {
  final PackingStationBloc packingStationBloc;

  const PicklistsOverviewScreen({super.key, required this.packingStationBloc});

  @override
  Widget build(BuildContext context) {
    packingStationBloc.add(PicklistGetPicklistsEvent());

    return MultiBlocListener(
      listeners: [
        BlocListener<PackingStationBloc, PackingStationState>(
          bloc: packingStationBloc,
          listenWhen: (p, c) => p.fosPicklistsOnObserveOption != c.fosPicklistsOnObserveOption,
          listener: (context, state) {
            state.fosPicklistsOnObserveOption.fold(
              () => null,
              (a) => a.fold(
                (failure) => failureRenderer(context, [failure]),
                (picklists) => myScaffoldMessenger(context, null, null, 'Picklisten erfolgreich geladen', null),
              ),
            );
          },
        ),
        BlocListener<PackingStationBloc, PackingStationState>(
          bloc: packingStationBloc,
          listenWhen: (p, c) => p.fosPicklistOnUpdateOption != c.fosPicklistOnUpdateOption,
          listener: (context, state) {
            state.fosPicklistOnUpdateOption.fold(
              () => null,
              (a) => a.fold(
                (failure) => failureRenderer(context, [failure]),
                (_) => myScaffoldMessenger(context, null, null, 'Pickliste erfolgreich aktualisiert', null),
              ),
            );
          },
        ),
      ],
      child: BlocBuilder<PackingStationBloc, PackingStationState>(
        bloc: packingStationBloc,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Picklisten')),
            body: SafeArea(child: PicklistsOverviewPage(packingStationBloc: packingStationBloc)),
          );
        },
      ),
    );
  }
}
