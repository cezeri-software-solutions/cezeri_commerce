import 'package:flutter/material.dart';

import '../../../3_domain/entities/address.dart';
import '../../../constants.dart';
import '../core.dart';

class AddressColumn extends StatelessWidget {
  final Address address;
  final String? companyName;
  final String? name;
  final double? width;
  final bool showStreet2;

  const AddressColumn({super.key, required this.address, this.companyName, this.name, this.width, this.showStreet2 = false});

  @override
  Widget build(BuildContext context) {
    String? getCompanyName() {
      if (companyName != null && companyName!.isNotEmpty) return companyName!;
      if (address.companyName.isEmpty) return address.companyName;
      return null;
    }

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (getCompanyName() != null) Text(getCompanyName()!),
          if (address.name.isNotEmpty) Text(address.name),
          if (address.street.isNotEmpty)
            Row(
              children: [
                width == null ? Text(address.street) : Expanded(child: Text(address.street, overflow: TextOverflow.ellipsis)),
                if (!address.street.containsDigit()) const Icon(Icons.warning_rounded, color: CustomColors.backgroundLightOrange)
              ],
            ),
          if (showStreet2 && address.street2.isNotEmpty) Text(address.street2),
          if (address.postcode.isNotEmpty || address.city.isNotEmpty)
            Text.rich(
              TextSpan(
                children: [
                  if (address.postcode.isNotEmpty) ...[
                    TextSpan(text: address.postcode),
                    const TextSpan(text: ' '),
                  ],
                  if (address.city.isNotEmpty) TextSpan(text: address.city),
                ],
              ),
            ),
          if (address.country.name.isNotEmpty)
            Row(
              children: [
                Text(address.country.name),
                Gaps.w8,
                MyCountryFlag(country: address.country, size: 12),
              ],
            ),
        ],
      ),
    );
  }
}
