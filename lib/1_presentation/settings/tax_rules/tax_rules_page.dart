import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/main_settings/main_settings_bloc.dart';
import '../../../3_domain/entities/settings/main_settings.dart';
import '../../../3_domain/entities/settings/tax.dart';
import '../../../constants.dart';
import '../../app_drawer.dart';
import '../../core/functions/my_scaffold_messanger.dart';
import '../../core/widgets/my_outlined_button.dart';
import 'widgets/add_edit_tax_rules.dart';

class TaxRulesPage extends StatefulWidget {
  final MainSettingsBloc mainSettingsBloc;
  final MainSettings mSettings;

  const TaxRulesPage({super.key, required this.mainSettingsBloc, required this.mSettings});

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
          actions: [
            IconButton(onPressed: () => context.read<MainSettingsBloc>().add(GetMainSettingsEvent()), icon: const Icon(Icons.refresh)),
            MyOutlinedButton(
              buttonText: 'Speichern',
              buttonBackgroundColor: Colors.green,
              onPressed: () => _onSaveSettings(),
              isLoading: state.isLoadingMainSettingsOnUpdate,
            ),
            Gaps.w16,
          ],
        );

        const drawer = AppDrawer();

        if ((state.mainSettings == null && state.firebaseFailure == null) || state.isLoadingMainSettingsOnObserve) {
          return Scaffold(appBar: appBar, drawer: drawer, body: const Center(child: CircularProgressIndicator()));
        }

        if (state.firebaseFailure != null && state.isAnyFailure) {
          return Scaffold(appBar: appBar, drawer: drawer, body: Center(child: Text(mapFirebaseFailureMessage(state.firebaseFailure!))));
        }

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
                        onPressed: () => _addEditTaxRulesPressed(context: context, mainSettingsBloc: widget.mainSettingsBloc, isDefault: true),
                        icon: const Icon(Icons.add, color: Colors.green),
                      ),
                  ],
                ),
                if (state.mainSettings!.taxes.isNotEmpty)
                  ListTile(
                    trailing: const Icon(Icons.star_rate),
                    title: Text(state.mainSettings!.taxes.where((e) => e.isDefault == true).first.country),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Restliche Steuerregeln', style: TextStyles.h2),
                    if (state.mainSettings!.taxes.isNotEmpty)
                      IconButton(
                        onPressed: () => _addEditTaxRulesPressed(context: context, mainSettingsBloc: widget.mainSettingsBloc, isDefault: false),
                        icon: const Icon(Icons.add, color: Colors.green),
                      ),
                  ],
                ),
                if (state.mainSettings!.taxes.where((e) => e.isDefault == false).isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.mainSettings!.taxes.where((e) => e.isDefault == false).length,
                    itemBuilder: (context, index) {
                      return Container();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSaveSettings() {}

  void _addEditTaxRulesPressed({required BuildContext context, required MainSettingsBloc mainSettingsBloc, Tax? taxRule, required bool isDefault}) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => BlocProvider.value(
          value: mainSettingsBloc,
          child: AddEditTaxRules(taxRule: taxRule, isDefault: isDefault),
        ),
      );
}
