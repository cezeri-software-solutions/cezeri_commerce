import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../../2_application/database/receipt_detail/receipt_detail_bloc.dart';
import '../../../3_domain/entities/carrier/carrier.dart';
import '../../../3_domain/entities/carrier/carrier_product.dart';
import '../../../3_domain/entities/receipt/receipt_carrier.dart';
import '../../../constants.dart';
import '../../core/core.dart';

class ReceiptDetailCarrierCard extends StatelessWidget {
  final ReceiptDetailBloc receiptDetailBloc;

  const ReceiptDetailCarrierCard({super.key, required this.receiptDetailBloc});

  @override
  Widget build(BuildContext context) {
    final mainSettings = context.read<MainSettingsBloc>().state.mainSettings!;
    final carrierItems = mainSettings.listOfCarriers.map((e) => ReceiptCarrier.fromCarrier(e)).toList();
    carrierItems.add(ReceiptCarrier.empty());

    return BlocBuilder<ReceiptDetailBloc, ReceiptDetailState>(
      bloc: receiptDetailBloc,
      builder: (context, state) {
        if (!carrierItems.any((e) => e.receiptCarrierName == state.receipt!.receiptCarrier.receiptCarrierName)) {
          carrierItems.add(state.receipt!.receiptCarrier);
        }

        Carrier? selectedCarrierFromSettings =
            mainSettings.listOfCarriers.where((e) => e.carrierTyp == state.receipt!.receiptCarrier.carrierTyp).firstOrNull;
        selectedCarrierFromSettings ??= mainSettings.listOfCarriers.where((e) => e.isDefault).first;

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
                  value: state.receipt!.receiptCarrier.receiptCarrierName,
                  onChanged: (carrierName) => receiptDetailBloc.add(
                    ReceiptDetailCarrierChangedEvent(receiptCarrier: carrierItems.where((e) => e.receiptCarrierName == carrierName).first),
                  ),
                  items: carrierItems.map((e) => e.receiptCarrierName).toList(),
                ),
                Gaps.h16,
                MyDropdownButtonSmall(
                  labelText: 'Produkt',
                  value: state.receipt!.receiptCarrier.carrierProduct.productName,
                  onChanged: (carrierProductName) => receiptDetailBloc.add(
                    ReceiptDetailCarrierProductChangedEvent(
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
