import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/3_domain/entities/marketplace/abstract_marketplace.dart';
import 'package:cezeri_commerce/3_domain/entities/marketplace/marketplace_shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/marketplace/marketplace_bloc.dart';
import '../../../injection.dart';
import '../../../routes/router.gr.dart';
import '../../core/core.dart';
import 'functions/add_edit_marktplace_pressed.dart';
import 'marketplaces_overview_page.dart';

@RoutePage()
class MarketplacesOverviewScreen extends StatelessWidget {
  final bool comeFromPos;

  const MarketplacesOverviewScreen({super.key, this.comeFromPos = false});

  @override
  Widget build(BuildContext context) {
    final getMarketplacesEvent = comeFromPos ? GetAllMarketplacesEvent(type: MarketplaceType.shop) : GetAllMarketplacesEvent();
    final marketplaceBloc = sl<MarketplaceBloc>()..add(getMarketplacesEvent);

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
                  (failure) => failureRenderer(context, [failure]),
                  (listMarketplace) {
                    if (comeFromPos && listMarketplace.length == 1 && listMarketplace.first is MarketplaceShop) {
                      onMarketplaceSelected(context, listMarketplace.first as MarketplaceShop);
                    }
                  },
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
                  (failure) => failureRenderer(context, [failure]),
                  (unit) {
                    context.router.popUntilRouteWithName(MarketplacesOverviewRoute.name);
                    myScaffoldMessenger(context, null, null, 'Marktplatz wurde erfolgreich erstellt', null);
                    context.read<MarketplaceBloc>().add(getMarketplacesEvent);
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
                  (failure) => failureRenderer(context, [failure]),
                  (unit) {
                    context.router.popUntilRouteWithName(MarketplacesOverviewRoute.name);
                    myScaffoldMessenger(context, null, null, 'Marktplatz wurde erfogreich bearbeitet', null);
                    context.read<MarketplaceBloc>().add(getMarketplacesEvent);
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
                  (failure) => failureRenderer(context, [failure]),
                  (unit) {
                    context.router.popUntilRouteWithName(MarketplacesOverviewRoute.name);
                    myScaffoldMessenger(context, null, null, 'Marktplatz wurde erfogreich gelöscht', null);
                    context.read<MarketplaceBloc>().add(getMarketplacesEvent);
                  },
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<MarketplaceBloc, MarketplaceState>(
          builder: (context, state) => MarketplacesOverviewPage(marketplaceBloc: marketplaceBloc, comeFromPos: comeFromPos),
        ),
      ),
    );
  }
}
