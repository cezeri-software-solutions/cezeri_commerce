import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/3_domain/repositories/database/marketplace_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../2_application/database/receipt/receipt_bloc.dart';
import '../../../3_domain/entities/address.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/receipt/receipt_customer.dart';
import '../../../3_domain/entities/receipt/receipt_product.dart';
import '../../../3_domain/pdf/pdf_api_mobile.dart';
import '../../../3_domain/pdf/pdf_api_web.dart';
import '../../../3_domain/pdf/pdf_outgoing_invoices_generator.dart';
import '../../../3_domain/repositories/database/receipt_repository.dart';
import '../../../constants.dart';
import '../../../routes/router.gr.dart';
import '../../core/core.dart';
import '../functions/pop_until_receipts_overview.dart';
import '../sheets/loading_on_import_appointments_dialog.dart';

void showReceiptsOverviewOptions({
  required BuildContext context,
  required ReceiptBloc receiptBloc,
  required ReceiptType receiptType,
  required List<Receipt> listOfselectedReceipts,
  required List<AbstractMarketplace> listOfMarketplaces,
}) {
  WoltModalSheet.show(
    context: context,
    useSafeArea: false,
    showDragHandle: false,
    pageListBuilder: (woltContext) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: false,
          isTopBarLayerAlwaysVisible: false,
          child: ReceiptsOverviewOptionsSheet(
            receiptBloc: receiptBloc,
            receipts: listOfselectedReceipts,
            receiptType: receiptType,
            marketplaces: listOfMarketplaces,
          ),
        ),
      ];
    },
  );
}

class ReceiptsOverviewOptionsSheet extends StatelessWidget {
  final ReceiptBloc receiptBloc;
  final List<Receipt> receipts;
  final ReceiptType receiptType;
  final List<AbstractMarketplace> marketplaces;

  const ReceiptsOverviewOptionsSheet({
    super.key,
    required this.receiptBloc,
    required this.receipts,
    required this.receiptType,
    required this.marketplaces,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = receipts.isNotEmpty;

    return BlocBuilder<ReceiptBloc, ReceiptState>(
      bloc: receiptBloc,
      builder: (context, state) {
        if (state.isLoadingReceiptOnDelete) {
          return Padding(
            padding: EdgeInsets.only(top: 24, bottom: max(MediaQuery.paddingOf(context).bottom, 16) + 24),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100, width: 100, child: CircularProgressIndicator(strokeWidth: 10)),
                Gaps.h24,
                Text('Die ausgewählten Belege werden gelöscht...', style: TextStyles.h3Bold),
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.only(top: 16, bottom: max(MediaQuery.paddingOf(context).bottom, 16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.add, color: Colors.green),
                title: Text(_getAddTitle()),
                onTap: () => _onCreateNewReceiptPressed(context),
              ),
              ListTile(
                leading: Icon(Icons.send, color: isActive ? CustomColors.primaryColor : Colors.grey),
                title: Text(_getSendTitle(), style: TextStyle(color: isActive ? null : Colors.grey)),
                onTap: isActive ? () => onSendPressed(context, receiptBloc, receiptType, receipts) : null,
              ),
              if (receiptType == ReceiptType.appointment) ...[
                ListTile(
                  leading: const Icon(Icons.download, color: CustomColors.primaryColor),
                  title: const Text('Aufträge importieren'),
                  onTap: () => onGetAppointments(context, receiptBloc),
                ),
                ListTile(
                  leading: const Icon(Icons.downloading, color: CustomColors.primaryColor),
                  title: const Text('Einzelnen Auftrag importieren'),
                  onTap: marketplaces.isNotEmpty ? () => onGetAppointmentByIdPressed(context, receiptBloc, marketplaces) : null,
                ),
              ],
              ListTile(
                leading: const Icon(Icons.table_chart_rounded, color: CustomColors.primaryColor),
                title: const Text('PDF-Tabelle erstellen'),
                onTap: () => _onGeneratePdfTable(context, receipts),
              ),
              ListTile(
                leading: Icon(Icons.delete, color: isActive ? Colors.red : Colors.grey),
                title: Text('Ausgewählte Belege löschen', style: TextStyle(color: isActive ? null : Colors.grey)),
                onTap: isActive ? () => onRemovePressed(context, receiptBloc, receipts, receiptType) : null,
              ),
            ],
          ),
        );
      },
    );
  }

  String _getAddTitle() => switch (receiptType) {
        ReceiptType.offer => 'Neues Angebot',
        ReceiptType.appointment => 'Neuer Auftrag',
        ReceiptType.deliveryNote => 'Neuer Lieferschein',
        ReceiptType.invoice => 'Neue Rechnung',
        ReceiptType.credit => 'Neue Gutschrift',
      };

  String _getSendTitle() {
    final typeName = switch (receiptType) {
      ReceiptType.offer => receipts.length > 1 ? 'Ausgewählte Angebote' : 'Ausgewähltes Angebot',
      ReceiptType.appointment => receipts.length > 1 ? 'Ausgewählte Aufträge' : 'Ausgewählten Auftrag',
      ReceiptType.deliveryNote => receipts.length > 1 ? 'Ausgewählte Lieferscheine' : 'Ausgewählten Lieferschein',
      ReceiptType.invoice => receipts.length > 1 ? 'Ausgewählte Rechnungen' : 'Ausgewählte Rechnung',
      ReceiptType.credit => '',
    };

    return '$typeName umwandeln zu ...';
  }

  void _onCreateNewReceiptPressed(BuildContext context) async {
    final selectedCustomer = await showSelectCustomerSheet(context);
    if (selectedCustomer == null) return;

    final newReceipt = Receipt.empty().copyWith(
      customerId: selectedCustomer.id,
      receiptCustomer: ReceiptCustomer.fromCustomer(selectedCustomer),
      addressInvoice: getDefaultAddress(selectedCustomer.listOfAddress, AddressType.invoice),
      addressDelivery: getDefaultAddress(selectedCustomer.listOfAddress, AddressType.delivery),
      tax: selectedCustomer.tax,
      listOfReceiptProduct: [ReceiptProduct.empty()],
      receiptTyp: receiptType,
    );
    receiptBloc.add(SetReceiptEvent(appointment: newReceipt));

    if (context.mounted) {
      context.router.push(ReceiptDetailRoute(receiptId: null, newEmptyReceipt: newReceipt, receiptTyp: receiptType));
      popUntilBase(context, receiptType);
    }
  }

  Future<void> _onGeneratePdfTable(BuildContext context, List<Receipt> listOfSelectedReceipts) async {
    final now = DateTime.now();
    List<Receipt> listOfReceiptsToShow = [];
    DateTimeRange? dateRange;

    void doPop() {
      switch (receiptType) {
        case ReceiptType.offer:
          context.router.popUntilRouteWithName(OffersOverviewRoute.name);
        case ReceiptType.appointment:
          context.router.popUntilRouteWithName(AppointmentsOverviewRoute.name);
        case ReceiptType.deliveryNote:
          context.router.popUntilRouteWithName(DeliveryNotesOverviewRoute.name);
        case ReceiptType.invoice || ReceiptType.credit:
          context.router.popUntilRouteWithName(InvoicesOverviewRoute.name);
      }
    }

    if (listOfSelectedReceipts.isEmpty) {
      dateRange = await showDateRangePicker(context: context, firstDate: DateTime(now.year - 2), lastDate: now);
      if (dateRange == null) return;

      if (context.mounted) showMyDialogLoading(context: context, text: 'PDF wird erstellt...');

      final receiptRepository = GetIt.I<ReceiptRepository>();
      final fosLoadedReceipts = await receiptRepository.getListOfReceiptsBetweenDates(dates: dateRange, receiptType: receiptType);
      if (fosLoadedReceipts.isLeft()) {
        if (context.mounted) {
          await showMyDialogAlert(context: context, title: 'Achtung', content: 'Beim Laden der Dokumente ist ein Fehler aufgetreten');
        }
        doPop();
        return;
      }

      listOfReceiptsToShow = fosLoadedReceipts.getRight();
    } else {
      listOfReceiptsToShow = listOfSelectedReceipts;
    }

    if (listOfReceiptsToShow.isEmpty) {
      if (context.mounted) {
        await showMyDialogAlert(context: context, title: 'Achtung', content: 'Es gibt keine Dokumente zum anzeigen im ausgewählten Datumsbereich');
        doPop();
        return;
      }
    }

    List<AbstractMarketplace>? listOfMarketplaces;
    final marketplaceRepository = GetIt.I<MarketplaceRepository>();
    final fosLoadedMarketplaces = await marketplaceRepository.getListOfMarketplaces();
    if (fosLoadedMarketplaces.isRight()) listOfMarketplaces = fosLoadedMarketplaces.getRight();

    final generatedPdf = await PdfOutgoingInvoicesGenerator.generate(
      listOfReceipts: listOfReceiptsToShow,
      listOfMarketplaces: listOfMarketplaces,
      dateRange: dateRange,
    );

    doPop();

    final documentType = switch (listOfReceiptsToShow.first.receiptTyp) {
      ReceiptType.offer => 'Angebote',
      ReceiptType.appointment => 'Aufträge',
      ReceiptType.deliveryNote => 'Lieferscheine',
      ReceiptType.invoice || ReceiptType.credit => 'Rechnungen',
    };
    final title = dateRange != null
        ? '$documentType ${dateRange.start.year}-${dateRange.start.month}-${dateRange.start.day} - ${dateRange.end.year}-${dateRange.end.month}-${dateRange.end.day}.pdf'
        : '$documentType.pdf';

    if (kIsWeb) {
      await PdfApiWeb.saveDocument(name: title, byteList: generatedPdf, showInBrowser: true);
    } else {
      await PdfApiMobile.saveDocument(name: title, byteList: generatedPdf);
    }
  }
}

void onRemovePressed(BuildContext context, ReceiptBloc receiptBloc, List<Receipt> selectedReceipts, ReceiptType receiptType) {
  showMyDialogDelete(
    context: context,
    content: 'Bist du sicher, dass du alle ausgewählten ${switch (receiptType) {
      ReceiptType.offer => 'Angebote',
      ReceiptType.appointment => 'Aufträge',
      ReceiptType.deliveryNote => 'Lieferscheine',
      ReceiptType.invoice || ReceiptType.credit => 'Rechnungen',
    }} unwiederruflich löschen willst?',
    onConfirm: () {
      receiptBloc.add(DeleteSelectedReceiptsEvent(selectedReceipts: selectedReceipts));
      context.router.maybePop();
    },
  );
}

void onGetAppointments(BuildContext context, ReceiptBloc receiptBloc) {
  Navigator.of(context).pop();
  receiptBloc.add(GetNewAppointmentsFromMarketplacesEvent());
  showDialog(
    context: context,
    builder: (context) => BlocProvider.value(
      value: receiptBloc,
      child: LoadingOnImportAppointmentsDialog(receiptBloc: receiptBloc),
    ),
  );
}

void onGetAppointmentByIdPressed(BuildContext context, ReceiptBloc receiptBloc, List<AbstractMarketplace> listOfMarketplaces) {
  WoltModalSheet.show(
    context: context,
    useSafeArea: false,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: true,
          isTopBarLayerAlwaysVisible: true,
          topBarTitle: const Text('Einzelimport Aufträge', style: TextStyles.h3Bold),
          child: _SelectToLoadAppointmentFromMarketplaceSheet(receiptBloc: receiptBloc, listOfMarketplaces: listOfMarketplaces),
        ),
      ];
    },
  );
}

void onSendPressed(BuildContext context, ReceiptBloc receiptBloc, ReceiptType receiptType, List<Receipt> selectedReceipts) {
  String getErrorMessageOnGenerateFromDeliveryNotesNewInvoice(List<Receipt> selectedReceipts) {
    if (selectedReceipts.isEmpty) return 'Du musst mindestens ein Lieferschein auswählen, zum generieren einer Sammelrechnung';
    if (selectedReceipts.any((e) => e.receiptCustomer.id != selectedReceipts.first.receiptCustomer.id)) {
      return 'Alle Lieferscheine die zu einer Sammelrechnung generiert werden sollen, müssen vom selben Kunden sein.';
    }
    return 'Ein Fehler ist aufgetreten';
  }

  showDialog(
    context: context,
    builder: (context) {
      switch (receiptType) {
        case ReceiptType.offer:
          return _GenerateFromReceiptDialog(receiptBloc: receiptBloc, listOfReceipts: selectedReceipts, receiptType: receiptType);
        case ReceiptType.appointment:
          return _GenerateFromReceiptDialog(receiptBloc: receiptBloc, listOfReceipts: selectedReceipts, receiptType: receiptType);
        case ReceiptType.deliveryNote:
          return selectedReceipts.any((e) => e.receiptCustomer.id != selectedReceipts.first.receiptCustomer.id)
              ? _ReceiptsAlertDialog(
                  title: 'Achtug',
                  content: getErrorMessageOnGenerateFromDeliveryNotesNewInvoice(selectedReceipts),
                )
              : _GenerateFromReceiptDialog(receiptBloc: receiptBloc, listOfReceipts: selectedReceipts, receiptType: receiptType);
        case ReceiptType.invoice || ReceiptType.credit:
          {
            if (selectedReceipts.any((e) => e.receiptTyp == ReceiptType.credit)) {
              return const _ReceiptsAlertDialog(
                title: 'Achtug',
                content: 'Aus einer Gutschrift kann kein weiteres Dokument generiert werden.',
              );
            }
            return selectedReceipts.length > 1
                ? const _ReceiptsAlertDialog(
                    title: 'Achtug',
                    content: 'Du darfst maximal eine Rechnung auswählen, zum generieren einer Gutschrift',
                  )
                : _GenerateFromReceiptDialog(receiptBloc: receiptBloc, listOfReceipts: selectedReceipts, receiptType: receiptType);
          }
      }
    },
  );
}

class _SelectToLoadAppointmentFromMarketplaceSheet extends StatefulWidget {
  final ReceiptBloc receiptBloc;
  final List<AbstractMarketplace> listOfMarketplaces;

  const _SelectToLoadAppointmentFromMarketplaceSheet({required this.receiptBloc, required this.listOfMarketplaces});

  @override
  State<_SelectToLoadAppointmentFromMarketplaceSheet> createState() => _SelectToLoadAppointmentFromMarketplaceSheetState();
}

class _SelectToLoadAppointmentFromMarketplaceSheetState extends State<_SelectToLoadAppointmentFromMarketplaceSheet> {
  List<AbstractMarketplace> listOfMarketplaces = [];
  AbstractMarketplace selectedMarketplace = AbstractMarketplace.empty();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    listOfMarketplaces = widget.listOfMarketplaces..insert(0, AbstractMarketplace.empty());
  }

  @override
  Widget build(BuildContext context) {
    final items = listOfMarketplaces.map((e) => e.name).toList();

    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: max(MediaQuery.paddingOf(context).bottom, 16)),
      child: Column(
        children: [
          MyDropdownButtonSmall(
            labelText: 'Marktplatz wählen',
            value: selectedMarketplace.name,
            onChanged: (marketplaceName) => setState(() => selectedMarketplace = listOfMarketplaces.where((e) => e.name == marketplaceName!).first),
            items: items,
          ),
          Gaps.h24,
          MyTextFormFieldSmall(
            labelText: 'ID aus Marktplatz',
            controller: _controller,
            keyboardType: TextInputType.number,
          ),
          Gaps.h24,
          MyOutlinedButton(
            buttonText: 'Bestellung Laden',
            onPressed: () {
              context.router.maybePopTop();
              widget.receiptBloc.add(GetNewAppointmentByIdFromPrestaEvent(id: _controller.text.toMyInt(), marketplace: selectedMarketplace));
              showDialog(context: context, builder: (context) => LoadingOnImportAppointmentsDialog(receiptBloc: widget.receiptBloc));
            },
          ),
        ],
      ),
    );
  }
}

class _GenerateFromReceiptDialog extends StatefulWidget {
  final ReceiptBloc receiptBloc;
  final List<Receipt> listOfReceipts;
  final ReceiptType receiptType;

  const _GenerateFromReceiptDialog({required this.receiptBloc, required this.listOfReceipts, required this.receiptType});

  @override
  State<_GenerateFromReceiptDialog> createState() => _GenerateFromReceiptDialogState();
}

class _GenerateFromReceiptDialogState extends State<_GenerateFromReceiptDialog> {
  bool _generateFirst = true;
  bool _printFirst = false;
  bool _generateSecond = true;
  bool _printSecond = false;
  bool _setQuantityOnCreateCredit = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptBloc, ReceiptState>(
      bloc: widget.receiptBloc,
      builder: (context, state) {
        return Dialog(
          child: SizedBox(
            width: 600,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Versenden', style: TextStyles.h1),
                  const Divider(),
                  Gaps.h24,
                  Text('Ausgewählte Belege: ${widget.listOfReceipts.length}', style: TextStyles.h3BoldPrimary),
                  if (widget.receiptType == ReceiptType.appointment) ...[
                    Gaps.h42,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 150, child: Text('Lieferschein:', style: TextStyles.h3Bold)),
                        Column(
                          children: [
                            const Text('Erstellen'),
                            Switch.adaptive(value: _generateFirst, onChanged: (value) => setState(() => _generateFirst = value)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Drucken'),
                            Switch.adaptive(value: _printFirst, onChanged: (value) => setState(() => _printFirst = value)),
                          ],
                        ),
                      ],
                    ),
                    Gaps.h42,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 150, child: Text('Rechnung:', style: TextStyles.h3Bold)),
                        Column(
                          children: [
                            const Text('Erstellen'),
                            Switch.adaptive(value: _generateSecond, onChanged: (value) => setState(() => _generateSecond = value)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Drucken'),
                            Switch.adaptive(value: _printSecond, onChanged: (value) => setState(() => _printSecond = value)),
                          ],
                        ),
                      ],
                    ),
                  ],
                  Gaps.h42,
                  Text(_getInfoText(), style: TextStyles.h3Bold),
                  if (widget.receiptType == ReceiptType.invoice) ...[
                    Gaps.h24,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Artikelbestände anpassen?'),
                        Switch.adaptive(value: _setQuantityOnCreateCredit, onChanged: (value) => setState(() => _setQuantityOnCreateCredit = value)),
                      ],
                    ),
                  ],
                  Gaps.h54,
                  Align(
                    alignment: Alignment.centerRight,
                    child: MyOutlinedButton(
                      buttonText: 'Anlegen',
                      buttonBackgroundColor: Colors.green,
                      isLoading: state.isLoadingReceiptOnGenerate,
                      onPressed: _onCreatePressed,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getInfoText() => switch (widget.receiptType) {
        ReceiptType.offer => 'Generiert Aufträge aus den ausgewählten Angeboten.',
        ReceiptType.appointment => 'Generiert Lieferscheine und/oder Rechnungen aus den ausgewählten Aufträgen.',
        ReceiptType.deliveryNote => 'Generiert eine Sammelrechnung aus den ausgewählten Lieferscheinen.',
        ReceiptType.invoice => 'Generiert eine Gutschrift aus der ausgewählten Rechnung.',
        _ => 'Ein Fehler ist aufgetreten.',
      };

  void _onCreatePressed() {
    switch (widget.receiptType) {
      case ReceiptType.offer:
        widget.receiptBloc.add(OnGenerateFromOfferNewAppointmentEvent());
      case ReceiptType.appointment:
        widget.receiptBloc.add(OnGenerateFromAppointmentEvent(generateDeliveryNote: _generateFirst, generateInvoice: _generateSecond));
      case ReceiptType.deliveryNote:
        widget.receiptBloc.add(OnGenerateFromDeliveryNotesNewInvoiceEvent());
      case ReceiptType.invoice:
        widget.receiptBloc.add(OnGenerateFromInvoiceNewCreditEvent(setQuantity: _setQuantityOnCreateCredit));
      default:
    }
  }
}

class _ReceiptsAlertDialog extends StatelessWidget {
  final String title;
  final String content;

  const _ReceiptsAlertDialog({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: TextStyles.h1),
              Gaps.h16,
              Text(content, style: TextStyles.h3, textAlign: TextAlign.center),
              Gaps.h32,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [MyOutlinedButton(buttonText: 'OK', onPressed: () => context.router.maybePop())],
              )
            ],
          ),
        ),
      ),
    );
  }
}
