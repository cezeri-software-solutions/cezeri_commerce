import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../../3_domain/entities/settings/tax.dart';
import '../../../constants.dart';
import '../../app_drawer.dart';
import '../../core/core.dart';
import 'widgets/add_edit_tax_rules.dart';

class TaxRulesPage extends StatefulWidget {
  const TaxRulesPage({super.key});

  @override
  State<TaxRulesPage> createState() => _TaxRulesPageState();
}

class _TaxRulesPageState extends State<TaxRulesPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainSettingsBloc, MainSettingsState>(
      builder: (context, state) {
        final appBar = AppBar(
          title: const Text('Steuerregeln'),
          actions: [IconButton(onPressed: () => context.read<MainSettingsBloc>().add(GetMainSettingsEvent()), icon: const Icon(Icons.refresh))],
        );

        final drawer = context.displayDrawer ? const AppDrawer() : null;

        if ((state.mainSettings == null && state.firebaseFailure == null) || state.isLoadingMainSettingsOnObserve) {
          return Scaffold(appBar: appBar, drawer: drawer, body: const Center(child: CircularProgressIndicator()));
        }

        if (state.firebaseFailure != null && state.isAnyFailure) {
          return Scaffold(appBar: appBar, drawer: drawer, body: const Center(child: Text('Ein Fehler ist aufgetreten')));
        }

        final taxRuleDefault = state.mainSettings!.taxes.where((e) => e.isDefault == true).firstOrNull;
        final taxRulesRest = state.mainSettings!.taxes.where((e) => e.isDefault == false).toList();
        return Scaffold(
          appBar: appBar,
          drawer: drawer,
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Steuerregel Inland', style: TextStyles.h2),
                    if (state.mainSettings!.taxes.isEmpty)
                      IconButton(
                        onPressed: () => _addEditTaxRulesPressed(isDefault: true),
                        icon: const Icon(Icons.add, color: Colors.green),
                      ),
                  ],
                ),
                if (taxRuleDefault != null && state.mainSettings!.taxes.isNotEmpty)
                  _TaxRuleListTile(
                    taxRule: taxRuleDefault,
                    isDefault: true,
                    addEditTaxRulesPressed: _addEditTaxRulesPressed,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Restliche Steuerregeln', style: TextStyles.h2),
                    if (state.mainSettings!.taxes.isNotEmpty)
                      IconButton(
                        onPressed: () => _addEditTaxRulesPressed(isDefault: false),
                        icon: const Icon(Icons.add, color: Colors.green),
                      ),
                  ],
                ),
                if (state.mainSettings!.taxes.where((e) => e.isDefault == false).isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: taxRulesRest.length,
                    itemBuilder: (context, index) {
                      final taxRule = taxRulesRest[index];
                      return _TaxRuleListTile(taxRule: taxRule, isDefault: false, addEditTaxRulesPressed: _addEditTaxRulesPressed);
                    },
                    separatorBuilder: (context, index) => const Divider(height: 0),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addEditTaxRulesPressed({Tax? taxRule, required bool isDefault}) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => AddEditTaxRules(taxRule: taxRule, isDefault: isDefault),
      );
}

class _TaxRuleListTile extends StatelessWidget {
  final Tax taxRule;
  final bool isDefault;
  final void Function({required Tax taxRule, required bool isDefault}) addEditTaxRulesPressed;

  const _TaxRuleListTile({required this.taxRule, required this.isDefault, required this.addEditTaxRulesPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: MyCountryFlag(country: taxRule.country),
        title: Row(
          children: [
            Text(taxRule.country.name),
            Text(' / ${taxRule.taxRate.toString()}%'),
          ],
        ),
        subtitle: Text(taxRule.taxName),
        trailing: IconButton(
          onPressed: () => addEditTaxRulesPressed(taxRule: taxRule, isDefault: true),
          icon: const Icon(Icons.edit, color: CustomColors.primaryColor),
        ),
      ),
    );
  }
}
