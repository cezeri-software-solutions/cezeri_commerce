import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

import '../../../../2_application/database/incoming_invoice_detail/incoming_invoice_detail_bloc.dart';
import '../../../../3_domain/entities/incoming_invoice/incoming_invoice_file.dart';
import '../../../core/core.dart';

void incomingInvoiceScanFile(BuildContext context, IncomingInvoiceDetailBloc bloc) async {
  Navigator.push<void>(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => MyDocumentScannerBasic(
        onSave: (imageBytes) async {
          final pdfBytes = await convertImageToPdf(imageBytes);

          final mime = lookupMimeType('', headerBytes: pdfBytes);

          final iiFile = IncomingInvoiceFile(
            id: '',
            sortId: 0,
            name: 'Gescanntes Dokument ${generateRandomString(4)}.pdf',
            url: '',
            fileBytes: pdfBytes,
            mimeType: mime,
          );

          bloc.add(OnAddFilesToListEvent(listOfFiles: [iiFile]));
        },
      ),
    ),
  );
}
