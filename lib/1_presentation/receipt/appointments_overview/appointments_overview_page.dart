import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../2_application/firebase/appointment/appointment_bloc.dart';
import '../../../3_domain/entities/address.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/receipt/receipt_product.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../constants.dart';
import '../../../core/firebase_failures.dart';
import '../../core/widgets/my_avatar.dart';
import '../../core/widgets/my_country_flag.dart';

class AppointmentsOverviewPage extends StatefulWidget {
  final AppointmentBloc appointmentBloc;

  const AppointmentsOverviewPage({super.key, required this.appointmentBloc});

  @override
  State<AppointmentsOverviewPage> createState() => _AppointmentsOverviewPageState();
}

class _AppointmentsOverviewPageState extends State<AppointmentsOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state.isLoadingAppointmentsOnObserve) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }
        if (state.firebaseFailure != null && state.isAnyFailure) {
          return switch (state.firebaseFailure.runtimeType) {
            EmptyFailure => const Expanded(child: Center(child: Text('Du hast noch keine Aufträge angelegt oder importiert!'))),
            (_) => const Expanded(child: Center(child: Text('Ein Fehler ist aufgetreten!'))),
          };
        }

        if (state.listOfAllAppointments == null || state.listOfFilteredAppointments == null) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }

        return Expanded(
          child: ListView.separated(
            itemCount: state.listOfFilteredAppointments!.length,
            itemBuilder: (context, index) {
              final curAppointment = state.listOfFilteredAppointments![index];
              return _AppointmentContainer(
                appointment: curAppointment,
                index: index,
                appointmentBloc: widget.appointmentBloc,
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          ),
        );
      },
    );
  }
}

class _AppointmentContainer extends StatefulWidget {
  final Receipt appointment;
  final int index;
  final AppointmentBloc appointmentBloc;

  const _AppointmentContainer({
    required this.appointment,
    required this.index,
    required this.appointmentBloc,
  });

  @override
  State<_AppointmentContainer> createState() => __AppointmentContainerState();
}

class __AppointmentContainerState extends State<_AppointmentContainer> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final responsiveness = screenWidth > 700 ? Responsiveness.isTablet : Responsiveness.isMobil;
    final deliveryAddress = widget.appointment.customer.listOfAddress.where((e) => e.addressType == AddressType.delivery && e.isDefault).first;
    final invoiceAddress = widget.appointment.customer.listOfAddress.where((e) => e.addressType == AddressType.invoice && e.isDefault).first;
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(
                    value: state.selectedAppointments.any((e) => e.receiptId == widget.appointment.receiptId),
                    onChanged: (_) => widget.appointmentBloc.add(OnAppointmentSelectedEvent(appointment: widget.appointment)),
                  ),
                  Column(
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
                        icon: const Icon(Icons.arrow_drop_down_circle, size: 30, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 150,
                    child: Column(
                      children: [
                        TextButton(onPressed: () {}, child: Text('Auftrag ${widget.appointment.appointmentId}')),
                        Text(DateFormat('dd.MM.yyy', 'de').format(widget.appointment.creationDate)),
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
                        const MyAvatar(name: 'P S', radius: 15, fontSize: 12), // TODO: Marketplace mit an dieses widget übergeben
                        Text(DateFormat('dd.MM.yyy', 'de').format(widget.appointment.creationDateMarektplace)),
                        Text(widget.appointment.receiptMarketplaceReference),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (invoiceAddress.companyName != '') Text(invoiceAddress.companyName),
                        Text(widget.appointment.customer.name),
                        Text(invoiceAddress.street),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: invoiceAddress.postcode),
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
        Expanded(flex: RowWidths.ean, child: Text(appointmentProduct.ean)),
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
