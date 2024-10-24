import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../2_application/database/incoming_invoice/incoming_invoice_bloc.dart';
import '../../../3_domain/entities/incoming_invoice/incoming_invoice.dart';
import '../../../constants.dart';
import '../../../routes/router.gr.dart';
import '../incoming_invoice_detail/incoming_invoice_detail_screen.dart';

class IncomingInvoicesOverviewPage extends StatelessWidget {
  final IncomingInvoiceBloc incomingInvoiceBloc;

  const IncomingInvoicesOverviewPage({super.key, required this.incomingInvoiceBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncomingInvoiceBloc, IncomingInvoiceState>(
      builder: (context, state) {
        if (state.isLoadingInvoicesOnObserve) return const Expanded(child: Center(child: CircularProgressIndicator()));
        if (state.abstractFailure != null) return const Expanded(child: Center(child: Text('Ein Fehler ist aufgetreten!')));
        if (state.listOfInvoices == null) return const Expanded(child: Center(child: CircularProgressIndicator()));
        if (state.listOfInvoices!.isEmpty) return const Expanded(child: Center(child: Text('Es konnten keine Eingangsrechnungen gefunden werden.')));

        return Expanded(
          child: Scrollbar(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: state.listOfInvoices!.length,
              separatorBuilder: (context, index) => const Divider(indent: 54, endIndent: 20, height: 0),
              itemBuilder: (context, index) {
                final invoice = state.listOfInvoices![index];
                if (ResponsiveBreakpoints.of(context).equals(MOBILE)) {
                  return _IncomingInvoiceTileMobile(
                    incomingInvoiceBloc: incomingInvoiceBloc,
                    selectedInvoices: state.selectedInvoices,
                    invoice: invoice,
                    currentPage: state.currentPage,
                  );
                }

                if (index == 0) {
                  return Column(
                    children: [
                      _IncomingInvoiceHeader(incomingInvoiceBloc: incomingInvoiceBloc, isAllInvoicesSelected: state.isAllInvoicesSelected),
                      _IncomingInvoiceTile(
                        incomingInvoiceBloc: incomingInvoiceBloc,
                        selectedInvoices: state.selectedInvoices,
                        invoice: invoice,
                        currentPage: state.currentPage,
                      ),
                    ],
                  );
                }

                return _IncomingInvoiceTile(
                  incomingInvoiceBloc: incomingInvoiceBloc,
                  selectedInvoices: state.selectedInvoices,
                  invoice: invoice,
                  currentPage: state.currentPage,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _IncomingInvoiceHeader extends StatelessWidget {
  final IncomingInvoiceBloc incomingInvoiceBloc;
  final bool isAllInvoicesSelected;

  const _IncomingInvoiceHeader({required this.incomingInvoiceBloc, required this.isAllInvoicesSelected});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerOrEqualTo(DESKTOP);

    return Row(
      children: [
        Checkbox.adaptive(
          value: isAllInvoicesSelected,
          onChanged: (value) => incomingInvoiceBloc.add(OnSelectAllInvoicesEvent(isSelected: value!)),
        ),
        const _CellTile(flex: RWIIO.incomingInvoiceNumber, child: Text('Eingangsr. Nr.', style: TextStyles.defaultBold, textAlign: TextAlign.center)),
        const _CellTile(flex: RWIIO.supplierNumber, child: Text('Lieferanten. Nr.', style: TextStyles.defaultBold, textAlign: TextAlign.center)),
        const _CellTile(flex: RWIIO.supplierName, child: Text('Lieferant', style: TextStyles.defaultBold)),
        const _CellTile(flex: RWIIO.invoiceNumber, child: Text('Rechnungs Nr.', style: TextStyles.defaultBold)),
        const _CellTile(flex: RWIIO.invoiceDate, child: Text('Re. Datum', style: TextStyles.defaultBold, textAlign: TextAlign.end)),
        const _CellTile(flex: RWIIO.bookingDate, child: Text('Buch. Datum', style: TextStyles.defaultBold, textAlign: TextAlign.end)),
        if (isDesktop) const _CellTile(flex: RWIIO.amount, child: Text('Nettobetrag', style: TextStyles.defaultBold, textAlign: TextAlign.end)),
        if (isDesktop) const _CellTile(flex: RWIIO.amount, child: Text('Steuer', style: TextStyles.defaultBold, textAlign: TextAlign.end)),
        const _CellTile(flex: RWIIO.amount, child: Text('Bruttobetrag', style: TextStyles.defaultBold, textAlign: TextAlign.end)),
        if (isDesktop) const _CellTile(flex: RWIIO.status, child: Text('Status', style: TextStyles.defaultBold, textAlign: TextAlign.center)),
        Gaps.w10,
      ],
    );
  }
}

class _IncomingInvoiceTile extends StatelessWidget {
  final IncomingInvoiceBloc incomingInvoiceBloc;
  final List<IncomingInvoice> selectedInvoices;
  final IncomingInvoice invoice;
  final int currentPage;

  const _IncomingInvoiceTile({
    required this.incomingInvoiceBloc,
    required this.selectedInvoices,
    required this.invoice,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerOrEqualTo(DESKTOP);

    return Row(
      children: [
        Checkbox.adaptive(
          value: selectedInvoices.any((e) => e.id == invoice.id),
          onChanged: (_) => incomingInvoiceBloc.add(OnSelectInvoiceEvent(invoice: invoice)),
        ),
        _CellTile(
            flex: RWIIO.incomingInvoiceNumber,
            child: TextButton(
                onPressed: () async {
                  await context.router.push(IncomingInvoiceDetailRoute(
                    type: IncomingInvoiceAddEditType.edit,
                    supplier: null,
                    incomingInvoiceId: invoice.id,
                  ));
                  incomingInvoiceBloc.add(GetIncomingInvoiceEvent(id: invoice.id));
                },
                onLongPress: () async {
                  await context.router.push(IncomingInvoiceDetailRoute(
                    type: IncomingInvoiceAddEditType.copy,
                    supplier: null,
                    incomingInvoiceId: invoice.id,
                  ));
                  incomingInvoiceBloc.add(GetIncomingInvoiceEvent(id: invoice.id));
                },
                child: Text(invoice.incomingInvoiceNumberAsString))),
        _CellTile(flex: RWIIO.supplierNumber, child: TextButton(onPressed: () {}, child: Text(invoice.supplier.supplierNumber.toString()))),
        _CellTile(
          flex: RWIIO.supplierName,
          child: Text(
            invoice.supplier.company.isNotEmpty ? invoice.supplier.company : invoice.supplier.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _CellTile(
          flex: RWIIO.invoiceNumber,
          child: Text(
            invoice.invoiceNumber.isNotEmpty ? invoice.invoiceNumber : 'FEHLT',
            style: invoice.invoiceNumber.isEmpty ? const TextStyle(fontWeight: FontWeight.bold, color: Colors.red) : null,
          ),
        ),
        _CellTile(flex: RWIIO.invoiceDate, child: Text(invoice.invoiceDate.toFormattedDayMonthYear(), textAlign: TextAlign.end)),
        _CellTile(
          flex: RWIIO.bookingDate,
          child: Text(
            invoice.bookingDate != null ? invoice.bookingDate!.toFormattedDayMonthYear() : 'FEHLT',
            style: invoice.bookingDate == null ? const TextStyle(fontWeight: FontWeight.bold, color: Colors.red) : null,
            textAlign: TextAlign.end,
          ),
        ),
        if (isDesktop)
          _CellTile(
            flex: RWIIO.amount,
            child: Text('${invoice.totalInvoice.netAmount.toMyCurrencyStringToShow()} €', textAlign: TextAlign.end),
          ),
        if (isDesktop)
          _CellTile(
            flex: RWIIO.amount,
            child: Text('${invoice.totalInvoice.taxAmount.toMyCurrencyStringToShow()} €', textAlign: TextAlign.end),
          ),
        _CellTile(flex: RWIIO.amount, child: Text('${invoice.totalInvoice.grossAmount.toMyCurrencyStringToShow()} €', textAlign: TextAlign.end)),
        if (isDesktop)
          _CellTile(
            flex: RWIIO.status,
            child: Container(
              height: 26,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(13), color: invoice.status.toColor(withAlpha: isDesktop)),
              child: Center(child: Text(invoice.status.convert())),
            ),
          ),
        isDesktop
            ? Gaps.w10
            : Container(
                width: 10,
                height: 26,
                decoration: BoxDecoration(
                  color: invoice.status.toColor(),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)),
                ),
              ),
      ],
    );
  }
}

class _CellTile extends StatelessWidget {
  final Widget child;
  final int flex;

  const _CellTile({required this.child, required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: flex, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: child));
  }
}

class _IncomingInvoiceTileMobile extends StatelessWidget {
  final IncomingInvoiceBloc incomingInvoiceBloc;
  final List<IncomingInvoice> selectedInvoices;
  final IncomingInvoice invoice;
  final int currentPage;

  const _IncomingInvoiceTileMobile({
    required this.incomingInvoiceBloc,
    required this.selectedInvoices,
    required this.invoice,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox.adaptive(
          value: selectedInvoices.any((e) => e.id == invoice.id),
          onChanged: (_) => incomingInvoiceBloc.add(OnSelectInvoiceEvent(invoice: invoice)),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () async {
                        await context.router.push(IncomingInvoiceDetailRoute(
                          type: IncomingInvoiceAddEditType.edit,
                          supplier: null,
                          incomingInvoiceId: invoice.id,
                        ));
                        incomingInvoiceBloc.add(GetIncomingInvoiceEvent(id: invoice.id));
                      },
                      onLongPress: () async {
                        await context.router.push(IncomingInvoiceDetailRoute(
                          type: IncomingInvoiceAddEditType.copy,
                          supplier: null,
                          incomingInvoiceId: invoice.id,
                        ));
                        incomingInvoiceBloc.add(GetIncomingInvoicesEvent(calcCount: true, currentPage: currentPage));
                      },
                      child: Text(invoice.incomingInvoiceNumberAsString),
                    ),
                    Column(
                      children: [
                        const Text('Buch. Datum', style: TextStyles.infoOnTextFieldSmall),
                        Text(invoice.bookingDate != null ? invoice.bookingDate!.toFormattedDayMonthYear() : '-'),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Rech. Nr.', style: TextStyles.infoOnTextFieldSmall),
                        Text(invoice.invoiceNumber, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Rech. Datum', style: TextStyles.infoOnTextFieldSmall),
                        Text(invoice.invoiceDate.toFormattedDayMonthYear()),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Text(
                  invoice.supplier.company.isNotEmpty ? invoice.supplier.company : invoice.supplier.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 10,
          height: 60,
          decoration: BoxDecoration(
            color: invoice.status.toColor(),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
          ),
        ),
      ],
    );
  }
}
