import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../2_application/database/incoming_invoice_detail/incoming_invoice_detail_bloc.dart';
import '../../../../3_domain/entities/incoming_invoice/incoming_invoice_file.dart';
import '../../../../3_domain/entities/my_file.dart';
import '../../../../constants.dart';

Future<void> incomingInvoicePickFiles(BuildContext context, IncomingInvoiceDetailBloc bloc) async {
  try {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) return;

    final List<IncomingInvoiceFile> listOfFiles = [];

    for (final file in result.files) {
      final myFile = await convertPlatfomFileToMyFile(file);

      final iiFile = IncomingInvoiceFile(
        id: '',
        sortId: 0,
        name: myFile.name,
        url: '',
        fileBytes: myFile.fileBytes,
        mimeType: myFile.mimeType,
      );

      listOfFiles.add(iiFile);
    }

    bloc.add(OnAddFilesToListEvent(listOfFiles: listOfFiles));
  } on PlatformException {
    logger.e('Fehler beim Laden des Dokumentes');
  }
}

Future<void> incomingInvoiceDropFiles(List<MyFile> myFiles, IncomingInvoiceDetailBloc bloc) async {
  final List<IncomingInvoiceFile> listOfFiles = [];

  for (final myFile in myFiles) {
    final iiFile = IncomingInvoiceFile(
      id: '',
      sortId: 0,
      name: myFile.name,
      url: '',
      fileBytes: myFile.fileBytes,
      mimeType: myFile.mimeType,
    );

    listOfFiles.add(iiFile);
  }

  bloc.add(OnAddFilesToListEvent(listOfFiles: listOfFiles));
}
