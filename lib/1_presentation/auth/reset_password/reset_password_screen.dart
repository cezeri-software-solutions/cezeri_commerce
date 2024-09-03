import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/auth/sign_in_form/sign_in_form_bloc.dart';
import '../../../injection.dart';
import '../../core/core.dart';
import 'reset_password_page.dart';

@RoutePage()
class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signInFormBloc = sl<SignInFormBloc>();

    return BlocProvider(
      create: (context) => signInFormBloc,
      child: BlocListener<SignInFormBloc, SignInFormState>(
        listenWhen: (previous, current) => previous.authFailureOrSuccessOptionOnResetPassword != current.authFailureOrSuccessOptionOnResetPassword,
        listener: (context, state) {
          state.authFailureOrSuccessOptionOnResetPassword.fold(
            () => null,
            (a) => a.fold(
              (failure) => failureRenderer(context, [failure]),
              (right) =>
                  myScaffoldMessenger(context, null, null, 'Sie haben eine E-Mail erhalten.\nBitte überprüfen Sie auch Ihren SPAM-Ordner!', null),
            ),
          );
        },
        child: Scaffold(
          body: SafeArea(child: ResetPasswordPage(signInFormBloc: signInFormBloc)),
        ),
      ),
    );
  }
}
