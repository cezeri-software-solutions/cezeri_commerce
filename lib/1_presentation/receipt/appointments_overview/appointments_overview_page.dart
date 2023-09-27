import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../2_application/firebase/appointment/appointment_bloc.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../constants.dart';
import '../../../core/firebase_failures.dart';

class AppointmentsOverviewPage extends StatelessWidget {
  final AppointmentBloc appointmentBloc;

  const AppointmentsOverviewPage({super.key, required this.appointmentBloc});

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

        return Expanded(
          child: ListView.builder(
            itemCount: state.listOfAppointment!.length,
            itemBuilder: (context, index) {
              final curAppointment = state.listOfAppointment![index];
              return _AppointmentContainer(appointment: curAppointment, index: index, appointmentBloc: appointmentBloc);
            },
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

  const _AppointmentContainer({required this.appointment, required this.index, required this.appointmentBloc});

  @override
  State<_AppointmentContainer> createState() => __AppointmentContainerState();
}

class __AppointmentContainerState extends State<_AppointmentContainer> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final responsiveness = screenWidth > 700 ? Responsiveness.isTablet : Responsiveness.isMobil;
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Row(
            children: [
              Checkbox(value: false, onChanged: (value) {}),
              Column(
                children: [
                  Badge.count(count: widget.appointment.listOfReceiptProduct.length),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Text('Auftrag ${widget.appointment.appointmentId}', style: TextStyles.h3Bold),
                  Text(DateFormat('dd.MM.yyy', 'de').format(widget.appointment.creationDate)),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
