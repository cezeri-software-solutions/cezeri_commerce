import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/auth/sign_in_form/sign_in_form_bloc.dart';
import '../../../constants.dart';
import '../../../routes/router.gr.dart';
import '../../core/core.dart';

class ResetPasswordPage extends StatelessWidget {
  final SignInFormBloc signInFormBloc;

  const ResetPasswordPage({super.key, required this.signInFormBloc});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return BlocBuilder<SignInFormBloc, SignInFormState>(
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  const Text('Passwort zurücksetzen', style: TextStyles.h1),
                  const SizedBox(height: 40),
                  const Text(
                    'Sobald Sie Ihre E-Mail eingegeben haben und auf den Button "Passwort zurücksetzten" geklickt haben, bekommen Sie auf die eingegeben E-Mail eine Nachricht, wo Sie Ihr Passwort zurücksetzen können.',
                    style: TextStyles.h3,
                  ),
                  const SizedBox(height: 80),
                  MyFormFieldContainer(
                    child: TextFormField(
                      controller: emailController,
                      cursorColor: Colors.grey,
                      decoration: const InputDecoration(
                        labelText: 'E-Mail',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (email) => validateEmail(email),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ),
                  const SizedBox(height: 40),
                  MyFormFieldContainer(
                    child: TextFormField(
                      controller: passwordController,
                      cursorColor: Colors.grey,
                      decoration: const InputDecoration(
                        labelText: 'Passwort',
                        prefixIcon: Icon(Icons.password),
                      ),
                      // validator: (email) => validateEmail(email),
                      // keyboardType: TextInputType.emailAddress,
                      // textInputAction: TextInputAction.done,
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ),
                  const SizedBox(height: 80),
                  MyElevatedButton(
                    buttonText: 'E-Mail senden',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        signInFormBloc.add(SendPasswordResetEmailPressed(email: emailController.text));
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  MyElevatedButton(
                    buttonText: 'Passwort zurücksetzen',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        signInFormBloc.add(ResetPasswordForEmailEvent(email: emailController.text, password: passwordController.text));
                      }
                    },
                  ),
                  if (state.isSubmitting) ...[
                    const SizedBox(height: 20),
                    const LinearProgressIndicator(),
                  ],
                  const SizedBox(height: 40),
                  MyElevatedButton(
                    buttonText: 'Abbrechen',
                    onPressed: () => context.router.popUntil((route) => route.settings.name == SignInRoute.name),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
