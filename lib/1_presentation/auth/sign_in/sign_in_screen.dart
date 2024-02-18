import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/auth/sign_in/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/auth/sign_in_form/sign_in_form_bloc.dart';
import '../../../injection.dart';
import '../../../routes/router.gr.dart';
import '../../core/renderer/failure_renderer.dart';

@RoutePage()
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signInFormBloc = sl<SignInFormBloc>();

    return BlocProvider(
      create: (context) => signInFormBloc,
      child: BlocListener<SignInFormBloc, SignInFormState>(
        listenWhen: (previous, current) => previous.authFailureOrSuccessOption != current.authFailureOrSuccessOption,
        listener: (context, state) {
          state.authFailureOrSuccessOption.fold(
            () => null,
            (a) => a.fold(
              (failure) => failureRenderer(context, [failure]),
              (right) => context.router.replace(SplashRoute()),
            ),
          );
        },
        child: Scaffold(
          body: SafeArea(child: SignInPage(signInFormBloc: signInFormBloc)),
        ),
      ),
    );
  }
}
