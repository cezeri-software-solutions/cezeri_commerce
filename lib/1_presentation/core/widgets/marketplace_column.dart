import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import 'marketplace_logo_and_type.dart';

class MarketplaceColumn extends StatelessWidget {
  final AbstractMarketplace marketplace;
  final Receipt receipt;
  final double? width;

  const MarketplaceColumn({super.key, required this.marketplace, required this.receipt, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          MarketplaceLogoAndType(marketplace: marketplace),
          Text(marketplace.name, textAlign: TextAlign.center),
          Text(DateFormat('dd.MM.yyy', 'de').format(receipt.creationDateMarektplace)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.watch_later_outlined, size: 16),
              const Text(' '),
              Text(DateFormat('Hm', 'de').format(receipt.creationDateMarektplace)),
            ],
          ),
          Text(receipt.receiptMarketplaceReference),
        ],
      ),
    );
  }
}
