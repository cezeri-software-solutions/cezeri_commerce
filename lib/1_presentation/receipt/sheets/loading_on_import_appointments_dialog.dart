import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/receipt/receipt_bloc.dart';
import '../../../constants.dart';

class LoadingOnImportAppointmentsDialog extends StatelessWidget {
  final ReceiptBloc receiptBloc;

  const LoadingOnImportAppointmentsDialog({super.key, required this.receiptBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptBloc, ReceiptState>(
      bloc: receiptBloc,
      builder: (context, state) {
        return Dialog(
          child: SizedBox(
            width: 250,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  Gaps.h24,
                  Text('${state.loadedAppointments} / ${state.numberOfToLoadAppointments}', style: TextStyles.h2Bold),
                  Gaps.h24,
                  Text(state.loadingText, textAlign: TextAlign.center, style: TextStyles.h3),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
