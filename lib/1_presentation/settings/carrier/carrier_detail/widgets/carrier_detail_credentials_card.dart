import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../../../../constants.dart';
import '../../../../core/core.dart';

class CarrierDetailCredentialsCard extends StatelessWidget {
  const CarrierDetailCredentialsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainSettingsBloc, MainSettingsState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Zugangsdaten', style: TextStyles.h3BoldPrimary),
                const Divider(height: 30),
                MyTextFormFieldSmall(
                  fieldTitle: 'ClientID:',
                  controller: state.clientIdController,
                  onChanged: (_) => context.read<MainSettingsBloc>().add(OnCarrierControllerChangedEvent()),
                ),
                Gaps.h8,
                MyTextFormFieldSmall(
                  fieldTitle: 'OrgUnit ID:',
                  controller: state.orgUnitIdController,
                  onChanged: (_) => context.read<MainSettingsBloc>().add(OnCarrierControllerChangedEvent()),
                ),
                Gaps.h8,
                MyTextFormFieldSmall(
                  fieldTitle: 'OrgUnitGUID:',
                  controller: state.orgUnitGuideController,
                  onChanged: (_) => context.read<MainSettingsBloc>().add(OnCarrierControllerChangedEvent()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
