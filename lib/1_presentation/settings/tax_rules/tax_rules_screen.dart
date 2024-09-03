import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../core/core.dart';
import 'tax_rules_page.dart';

@RoutePage()
class TaxRulesScreen extends StatelessWidget {
  const TaxRulesScreen({super.key});

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
      child: const TaxRulesPage(),
    );
  }
}
