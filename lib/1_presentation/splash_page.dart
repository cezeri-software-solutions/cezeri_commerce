import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../2_application/database/auth/auth_bloc/auth_bloc.dart';
import '../2_application/database/client/client_bloc.dart';
import '../2_application/database/main_settings/main_settings_bloc.dart';
import '../3_domain/entities/client.dart';
import '../constants.dart';
import '../failures/firebase_failures.dart';
import '../injection.dart';
import 'core/renderer/failure_renderer.dart';

enum ComeFromToSplashPage { appDrawer }

@RoutePage()
class SplashPage extends StatefulWidget {
  final ComeFromToSplashPage? comeFrom;

  const SplashPage({super.key, this.comeFrom});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    //! Zum manuellen ausloggen
    // authBloc.add(SignOutPressedEvent());
    final clientBloc = sl<ClientBloc>();

    if (widget.comeFrom == ComeFromToSplashPage.appDrawer) context.read<AuthBloc>().add(SignOutPressedEvent());
    if (widget.comeFrom == null) context.read<AuthBloc>().add(AuthCheckRequestedEvent());

    return MultiBlocProvider(
      providers: [
        BlocProvider<ClientBloc>(
          create: (context) => clientBloc,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              logger.i(state);
              if (state is AuthStateAuthenticated) {
                context.read<ClientBloc>().add(GetCurrentClientEvent());
              } else if (state is AuthStateUnauthenticated) {
                context.router.replaceAll([const SignInRoute()]);
              }
            },
          ),
          BlocListener<ClientBloc, ClientState>(
            listenWhen: (p, c) => p.fosClientOnObserveOption != c.fosClientOnObserveOption,
            listener: (context, state) {
              state.fosClientOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failure.runtimeType == EmptyFailure
                      ? context.router.replaceAll([const RegisterUserDataRoute()])
                      : null, // TODO: Speichere den Fehler in Firebase und kontaktiere den User
                  (client) {
                    if (client.companyName != Client.empty().companyName && client.name != Client.empty().name) {
                      context.read<MainSettingsBloc>().add(GetMainSettingsEvent());
                    } else {
                      context.router.replaceAll([const RegisterUserDataRoute()]);
                    }
                  },
                ),
              );
            },
          ),
          BlocListener<MainSettingsBloc, MainSettingsState>(
            listenWhen: (p, c) => p.fosMainSettingsOnObserveOption != c.fosMainSettingsOnObserveOption,
            listener: (context, state) {
              state.fosMainSettingsOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (mainSettings) => context.router.replaceAll([const HomeRoute()]),
                ),
              );
            },
          ),
        ],
        child: const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}
