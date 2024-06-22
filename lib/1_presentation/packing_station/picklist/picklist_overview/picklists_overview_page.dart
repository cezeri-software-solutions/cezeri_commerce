import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../2_application/packing_station/packing_station_bloc.dart';
import '../../../../3_domain/entities/picklist/picklist.dart';
import '../../../../3_domain/enums/enums.dart';
import '../../../../routes/router.gr.dart';
import '../../../core/core.dart';

class PicklistsOverviewPage extends StatelessWidget {
  final PackingStationBloc packingStationBloc;

  const PicklistsOverviewPage({super.key, required this.packingStationBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackingStationBloc, PackingStationState>(
      bloc: packingStationBloc,
      builder: (context, state) {
        if (state.isLoadingPicklistsOnObserve) return const Center(child: MyCircularProgressIndicator());
        if (state.firebaseFailure != null && state.isAnyFailure) {
          return const Center(child: Text('Ein Fehler beim Laden der Picklisten ist aufgetreten!'));
        }
        if (state.listOfPicklists == null) return const Center(child: MyCircularProgressIndicator());
        if (state.listOfPicklists!.isEmpty) return const Center(child: Text('Aktuell sind keine Picklisten vorhanden'));

        return ListView.builder(
          itemCount: state.listOfPicklists!.length,
          itemBuilder: (context, index) {
            final picklist = state.listOfPicklists![index];
            return Column(
              children: [
                if (index == 0) const Divider(height: 2),
                _PicklistsContainer(packingStationBloc: packingStationBloc, picklist: picklist),
                const Divider(height: 2),
              ],
            );
          },
        );
      },
    );
  }
}

class _PicklistsContainer extends StatelessWidget {
  final PackingStationBloc packingStationBloc;
  final Picklist picklist;

  const _PicklistsContainer({required this.packingStationBloc, required this.picklist});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackingStationBloc, PackingStationState>(
      bloc: packingStationBloc,
      builder: (context, state) {
        int totalQuantity = 0;
        for (final picklistProduct in picklist.listOfPicklistProducts) {
          totalQuantity += picklistProduct.quantity;
        }

        PicklistStatus picklistStatus = PicklistStatus.open;
        if (picklist.listOfPicklistProducts.every((e) => e.pickedQuantity == 0)) {
          picklistStatus = PicklistStatus.open;
        } else if (picklist.listOfPicklistProducts.every((e) => e.pickedQuantity == e.quantity)) {
          picklistStatus = PicklistStatus.completed;
        } else {
          picklistStatus = PicklistStatus.partiallyCompleted;
        }

        return ListTile(
          title: Text(DateFormat('EE dd.MM.yyyy - HH:mm:ss', 'de').format(picklist.creationDate)),
          subtitle: Text('Artikel: ${picklist.listOfPicklistProducts.length} | Stückzahl: $totalQuantity'),
          trailing: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: switch (picklistStatus) {
                PicklistStatus.open => Colors.grey,
                PicklistStatus.partiallyCompleted => Colors.orange,
                PicklistStatus.completed => Colors.green,
              },
              shape: BoxShape.circle,
            ),
          ),
          onTap: () {
            packingStationBloc.add(PicklistOnSetPicklistEvent(picklist: picklist));
            context.router.push(PicklistDetailRoute(packingStationBloc: packingStationBloc));
          },
        );
      },
    );
  }
}
