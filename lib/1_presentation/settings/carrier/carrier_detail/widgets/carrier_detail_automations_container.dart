import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../../../../3_domain/entities/carrier/carrier.dart';
import '../../../../../3_domain/entities/carrier/carrier_product.dart';
import '../../../../../constants.dart';
import '../../../../core/core.dart';

class CarrierDetailAutomationsContainer extends StatelessWidget {
  const CarrierDetailAutomationsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainSettingsBloc, MainSettingsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Automatisierungen nach Land des Empfängers', style: TextStyles.h2),
                  IconButton(
                    onPressed: () => showDialog(context: context, builder: (_) => const SelectAutomationDialog()),
                    icon: const Icon(Icons.add, color: Colors.green),
                  ),
                ],
              ),
              Gaps.h24,
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.curCarrier.carrierAutomations.length,
                itemBuilder: (context, index) {
                  final automation = state.curCarrier.carrierAutomations[index];
                  return AutomationsShippingContainer(automation: automation, index: index, state: state);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class AutomationsShippingContainer extends StatelessWidget {
  final CarrierProduct automation;
  final int index;
  final MainSettingsState state;

  const AutomationsShippingContainer({super.key, required this.automation, required this.index, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                MyCountryFlag(country: automation.country),
                Gaps.w8,
                Text(automation.country.name == '' ? 'Restliche Länder' : automation.country.name),
                Gaps.w8,
                if (automation.isReturn)
                  const Icon(
                    Icons.keyboard_return,
                    color: CustomColors.primaryColor,
                  )
              ],
            ),
          ),
          Expanded(
            child: MyDropdownButtonSmall(
              value: automation.productName,
              onChanged: (carrierProductName) => context.read<MainSettingsBloc>().add(
                    ChangePackageAutomationForCountryEvnet(
                      selectedCarrierProduct: _selectListOfCarrierProducts(state.curCarrier).where((e) => e.productName == carrierProductName).first,
                      index: index,
                    ),
                  ),
              items: _selectListOfCarrierProducts(state.curCarrier).map((e) => e.productName).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectAutomationDialog extends StatelessWidget {
  const SelectAutomationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainSettingsBloc, MainSettingsState>(
      builder: (context, state) {
        return Dialog(
          child: SizedBox(
            width: 600,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyDialogSelectCountry(
                    labelText: 'Land',
                    selectedCountry: state.selectedCountry.name,
                    onSelectCountry: (country) =>
                        context.read<MainSettingsBloc>().add(SetSelectedCountryToCarrierAutomationEvent(selectedCountry: country)),
                  ),
                  Gaps.h24,
                  MyDropdownButtonFormField(
                    labelText: 'Paket',
                    value: state.selectedCarrierProduct.productName,
                    onChanged: (carrierProductName) => context.read<MainSettingsBloc>().add(
                          SetSelectedCarrierProductToCarrierAutomationEvent(
                              selectedCarrierProduct:
                                  _selectListOfCarrierProducts(state.curCarrier).where((e) => e.productName == carrierProductName).first),
                        ),
                    items: _selectListOfCarrierProducts(state.curCarrier).map((e) => e.productName).toList(),
                  ),
                  Gaps.h24,
                  Row(
                    children: [
                      const Text('Retour-Sendung:'),
                      Gaps.w16,
                      Checkbox.adaptive(
                        value: state.selectedCarrierProduct.isReturn,
                        onChanged: (value) => context.read<MainSettingsBloc>().add(SetIsReturnShipmentToCarrierAutomationEvent(value: value!)),
                      ),
                    ],
                  ),
                  Gaps.h24,
                  MyOutlinedButton(
                      buttonText: 'Speichern',
                      onPressed: () {
                        context.read<MainSettingsBloc>().add(SaveSelectedCarrierProductToCarrierAutomationEvent());
                        context.router.maybePop();
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

List<CarrierProduct> _selectListOfCarrierProducts(Carrier carrier) {
  return switch (carrier.carrierTyp) {
    CarrierTyp.austrianPost => CarrierProduct.carrierProductListAustrianPost,
    CarrierTyp.dpd => CarrierProduct.carrierProductListDpd,
    CarrierTyp.empty => [],
  };
}
