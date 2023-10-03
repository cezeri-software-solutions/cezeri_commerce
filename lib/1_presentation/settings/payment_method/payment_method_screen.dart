import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/main_settings/main_settings_bloc.dart';
import '../../../injection.dart';
import '../../core/functions/my_scaffold_messanger.dart';
import 'payment_method_page.dart';

@RoutePage()
class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainSettingsBloc = sl<MainSettingsBloc>()..add(GetMainSettingsEvent());
    // final mainSettingsBloc = sl<MainSettingsBloc>()..add(CreateMainSettingsEvent(mainSettings: MainSettings.empty()));

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
                  (unit) {
                    myScaffoldMessenger(context, null, null, 'Einstellungen erfolgreich aktualisiert', null);
                    mainSettingsBloc.add(GetMainSettingsEvent());
                  },
                ),
              );
            },
          ),
        ],
        child: PaymentMethodPage(mainSettingsBloc: mainSettingsBloc),
      ),
    );
  }
}
