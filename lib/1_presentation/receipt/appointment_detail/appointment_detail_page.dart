import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../2_application/firebase/appointment/appointment_bloc.dart';
import '../../../2_application/firebase/main_settings/main_settings_bloc.dart';
import '../../../2_application/firebase/receipt_detail/receipt_detail_bloc.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../constants.dart';
import '../../core/functions/dialogs.dart';
import '../../core/widgets/my_circular_progress_indicator.dart';
import '../../core/widgets/my_outlined_button.dart';
import '../widgets/receipt_detail_address_card.dart';
import '../widgets/receipt_detail_carrier_card.dart';
import '../widgets/receipt_detail_general_card.dart';
import '../widgets/receipt_detail_payment_method_card.dart';
import '../widgets/receipt_detail_products_card.dart';
import '../widgets/receipt_detail_products_total_card.dart';
import 'appointment_detail_screen.dart';

class AppointmentDetailPage extends StatefulWidget {
  final AppointmentBloc appointmentBloc;
  final ReceiptDetailBloc receiptDetailBloc;
  final List<AbstractMarketplace> listOfMarketplaces;
  final ReceiptCreateOrEdit receiptCreateOrEdit;
  final ReceiptTyp receiptTyp;

  const AppointmentDetailPage({
    super.key,
    required this.appointmentBloc,
    required this.receiptDetailBloc,
    required this.listOfMarketplaces,
    required this.receiptCreateOrEdit,
    required this.receiptTyp,
  });

  @override
  State<AppointmentDetailPage> createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  @override
  Widget build(BuildContext context) {
    final logger = Logger();
    
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      bloc: widget.appointmentBloc,
      builder: (context, state) {
        logger.i(state.receipt!.receiptCarrier.carrierProduct.id);
        final mainSettings = context.read<MainSettingsBloc>().state.mainSettings!;
        final screenWidth = MediaQuery.sizeOf(context).width;
        final responsiveness = screenWidth > 700 ? Responsiveness.isTablet : Responsiveness.isMobil;

        final appBar = AppBar(
          title: switch (state.receipt!.receiptTyp) {
            ReceiptTyp.offer => Text('Angebot: ${state.receipt!.offerNumberAsString}'),
            ReceiptTyp.appointment => Text('Auftrag: ${state.receipt!.appointmentNumberAsString}'),
            ReceiptTyp.deliveryNote => Text('Lieferschein: ${state.receipt!.deliveryNoteNumberAsString}'),
            ReceiptTyp.invoice => Text('Rechnung: ${state.receipt!.invoiceNumberAsString}'),
            ReceiptTyp.credit => Text('Guschrift: ${state.receipt!.invoiceNumberAsString}'),
          },
          centerTitle: responsiveness == Responsiveness.isTablet ? true : false,
          actions: [
            if (widget.receiptCreateOrEdit == ReceiptCreateOrEdit.edit)
              IconButton(
                onPressed: () => widget.appointmentBloc.add(GetAppointmentEvent(appointment: state.receipt!)),
                icon: const Icon(Icons.refresh, size: 30),
              ),
            responsiveness == Responsiveness.isTablet ? Gaps.w32 : Gaps.w8,
            if (widget.receiptTyp == ReceiptTyp.deliveryNote) ...[
              IconButton(
                onPressed: () => widget.appointmentBloc.add(CreateParcelLabelReceiptEvent()),
                icon: state.isLoadingParcelLabelOnCreate
                    ? const MyCircularProgressIndicator()
                    : const Icon(Icons.new_label, color: CustomColors.primaryColor),
              ),
              responsiveness == Responsiveness.isTablet ? Gaps.w32 : Gaps.w8,
            ],
            BlocBuilder<ReceiptDetailBloc, ReceiptDetailState>(
              bloc: widget.receiptDetailBloc,
              builder: (context, stateReceiptDetail) {
                return MyOutlinedButton(
                  buttonText: 'Speichern',
                  onPressed: () async {
                    final isValid = await _validateReceiptOncreateOrUpdate(state, stateReceiptDetail);
                    if (!isValid) return;
                    if (widget.receiptCreateOrEdit == ReceiptCreateOrEdit.edit) {
                      final updatedAppointment = stateReceiptDetail.receipt.copyWith(
                        //* Hier kommen die Änderungen vom AppointmentBloc
                        //* Also Änderungen die oberhalb passieren bevor die Produkte anfangen
                        listOfReceiptProduct: stateReceiptDetail.listOfReceiptProducts,
                        marketplaceId: state.receipt!.marketplaceId,
                        receiptMarketplace: state.receipt!.receiptMarketplace,
                        paymentMethod: state.receipt!.paymentMethod,
                        paymentStatus: state.receipt!.paymentStatus,
                        receiptCarrier: state.receipt!.receiptCarrier,
                        addressDelivery: state.receipt!.addressDelivery,
                        addressInvoice: state.receipt!.addressInvoice,
                        lastEditingDate: DateTime.now(),
                      );
                      widget.appointmentBloc.add(UpdateAppointmentEvent(
                        appointment: updatedAppointment,
                        oldListOfReceiptProducts: state.receipt!.listOfReceiptProduct,
                        newListOfReceiptProducts: stateReceiptDetail.listOfReceiptProducts,
                      ));
                    } else {
                      final toCreateReceipt = stateReceiptDetail.receipt.copyWith(
                        listOfReceiptProduct: stateReceiptDetail.listOfReceiptProducts,
                        marketplaceId: state.receipt!.marketplaceId,
                        receiptMarketplace: state.receipt!.receiptMarketplace,
                        paymentMethod: state.receipt!.paymentMethod,
                        paymentStatus: state.receipt!.paymentStatus,
                        receiptCarrier: state.receipt!.receiptCarrier,
                        addressDelivery: state.receipt!.addressDelivery,
                        addressInvoice: state.receipt!.addressInvoice,
                        lastEditingDate: DateTime.now(),
                        creationDate: DateTime.now(),
                        receiptTyp: widget.receiptTyp,
                        currency: mainSettings.currency,
                      );
                      widget.appointmentBloc.add(CreateNewAppointmentManuallyEvent(receipt: toCreateReceipt));
                    }
                  },
                  isLoading: state.isLoadingReceiptOnUpdate,
                  buttonBackgroundColor: Colors.green,
                );
              },
            ),
            responsiveness == Responsiveness.isTablet ? Gaps.w32 : Gaps.w8,
          ],
        );

        logger.i(state.receipt!.addressDelivery);

        return Scaffold(
          appBar: appBar,
          body: SafeArea(
            child: responsiveness == Responsiveness.isTablet
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: ReceiptDetailAddressCard(receipt: state.receipt!, appointmentBloc: widget.appointmentBloc)),
                              Gaps.w16,
                              Expanded(
                                child: ReceiptDetailGeneralCard(
                                  receipt: state.receipt!,
                                  appointmentBloc: widget.appointmentBloc,
                                  listOfMarketplaces: widget.listOfMarketplaces,
                                ),
                              ),
                            ],
                          ),
                          Gaps.h16,
                          ReceiptDetailProductsCard(appointmentBloc: widget.appointmentBloc, receiptDetailBloc: widget.receiptDetailBloc),
                          Gaps.h16,
                          Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              Gaps.w16,
                              Expanded(
                                child: ReceiptDetailProductsTotalCard(
                                  appointmentBloc: widget.appointmentBloc,
                                  receiptDetailBloc: widget.receiptDetailBloc,
                                ),
                              ),
                            ],
                          ),
                          Gaps.h16,
                          Row(
                            children: [
                              Expanded(child: ReceiptDetailPaymentMethodCard(appointmentBloc: widget.appointmentBloc)),
                              Gaps.w16,
                              Expanded(child: ReceiptDetailCarrierCard(appointmentBloc: widget.appointmentBloc)),
                            ],
                          ),
                          Gaps.h42,
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView(
                      children: [
                        ReceiptDetailAddressCard(receipt: state.receipt!, appointmentBloc: widget.appointmentBloc),
                        Gaps.h16,
                        ReceiptDetailGeneralCard(
                          receipt: state.receipt!,
                          appointmentBloc: widget.appointmentBloc,
                          listOfMarketplaces: widget.listOfMarketplaces,
                        ),
                        Gaps.h16,
                        ReceiptDetailProductsCard(appointmentBloc: widget.appointmentBloc, receiptDetailBloc: widget.receiptDetailBloc),
                        Gaps.h16,
                        ReceiptDetailProductsTotalCard(appointmentBloc: widget.appointmentBloc, receiptDetailBloc: widget.receiptDetailBloc),
                        Gaps.h16,
                        ReceiptDetailPaymentMethodCard(appointmentBloc: widget.appointmentBloc),
                        Gaps.h16,
                        ReceiptDetailCarrierCard(appointmentBloc: widget.appointmentBloc),
                        Gaps.h42,
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  Future<bool> _validateReceiptOncreateOrUpdate(AppointmentState stateReceipt, ReceiptDetailState stateReceiptDetail) async {
    if (stateReceipt.receipt!.marketplaceId == '') {
      await showMyDialogAlert(context: context, title: 'Achtung!', content: 'Ein Marktplatz muss ausgewählt werden');
      return false;
    }
    if (stateReceiptDetail.listOfReceiptProducts.any((e) => e.articleNumber == '' || e.name == '')) {
      await showMyDialogAlert(
        context: context,
        title: 'Achtung!',
        content: 'Es dark kein Artikel mit leerer Artikelnummer oder leerem Artikelnamen vorhanden sein',
      );
      return false;
    }
    return true;
  }
}
