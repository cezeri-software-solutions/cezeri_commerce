import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:flutter/material.dart';

import '../../../2_application/database/receipt_detail/receipt_detail_bloc.dart';
import '../../../constants.dart';

class ReceiptDetailCommentCard extends StatelessWidget {
  final ReceiptDetailBloc receiptDetailBloc;
  final TextEditingController internalCommentController;
  final TextEditingController globalCommentController;

  const ReceiptDetailCommentCard({
    super.key,
    required this.receiptDetailBloc,
    required this.internalCommentController,
    required this.globalCommentController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(alignment: Alignment.center, child: Text('Kommentar', style: TextStyles.h3BoldPrimary)),
            const Divider(height: 30),
            MyTextFormFieldSmall(
              fieldTitle: 'Dieser Beleg',
              controller: internalCommentController,
              maxLines: null,
              onChanged: (_) => receiptDetailBloc.add(ReceiptDetailCommentChangedEvent()),
            ),
            Gaps.h10,
            MyTextFormFieldSmall(
              fieldTitle: 'Alle Belege',
              controller: globalCommentController,
              maxLines: null,
              onChanged: (_) => receiptDetailBloc.add(ReceiptDetailCommentChangedEvent()),
            ),
          ],
        ),
      ),
    );
  }
}
