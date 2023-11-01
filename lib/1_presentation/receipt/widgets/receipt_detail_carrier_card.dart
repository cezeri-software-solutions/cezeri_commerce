import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/appointment/appointment_bloc.dart';
import '../../../2_application/firebase/main_settings/main_settings_bloc.dart';
import '../../../3_domain/entities/carrier/carrier_product.dart';
import '../../../3_domain/entities/receipt/receipt_carrier.dart';
import '../../../constants.dart';
import '../../core/widgets/my_dropdown_button_small.dart';

class ReceiptDetailCarrierCard extends StatelessWidget {
  final AppointmentBloc appointmentBloc;

  const ReceiptDetailCarrierCard({super.key, required this.appointmentBloc});

  @override
  Widget build(BuildContext context) {
    final carrierItems = context.read<MainSettingsBloc>().state.mainSettings!.listOfCarriers.map((e) => ReceiptCarrier.fromCarrier(e)).toList();
    carrierItems.add(ReceiptCarrier.empty());

    return BlocBuilder<AppointmentBloc, AppointmentState>(
      bloc: appointmentBloc,
      builder: (context, state) {
        if (!carrierItems.any((e) => e.receiptCarrierName == state.appointment!.receiptCarrier.receiptCarrierName)) {
          carrierItems.add(state.appointment!.receiptCarrier);
        }

        final selectedCarrierFromSettings = context
            .read<MainSettingsBloc>()
            .state
            .mainSettings!
            .listOfCarriers
            .where((e) => e.carrierTyp == state.appointment!.receiptCarrier.carrierTyp)
            .first;

        final List<CarrierProduct> carrierProductItems = [CarrierProduct.empty()];
        for (final carrierProduct in selectedCarrierFromSettings.carrierAutomations) {
          if (!carrierProductItems.any((e) => e.productName == carrierProduct.productName)) carrierProductItems.add(carrierProduct);
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(alignment: Alignment.center, child: Text('Versandart', style: TextStyles.h3BoldPrimary)),
                const Divider(height: 30),
                MyDropdownButtonSmall(
                  labelText: 'Versanddienstleister',
                  value: state.appointment!.receiptCarrier.receiptCarrierName,
                  onChanged: (carrierName) => appointmentBloc.add(
                    OnAppointmentCarrierChangedEvent(receiptCarrier: carrierItems.where((e) => e.receiptCarrierName == carrierName).first),
                  ),
                  items: carrierItems.map((e) => e.receiptCarrierName).toList(),
                ),
                Gaps.h16,
                MyDropdownButtonSmall(
                  labelText: 'Produkt',
                  value: state.appointment!.receiptCarrier.carrierProduct.productName,
                  onChanged: (carrierProductName) => appointmentBloc.add(
                    OnAppointmentCarrierProductChangedEvent(
                      receiptCarrierProduct: carrierProductItems.where((e) => e.productName == carrierProductName!).first,
                    ),
                  ),
                  items: carrierProductItems.map((e) => e.productName).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
