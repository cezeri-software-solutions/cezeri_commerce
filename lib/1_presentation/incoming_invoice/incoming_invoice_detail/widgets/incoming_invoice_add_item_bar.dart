import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
    if (ResponsiveBreakpoints.of(context).equals(MOBILE)) return _ItemBarMobile(bloc: bloc, supplierId: supplierId, padding: padding);

    return _ItemBarTabletDesktop(bloc: bloc, supplierId: supplierId, padding: padding);
  }
}

class _ItemBarMobile extends StatelessWidget {
  final IncomingInvoiceDetailBloc bloc;
  final String supplierId;
  final double padding;

  const _ItemBarMobile({required this.bloc, required this.supplierId, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => showIncomingInvoiceDetailMassEditingItemsSheet(context, bloc),
              icon: const Icon(Icons.edit_note_rounded, color: Colors.green),
            ),
            IconButton(
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
              icon: const Icon(CupertinoIcons.delete, color: Colors.red),
            ),
          ],
        ),
        PopupMenuButton(
          icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.green),
          offset: const Offset(40, 48),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: const Text('Konto'),
                onTap: () => bloc.add(OnAddNewItemToListEvent(itemType: ItemType.account)),
              ),
              PopupMenuItem(
                child: const Text('Artikel'),
                onTap: () => bloc.add(OnAddNewItemToListEvent(itemType: ItemType.position)),
              ),
              PopupMenuItem(
                child: const Text('Aus Bestellung'),
                onTap: () async {
                  final selectedReorder = await showSelectReorderBySupplierIdSheet(context, supplierId);
                  if (selectedReorder == null) return;

                  bloc.add(OnAddNewItemsFromReorderEvent(reorder: selectedReorder));
                },
              ),
              PopupMenuItem(
                child: const Text('Aus Bestellung'),
                onTap: () => showMyDialogNotImplemented(context: context),
              ),
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
      ],
    );
  }
}

class _ItemBarTabletDesktop extends StatelessWidget {
  final IncomingInvoiceDetailBloc bloc;
  final String supplierId;
  final double padding;

  const _ItemBarTabletDesktop({required this.bloc, required this.supplierId, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => showIncomingInvoiceDetailMassEditingItemsSheet(context, bloc),
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
            _AddItemButtomTabletDesktop(
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
            _AddItemButtomTabletDesktop(
              onPressed: () => bloc.add(OnAddNewItemToListEvent(itemType: ItemType.position)),
              title: 'Artikel',
            ),
            SizedBox(width: padding),
            _AddItemButtomTabletDesktop(
              onPressed: () async {
                final selectedReorder = await showSelectReorderBySupplierIdSheet(context, supplierId);
                if (selectedReorder == null) return;

                bloc.add(OnAddNewItemsFromReorderEvent(reorder: selectedReorder));
              },
              title: 'Aus Bestellung',
            ),
            SizedBox(width: padding),
            _AddItemButtomTabletDesktop(
              onPressed: () => showMyDialogNotImplemented(context: context),
              title: 'Aus Artikel',
            ),
          ],
        ),
      ],
    );
  }
}

class _AddItemButtomTabletDesktop extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _AddItemButtomTabletDesktop({required this.title, required this.onPressed});

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
