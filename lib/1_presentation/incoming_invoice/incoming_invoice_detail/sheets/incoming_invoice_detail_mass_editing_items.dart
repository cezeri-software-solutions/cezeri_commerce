import 'dart:async';
import 'dart:math';

import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../../2_application/database/incoming_invoice_detail/incoming_invoice_detail_bloc.dart';
import '../../../../constants.dart';
import '../functions/functions.dart';

Future<void> showIncomingInvoiceDetailMassEditingItemsSheet(BuildContext context, IncomingInvoiceDetailBloc bloc) async {
  const title = Padding(
    padding: EdgeInsets.only(left: 24, top: 20),
    child: Text('Massenbearbeitung', style: TextStyles.h2),
  );

  final closeButton = Padding(
    padding: const EdgeInsets.only(right: 8),
    child: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
  );

  WoltModalSheet.show<void>(
    context: context,
    enableDrag: false,
    useSafeArea: false,
    pageListBuilder: (context) => [
      WoltModalSheetPage(
        leadingNavBarWidget: title,
        trailingNavBarWidget: closeButton,
        child: _ItemsMassEditingSheet(bloc: bloc),
      ),
    ],
  );
}

class _ItemsMassEditingSheet extends StatefulWidget {
  final IncomingInvoiceDetailBloc bloc;

  const _ItemsMassEditingSheet({required this.bloc});

  @override
  State<_ItemsMassEditingSheet> createState() => _ItemsMassEditingSheetState();
}

class _ItemsMassEditingSheetState extends State<_ItemsMassEditingSheet> {
  String? _gLAccount;
  int? _taxRate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: max(MediaQuery.paddingOf(context).bottom, 16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyDropdownButtonSmall(
            value: _gLAccount ?? '',
            onChanged: (val) => setState(() => _gLAccount = val),
            fieldTitle: 'Sachkonto',
            cacheItems: false,
            loadItems: (filter, loadProps) async => await incomingInvoiceDetailLoadAccounts(filter),
          ),
          Gaps.h8,
          MyDropdownButtonSmall(
            value: _taxRate != null ? _taxRate.toString() : '',
            itemAsString: (val) => _taxRate != null ? 'Vorsteuer $val%' : '',
            onChanged: (val) => val != null ? setState(() => _taxRate = val.toMyInt()) : null,
            fieldTitle: 'Steuer',
            cacheItems: false,
            loadItems: (filter, loadProps) async => await incomingInvoiceDetailLoadTaxRates(),
            itemBuilder: (context, item, isSelected, isDisabled) {
              return ListTile(
                dense: true,
                title: Text('Vorsteuer $item%', style: isDisabled ? TextStyles.defaultBold : null),
                selected: isDisabled,
                visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
              );
            },
          ),
          Gaps.h32,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(child: const Text('Abbrechen'), onPressed: () => Navigator.of(context).pop()),
              Gaps.w16,
              FilledButton(
                onPressed: () {
                  widget.bloc.add(OnItemsMassEditingEvent(gLAccount: _gLAccount, taxRate: _taxRate));
                  Navigator.of(context).pop();
                },
                child: const Text('Übernehmen'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
