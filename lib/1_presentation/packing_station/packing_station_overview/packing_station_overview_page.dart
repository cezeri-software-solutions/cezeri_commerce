import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../2_application/firebase/main_settings/main_settings_bloc.dart';
import '../../../2_application/firebase/marketplace/marketplace_bloc.dart';
import '../../../2_application/packing_station/packing_station_bloc.dart';
import '../../../3_domain/entities/carrier/carrier.dart';
import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../constants.dart';
import '../../../core/firebase_failures.dart';
import '../../../routes/router.gr.dart';
import '../../core/widgets/my_avatar.dart';
import '../../core/widgets/my_country_flag.dart';

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
              return switch (state.firebaseFailure.runtimeType) {
                EmptyFailure => const Expanded(child: Center(child: Text('Aktuell sind keine offenen Aufträge vorhanden'))),
                (_) => const Expanded(child: Center(child: Text('Ein Fehler beim Laden der Aufträge ist aufgetreten!')))
              };
            }
            if (stateMarketplace.firebaseFailure != null && stateMarketplace.isAnyFailure) {
              return switch (stateMarketplace.firebaseFailure.runtimeType) {
                EmptyFailure => const Expanded(child: Center(child: Text('Du hast noch keine Marktplätze angelegt!'))),
                (_) => const Expanded(child: Center(child: Text('Ein Fehler beim Laden der Marktplätze ist aufgetreten!'))),
              };
            }
            if (state.listOfAllAppointments == null || stateMarketplace.listOfMarketplace == null) {
              return const Expanded(child: Center(child: CircularProgressIndicator()));
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
  final List<Marketplace> listOfMarketplaces;

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
                      onTap: () {
                        packingStationBloc.add(PackgingStationGetAppointmentEvent(
                          appointment: appointment,
                          listOfPackagingBoxes: context.read<MainSettingsBloc>().state.mainSettings!.listOfPackagingBoxes,
                        ));
                        packingStationBloc.add(PackingsStationGetProductsFromFirestoreEvent(
                          productIds: appointment.listOfReceiptProduct.map((e) => e.productId).toList(),
                        ));
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
                          marketplace.logoUrl != ''
                              ? MyAvatar(
                                  name: marketplace.shortName,
                                  radius: 12,
                                  fontSize: 12,
                                  imageUrl: marketplace.logoUrl,
                                  shape: BoxShape.rectangle,
                                  fit: BoxFit.scaleDown,
                                )
                              : Text(marketplace.name),
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
                      child: Column(children: [
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
                      ]),
                    ),
                    SizedBox(
                      width: 220,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (appointment.addressDelivery.companyName != '') Text(appointment.addressDelivery.companyName),
                          Text(appointment.addressDelivery.name),
                          Text(appointment.addressDelivery.street),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: appointment.addressDelivery.postcode),
                                const TextSpan(text: ' '),
                                TextSpan(text: appointment.addressDelivery.city),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(appointment.addressDelivery.country.name),
                              Gaps.w8,
                              MyCountryFlag(country: appointment.addressDelivery.country, size: 12),
                            ],
                          ),
                        ],
                      ),
                    ),
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
