import 'dart:async';
import 'dart:math';

import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../../2_application/database/incoming_invoice_detail/incoming_invoice_detail_bloc.dart';
import '../../../../3_domain/entities/incoming_invoice/incoming_invoice_file.dart';
import '../../../../constants.dart';

Future<void> showIncomingInvoiceUpdateFileNameSheet(BuildContext context, IncomingInvoiceFile file, int index, IncomingInvoiceDetailBloc bloc) async {
  const title = Padding(
    padding: EdgeInsets.only(left: 24, top: 20),
    child: Text('Name ändern', style: TextStyles.h2),
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
        child: _ItemUpdateNameSheet(bloc: bloc, file: file, index: index),
      ),
    ],
  );
}

class _ItemUpdateNameSheet extends StatefulWidget {
  final IncomingInvoiceDetailBloc bloc;
  final IncomingInvoiceFile file;
  final int index;

  const _ItemUpdateNameSheet({required this.bloc, required this.file, required this.index});

  @override
  State<_ItemUpdateNameSheet> createState() => _ItemUpdateNameSheetState();
}

class _ItemUpdateNameSheetState extends State<_ItemUpdateNameSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.file.name);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: max(MediaQuery.paddingOf(context).bottom, 16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.upload_file_rounded, color: CustomColors.primaryColor, size: 80),
          Gaps.h16,
          MyTextFormFieldSmall(
            controller: _controller,
            fieldTitle: 'Dokument-Name',
          ),
          Gaps.h32,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(child: const Text('Abbrechen'), onPressed: () => Navigator.of(context).pop()),
              Gaps.w16,
              FilledButton(
                onPressed: () {
                  widget.bloc.add(OnUpdateFileNameEvent(
                    name: _controller.text,
                    index: widget.index,
                  ));
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
