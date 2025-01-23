import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/2_application/database/main_settings/main_settings_bloc.dart';
import '/3_domain/entities/carrier/carrier.dart';
import '/3_domain/enums/enums.dart';
import '/constants.dart';
import '../../../core/core.dart';
import 'widgets/carrier_detail_automations_container.dart';
import 'widgets/carrier_detail_credentials_card.dart';
import 'widgets/carrier_detail_settings_card.dart';

class CarrierDetailPage extends StatelessWidget {
  final int index;

  const CarrierDetailPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;
    final responsiveness = screenWidth > 700 ? Responsiveness.isTablet : Responsiveness.isMobil;

    return BlocBuilder<MainSettingsBloc, MainSettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.mainSettings!.listOfCarriers[index].name),
            actions: [
              MyOutlinedButton(
                buttonText: 'Speichern',
                buttonBackgroundColor: Colors.green,
                onPressed: () => context.read<MainSettingsBloc>().add(OnSaveCarrierDetailEvent(index: index)),
                isLoading: state.isLoadingMainSettingsOnUpdate,
              )
            ],
          ),
          body: SafeArea(
            child: responsiveness == Responsiveness.isTablet
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          Image.asset(
                            Carrier.carrierList.where((e) => e.carrierTyp == state.curCarrier.carrierTyp).first.imagePath,
                            width: 100,
                            height: 100,
                          ),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: CarrierDetailSettingsCard()),
                              Gaps.w16,
                              Expanded(child: CarrierDetailCredentialsCard()),
                            ],
                          ),
                          Gaps.h24,
                          const CarrierDetailAutomationsContainer(),
                          Gaps.h24,
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView(
                      children: const [
                        Expanded(child: CarrierDetailSettingsCard()),
                        Gaps.w16,
                        Expanded(child: CarrierDetailCredentialsCard()),
                        Gaps.h24,
                        Text('Automatisierungen nach Land des Empfängers', style: TextStyles.h2),
                        Gaps.h24,
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
