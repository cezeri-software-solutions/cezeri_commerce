import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

class SelectMarketplaceToExportSheet extends StatelessWidget {
  final bool isSelectMarketplaceForSourceCategories;
  final List<AbstractMarketplace> marketplaces;
  final Function(AbstractMarketplace?) onMarketplaceSelected;

  const SelectMarketplaceToExportSheet({
    super.key,
    required this.isSelectMarketplaceForSourceCategories,
    required this.marketplaces,
    required this.onMarketplaceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveBreakpoints.of(context).isMobile ? const EdgeInsets.only(top: 16, bottom: 40) : const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              !isSelectMarketplaceForSourceCategories
                  ? 'Zu welchem Marktplatz sollen die Artikel exportiert werden?'
                  : 'Von welchem Marktplatz sollen die Kategorien gemappt werden?',
              style: TextStyles.h3Bold,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: marketplaces.length,
            itemBuilder: (context, index) {
              final marketplace = marketplaces[index];
              return Column(
                children: [
                  ListTile(
                    leading: SizedBox(
                      width: 40,
                      height: 40,
                      child: marketplace.logoUrl != ''
                          ? MyAvatar(name: marketplace.shortName, imageUrl: marketplace.logoUrl, fit: BoxFit.contain, shape: BoxShape.rectangle)
                          : SvgPicture.asset(getMarketplaceLogoAsset(marketplace.marketplaceType)),
                    ),
                    title: Text(marketplace.name),
                    onTap: () => onMarketplaceSelected(marketplace),
                  ),
                  const Divider(),
                ],
              );
            },
          ),
          if (isSelectMarketplaceForSourceCategories)
            ListTile(
              leading: const Icon(Icons.close, color: Colors.red),
              title: const Text('Kategorien nicht mappen'),
              onTap: () => onMarketplaceSelected(null),
            ),
        ],
      ),
    );
  }
}
