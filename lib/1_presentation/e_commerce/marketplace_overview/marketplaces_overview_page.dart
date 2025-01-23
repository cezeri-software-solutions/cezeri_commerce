import 'package:cezeri_commerce/3_domain/entities/marketplace/abstract_marketplace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../2_application/database/marketplace/marketplace_bloc.dart';
import '../../../3_domain/entities/marketplace/marketplace_shop.dart';
import '../../../constants.dart';
import '../../app_drawer.dart';
import '../../core/core.dart';
import 'functions/add_edit_marktplace_pressed.dart';

const double padding = 20;

class MarketplacesOverviewPage extends StatelessWidget {
  final MarketplaceBloc marketplaceBloc;
  final bool comeFromPos;

  const MarketplacesOverviewPage({super.key, required this.marketplaceBloc, required this.comeFromPos});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketplaceBloc, MarketplaceState>(
      builder: (context, state) {
        List<_MarktplaceItemCard> markedplaceItems = [];

        final appBar = AppBar(
          title: const Text('Marktplätze'),
          actions: [
            IconButton(
              onPressed: () => onAddEditMarketplace(context: context, marketplaceBloc: marketplaceBloc),
              icon: const Icon(Icons.add, color: Colors.green),
            ),
            IconButton(
              onPressed: () => context.read<MarketplaceBloc>().add(GetAllMarketplacesEvent()),
              icon: const Icon(Icons.refresh),
            ),
          ],
        );
        final drawer = context.displayDrawer ? const AppDrawer() : null;

        if (state.isLoadingMarketplacesOnObserve) {
          return Scaffold(appBar: appBar, drawer: drawer, body: const Center(child: CircularProgressIndicator()));
        }
        if (state.firebaseFailure != null && state.isAnyFailure) {
          return Scaffold(appBar: appBar, drawer: drawer, body: const Center(child: Text('Ein Fehler ist aufgetreten')));
        }

        void createMarketplaceItems(List<AbstractMarketplace> listOfMarketplace) {
          for (AbstractMarketplace mp in listOfMarketplace) {
            _MarktplaceItemCard mpItem = _MarktplaceItemCard(marketplace: mp, marketplaceBloc: marketplaceBloc, comeFromPos: comeFromPos);
            markedplaceItems.add(mpItem);
          }
        }

        createMarketplaceItems(state.listOfMarketplace!);

        return Scaffold(
          drawer: drawer,
          appBar: appBar,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(padding),
                child: Wrap(spacing: 10, runSpacing: 10, children: markedplaceItems),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MarktplaceItemCard extends StatelessWidget {
  final AbstractMarketplace marketplace;
  final MarketplaceBloc marketplaceBloc;
  final bool comeFromPos;

  const _MarktplaceItemCard({required this.marketplace, required this.marketplaceBloc, required this.comeFromPos});

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;
    return SizedBox(
      width: ResponsiveBreakpoints.of(context).largerThan(MOBILE) ? (screenWidth - (2.5 * padding)) / 2 : screenWidth,
      child: InkWell(
        onTap: () => comeFromPos
            ? onMarketplaceSelected(context, marketplace as MarketplaceShop)
            : onAddEditMarketplace(context: context, marketplaceBloc: marketplaceBloc, marketplace: marketplace),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 60, height: 60, child: SvgPicture.asset(getMarketplaceLogoAsset(marketplace.marketplaceType))),
                    SizedBox(
                      width: 120,
                      child: MyAvatar(
                        name: marketplace.shortName,
                        fit: BoxFit.scaleDown,
                        shape: BoxShape.rectangle,
                        imageUrl: marketplace.logoUrl,
                        radius: 60,
                        onTap: () {},
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: Center(child: Badge(backgroundColor: marketplace.isActive ? Colors.green : Colors.grey, smallSize: 20, largeSize: 20)),
                    ),
                  ],
                ),
                Text(marketplace.name, style: TextStyles.h2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
