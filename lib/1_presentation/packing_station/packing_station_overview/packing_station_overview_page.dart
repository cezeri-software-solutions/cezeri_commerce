import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../../2_application/database/marketplace/marketplace_bloc.dart';
import '../../../2_application/packing_station/packing_station_bloc.dart';
import '../../../3_domain/entities/carrier/carrier.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../constants.dart';
import '../../../routes/router.gr.dart';
import '../../core/core.dart';

class PackingStationOverviewPage extends StatelessWidget {
  final PackingStationBloc packingStationBloc;
  final MarketplaceBloc marketplaceBloc;

  const PackingStationOverviewPage({super.key, required this.packingStationBloc, required this.marketplaceBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackingStationBloc, PackingStationState>(
      builder: (context, state) {
        return BlocBuilder<MarketplaceBloc, MarketplaceState>(
          builder: (context, stateMarketplace) {
            if (state.isLoadingAppointmentsOnObserve || stateMarketplace.isLoadingMarketplacesOnObserve) {
              return const Expanded(child: Center(child: CircularProgressIndicator()));
            }
            if (state.firebaseFailure != null && state.isAnyFailure) {
              return const Expanded(child: Center(child: Text('Ein Fehler beim Laden der Aufträge ist aufgetreten!')));
            }
            if (stateMarketplace.firebaseFailure != null && stateMarketplace.isAnyFailure) {
              return const Expanded(child: Center(child: Text('Ein Fehler beim Laden der Marktplätze ist aufgetreten!')));
            }
            if (state.listOfAllAppointments == null || stateMarketplace.listOfMarketplace == null) {
              return const Expanded(child: Center(child: CircularProgressIndicator()));
            }

            if (state.listOfAllAppointments!.isEmpty) {
              return const Expanded(child: Center(child: Text('Keine Aufträge vorhanden')));
            }

            if (state.listOfFilteredAppointments.isEmpty) {
              return const Expanded(child: Center(child: Text('Keine Aufträge mit diesem Filter vorhanden')));
            }

            return Expanded(
              child: ListView.separated(
                itemCount: state.listOfFilteredAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = state.listOfFilteredAppointments[index];
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox.adaptive(
                              value: state.isAllReceiptsSelected,
                              onChanged: (value) => packingStationBloc.add(PackingsStationOnAllAppointmentsSelectedEvent(isSelected: value!)),
                            ),
                            const Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 150, child: Text('Beleg-Nr. / Datum', style: TextStyles.h3Bold)),
                                  SizedBox(width: 120, child: Text('Marktplatz', style: TextStyles.h3Bold)),
                                  SizedBox(width: 120, child: Text('Informationen', style: TextStyles.h3Bold)),
                                  SizedBox(width: 220, child: Text('Lieferadresse', style: TextStyles.h3Bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        _PackingStationContainer(
                          appointment: appointment,
                          index: index,
                          packingStationBloc: packingStationBloc,
                          listOfMarketplaces: stateMarketplace.listOfMarketplace!,
                        ),
                      ],
                    );
                  } else {
                    return _PackingStationContainer(
                      appointment: appointment,
                      index: index,
                      packingStationBloc: packingStationBloc,
                      listOfMarketplaces: stateMarketplace.listOfMarketplace!,
                    );
                  }
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            );
          },
        );
      },
    );
  }
}

class _PackingStationContainer extends StatelessWidget {
  final Receipt appointment;
  final int index;
  final PackingStationBloc packingStationBloc;
  final List<AbstractMarketplace> listOfMarketplaces;

  const _PackingStationContainer({
    required this.appointment,
    required this.index,
    required this.packingStationBloc,
    required this.listOfMarketplaces,
  });

  @override
  Widget build(BuildContext context) {
    final marketplace = listOfMarketplaces.where((e) => e.id == appointment.marketplaceId).first;
    final carrier = Carrier.carrierList.where((e) => e.carrierTyp == appointment.receiptCarrier.carrierTyp).first;
    return BlocBuilder<PackingStationBloc, PackingStationState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Row(
            children: [
              Checkbox.adaptive(
                value: state.selectedAppointments.any((e) => e.id == appointment.id),
                onChanged: (_) => packingStationBloc.add(PackingsStationOnAppointmentSelectedEvent(appointment: appointment)),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (!appointment.addressDelivery.street.containsDigit()) {
                          final shouldPack = await WoltModalSheet.show<bool>(
                            context: context,
                            useSafeArea: false,
                            barrierDismissible: false,
                            pageListBuilder: (woltContext) {
                              return [
                                WoltModalSheetPage(
                                  hasTopBarLayer: false,
                                  isTopBarLayerAlwaysVisible: false,
                                  child: const _NoHouseNumber(),
                                ),
                              ];
                            },
                          );

                          if (shouldPack == null || !shouldPack) return;
                        }

                        packingStationBloc.add(PackgingStationGetAppointmentEvent(
                          appointment: appointment,
                          listOfPackagingBoxes: context.read<MainSettingsBloc>().state.mainSettings!.listOfPackagingBoxes,
                        ));
                        packingStationBloc.add(PackingsStationGetProductsFromFirestoreEvent(
                          productIds: appointment.listOfReceiptProduct.where((e) => e.productId != '').map((e) => e.productId).toList(),
                        ));

                        if (!context.mounted) return;
                        context.router.push(PackingStationDetailRoute(packingStationBloc: packingStationBloc, marketplace: marketplace));
                      },
                      child: SizedBox(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(appointment.appointmentNumberAsString, style: TextStyles.h3BoldPrimary),
                            Text(DateFormat('dd.MM.yyy', 'de').format(appointment.creationDate)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.watch_later_outlined, size: 16),
                                const Text(' '),
                                Text(DateFormat('Hm', 'de').format(appointment.creationDate)),
                              ],
                            ),
                            Icon(
                              Icons.delivery_dining,
                              color: switch (appointment.appointmentStatus) {
                                AppointmentStatus.open => Colors.grey,
                                AppointmentStatus.partiallyCompleted => Colors.orange[400],
                                AppointmentStatus.completed => Colors.green,
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Column(
                        children: [
                          marketplace.logoUrl != '' ? MarketplaceLogoAndType(marketplace: marketplace) : Text(marketplace.name),
                          Text(DateFormat('dd.MM.yyy', 'de').format(appointment.creationDateMarektplace)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.watch_later_outlined, size: 16),
                              const Text(' '),
                              Text(DateFormat('Hm', 'de').format(appointment.creationDateMarektplace)),
                            ],
                          ),
                          Text(appointment.receiptMarketplaceReference),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Column(
                        children: [
                          Image.asset(carrier.imagePath, height: 25, width: 65, fit: BoxFit.scaleDown),
                          Text(
                            '${appointment.listOfReceiptProduct.fold<double>(0.0, (sum, current) => sum + (current.weight * (current.quantity - current.shippedQuantity))).toMyCurrencyStringToShow()} kg',
                          ),
                          Gaps.h8,
                          Tooltip(
                            message: 'Bezahlter Betrag: ${appointment.totalPaidGross} €',
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: switch (appointment.paymentStatus) {
                                  PaymentStatus.open => CustomColors.backgroundLightGrey,
                                  PaymentStatus.partiallyPaid => CustomColors.backgroundLightOrange,
                                  PaymentStatus.paid => CustomColors.backgroundLightGreen,
                                },
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Center(
                                  child: switch (appointment.paymentStatus) {
                                    PaymentStatus.open => const Text('Offen', style: TextStyles.s12),
                                    PaymentStatus.partiallyPaid => const Text('Teilweise bezahlt', style: TextStyles.s12),
                                    PaymentStatus.paid => const Text('Komplett bezahlt', style: TextStyles.s12),
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AddressColumn(width: 220, address: appointment.addressDelivery),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NoHouseNumber extends StatelessWidget {
  const _NoHouseNumber();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16, left: 16, right: 16),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning, color: CustomColors.backgroundLightOrange),
              Gaps.w8,
              Text('Achtung!', style: TextStyles.h2Bold),
              Gaps.w8,
              Icon(Icons.warning, color: CustomColors.backgroundLightOrange),
            ],
          ),
          Gaps.h24,
          const Text('Die Lieferadresse von diesem Auftrag scheint keine Hausnummer zu haben.'),
          const Text('Willst du diesen Auftrag trotzdem verpacken?'),
          Gaps.h24,
          MyOutlinedButton(buttonText: 'JA', onPressed: () => context.router.maybePop(true)),
          TextButton(child: const Text('Abbrechen'), onPressed: () => context.router.maybePop(false)),
        ],
      ),
    );
  }
}
