import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/main_settings/main_settings_bloc.dart';
import '../../../injection.dart';
import '../../core/functions/my_scaffold_messanger.dart';
import 'main_settings_page.dart';

@RoutePage()
class MainSettingsScreen extends StatelessWidget {
  const MainSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainSettingsBloc = sl<MainSettingsBloc>()..add(GetMainSettingsEvent());

    return BlocProvider(
      create: (context) => mainSettingsBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<MainSettingsBloc, MainSettingsState>(
            listenWhen: (p, c) => p.fosMainSettingsOnObserveOption != c.fosMainSettingsOnObserveOption,
            listener: (context, state) {
              state.fosMainSettingsOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
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
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
                  (unit) => myScaffoldMessenger(context, null, null, 'Einstellungen erfolgreich aktualisiert', null),
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<MainSettingsBloc, MainSettingsState>(
          builder: (context, state) {
            final appBar = AppBar(
              title: const Text('Einstellungen'),
              actions: [IconButton(onPressed: () => context.read<MainSettingsBloc>().add(GetMainSettingsEvent()), icon: const Icon(Icons.refresh))],
            );

            const drawer = AppDrawer();

            if (state.mainSettings == null && state.firebaseFailure == null) {
              return Scaffold(appBar: appBar, drawer: drawer, body: const Center(child: CircularProgressIndicator()));
            }

            if (state.firebaseFailure != null && state.isAnyFailure) {
              return Scaffold(appBar: appBar, drawer: drawer, body: Center(child: Text(mapFirebaseFailureMessage(state.firebaseFailure!))));
            }
            return Scaffold(
              appBar: appBar,
              drawer: drawer,
              body: SafeArea(child: MainSettingsPage(mainSettingsBloc: mainSettingsBloc, mSettings: state.mainSettings!)),
            );
          },
        ),
      ),
    );
  }
}
