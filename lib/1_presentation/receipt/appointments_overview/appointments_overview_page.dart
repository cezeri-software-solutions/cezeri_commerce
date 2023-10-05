import 'dart:math';

import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../2_application/firebase/appointment/appointment_bloc.dart';
import '../../../2_application/firebase/marketplace/marketplace_bloc.dart';
import '../../../3_domain/entities/address.dart';
import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/receipt/receipt_product.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../constants.dart';
import '../../../core/firebase_failures.dart';
import '../../core/widgets/my_avatar.dart';
import '../../core/widgets/my_country_flag.dart';

class AppointmentsOverviewPage extends StatefulWidget {
  final AppointmentBloc appointmentBloc;
  final MarketplaceBloc marketplaceBloc;

  const AppointmentsOverviewPage({super.key, required this.appointmentBloc, required this.marketplaceBloc});

  @override
  State<AppointmentsOverviewPage> createState() => _AppointmentsOverviewPageState();
}

class _AppointmentsOverviewPageState extends State<AppointmentsOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        return BlocBuilder<MarketplaceBloc, MarketplaceState>(
          builder: (context, stateMarketplace) {
            if (state.isLoadingAppointmentsOnObserve || stateMarketplace.isLoadingMarketplacesOnObserve) {
              return const Expanded(child: Center(child: CircularProgressIndicator()));
            }
            if (state.firebaseFailure != null && state.isAnyFailure) {
              return switch (state.firebaseFailure.runtimeType) {
                EmptyFailure => const Expanded(child: Center(child: Text('Du hast noch keine Aufträge angelegt oder importiert!'))),
                (_) => const Expanded(child: Center(child: Text('Ein Fehler beim Laden der Artikel ist aufgetreten!'))),
              };
            }

            if (stateMarketplace.firebaseFailure != null && stateMarketplace.isAnyFailure) {
              return switch (stateMarketplace.firebaseFailure.runtimeType) {
                EmptyFailure => const Expanded(child: Center(child: Text('Du hast noch keine Marktplätze angelegt!'))),
                (_) => const Expanded(child: Center(child: Text('Ein Fehler beim Laden der Marktplätze ist aufgetreten!'))),
              };
            }

            if (state.listOfAllAppointments == null || state.listOfFilteredAppointments == null || stateMarketplace.listOfMarketplace == null) {
              return const Expanded(child: Center(child: CircularProgressIndicator()));
            }

            return Expanded(
              child: ListView.separated(
                itemCount: state.listOfFilteredAppointments!.length,
                itemBuilder: (context, index) {
                  final curAppointment = state.listOfFilteredAppointments![index];
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox.adaptive(
                          value: state.selectAllAppointments,
                          onChanged: (value) => widget.appointmentBloc.add(
                            OnAllAppointmentSelectedEvent(isSelected: value!),
                          ),
                        ),
                        const Divider(),
                        _AppointmentContainer(
                          appointment: curAppointment,
                          index: index,
                          appointmentBloc: widget.appointmentBloc,
                          listOfMarketplaces: stateMarketplace.listOfMarketplace!,
                        ),
                      ],
                    );
                  }
                  return _AppointmentContainer(
                    appointment: curAppointment,
                    index: index,
                    appointmentBloc: widget.appointmentBloc,
                    listOfMarketplaces: stateMarketplace.listOfMarketplace!,
                  );
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

class _AppointmentContainer extends StatefulWidget {
  final Receipt appointment;
  final int index;
  final AppointmentBloc appointmentBloc;
  final List<Marketplace> listOfMarketplaces;

  const _AppointmentContainer({
    required this.appointment,
    required this.index,
    required this.appointmentBloc,
    required this.listOfMarketplaces,
  });

  @override
  State<_AppointmentContainer> createState() => __AppointmentContainerState();
}

class __AppointmentContainerState extends State<_AppointmentContainer> {
  final logger = Logger();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final responsiveness = screenWidth > 700 ? Responsiveness.isTablet : Responsiveness.isMobil;
    final marketplace = widget.listOfMarketplaces.where((e) => e.id == widget.appointment.marketplaceId).first;
    final deliveryAddress = widget.appointment.customer.listOfAddress.where((e) => e.addressType == AddressType.delivery && e.isDefault).first;
    final invoiceAddress = widget.appointment.customer.listOfAddress.where((e) => e.addressType == AddressType.invoice && e.isDefault).first;
    logger.i(widget.appointment.receiptMarketplaceId);
    logger.i(widget.appointment.receiptMarketplaceReference);
    logger.i(widget.appointment.creationDateMarektplace);
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox.adaptive(
                    value: state.selectedAppointments.any((e) => e.receiptId == widget.appointment.receiptId),
                    onChanged: (_) => widget.appointmentBloc.add(OnAppointmentSelectedEvent(appointment: widget.appointment)),
                  ),
                  SizedBox(
                    width: 60,
                    child: Column(
                      children: [
                        widget.appointment.listOfReceiptProduct.length > 1
                            ? Container(
                                height: 20,
                                width: 20,
                                decoration: const BoxDecoration(
                                  color: CustomColors.backgroundLightGreen,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Center(child: Text(widget.appointment.listOfReceiptProduct.length.toString())),
                              )
                            : const SizedBox(),
                        Gaps.h10,
                        IconButton(
                          onPressed: () => widget.appointmentBloc.add(SetAppointmentIsExpandedEvent(index: widget.index)),
                          icon: switch (state.isExpanded[widget.index]) {
                            true => const Icon(Icons.arrow_drop_down_circle, size: 30, color: CustomColors.primaryColor),
                            false => Transform.rotate(
                                angle: -pi / 2,
                                child: const Icon(Icons.arrow_drop_down_circle, size: 30, color: Colors.grey, grade: 25),
                              ),
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: Column(
                      children: [
                        TextButton(onPressed: () {}, child: Text('Auftrag ${widget.appointment.appointmentId}')),
                        Text(DateFormat('dd.MM.yyy', 'de').format(widget.appointment.creationDate)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.watch_later_outlined, size: 16),
                            const Text(' '),
                            Text(DateFormat('Hm', 'de').format(widget.appointment.creationDate)),
                          ],
                        ),
                        Text('${widget.appointment.totalGross.toMyCurrency()} €', style: TextStyles.defaultBold)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (deliveryAddress.companyName != '') Text(deliveryAddress.companyName),
                        Text(deliveryAddress.name),
                        Text(deliveryAddress.street),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: deliveryAddress.postcode),
                              const TextSpan(text: ' '),
                              TextSpan(text: deliveryAddress.city),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(deliveryAddress.country.name),
                            Gaps.w8,
                            MyCountryFlag(country: deliveryAddress.country, size: 12),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Column(
                      children: [
                        MyAvatar(
                          name: marketplace.shortName,
                          radius: 12,
                          fontSize: 12,
                          imageUrl: marketplace.logoUrl,
                          shape: BoxShape.rectangle,
                          fit: BoxFit.scaleDown,
                        ),
                        Text(marketplace.name),
                        Text(DateFormat('dd.MM.yyy', 'de').format(widget.appointment.creationDateMarektplace)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.watch_later_outlined, size: 16),
                            const Text(' '),
                            Text(DateFormat('Hm', 'de').format(widget.appointment.creationDateMarektplace)),
                          ],
                        ),
                        Text(widget.appointment.receiptMarketplaceReference),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.appointment.customer.company != null) Text(widget.appointment.customer.company!),
                        Text(widget.appointment.customer.name),
                        Text(invoiceAddress.street),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: invoiceAddress.postcode),
                              const TextSpan(text: ' '),
                              TextSpan(text: invoiceAddress.city),
                            ],
                          ),
                        ),
                        Text(invoiceAddress.country.name),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: Column(
                      children: [
                        Tooltip(
                          message: 'Bezahlter Betrag: ${widget.appointment.totalPaidGross} €',
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: switch (widget.appointment.paymentStatus) {
                                PaymentStatus.open => CustomColors.backgroundLightGrey,
                                PaymentStatus.partiallyPaid => CustomColors.backgroundLightOrange,
                                PaymentStatus.paid => CustomColors.backgroundLightGreen,
                              },
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Center(
                                child: switch (widget.appointment.paymentStatus) {
                                  PaymentStatus.open => const Text('Offen'),
                                  PaymentStatus.partiallyPaid => const Text('Teilweise bezahlt'),
                                  PaymentStatus.paid => const Text('Komplett bezahlt'),
                                },
                              ),
                            ),
                          ),
                        ),
                        Gaps.h2,
                        Image.asset(widget.appointment.paymentMethod.logoPath, height: 25, width: 65, fit: BoxFit.scaleDown),
                      ],
                    ),
                  ),
                  const SizedBox(),
                ],
              ),
              if (state.isExpanded[widget.index])
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Expanded(flex: RowWidths.pos, child: Text('Pos', style: TextStyles.defaultBold)),
                              Spacer(),
                              Expanded(flex: RowWidths.articleNumber, child: Text('Artikelnummer', style: TextStyles.defaultBold)),
                              Spacer(),
                              Expanded(flex: RowWidths.ean, child: Text('EAN', style: TextStyles.defaultBold)),
                              Spacer(),
                              Expanded(flex: RowWidths.articleName, child: Text('Name', style: TextStyles.defaultBold)),
                              Spacer(),
                              Expanded(flex: RowWidths.openQuantity, child: Text('Offen', style: TextStyles.defaultBold)),
                              Spacer(),
                              Expanded(flex: RowWidths.quantity, child: Text('Anzahl', style: TextStyles.defaultBold)),
                            ],
                          ),
                          const Divider(),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.appointment.listOfReceiptProduct.length,
                            itemBuilder: (context, index) {
                              return _AppointmentProdcutsContainer(appointmentProduct: widget.appointment.listOfReceiptProduct[index], index: index);
                            },
                            separatorBuilder: (context, index) => const Divider(),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}

class _AppointmentProdcutsContainer extends StatelessWidget {
  final ReceiptProduct appointmentProduct;
  final int index;

  const _AppointmentProdcutsContainer({required this.appointmentProduct, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(flex: RowWidths.pos, child: Text((index + 1).toString(), style: TextStyles.defaultBold)),
        const Spacer(),
        Expanded(flex: RowWidths.articleNumber, child: Text(appointmentProduct.articleNumber, overflow: TextOverflow.ellipsis)),
        const Spacer(),
        Expanded(flex: RowWidths.ean, child: Text(appointmentProduct.ean, overflow: TextOverflow.ellipsis)),
        const Spacer(),
        Expanded(flex: RowWidths.articleName, child: Text(appointmentProduct.name, overflow: TextOverflow.ellipsis)),
        const Spacer(),
        Expanded(
            flex: RowWidths.openQuantity,
            child: Center(
                child: switch (appointmentProduct.quantity - appointmentProduct.shippedQuantity) {
              0 => Text(
                  (appointmentProduct.quantity - appointmentProduct.shippedQuantity).toString(),
                  style: TextStyles.defaultBold.copyWith(
                    color: Colors.green,
                  ),
                ),
              (_) => Text(
                  (appointmentProduct.quantity - appointmentProduct.shippedQuantity).toString(),
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
            })),
        const Spacer(),
        Expanded(flex: RowWidths.quantity, child: Center(child: Text(appointmentProduct.quantity.toString()))),
      ],
    );
  }
}
