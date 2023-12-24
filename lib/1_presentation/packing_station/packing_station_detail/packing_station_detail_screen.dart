import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';

import '../../../2_application/packing_station/packing_station_bloc.dart';
import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/pdf/pdf_receipt_generator.dart';
import '../../../routes/router.gr.dart';
import '../../core/functions/dialogs.dart';
import 'packing_station_detail_page.dart';

@RoutePage()
class PackingStationDetailScreen extends StatelessWidget {
  final PackingStationBloc packingStationBloc;
  final Marketplace marketplace;

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
              final deliveryNote = listOfReceipts.where((e) => e.receiptTyp == ReceiptTyp.deliveryNote).firstOrNull;
              if (deliveryNote == null) {
                await showMyDialogAlert(context: context, title: 'FEHLER', content: 'Beim Erstellen der Lieferscheines ist ein Fehler aufgetreten');
                if (context.mounted) context.router.popUntilRouteWithName(PackingStationOverviewRoute.name);
              }
              final generatedPdf = await PdfReceiptGenerator.generate(
                receipt: deliveryNote!,
                logoUrl: marketplace.logoUrl,
              );
              await Printing.layoutPdf(onLayout: (_) => generatedPdf);
              await Future.delayed(const Duration(milliseconds: 500));
              if (deliveryNote.listOfParcelTracking.isNotEmpty && deliveryNote.listOfParcelTracking.first.pdfString != '') {
                final pdfString = deliveryNote.listOfParcelTracking.first.pdfString;
                final pdfBytes = base64.decode(pdfString);
                await Printing.layoutPdf(onLayout: (_) => pdfBytes);
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
