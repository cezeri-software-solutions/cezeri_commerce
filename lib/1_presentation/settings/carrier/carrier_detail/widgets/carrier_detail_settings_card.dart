import 'package:cezeri_commerce/1_presentation/core/widgets/my_dropdown_button_small.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../2_application/firebase/main_settings/main_settings_bloc.dart';
import '../../../../../3_domain/entities/carrier/carrier.dart';
import '../../../../../constants.dart';
import '../../../../core/widgets/my_form_field_small.dart';

class CarrierDetailSettingsCard extends StatelessWidget {
  const CarrierDetailSettingsCard({super.key});

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
                const Text('Einstellungen', style: TextStyles.h3BoldPrimary),
                const Divider(height: 30),
                MyDropdownButtonSmall(
                  labelText: 'Papierlayout:',
                  onChanged: (value) => context.read<MainSettingsBloc>().add(OnCarrierPaperLayoutChangedEvnet(value: value!)),
                  value: state.curCarrier.paperLayout,
                  items: Carrier.carrierList.where((e) => e.internalName == state.curCarrier.internalName).first.listOfPaperLayout,
                ),
                Gaps.h8,
                MyDropdownButtonSmall(
                  labelText: 'Etikettengröße:',
                  onChanged: (value) => context.read<MainSettingsBloc>().add(OnCarrierLabelSizeChangedEvnet(value: value!)),
                  value: state.curCarrier.labelSize,
                  items: Carrier.carrierList.where((e) => e.internalName == state.curCarrier.internalName).first.listOfLabelSizes,
                ),
                Gaps.h8,
                MyDropdownButtonSmall(
                  labelText: 'Druckersprache:',
                  onChanged: (value) => context.read<MainSettingsBloc>().add(OnCarrierPrinterLanguageChangedEvnet(value: value!)),
                  value: state.curCarrier.printerLanguage,
                  items: Carrier.carrierList.where((e) => e.internalName == state.curCarrier.internalName).first.listOfPrinterLanguages,
                ),
                Gaps.h8,
                MyTextFormFieldSmall(
                  labelText: 'Marktplatz-Mapping:',
                  controller: state.marketplaceMappingController,
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
