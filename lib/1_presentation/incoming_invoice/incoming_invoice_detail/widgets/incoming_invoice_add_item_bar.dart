import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../2_application/database/incoming_invoice_detail/incoming_invoice_detail_bloc.dart';
import '../../../../3_domain/entities/incoming_invoice/incoming_invoice_item.dart';
import '../../../core/core.dart';
import '../sheets/sheets.dart';

class IncomingInvoiceAddItemBar extends StatelessWidget {
  final IncomingInvoiceDetailBloc bloc;
  final String supplierId;
  final double padding;

  const IncomingInvoiceAddItemBar({super.key, required this.bloc, required this.supplierId, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => showIncomingInvoiceDetailMassEditingItems(context, bloc),
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
              icon: const Icon(Icons.edit_note_rounded, color: Colors.green),
              label: const Text('Auf alle anwenden'),
            ),
            SizedBox(width: padding),
            ElevatedButton.icon(
              onPressed: () {
                showMyDialogDelete(
                  context: context,
                  content: 'Bist du sicher, dass du alle Positionen löschen willst?',
                  onConfirm: () {
                    bloc.add(OnRemoveAllItemsFromListEvent());
                    Navigator.of(context).pop();
                  },
                );
              },
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
              icon: const Icon(CupertinoIcons.delete, color: Colors.red),
              label: const Text('Alle löschen'),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _AddItemButtom(
              onPressed: () => bloc.add(OnAddNewItemToListEvent(itemType: ItemType.account)),
              title: 'Konto',
            ),
            SizedBox(width: padding),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                offset: const Offset(40, 48),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: const Text('Versandkosten'),
                      onTap: () => bloc.add(OnAddNewItemToListEvent(itemType: ItemType.shipping)),
                    ),
                    PopupMenuItem(
                      child: const Text('Rabatt'),
                      onTap: () => bloc.add(OnAddNewItemToListEvent(itemType: ItemType.discount)),
                    ),
                    PopupMenuItem(
                      child: const Text('Zuschlag'),
                      onTap: () => bloc.add(OnAddNewItemToListEvent(itemType: ItemType.otherSurcharge)),
                    ),
                  ];
                },
              ),
            ),
            SizedBox(width: padding),
            _AddItemButtom(
              onPressed: () => bloc.add(OnAddNewItemToListEvent(itemType: ItemType.position)),
              title: 'Artikel',
            ),
            SizedBox(width: padding),
            _AddItemButtom(
              onPressed: () async {
                final selectedReorder = await showSelectReorderBySupplierIdSheet(context, supplierId);
                if (selectedReorder == null) return;

                bloc.add(OnAddNewItemsFromReorderEvent(reorder: selectedReorder));
              },
              title: 'Aus Bestellung',
            ),
            SizedBox(width: padding),
            _AddItemButtom(
              onPressed: () => showMyDialogNotImplemented(context: context),
              title: 'Aus Artikel',
            ),
          ],
        ),
      ],
    );
  }
}

class _AddItemButtom extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _AddItemButtom({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.green),
      label: Text(title),
    );
  }
}
