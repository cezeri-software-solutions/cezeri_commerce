import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/appointment/appointment_bloc.dart';
import '../../../2_application/firebase/receipt_detail/receipt_detail_bloc.dart';
import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../constants.dart';
import '../../core/widgets/my_outlined_button.dart';
import '../widgets/receipt_detail_address_card.dart';
import '../widgets/receipt_detail_general_card.dart';
import '../widgets/receipt_detail_products_card.dart';
import '../widgets/receipt_detail_products_total_card.dart';
import 'appointment_detail_screen.dart';

class AppointmentDetailPage extends StatefulWidget {
  final AppointmentBloc appointmentBloc;
  final ReceiptDetailBloc receiptDetailBloc;
  final List<Marketplace> listOfMarketplaces;
  final ReceiptCreateOrEdit receiptCreateOrEdit;

  const AppointmentDetailPage({
    super.key,
    required this.appointmentBloc,
    required this.receiptDetailBloc,
    required this.listOfMarketplaces,
    required this.receiptCreateOrEdit,
  });

  @override
  State<AppointmentDetailPage> createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      bloc: widget.appointmentBloc,
      builder: (context, state) {
        final screenWidth = MediaQuery.sizeOf(context).width;
        final responsiveness = screenWidth > 700 ? Responsiveness.isTablet : Responsiveness.isMobil;

        final appBar = AppBar(
          title: Text('Auftrag: ${state.appointment!.appointmentNumberAsString}'),
          centerTitle: responsiveness == Responsiveness.isTablet ? true : false,
          actions: [
            if (state.appointment != null)
              IconButton(
                onPressed: () => widget.appointmentBloc.add(GetAppointmentEvent(appointment: state.appointment!)),
                icon: const Icon(Icons.refresh, size: 30),
              ),
            responsiveness == Responsiveness.isTablet ? Gaps.w32 : Gaps.w8,
            BlocBuilder<ReceiptDetailBloc, ReceiptDetailState>(
              bloc: widget.receiptDetailBloc,
              builder: (context, stateReceiptDetail) {
                return MyOutlinedButton(
                  buttonText: 'Speichern',
                  onPressed: () {
                    if (state.appointment != null) {
                      final updatedAppointment = state.appointment!.copyWith(
                        discountPercent: stateReceiptDetail.discountPercentage,
                        discountGross: stateReceiptDetail.discountAmountGross,
                        totalShippingGross: stateReceiptDetail.shippingAmountGross,
                      );
                      widget.appointmentBloc.add(UpdateAppointmentEvent(
                        appointment: updatedAppointment,
                        oldListOfReceiptProducts: state.appointment!.listOfReceiptProduct,
                        newListOfReceiptProducts: stateReceiptDetail.listOfReceiptProducts,
                      ));
                    } else {
                      // TODO: Handle create new product
                    }
                  },
                  isLoading: state.isLoadingAppointmentOnUpdate,
                  buttonBackgroundColor: Colors.green,
                );
              },
            ),
            responsiveness == Responsiveness.isTablet ? Gaps.w32 : Gaps.w8,
          ],
        );

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
                              Expanded(child: ReceiptDetailAddressCard(receipt: state.appointment!)),
                              Gaps.w16,
                              Expanded(child: ReceiptDetailGeneralCard(receipt: state.appointment!, listOfMarketplaces: widget.listOfMarketplaces)),
                            ],
                          ),
                          Gaps.h16,
                          ReceiptDetailProductsCard(appointmentBloc: widget.appointmentBloc, receiptDetailBloc: widget.receiptDetailBloc),
                          Gaps.h16,
                          Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              Expanded(
                                child: ReceiptDetailProductsTotalCard(
                                  appointmentBloc: widget.appointmentBloc,
                                  receiptDetailBloc: widget.receiptDetailBloc,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView(
                      children: [
                        ReceiptDetailAddressCard(receipt: state.appointment!),
                        Gaps.h16,
                        ReceiptDetailGeneralCard(receipt: state.appointment!, listOfMarketplaces: widget.listOfMarketplaces),
                        Gaps.h16,
                        ReceiptDetailProductsCard(appointmentBloc: widget.appointmentBloc, receiptDetailBloc: widget.receiptDetailBloc),
                        Gaps.h16,
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
