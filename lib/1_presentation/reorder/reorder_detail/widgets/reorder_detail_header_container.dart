import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../2_application/firebase/reorder_detail/reorder_detail_bloc.dart';
import '../../../../3_domain/entities/reorder/reorder.dart';
import '../../../../constants.dart';
import '../../../core/widgets/my_form_field_container.dart';
import '../../../core/widgets/my_form_field_small.dart';

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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nachbestellung: ${state.reorder!.reorderNumber.toString()}'),
                        Text(state.reorder!.reorderSupplier.company),
                        Text('Vorsteuer: ${state.reorder!.tax.taxRate.toString()} %')
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Dokumentdatum:'),
                        Text(DateFormat('dd.MM.yyy', 'de').format(state.reorder!.creationDate)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Status:'),
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: switch (state.reorder!.reorderStatus) {
                              ReorderStatus.open => CustomColors.backgroundLightGrey,
                              ReorderStatus.partiallyCompleted => CustomColors.backgroundLightOrange,
                              ReorderStatus.completed => CustomColors.backgroundLightGreen,
                            },
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: switch (state.reorder!.reorderStatus) {
                                ReorderStatus.open => const Text('Offen'),
                                ReorderStatus.partiallyCompleted => const Text('Teilweise offen'),
                                ReorderStatus.completed => const Text('Geschlossen'),
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 180,
                    child: MyTextFormFieldSmall(
                      labelText: 'Bestellnummer intern',
                      controller: state.reorderNumberInternalController,
                      onChanged: (_) => reorderDetailBloc.add(OnReorderDetailControllerChangedEvent()),
                    ),
                  ),
                  Column(
                    children: [
                      const Text('Manuell geschlossen'),
                      Switch.adaptive(
                        value: state.reorder!.closedManually,
                        onChanged: (value) => reorderDetailBloc.add(OnReorderDetailClosedManuallyChangeEvent(value: value)),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
