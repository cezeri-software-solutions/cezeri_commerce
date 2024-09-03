import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../functions/dialogs.dart';
import '../functions/input_validators.dart';
import '/3_domain/entities/address.dart';
import '/3_domain/entities/country.dart';
import '/3_domain/entities/id.dart';
import '/constants.dart';
import 'my_dialog_countries.dart';
import 'my_form_field_small.dart';
import 'my_outlined_button.dart';

class MyAddressUpdateSheet extends StatefulWidget {
  final Address? address;
  final Function(Address) onSave;
  final bool comeFromSupplier;

  const MyAddressUpdateSheet({super.key, required this.address, required this.onSave, this.comeFromSupplier = false});

  @override
  State<MyAddressUpdateSheet> createState() => _MyAddressUpdateSheetState();
}

class _MyAddressUpdateSheetState extends State<MyAddressUpdateSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _streetNameController = TextEditingController();
  TextEditingController _street2NameController = TextEditingController();
  TextEditingController _postcodeNameController = TextEditingController();
  TextEditingController _cityNameController = TextEditingController();
  TextEditingController _phoneNameController = TextEditingController();
  TextEditingController _phoneMobileNameController = TextEditingController();

  Country _selectedCountry = Country.countryList.first;
  AddressType _addressType = AddressType.delivery;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();

    if (widget.address != null) {
      _companyNameController = TextEditingController(text: widget.address!.companyName);
      _firstNameController = TextEditingController(text: widget.address!.firstName);
      _lastNameController = TextEditingController(text: widget.address!.lastName);
      _streetNameController = TextEditingController(text: widget.address!.street);
      _street2NameController = TextEditingController(text: widget.address!.street2);
      _postcodeNameController = TextEditingController(text: widget.address!.postcode);
      _cityNameController = TextEditingController(text: widget.address!.city);
      _phoneNameController = TextEditingController(text: widget.address!.phone);
      _phoneMobileNameController = TextEditingController(text: widget.address!.phoneMobile);

      _selectedCountry = widget.address!.country;
      _addressType = widget.address!.addressType;
      _isDefault = widget.address!.isDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Gaps.h16,
            //* Nur wenn eine neue Adresse hinzugefügt werden soll
            if (!widget.comeFromSupplier && widget.address == null) ...[
              Row(
                children: [
                  const Text('Standardadresse:'),
                  Switch.adaptive(value: _isDefault, onChanged: (value) => setState(() => _isDefault = value)),
                ],
              ),
              Gaps.h16,
            ],
            MyTextFormFieldSmall(labelText: 'Firmenname', controller: _companyNameController),
            Gaps.h16,
            Row(
              children: [
                Expanded(
                  child: MyTextFormFieldSmall(
                    labelText: 'Vorname',
                    controller: _firstNameController,
                    validator: (input) => validateGeneralMin3(input),
                  ),
                ),
                Gaps.w8,
                Expanded(
                  child: MyTextFormFieldSmall(
                    labelText: 'Nachname',
                    controller: _lastNameController,
                    validator: (input) => validateGeneralMin3(input),
                  ),
                ),
              ],
            ),
            Gaps.h16,

            Row(
              children: [
                Expanded(
                  child: MyTextFormFieldSmall(
                    labelText: 'Straße & Hausnummer',
                    controller: _streetNameController,
                    validator: (input) => validateGeneralMin3(input),
                  ),
                ),
                Gaps.w8,
                Expanded(child: MyTextFormFieldSmall(labelText: '2. Straße & Hausnummer', controller: _street2NameController)),
              ],
            ),
            Gaps.h16,
            Row(
              children: [
                Expanded(
                  child: MyTextFormFieldSmall(
                    labelText: 'PLZ',
                    controller: _postcodeNameController,
                    validator: (input) => validateGeneralMin2(input),
                  ),
                ),
                Gaps.w8,
                Expanded(
                  child: MyTextFormFieldSmall(
                    labelText: 'Stadt',
                    controller: _cityNameController,
                    validator: (input) => validateGeneralMin3(input),
                  ),
                ),
              ],
            ),
            Gaps.h16,
            if (!widget.comeFromSupplier) ...[
              Row(
                children: [
                  Expanded(child: MyTextFormFieldSmall(labelText: 'Tel. 1:', controller: _phoneNameController)),
                  Gaps.w8,
                  Expanded(child: MyTextFormFieldSmall(labelText: 'Tel. 2:', controller: _phoneMobileNameController)),
                ],
              ),
              Gaps.h16,
            ],
            MyDialogSelectCountry(
              labelText: 'Land',
              selectedCountry: _selectedCountry.name,
              onSelectCountry: (country) => setState(() => _selectedCountry = country),
            ),
            Gaps.h24,
            MyOutlinedButton(
              buttonText: 'Speichern',
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                if (_selectedCountry.name.isEmpty) {
                  showMyDialogAlert(context: context, title: 'Achtung', content: 'Wähle bitte ein Land aus');
                  return;
                }

                final now = DateTime.now();

                String id = UniqueID().value;
                if (widget.address != null) id = widget.address!.id;

                DateTime creationDate = now;
                if (widget.address != null) creationDate = widget.address!.creationDate;

                final address = Address(
                  id: id,
                  companyName: _companyNameController.text,
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  street: _streetNameController.text,
                  street2: _street2NameController.text,
                  postcode: _postcodeNameController.text,
                  city: _cityNameController.text,
                  country: _selectedCountry,
                  phone: _phoneNameController.text,
                  phoneMobile: _phoneMobileNameController.text,
                  addressType: _addressType,
                  isDefault: _isDefault,
                  creationDate: creationDate,
                  lastEditingDate: now,
                );
                widget.onSave(address);
                context.router.pop();
              },
            ),
            Gaps.h16,
          ],
        ),
      ),
    );
  }
}
