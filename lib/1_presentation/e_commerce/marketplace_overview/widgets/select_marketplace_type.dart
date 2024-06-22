import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../core/core.dart';

class SelectMarketplaceType extends StatelessWidget {
  final Function(MarketplaceType) onMarketplaceSelected;

  const SelectMarketplaceType({super.key, required this.onMarketplaceSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveBreakpoints.of(context).isMobile ? const EdgeInsets.only(top: 16, bottom: 40) : const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          ListTile(
            leading: SvgPicture.asset(getMarketplaceLogoAsset(MarketplaceType.shop), width: 40, height: 40),
            title: const Text('Ladengeschäft (POS)'),
            onTap: () => onMarketplaceSelected(MarketplaceType.shop),
          ),
          const Divider(),
          ListTile(
            leading: SizedBox(width: 40, height: 40, child: SvgPicture.asset(getMarketplaceLogoAsset(MarketplaceType.prestashop))),
            title: const Text('Prestashop'),
            onTap: () => onMarketplaceSelected(MarketplaceType.prestashop),
          ),
          const Divider(),
          ListTile(
            leading: SizedBox(width: 40, height: 40, child: SvgPicture.asset(getMarketplaceLogoAsset(MarketplaceType.shopify))),
            title: const Text('Shopify'),
            onTap: () => onMarketplaceSelected(MarketplaceType.shopify),
          ),
        ],
      ),
    );
  }
}
