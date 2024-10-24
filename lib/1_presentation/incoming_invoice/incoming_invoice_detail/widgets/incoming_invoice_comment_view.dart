import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../2_application/database/incoming_invoice_detail/incoming_invoice_detail_bloc.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

class IncomingInvoiceCommentView extends StatelessWidget {
  final IncomingInvoiceDetailBloc bloc;

  const IncomingInvoiceCommentView({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncomingInvoiceDetailBloc, IncomingInvoiceDetailState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.center,
          child: MyFormFieldContainer(
            padding: const EdgeInsets.all(10),
            borderRadius: 10,
            width: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET) ? 600 : double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kommentar', style: TextStyles.defaultBoldPrimary),
                const Divider(),
                MyTextFormFieldSmall(
                  controller: state.commentController,
                  fieldTitle: 'Kommentar',
                  maxLines: 5,
                  onChanged: (val) => bloc.add(OnCommentControllerChangedEvent()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
