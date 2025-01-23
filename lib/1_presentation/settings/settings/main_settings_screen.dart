import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../app_drawer.dart';
import '../../core/core.dart';
import 'main_settings_page.dart';

@RoutePage()
class MainSettingsScreen extends StatelessWidget {
  const MainSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<MainSettingsBloc>().add(GetMainSettingsEvent());

    return MultiBlocListener(
      listeners: [
        BlocListener<MainSettingsBloc, MainSettingsState>(
          listenWhen: (p, c) => p.fosMainSettingsOnObserveOption != c.fosMainSettingsOnObserveOption,
          listener: (context, state) {
            state.fosMainSettingsOnObserveOption.fold(
              () => null,
              (a) => a.fold(
                (failure) => failureRenderer(context, [failure]),
                (mainSettings) => null,
              ),
            );
          },
        ),
        BlocListener<MainSettingsBloc, MainSettingsState>(
          listenWhen: (p, c) => p.fosMainSettingsOnUpdateOption != c.fosMainSettingsOnUpdateOption,
          listener: (context, state) {
            state.fosMainSettingsOnUpdateOption.fold(
              () => null,
              (a) => a.fold(
                (failure) => failureRenderer(context, [failure]),
                (unit) {
                  myScaffoldMessenger(context, null, null, 'Einstellungen erfolgreich aktualisiert', null);
                  context.read<MainSettingsBloc>().add(GetMainSettingsEvent());
                },
              ),
            );
          },
        ),
      ],
      child: BlocBuilder<MainSettingsBloc, MainSettingsState>(
        builder: (context, state) {
          final appBar = AppBar(
            title: const Text('Einstellungen'),
            actions: [
              IconButton(onPressed: () => context.read<MainSettingsBloc>().add(GetMainSettingsEvent()), icon: const Icon(Icons.refresh)),
            ],
          );

          final drawer = context.displayDrawer ? const AppDrawer() : null;
          if ((state.mainSettings == null && state.firebaseFailure == null) || state.isLoadingMainSettingsOnObserve) {
            return Scaffold(appBar: appBar, drawer: drawer, body: const Center(child: CircularProgressIndicator()));
          }

          if (state.firebaseFailure != null && state.isAnyFailure) {
            return Scaffold(appBar: appBar, drawer: drawer, body: const Center(child: Text('Ein Fehler ist aufgetreten.')));
          }
          return MainSettingsPage(mSettings: state.mainSettings!);
        },
      ),
    );
  }
}
