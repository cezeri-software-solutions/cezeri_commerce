import 'package:flutter/material.dart';

import '../../../../2_application/database/incoming_invoice_detail/incoming_invoice_detail_bloc.dart';
import '../../../core/core.dart';

void incomingInvoiceRemoveFile(BuildContext context, IncomingInvoiceDetailBloc bloc, String fileName, int index) async {
  await showMyDialogDelete(
    context: context,
    content: 'Bist du sicher, dass du "$fileName" löschen willst?',
    onConfirm: () {
      Navigator.of(context).pop();
      bloc.add(OnRemoveFileFromListEvent(index: index));
    },
  );
}
