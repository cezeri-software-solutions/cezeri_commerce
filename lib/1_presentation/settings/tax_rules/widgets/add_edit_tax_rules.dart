import 'package:flutter/material.dart';

import '../../../../3_domain/entities/settings/tax.dart';
import '../../../../constants.dart';
import '../../../core/classes/list_of_countries.dart';
import '../../../core/widgets/my_dropdown_button_form_field.dart';
import '../../../core/widgets/my_modal_scrollable.dart';
import '../../../core/widgets/my_outlined_button.dart';
import '../../../core/widgets/my_text_form_field.dart';

class AddEditTaxRules extends StatefulWidget {
  final Tax? taxRule;
  final bool isDefault;

  const AddEditTaxRules({super.key, required this.taxRule, required this.isDefault});

  @override
  State<AddEditTaxRules> createState() => _AddEditTaxRulesState();
}

class _AddEditTaxRulesState extends State<AddEditTaxRules> {
  final _listOfCountries = Countries.listOfCountries;

  late TextEditingController _taxNameController;
  late TextEditingController _taxRateController;

  String _selectedCountry = Countries.listOfCountries[0];

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
      _selectedCountry = Countries.listOfCountries[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

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
        MyDropdownButtonFormField(
          labelText: 'Land',
          menuMaxHeight: screenHeight / 2,
          value: _selectedCountry,
          onChanged: (country) => setState(() => _selectedCountry = country.toString()),
          items: _listOfCountries,
        ),
        Gaps.h16,
        MyOutlinedButton(buttonText: 'Speichern', onPressed: () => _saveTaxRulePressed()),
        Gaps.h54,
      ],
    );
  }

  void _saveTaxRulePressed() {}
}
