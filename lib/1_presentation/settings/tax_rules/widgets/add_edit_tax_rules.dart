import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/3_domain/entities/id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../../../3_domain/entities/country.dart';
import '../../../../3_domain/entities/settings/tax.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

class AddEditTaxRules extends StatefulWidget {
  final Tax? taxRule;
  final bool isDefault;

  const AddEditTaxRules({super.key, required this.taxRule, required this.isDefault});

  @override
  State<AddEditTaxRules> createState() => _AddEditTaxRulesState();
}

class _AddEditTaxRulesState extends State<AddEditTaxRules> {
  late TextEditingController _taxNameController;
  late TextEditingController _taxRateController;

  Country _selectedCountry = Country.countryList.where((e) => e.isoCode.toUpperCase() == ('AT').toUpperCase()).first;

  @override
  void initState() {
    super.initState();
    if (widget.taxRule != null) {
      _taxNameController = TextEditingController(text: widget.taxRule!.taxName);
      _taxRateController = TextEditingController(text: widget.taxRule!.taxRate.toString());
      _selectedCountry = widget.taxRule!.country;
    } else {
      _taxNameController = TextEditingController();
      _taxRateController = TextEditingController();
      _selectedCountry = _selectedCountry;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyModalScrollable(
      title: widget.isDefault ? 'Steuerregel Inland' : 'Steuerregel',
      keyboardDismiss: KeyboardDissmiss.onTab,
      children: [
        Gaps.h24,
        MyTextFormField(
          labelText: 'Name',
          hintText: 'z.B.: Vorsteuer 20%',
          controller: _taxNameController,
        ),
        Gaps.h16,
        MyTextFormField(
          labelText: 'Steuer in %',
          hintText: 'z.B.: 20',
          controller: _taxRateController,
        ),
        Gaps.h16,
        MyDialogSelectCountry(
          labelText: 'Land',
          selectedCountry: _selectedCountry.name,
          onSelectCountry: (country) => setState(() => _selectedCountry = country),
        ),
        Gaps.h16,
        MyOutlinedButton(buttonText: 'Speichern', onPressed: () => _saveTaxRulePressed()),
        Gaps.h54,
      ],
    );
  }

  void _saveTaxRulePressed() {
    if (widget.taxRule == null) {
      final taxRule = Tax(
        taxId: UniqueID().value,
        taxName: _taxNameController.text,
        taxRate: int.parse(_taxRateController.text),
        country: _selectedCountry,
        isDefault: widget.isDefault,
      );
      context.read<MainSettingsBloc>().add(AddTaxRulesEvent(taxRules: taxRule));
      context.router.maybePop();
    } else {
      final taxRule = widget.taxRule!.copyWith(
        taxName: _taxNameController.text,
        taxRate: int.parse(_taxRateController.text),
        country: _selectedCountry,
      );
      context.read<MainSettingsBloc>().add(UpdateTaxRulesEvent(taxRules: taxRule));
      context.router.maybePop();
    }
  }
}
