import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/auth/sign_in_form/sign_in_form_bloc.dart';
import '../../../constants.dart';
import '../../../routes/router.gr.dart';
import '../../core/core.dart';

class SignInPage extends StatefulWidget {
  final SignInFormBloc signInFormBloc;

  const SignInPage({super.key, required this.signInFormBloc});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isHidden = true;
  bool isSnackbarActive = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInFormBloc, SignInFormState>(
      builder: (context, state) {
        return Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    // TODO: Image.asset(isLightMode ? 'assets/logo/logo_black_big.png' : 'assets/logo/logo_black_white.png'),
                    const SizedBox(height: 40),
                    const Text('Anmelden', style: TextStyles.h1, textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    MyFormFieldContainer(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            cursorColor: Colors.grey,
                            decoration: const InputDecoration(
                              labelText: 'E-Mail',
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: (email) => validateEmail(email),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: passwordController,
                            cursorColor: Colors.grey,
                            obscureText: _isHidden,
                            decoration: InputDecoration(
                              labelText: 'Passwort',
                              prefixIcon: const Icon(Icons.vpn_key),
                              suffix: InkWell(
                                onTap: _togglePasswordView,
                                child: !_isHidden
                                    ? const Icon(Icons.visibility_off, color: Colors.grey)
                                    : const Icon(Icons.visibility, color: Colors.grey),
                              ),
                            ),
                            onFieldSubmitted: (_) => _onSubmitPasswordField(),
                            validator: (password) => validatePassword(password),
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    MyElevatedButton(buttonText: 'Anmelden', onPressed: () => _onSubmitPasswordField()),
                    const SizedBox(height: 20),
                    MyElevatedButton(
                      buttonText: 'Registrieren',
                      onPressed: () => context.router.push(const SignUpRoute()),
                    ),
                    if (state.isSubmitting) ...[
                      const SizedBox(height: 20),
                      const LinearProgressIndicator(),
                    ],
                    const SizedBox(height: 40),
                    MyElevatedButton(
                      buttonText: 'Passwort vergessen?',
                      onPressed: () => context.router.push(const ResetPasswordRoute()),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _onSubmitPasswordField() {
    print('######## _onSubmitPasswordField #################################');
    if (formKey.currentState!.validate()) {
      BlocProvider.of<SignInFormBloc>(context).add(
        SignInWithEmailAndPasswordPressed(email: emailController.text, password: passwordController.text),
      );
    }
  }
}
