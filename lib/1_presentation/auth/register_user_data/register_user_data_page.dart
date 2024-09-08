import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/auth/auth_bloc/auth_bloc.dart';
import '../../../2_application/database/auth/user_data_form/user_data_form_bloc.dart';
import '../../../3_domain/entities/country.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../4_infrastructur/repositories/database/functions/repository_functions.dart';
import '../../../constants.dart';
import '../../../routes/router.gr.dart';
import '../../core/core.dart';
import '../../splash_page.dart';

class RegisterUserDataPage extends StatefulWidget {
  final UserDataFormBloc userDataFormBloc;

  const RegisterUserDataPage({super.key, required this.userDataFormBloc});

  @override
  State<RegisterUserDataPage> createState() => _RegisterUserDataPageState();
}

class _RegisterUserDataPageState extends State<RegisterUserDataPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final currentUserEmail = getCurrentUserEmail();

  bool isSnackbarActive = false;
  Gender gender = Gender.empty;

  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  //final TextEditingController _countryController = TextEditingController();
  final TextEditingController _tel1Controller = TextEditingController();
  final TextEditingController _tel2Controller = TextEditingController();
  String selectedCountry = Country.countryList.map((e) => e.name).toList()[13];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataFormBloc, UserDataFormState>(builder: (context, state) {
      return Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  IconButton(
                    icon: const Icon(Icons.exit_to_app, color: Colors.grey),
                    onPressed: () => context.read<AuthBloc>().add(SignOutPressedEvent()),
                  ),
                  const Text('Firmendaten', style: TextStyles.h1),
                  const SizedBox(height: 20),
                  const Text('Bitte geben Sie die Daten Ihrer Hauptfiliale ein.', style: TextStyles.h3),
                  const SizedBox(height: 40),
                  MyFormFieldContainer(
                    child: Column(
                      children: [
                        const Text(
                          'Geschlecht:',
                          style: TextStyle(color: Color.fromARGB(255, 141, 140, 140), fontWeight: FontWeight.bold),
                        ),
                        _GenderChoiceChip(gender: gender, onPressSalatation: _onPressSalatation),
                        TextFormField(
                          controller: _companyNameController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Firmenname',
                            icon: Icon(Icons.business),
                          ),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          validator: (input) => validateGeneralMin3(input),
                        ),
                        TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Vorname',
                            icon: Icon(Icons.supervised_user_circle_outlined),
                          ),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          validator: (input) => validateGeneralMin3(input),
                        ),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Nachname',
                            icon: Icon(Icons.supervised_user_circle),
                          ),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          validator: (input) => validateGeneralMin3(input),
                        ),
                        TextFormField(
                          controller: _tel1Controller,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Telefon 1',
                            icon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                        ),
                        TextFormField(
                          controller: _tel2Controller,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Telefon 2',
                            icon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        TextFormField(
                          controller: _streetController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Straße & Hausnummer',
                          ),
                          keyboardType: TextInputType.streetAddress,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                        ),
                        TextFormField(
                          controller: _postCodeController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'PLZ',
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                        ),
                        TextFormField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Stadt',
                          ),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 10),
                        MyDialogSelectCountry(
                          labelText: 'Land',
                          selectedCountry: selectedCountry,
                          onSelectCountry: (country) => setState(() => selectedCountry = country.toString()),
                        ),
                        const Divider(height: 0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  MyElevatedButton(
                    buttonText: 'Speichern',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        widget.userDataFormBloc.add(
                          SaveUserDataPressedEvent(
                            gender: gender,
                            companyName: _companyNameController.text,
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            name: '${_firstNameController.text} ${_lastNameController.text}',
                            tel1: _tel1Controller.text,
                            tel2: _tel2Controller.text,
                            email: currentUserEmail,
                            street: _streetController.text,
                            postCode: _postCodeController.text,
                            city: _cityController.text,
                            country: selectedCountry, //_countryController.text,
                          ),
                        );
                      }
                    },
                  ),
                  if (state.isLoading) ...[
                    const SizedBox(height: 20),
                    const LinearProgressIndicator(),
                  ],
                  const SizedBox(height: 40),
                  if (context.router.canPop())
                    MyElevatedButton(
                      buttonText: 'Abbrechen',
                      onPressed: () => context.router.popUntil((route) => route.settings.name == SignInRoute.name),
                    ),
                  Gaps.h24,
                  MyElevatedButton(
                    buttonText: 'Abmelden',
                    buttonBackgroundColor: Colors.red,
                    onPressed: () => context.router.replaceAll([SplashRoute(comeFrom: ComeFromToSplashPage.appDrawer)]),
                  ),
                  Gaps.h32
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _onPressSalatation(Gender newGender) {
    return switch (newGender) {
      Gender.empty => setState(() => gender = Gender.empty),
      Gender.male => setState(() => gender = Gender.male),
      Gender.female => setState(() => gender = Gender.female),
    };
  }
}

class _GenderChoiceChip extends StatelessWidget {
  final Gender gender;
  final void Function(Gender gender) onPressSalatation;

  const _GenderChoiceChip({required this.gender, required this.onPressSalatation});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: [
        FilterChip(
          label: const Text('Frau'),
          labelStyle: const TextStyle(color: Colors.black),
          selected: gender == Gender.female ? true : false,
          selectedColor: Colors.blue[300],
          backgroundColor: Colors.lightBlue[50],
          onSelected: (bool isSelected) => !isSelected ? onPressSalatation(Gender.empty) : onPressSalatation(Gender.female),
        ),
        FilterChip(
          label: const Text('Herr'),
          labelStyle: const TextStyle(color: Colors.black),
          selected: gender == Gender.male ? true : false,
          selectedColor: Colors.blue[300],
          backgroundColor: Colors.lightBlue[50],
          onSelected: (bool isSelected) => !isSelected ? onPressSalatation(Gender.empty) : onPressSalatation(Gender.male),
        ),
      ],
    );
  }
}
