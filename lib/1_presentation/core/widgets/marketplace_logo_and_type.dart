import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../constants.dart';
import '../functions/mixed_functions.dart';
import 'my_avatar.dart';

class MarketplaceLogoAndType extends StatelessWidget {
  final AbstractMarketplace marketplace;

  const MarketplaceLogoAndType({super.key, required this.marketplace});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 28,
          width: 48,
          child: MyAvatar(
            name: marketplace.shortName,
            radius: 12,
            fontSize: 12,
            imageUrl: marketplace.logoUrl,
            shape: BoxShape.rectangle,
            fit: BoxFit.scaleDown,
          ),
        ),
        Gaps.w8,
        SizedBox(
          height: 20,
          width: 20,
          child: SvgPicture.asset(getMarketplaceLogoAsset(marketplace.marketplaceType)),
        ),
      ],
    );
  }
}
