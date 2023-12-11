import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../2_application/firebase/reorder_detail/reorder_detail_bloc.dart';
import '../../../../3_domain/entities/reorder/reorder.dart';
import '../../../core/widgets/my_form_field_container.dart';

class ReorderDetailHeaderContainer extends StatelessWidget {
  final ReorderDetailBloc reorderDetailBloc;

  const ReorderDetailHeaderContainer({super.key, required this.reorderDetailBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReorderDetailBloc, ReorderDetailState>(
      bloc: reorderDetailBloc,
      builder: (context, state) {
        return MyFormFieldContainer(
          width: double.infinity,
          borderRadius: 6,
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Nachbestellung: ${state.reorder!.reorderNumber.toString()}'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const Text('Dokumentendatum:'), Text(DateFormat('dd.MM.yyy', 'de').format(state.reorder!.creationDate))],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Status:'),
                  Text(switch (state.reorder!.reorderStatus) {
                    ReorderStatus.open => 'Offen',
                    ReorderStatus.partiallyCompleted => 'Teilweise abgeschlossen',
                    ReorderStatus.completed => 'Abgeschlossen',
                  }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
