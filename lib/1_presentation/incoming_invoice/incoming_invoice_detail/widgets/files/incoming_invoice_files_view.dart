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
    final screenWidth = context.screenWidth;
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

                      return _FileTile(bloc: bloc, file: file, index: index);
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

class _FileTile extends StatefulWidget {
  final IncomingInvoiceDetailBloc bloc;
  final IncomingInvoiceFile file;
  final int index;

  const _FileTile({required this.bloc, required this.file, required this.index});

  @override
  State<_FileTile> createState() => __FileTileState();
}

class __FileTileState extends State<_FileTile> {
  bool _isLoadingFile = false;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        setState(() => _isLoadingFile = true);
        await Future.delayed(const Duration(seconds: 3));
        if (widget.file.fileBytes != null) {
          kIsWeb
              ? PdfApiWeb.openPdf(name: widget.file.name, byteList: widget.file.fileBytes!, showInBrowser: true)
              : PdfApiMobile.openPdf(name: widget.file.name, byteList: widget.file.fileBytes!);
        } else {
          final loadedBytes = await downloadFileFromUrl(widget.file.url);
          if (loadedBytes == null) return;

          kIsWeb
              ? PdfApiWeb.openPdf(name: widget.file.name, byteList: loadedBytes, showInBrowser: true)
              : PdfApiMobile.openPdf(name: widget.file.name, byteList: loadedBytes);
        }
        setState(() => _isLoadingFile = false);
      },
      onLongPress: widget.file.url.isEmpty ? () => showIncomingInvoiceUpdateFileNameSheet(context, widget.file, widget.index, widget.bloc) : null,
      child: Stack(
        children: [
          Column(
            children: [
              Gaps.h10,
              Icon(
                widget.file.url.isEmpty ? Icons.upload_file_rounded : Icons.file_open_rounded,
                color: CustomColors.primaryColor,
                size: 60,
              ),
              SizedBox(width: 90, child: Text(widget.file.name, maxLines: 2, overflow: TextOverflow.ellipsis)),
            ],
          ),
          Positioned(
            right: 0,
            child: IconButton(
              onPressed: () => incomingInvoiceRemoveFile(context, widget.bloc, widget.file.name, widget.index),
              icon: const Icon(CupertinoIcons.clear_circled_solid, color: Colors.red),
            ),
          ),
          if (_isLoadingFile)
            Positioned(
              top: 30,
              left: 30,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(6)),
                child: const MyCircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
