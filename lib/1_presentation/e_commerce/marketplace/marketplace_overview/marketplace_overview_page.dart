import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/core/functions/my_scaffold_messanger.dart';
import 'package:cezeri_commerce/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/marketplace/marketplace_bloc.dart';
import '../../../../3_domain/entities/marketplace.dart';
import '../../../app_drawer.dart';
import '../../../core/widgets/my_circular_avatar.dart';
import 'functions/add_edit_marktplace_pressed.dart';
import 'marketplace_overview_screen.dart';

class MarketplaceOverviewPage extends StatelessWidget {
  final ComeFromToMarketplaceOverview comeFromToMarketplaceOverview;
  final MarketplaceBloc marketplaceBloc;

  const MarketplaceOverviewPage({super.key, required this.comeFromToMarketplaceOverview, required this.marketplaceBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketplaceBloc, MarketplaceState>(
      builder: (context, state) {
        List<_MarktplaceItem> markedplaceItems = [];

        final appBar = AppBar(
          title: const Text('Marktplätze'),
          actions: [
            IconButton(
              onPressed: () => addEditMarketplacepressed(context: context, marketplaceBloc: marketplaceBloc),
              icon: const Icon(Icons.add, color: Colors.green),
            ),
            IconButton(
              onPressed: () => context.read<MarketplaceBloc>().add(GetAllMarketplacesEvent()),
              icon: const Icon(Icons.refresh),
            ),
          ],
        );
        const drawer = AppDrawer();

        if (state.isLoadingMarketplacesOnObserve) {
          return Scaffold(appBar: appBar, drawer: drawer, body: const Center(child: CircularProgressIndicator()));
        }
        if (state.firebaseFailure != null && state.isAnyFailure) {
          return Scaffold(appBar: appBar, drawer: drawer, body: Center(child: Text(mapFirebaseFailureMessage(state.firebaseFailure!))));
        }

        void createMarketplaceItems(List<Marketplace> listOfMarketplace) {
          for (Marketplace mp in listOfMarketplace) {
            _MarktplaceItem mpItem = _MarktplaceItem(
              marketplace: mp,
              marketplaceBloc: marketplaceBloc,
              comeFromToMarketplaceOverview: comeFromToMarketplaceOverview,
            );
            markedplaceItems.add(mpItem);
          }
        }

        createMarketplaceItems(state.listOfMarketplace!);

        return Scaffold(
          drawer: drawer,
          appBar: appBar,
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: markedplaceItems,
            ),
          ),
        );
      },
    );
  }
}

class _MarktplaceItem extends StatelessWidget {
  final Marketplace marketplace;
  final MarketplaceBloc marketplaceBloc;
  final ComeFromToMarketplaceOverview comeFromToMarketplaceOverview;

  const _MarktplaceItem({required this.marketplace, required this.marketplaceBloc, required this.comeFromToMarketplaceOverview});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return SizedBox(
      width: screenWidth > 500 ? 500 : screenWidth,
      child: InkWell(
        onTap: () => switch (comeFromToMarketplaceOverview) {
          ComeFromToMarketplaceOverview.marketplaceOverview =>
            addEditMarketplacepressed(context: context, marketplaceBloc: marketplaceBloc, marketplace: marketplace),
          ComeFromToMarketplaceOverview.marketplaceMassEditing => context.router.push(MarketplaceMassEditingRoute(marketplace: marketplace)),
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                const MyAvatar(name: 'P S'),
                Text(marketplace.name),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
