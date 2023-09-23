import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../2_application/firebase/auth/auth_bloc/auth_bloc.dart';
import '../2_application/firebase/client/client_bloc.dart';
import '../3_domain/entities/client.dart';
import '../injection.dart';

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
    //authBloc.add(SignOutPressedEvent());
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
                  (failure) => null, // TODO: Speichere den Fehler in Firebase und kontaktiere den User
                  (client) {
                    if (client.companyName != Client.empty().companyName && client.name != Client.empty().name) {
                      context.router.replaceAll([const HomeRoute()]);
                    } else {
                      context.router.replaceAll([const RegisterUserDataRoute()]);
                    }
                  },
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
