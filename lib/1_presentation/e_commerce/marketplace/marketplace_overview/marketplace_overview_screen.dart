import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/marketplace/marketplace_bloc.dart';
import '../../../../injection.dart';
import '../../../core/functions/my_scaffold_messanger.dart';
import 'marketplace_overview_page.dart';

enum ComeFromToMarketplaceOverview { marketplaceOverview, marketplaceMassEditing }

@RoutePage()
class MarketplaceOverviewScreen extends StatelessWidget {
  final ComeFromToMarketplaceOverview comeFromToMarketplaceOverview;

  const MarketplaceOverviewScreen({super.key, required this.comeFromToMarketplaceOverview});

  @override
  Widget build(BuildContext context) {
    final marketplaceBloc = sl<MarketplaceBloc>()..add(GetAllMarketplacesEvent());

    return BlocProvider(
      create: (_) => marketplaceBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<MarketplaceBloc, MarketplaceState>(
            listenWhen: (p, c) => p.fosMarketplacesOnObserveOption != c.fosMarketplacesOnObserveOption,
            listener: (context, state) {
              state.fosMarketplacesOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
                  (listMarketplace) => null,
                ),
              );
            },
          ),
          BlocListener<MarketplaceBloc, MarketplaceState>(
            listenWhen: (p, c) => p.fosMarketplaceOnCreateOption != c.fosMarketplaceOnCreateOption,
            listener: (context, state) {
              state.fosMarketplaceOnCreateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
                  (unit) {
                    context.router.popUntilRouteWithName(MarketplaceOverviewRoute.name);
                    myScaffoldMessenger(context, null, null, 'Marktplatz wurde erfolgreich erstellt', null);
                    context.read<MarketplaceBloc>().add(GetAllMarketplacesEvent());
                  },
                ),
              );
            },
          ),
          BlocListener<MarketplaceBloc, MarketplaceState>(
            listenWhen: (p, c) => p.fosMarketplaceOnUpdateOption != c.fosMarketplaceOnUpdateOption,
            listener: (context, state) {
              state.fosMarketplaceOnUpdateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
                  (unit) {
                    context.router.popUntilRouteWithName(MarketplaceOverviewRoute.name);
                    myScaffoldMessenger(context, null, null, 'Marktplatz wurde erfogreich bearbeitet', null);
                    context.read<MarketplaceBloc>().add(GetAllMarketplacesEvent());
                  },
                ),
              );
            },
          ),
          BlocListener<MarketplaceBloc, MarketplaceState>(
            listenWhen: (p, c) => p.fosMarketplaceOnDeleteOption != c.fosMarketplaceOnDeleteOption,
            listener: (context, state) {
              state.fosMarketplaceOnDeleteOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
                  (unit) {
                    context.router.popUntilRouteWithName(MarketplaceOverviewRoute.name);
                    myScaffoldMessenger(context, null, null, 'Marktplatz wurde erfogreich gelöscht', null);
                    context.read<MarketplaceBloc>().add(GetAllMarketplacesEvent());
                  },
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<MarketplaceBloc, MarketplaceState>(
          builder: (context, state) {
            return MarketplaceOverviewPage(comeFromToMarketplaceOverview: comeFromToMarketplaceOverview, marketplaceBloc: marketplaceBloc);
          },
        ),
      ),
    );
  }
}
