import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../2_application/database/marketplace/marketplace_bloc.dart';
import '../../../2_application/packing_station/packing_station_bloc.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../constants.dart';
import '../../../injection.dart';
import '../../../routes/router.gr.dart';
import '../../app_drawer.dart';
import '../../core/core.dart';
import 'packing_station_overview_page.dart';

@RoutePage()
class PackingStationOverviewScreen extends StatefulWidget {
  const PackingStationOverviewScreen({super.key});

  @override
  State<PackingStationOverviewScreen> createState() => _PackingStationOverviewScreenState();
}

class _PackingStationOverviewScreenState extends State<PackingStationOverviewScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final packingStationBloc = sl<PackingStationBloc>()..add(PackgingStationGetAppointmentsEvent());
    final marketplaceBloc = sl<MarketplaceBloc>()..add(GetAllMarketplacesEvent());

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: packingStationBloc,
        ),
        BlocProvider.value(
          value: marketplaceBloc,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<PackingStationBloc, PackingStationState>(
            listenWhen: (p, c) => p.fosAppointmentOnObserveOption != c.fosAppointmentOnObserveOption,
            listener: (context, state) {
              state.fosAppointmentOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (appointment) => null,
                ),
              );
            },
          ),
          BlocListener<PackingStationBloc, PackingStationState>(
            listenWhen: (p, c) => p.fosAppointmentsOnObserveOption != c.fosAppointmentsOnObserveOption,
            listener: (context, state) {
              state.fosAppointmentsOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (appointments) => myScaffoldMessenger(context, null, null, 'Aufträge erfolgreich geladen', null),
                ),
              );
            },
          ),
          BlocListener<PackingStationBloc, PackingStationState>(
            listenWhen: (p, c) => p.fosPicklistOnCreateOption != c.fosPicklistOnCreateOption,
            listener: (context, state) {
              state.fosPicklistOnCreateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (picklist) {
                    packingStationBloc.add(PicklistOnSetPicklistEvent(picklist: picklist));
                    context.router.push(PicklistDetailRoute(packingStationBloc: packingStationBloc));
                  },
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<PackingStationBloc, PackingStationState>(
          builder: (context, state) {
            final isTabletOrLarger = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);

            return Scaffold(
              drawer: context.displayDrawer ? const AppDrawer() : null,
              appBar: AppBar(
                title: const Text('Packtisch'),
                actions: [
                  IconButton(
                    onPressed: () => context.read<PackingStationBloc>().add(PackgingStationGetAppointmentsEvent()),
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Gaps.w8,
                          MyOutlinedButton(
                            buttonText: 'Pickliste erstellen',
                            isLoading: state.isLoadingPicklistOnCreate,
                            buttonBackgroundColor: Colors.green,
                            onPressed: () => packingStationBloc.add(PicklistOnCreatePicklistEvent(context: context)),
                          ),
                          Gaps.w8,
                          MyOutlinedButton(
                            buttonText: 'Picklisten',
                            onPressed: () => context.router.push(PicklistsOverviewRoute(packingStationBloc: packingStationBloc)),
                          ),
                        ],
                      ),
                      if (isTabletOrLarger)
                        _PackingStationFilterChipsContainer(packingStationBloc: packingStationBloc, packingStationFilter: state.packingStationFilter),
                    ],
                  ),
                  if (!isTabletOrLarger)
                    _PackingStationFilterChipsContainer(packingStationBloc: packingStationBloc, packingStationFilter: state.packingStationFilter),
                  PackingStationOverviewPage(packingStationBloc: packingStationBloc, marketplaceBloc: marketplaceBloc),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _PackingStationFilterChipsContainer extends StatelessWidget {
  final PackingStationBloc packingStationBloc;
  final PackingStationFilter packingStationFilter;

  const _PackingStationFilterChipsContainer({required this.packingStationBloc, required this.packingStationFilter});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FilterChip(
          label: const Text('Bezahlt'),
          labelStyle: const TextStyle(color: Colors.black),
          selected: packingStationFilter == PackingStationFilter.paid,
          selectedColor: CustomColors.chipSelectedColor,
          backgroundColor: CustomColors.chipBackgroundColor,
          onSelected: (bool isSelected) => packingStationFilter != PackingStationFilter.paid
              ? packingStationBloc.add(SetPackingStationFilterAppointmentsEvent(packingStationFilter: PackingStationFilter.paid))
              : null,
        ),
        Gaps.w8,
        FilterChip(
          label: const Text('Gepickt'),
          labelStyle: const TextStyle(color: Colors.black),
          selected: packingStationFilter == PackingStationFilter.picked,
          selectedColor: CustomColors.chipSelectedColor,
          backgroundColor: CustomColors.chipBackgroundColor,
          onSelected: (bool isSelected) => packingStationFilter != PackingStationFilter.picked
              ? packingStationBloc.add(SetPackingStationFilterAppointmentsEvent(packingStationFilter: PackingStationFilter.picked))
              : null,
        ),
        Gaps.w8,
        FilterChip(
          label: const Text('Alle'),
          labelStyle: const TextStyle(color: Colors.black),
          selected: packingStationFilter == PackingStationFilter.all,
          selectedColor: CustomColors.chipSelectedColor,
          backgroundColor: CustomColors.chipBackgroundColor,
          onSelected: (bool isSelected) => packingStationFilter != PackingStationFilter.all
              ? packingStationBloc.add(SetPackingStationFilterAppointmentsEvent(packingStationFilter: PackingStationFilter.all))
              : null,
        ),
        Gaps.w8,
      ],
    );
  }
}
