import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/auth/sign_in_form/sign_in_form_bloc.dart';
import '../../../injection.dart';
import '../../../routes/router.gr.dart';
import '../../core/core.dart';
import 'sign_up_page.dart';

@RoutePage()
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signInFormBloc = sl<SignInFormBloc>();

    return BlocProvider(
      create: (context) => signInFormBloc,
      child: BlocListener<SignInFormBloc, SignInFormState>(
        listenWhen: (previous, current) => previous.authFailureOrSuccessOptionOnRegister != current.authFailureOrSuccessOptionOnRegister,
        listener: (context, state) {
          state.authFailureOrSuccessOptionOnRegister.fold(
            () => null,
            (a) => a.fold(
              (failure) => failureRenderer(context, [failure]),
              (right) => context.router.replaceAll([SplashRoute()]),
            ),
          );
        },
        child: Scaffold(
          body: SafeArea(child: SignUpPage(signInFormBloc: signInFormBloc)),
        ),
      ),
    );
  }
}
