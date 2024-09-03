import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';

import '../../../2_application/database/pos/pos_bloc.dart';
import '../../../3_domain/entities/customer/customer.dart';
import '../../../3_domain/entities/marketplace/marketplace_shop.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/pdf/pdf_receipt_generator.dart';
import '../../../constants.dart';
import '../../../injection.dart';
import '../../../routes/router.gr.dart';
import '../../core/core.dart';
import 'pos_detail_page.dart';

@RoutePage()
class PosDetailScreen extends StatefulWidget {
  final MarketplaceShop marketplace;
  final Customer customer;

  const PosDetailScreen({super.key, required this.marketplace, required this.customer});

  @override
  State<PosDetailScreen> createState() => _PosDetailScreenState();
}

class _PosDetailScreenState extends State<PosDetailScreen> with AutomaticKeepAliveClientMixin {
  final posBloc = sl<PosBloc>();

  @override
  initState() {
    super.initState();

    posBloc.add(SetPosStatesOnLoadEvent(marketplace: widget.marketplace, customer: widget.customer));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
        value: posBloc,
        child: MultiBlocListener(listeners: [
          BlocListener<PosBloc, PosState>(
            listenWhen: (p, c) => p.fosPosOnCreateOption != c.fosPosOnCreateOption,
            listener: (context, state) {
              state.fosPosOnCreateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => null,
                  (receipts) async {
                    if (mounted) context.router.popUntilRouteWithName(PosDetailRoute.name);

                    showCreatedReceiptsDialog(receipts);

                    if (state.printInvoice) {
                      final printerMain = state.mainSettings?.printerMain != null ? Printer(url: state.mainSettings!.printerMain!.url) : null;
                      final invoice = receipts.where((e) => e.receiptTyp == ReceiptType.invoice).firstOrNull;

                      if (invoice != null) {
                        final generatedPdf = await PdfReceiptGenerator.generate(receipt: invoice, logoUrl: state.marketplace!.logoUrl);

                        if (printerMain != null) {
                          try {
                            await Printing.directPrintPdf(printer: printerMain, onLayout: (_) => generatedPdf);
                          } catch (_) {
                            await Printing.layoutPdf(onLayout: (_) => generatedPdf);
                          }
                        } else {
                          await Printing.layoutPdf(onLayout: (_) => generatedPdf);
                        }
                      }
                    }

                    final customer = state.customer!;

                    posBloc.add(SetPosStateInitialEvent());
                    posBloc.add(SetPosStatesOnLoadEvent(marketplace: widget.marketplace, customer: customer));
                  },
                ),
              );
            },
          ),
        ], child: PosDetailPage(posBloc: posBloc)));
  }

  void showCreatedReceiptsDialog(List<Receipt> receipts) {
    showDialog(
      context: context,
      builder: (context) {
        final appointment = receipts.where((e) => e.receiptTyp == ReceiptType.appointment).firstOrNull;
        final deliveryNote = receipts.where((e) => e.receiptTyp == ReceiptType.deliveryNote).firstOrNull;
        final invoice = receipts.where((e) => e.receiptTyp == ReceiptType.invoice).firstOrNull;

        return AlertDialog(
          icon: const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
          title: const Text('Folgende Belege wurden erfolgreich erstellt'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gaps.h10,
              if (appointment != null) ...[Text(appointment.appointmentNumberAsString, style: TextStyles.h3Bold), Gaps.h10],
              if (deliveryNote != null) ...[Text(deliveryNote.deliveryNoteNumberAsString, style: TextStyles.h3Bold), Gaps.h10],
              if (invoice != null) Text(invoice.invoiceNumberAsString, style: TextStyles.h3Bold),
              Gaps.h42,
              SizedBox(width: 150, child: MyElevatedButton(buttonText: 'OK', onPressed: () => context.maybePop()))
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
