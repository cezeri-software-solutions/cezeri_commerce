import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../../2_application/database/incoming_invoice_detail/incoming_invoice_detail_bloc.dart';
import '../../../../../3_domain/entities/incoming_invoice/incoming_invoice_file.dart';
import '../../../../../3_domain/pdf/pdf_api_mobile.dart';
import '../../../../../3_domain/pdf/pdf_api_web.dart';
import '../../../../../4_infrastructur/repositories/database/functions/supabase_storage_functions.dart';
import '../../../../../constants.dart';
import '../../../../core/core.dart';
import '../../functions/functions.dart';
import '../../sheets/sheets.dart';

class IncomingInvoiceFilesView extends StatelessWidget {
  final IncomingInvoiceDetailBloc bloc;
  final List<IncomingInvoiceFile>? listOfIncomingInvoiceFiles;
  final double padding;

  const IncomingInvoiceFilesView({super.key, required this.bloc, required this.listOfIncomingInvoiceFiles, required this.padding});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final containerWidth = (screenWidth - padding * 2) - 20;
    final isMobile = ResponsiveBreakpoints.of(context).equals(MOBILE);

    return MyFormFieldContainer(
      padding: const EdgeInsets.all(10),
      borderRadius: 10,
      width: containerWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Dokumente Hochladen', style: TextStyles.defaultBoldPrimary),
                  IconButton(
                    onPressed: () async => incomingInvoicePickFiles(context, bloc),
                    icon: const Icon(Icons.add, color: Colors.green),
                  ),
                  if (!kIsWeb)
                    IconButton(
                      onPressed: () => incomingInvoiceScanFile(context, bloc),
                      icon: const Icon(Icons.document_scanner_rounded, color: CustomColors.primaryColor),
                    ),
                ],
              ),
              if (listOfIncomingInvoiceFiles != null && listOfIncomingInvoiceFiles!.isNotEmpty)
                SizedBox(
                  height: 110,
                  width: kIsWeb
                      ? containerWidth - 22 - 318
                      : isMobile
                          ? containerWidth - 2
                          : containerWidth - 22,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: listOfIncomingInvoiceFiles!.length,
                    itemBuilder: (context, index) {
                      final file = listOfIncomingInvoiceFiles![index];
                      return MaterialButton(
                        onPressed: () async {
                          if (file.fileBytes != null) {
                            kIsWeb
                                ? PdfApiWeb.openPdf(name: file.name, byteList: file.fileBytes!, showInBrowser: true)
                                : PdfApiMobile.openPdf(name: file.name, byteList: file.fileBytes!);
                          } else {
                            final loadedBytes = await downloadFileFromUrl(file.url);
                            if (loadedBytes == null) return;

                            kIsWeb
                                ? PdfApiWeb.openPdf(name: file.name, byteList: loadedBytes, showInBrowser: true)
                                : PdfApiMobile.openPdf(name: file.name, byteList: loadedBytes);
                          }
                        },
                        onLongPress: file.url.isEmpty ? () => showIncomingInvoiceUpdateFileNameSheet(context, file, index, bloc) : null,
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Gaps.h10,
                                Icon(
                                  file.url.isEmpty ? Icons.upload_file_rounded : Icons.file_open_rounded,
                                  color: CustomColors.primaryColor,
                                  size: 60,
                                ),
                                SizedBox(width: 90, child: Text(file.name, maxLines: 2, overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                onPressed: () => incomingInvoiceRemoveFile(context, bloc, file.name, index),
                                icon: const Icon(CupertinoIcons.clear_circled_solid, color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
          if (kIsWeb)
            MyDropzoneWeb(
              mime: const ['application/pdf'],
              getMyFiles: (myFiles) async => incomingInvoiceDropFiles(myFiles, bloc),
            ),
        ],
      ),
    );
  }
}
