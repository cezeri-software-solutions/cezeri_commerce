import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';

import '../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../../2_application/packing_station/packing_station_bloc.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/pdf/pdf_receipt_generator.dart';
import '../../../routes/router.gr.dart';
import '../../core/core.dart';
import 'packing_station_detail_page.dart';

@RoutePage()
class PackingStationDetailScreen extends StatelessWidget {
  final PackingStationBloc packingStationBloc;
  final AbstractMarketplace marketplace;

  const PackingStationDetailScreen({super.key, required this.packingStationBloc, required this.marketplace});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PackingStationBloc, PackingStationState>(
      bloc: packingStationBloc,
      listenWhen: (p, c) => p.fosOnGenerateAppointmentsOption != c.fosOnGenerateAppointmentsOption,
      listener: (context, state) {
        state.fosOnGenerateAppointmentsOption.fold(
          () => null,
          (a) => a.fold(
            (failure) async => await showMyDialogAlert(
              context: context,
              title: 'FEHLER',
              content: 'Beim generieren der Dokumente ist ein Fehler aufgetreten:\n\n$failure',
            ),
            (listOfReceipts) async {
              final myPrinterMain = context.read<MainSettingsBloc>().state.mainSettings!.printerMain;
              final myPrinterLabel = context.read<MainSettingsBloc>().state.mainSettings!.printerLabel;
              final printerMain = myPrinterMain != null ? Printer(url: myPrinterMain.url) : null;
              final printerLabel = myPrinterLabel != null ? Printer(url: myPrinterLabel.url) : null;

              final deliveryNote = listOfReceipts.where((e) => e.receiptTyp == ReceiptType.deliveryNote).firstOrNull;
              if (deliveryNote == null) {
                await showMyDialogAlert(context: context, title: 'FEHLER', content: 'Beim Erstellen der Lieferscheines ist ein Fehler aufgetreten');
                if (context.mounted) context.router.popUntilRouteWithName(PackingStationOverviewRoute.name);
              }
              final generatedPdf = await PdfReceiptGenerator.generate(
                receipt: deliveryNote!,
                logoUrl: marketplace.logoUrl,
              );

              if (printerMain != null) {
                await Printing.directPrintPdf(printer: printerMain, onLayout: (_) => generatedPdf);
              } else {
                await Printing.layoutPdf(onLayout: (_) => generatedPdf);
              }
              await Future.delayed(const Duration(milliseconds: 500));
              if (deliveryNote.listOfParcelTracking.isNotEmpty && deliveryNote.listOfParcelTracking.first.pdfString != '') {
                final pdfString = deliveryNote.listOfParcelTracking.first.pdfString;
                final pdfBytes = await loadFileFromStorage(pdfString);
                if (pdfBytes == null) return;
                if (printerLabel != null) {
                  await Printing.directPrintPdf(printer: printerLabel, onLayout: (_) => pdfBytes);
                } else {
                  await Printing.layoutPdf(onLayout: (_) => pdfBytes);
                }
              }
              if (context.mounted) context.router.popUntilRouteWithName(PackingStationOverviewRoute.name);
            },
          ),
        );
      },
      child: BlocBuilder<PackingStationBloc, PackingStationState>(
        bloc: packingStationBloc,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: state.appointment != null ? Text('Packtisch: ${state.appointment!.appointmentNumberAsString}') : const Text('Packtisch:'),
            ),
            body: SafeArea(child: PackingStationDetailPage(packingStationBloc: packingStationBloc, marketplace: marketplace)),
          );
        },
      ),
    );
  }
}
