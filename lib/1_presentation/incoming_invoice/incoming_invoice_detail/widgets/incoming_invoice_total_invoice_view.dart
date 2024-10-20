import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:flutter/material.dart';

import '../../../../2_application/database/incoming_invoice_detail/incoming_invoice_detail_bloc.dart';
import '../../../../3_domain/entities/incoming_invoice/incoming_invoice.dart';
import '../../../../constants.dart';

class IncomingInvoiceTotalInvoiceView extends StatelessWidget {
  final IncomingInvoiceDetailBloc bloc;
  final IncomingInvoice invoice;
  final double? containerWidth;

  const IncomingInvoiceTotalInvoiceView({super.key, required this.bloc, required this.invoice, this.containerWidth});

  @override
  Widget build(BuildContext context) {
    return MyFormFieldContainer(
      padding: const EdgeInsets.all(10),
      borderRadius: 10,
      width: containerWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Gesamtbeträge', style: TextStyles.defaultBoldPrimary),
          const Divider(),
          _TotalSumView(bloc: bloc, invoice: invoice),
        ],
      ),
    );
  }
}

class _TotalSumView extends StatefulWidget {
  final IncomingInvoiceDetailBloc bloc;
  final IncomingInvoice invoice;

  const _TotalSumView({required this.bloc, required this.invoice});

  @override
  State<_TotalSumView> createState() => _TotalSumViewState();
}

class _TotalSumViewState extends State<_TotalSumView> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Rabatt hinzufügen', style: TextStyles.defaultBold),
            IconButton(
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
              icon: Icon(_isExpanded ? Icons.remove : Icons.add, color: CustomColors.primaryColor),
            ),
          ],
        ),
        MyAnimatedExpansionContainer(
          isExpanded: _isExpanded,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Rabatt in %'),
                  Row(
                    children: [
                      const Icon(Icons.remove),
                      MyTextFormFieldSmall(
                        maxWidth: 100,
                        initialValue: widget.invoice.discountPercentage.toString(),
                        inputType: FieldInputType.double,
                        suffix: const Text('%'),
                        onChanged: (value) => widget.bloc.add(OnDiscountPercentageChangedEvent(value: value)),
                      ),
                    ],
                  ),
                ],
              ),
              Gaps.h8,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Rabatt in €'),
                  Row(
                    children: [
                      const Icon(Icons.remove),
                      MyTextFormFieldSmall(
                        maxWidth: 100,
                        initialValue: widget.invoice.discountAmount.toString(),
                        inputType: FieldInputType.double,
                        suffix: const Text('€'),
                        onChanged: (value) => widget.bloc.add(OnDiscountAmountChangedEvent(value: value)),
                      ),
                    ],
                  ),
                ],
              ),
              Gaps.h8,
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [const Text('Netto'), Text('${widget.invoice.totalInvoice.netAmount.toMyCurrencyStringToShow()} €')],
        ),
        Gaps.h8,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [const Text('MwSt.'), Text('${widget.invoice.totalInvoice.taxAmount.toMyCurrencyStringToShow()} €')],
        ),
        Gaps.h8,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [const Text('Brutto'), Text('${widget.invoice.totalInvoice.grossAmount.toMyCurrencyStringToShow()} €')],
        ),
      ],
    );
  }
}
