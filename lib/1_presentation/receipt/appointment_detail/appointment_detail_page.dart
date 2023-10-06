import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/appointment/appointment_bloc.dart';
import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../constants.dart';
import '../../core/widgets/my_outlined_button.dart';
import 'appointment_detail_screen.dart';

class AppointmentDetailPage extends StatefulWidget {
  final AppointmentBloc appointmentBloc;
  final List<Marketplace> listOfMarketplaces;
  final ReceiptCreateOrEdit receiptCreateOrEdit;

  const AppointmentDetailPage({super.key, required this.appointmentBloc, required this.listOfMarketplaces, required this.receiptCreateOrEdit});

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
            MyOutlinedButton(
              buttonText: 'Speichern',
              onPressed: () {
                if (state.appointment != null) {
                  // TODO: updated appointment
                  // widget.appointmentBloc.add(UpdateAppointmentEvent(appointment: ));
                } else {
                  // TODO: Handle create new product
                }
              },
              isLoading: state.isLoadingAppointmentOnUpdate,
              buttonBackgroundColor: Colors.green,
            ),
            responsiveness == Responsiveness.isTablet ? Gaps.w32 : Gaps.w8,
          ],
        );

        return Scaffold(
          appBar: appBar,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Text(state.appointment!.customer.name, style: TextStyles.h3BoldPrimary),
                                  const Divider(height: 30),
                                  DefaultTabController(
                                    length: 3,
                                    child: TabBar(
                                        tabs: const [Tab(text: 'Kunde'), Tab(text: 'Lieferadr.'), Tab(text: 'Rechnungsadr.')],
                                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                                        unselectedLabelStyle: const TextStyle(),
                                        onTap: (value) {}),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
