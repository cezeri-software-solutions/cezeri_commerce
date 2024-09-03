import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/auth/user_data_form/user_data_form_bloc.dart';
import '../../../injection.dart';
import '../../core/core.dart';
import 'register_user_data_page.dart';

@RoutePage()
class RegisterUserDataScreen extends StatelessWidget {
  const RegisterUserDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userDataFormBloc = sl<UserDataFormBloc>();

    return BlocProvider(
      create: (context) => userDataFormBloc,
      child: BlocListener<UserDataFormBloc, UserDataFormState>(
        listenWhen: (previous, current) => previous.failureOrSuccessClientOption != current.failureOrSuccessClientOption,
        listener: (context, state) {
          state.failureOrSuccessClientOption.fold(
            () => null,
            (a) => a.fold(
              (failure) => failureRenderer(context, [failure]),
              (unit) => context.router.replaceAll([const HomeRoute()]),
            ),
          );
        },
        child: Scaffold(body: RegisterUserDataPage(userDataFormBloc: userDataFormBloc)),
      ),
    );
  }
}
