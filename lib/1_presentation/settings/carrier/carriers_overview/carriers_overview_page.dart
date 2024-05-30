import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../../../3_domain/entities/carrier/carrier.dart';
import '../../../../3_domain/entities/settings/main_settings.dart';
import '../../../../constants.dart';
import '../../../app_drawer.dart';

class CarriersOverviewPage extends StatelessWidget {
  const CarriersOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainSettingsBloc, MainSettingsState>(
      builder: (context, state) {
        final appBar = AppBar(
          title: const Text('Versanddienstleister'),
          actions: [IconButton(onPressed: () => context.read<MainSettingsBloc>().add(GetMainSettingsEvent()), icon: const Icon(Icons.refresh))],
        );

        const drawer = AppDrawer();

        if ((state.mainSettings == null && state.firebaseFailure == null) || state.isLoadingMainSettingsOnObserve) {
          return Scaffold(appBar: appBar, drawer: drawer, body: const Center(child: CircularProgressIndicator()));
        }

        if (state.firebaseFailure != null && state.isAnyFailure) {
          return Scaffold(appBar: appBar, drawer: drawer, body: const Center(child: Text('Ein Fehler ist aufgetreten')));
        }

        final unusedCarriers =
            Carrier.carrierList.where((e) => !state.mainSettings!.listOfCarriers.any((f) => e.internalName == f.internalName)).toList();
        return Scaffold(
          appBar: appBar,
          drawer: drawer,
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gaps.h42,
                  const Text('Meine Versanddienstleister', style: TextStyles.h2),
                  Gaps.h16,
                  if (state.mainSettings!.listOfCarriers.isEmpty)
                    const SizedBox(
                      height: 150,
                      child: Center(
                        child: Text('Keine Versanddienstleister vorhanden'),
                      ),
                    ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.mainSettings!.listOfCarriers.length,
                    itemBuilder: (context, index) {
                      final carrier = state.mainSettings!.listOfCarriers[index];
                      return _CarrierListTile(carrier: carrier, mainSettings: state.mainSettings!, index: index, isActive: true);
                    },
                  ),
                  Gaps.h42,
                  const Text('Verfügbare Versanddienstleister', style: TextStyles.h2),
                  Gaps.h16,
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: unusedCarriers.length,
                    itemBuilder: (context, index) {
                      final carrier = unusedCarriers[index];
                      return _CarrierListTile(carrier: carrier, mainSettings: state.mainSettings!, index: index, isActive: false);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CarrierListTile extends StatelessWidget {
  final Carrier carrier;
  final MainSettings mainSettings;
  final int index;
  final bool isActive;

  const _CarrierListTile({required this.carrier, required this.mainSettings, required this.index, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 0),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Image.asset(
                Carrier.carrierList.where((e) => e.carrierTyp == carrier.carrierTyp).first.imagePath,
                height: 25,
                width: 65,
                fit: BoxFit.scaleDown,
              ),
              isActive
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          context.read<MainSettingsBloc>().add(OnCarrierDetailPressedEvent(carrier: carrier));
                          context.router.push(CarrierDetailRoute(index: index));
                        },
                        child: Text(carrier.name, style: TextStyles.textButtonText),
                      ),
                    )
                  : Text(carrier.name, style: TextStyles.h3),
              const Spacer(),
              Row(
                children: [
                  if (isActive)
                    Switch.adaptive(
                      value: carrier.isDefault,
                      onChanged: (value) => context.read<MainSettingsBloc>().add(OnIsDefaultCarrierChangedEvent(value: value, carrier: carrier)),
                    ),
                  Gaps.w16,
                  Switch.adaptive(
                    value: isActive ? carrier.isActive : mainSettings.listOfCarriers.any((e) => e.internalName == carrier.internalName),
                    onChanged: (value) => context.read<MainSettingsBloc>().add(EnableOrDisableCarrierEvent(value: value, carrier: carrier)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 0),
      ],
    );
  }
}
