import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/packing_station/packing_station_bloc.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';
import 'picklist_detail_page.dart';

@RoutePage()
class PicklistDetailScreen extends StatelessWidget {
  final PackingStationBloc packingStationBloc;

  const PicklistDetailScreen({super.key, required this.packingStationBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackingStationBloc, PackingStationState>(
      bloc: packingStationBloc,
      builder: (context, state) {
        Color buttonColor = Colors.green;
        if (state.picklist != null) {
          if (state.picklist!.listOfPicklistProducts.every((e) => e.pickedQuantity == 0)) {
            buttonColor = Colors.grey;
          } else if (state.picklist!.listOfPicklistProducts.every((e) => e.pickedQuantity == e.quantity)) {
            buttonColor = Colors.green;
          } else {
            buttonColor = Colors.orange;
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Kommisionierliste'),
            actions: [
              MyOutlinedButton(
                buttonText: 'Speichern',
                buttonBackgroundColor: buttonColor,
                isLoading: state.isLoadingPicklistOnUpdate,
                onPressed: () => packingStationBloc.add(PicklistOnUpdatePicklistEvent()),
              ),
              Gaps.w8,
            ],
          ),
          body: SafeArea(child: PicklistDetailPage(packingStationBloc: packingStationBloc)),
        );
      },
    );
  }
}
