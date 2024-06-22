import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/auth/sign_in_form/sign_in_form_bloc.dart';
import '../../../constants.dart';
import '../../../routes/router.gr.dart';
import '../../core/core.dart';

class SignUpPage extends StatefulWidget {
  final SignInFormBloc signInFormBloc;

  const SignUpPage({super.key, required this.signInFormBloc});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isSnackbarActive = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final FocusNode _password2FocusNode = FocusNode();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isHidden1 = true;
  bool _isHidden2 = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController1.dispose();
    _passwordController2.dispose();
    _password2FocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInFormBloc, SignInFormState>(
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    const Text('Registrieren', style: TextStyles.h1),
                    const SizedBox(height: 20),
                    const Text('Bitte geben Sie Ihre E-Mail und Passwort ein Account zu erstellen.', style: TextStyles.h3),
                    const SizedBox(height: 60),
                    MyFormFieldContainer(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            cursorColor: Colors.grey,
                            decoration: const InputDecoration(labelText: 'E-Mail', prefixIcon: Icon(Icons.email)),
                            validator: (email) => validateEmail(email),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController1,
                            cursorColor: Colors.grey,
                            obscureText: _isHidden1,
                            decoration: InputDecoration(
                              labelText: 'Passwort',
                              prefixIcon: const Icon(Icons.vpn_key),
                              suffix: InkWell(
                                onTap: _togglePasswordView1,
                                child: !_isHidden1
                                    ? const Icon(Icons.visibility_off, color: Colors.grey)
                                    : const Icon(Icons.visibility, color: Colors.grey),
                              ),
                            ),
                            validator: (password) => validatePassword(password),
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context).requestFocus(_password2FocusNode),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController2,
                            cursorColor: Colors.grey,
                            obscureText: _isHidden2,
                            decoration: InputDecoration(
                              labelText: 'Passwort bestätigen',
                              prefixIcon: const Icon(Icons.vpn_key),
                              suffix: InkWell(
                                onTap: _togglePasswordView2,
                                child: !_isHidden2
                                    ? const Icon(Icons.visibility_off, color: Colors.grey)
                                    : const Icon(Icons.visibility, color: Colors.grey),
                              ),
                            ),
                            validator: (password) => validatePassword(password),
                            focusNode: _password2FocusNode,
                            textInputAction: TextInputAction.done,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    MyElevatedButton(
                      buttonText: 'Registrieren',
                      onPressed: () async {
                        if (formKey.currentState!.validate() && _passwordController1.text == _passwordController2.text) {
                          widget.signInFormBloc
                              .add(RegisterWithEmailAndPasswordPressed(email: _emailController.text, password: _passwordController1.text));
                        } else {
                          myScaffoldMessenger(context, null, null, null, 'Die Passwörter stimmen nicht überein!');
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

  void _togglePasswordView1() => setState(() => _isHidden1 = !_isHidden1);

  void _togglePasswordView2() => setState(() => _isHidden2 = !_isHidden2);
}
