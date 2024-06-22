import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../core/core.dart';
import 'packaging_box_page.dart';

@RoutePage()
class PackagingBoxesScreen extends StatelessWidget {
  const PackagingBoxesScreen({super.key});

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
          listenWhen: (p, c) => p.fosMainSettingsOnUpdateWithMsOption != c.fosMainSettingsOnUpdateWithMsOption,
          listener: (context, state) {
            state.fosMainSettingsOnUpdateWithMsOption.fold(
              () => null,
              (a) => a.fold(
                (failure) => failureRenderer(context, [failure]),
                (mainSettings) => myScaffoldMessenger(context, null, null, 'Einstellungen erfolgreich aktualisiert', null),
              ),
            );
          },
        ),
      ],
      child: const PackagingBoxesPage(),
    );
  }
}
