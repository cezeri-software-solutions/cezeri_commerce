import 'package:flutter/material.dart';

import '../../../../../2_application/database/supplier/supplier_bloc.dart';
import '../../../../../3_domain/entities/address.dart';
import '../../../../../3_domain/entities/reorder/supplier.dart';
import '../../../../../constants.dart';
import '../../../../core/core.dart';

class SupplierAddressCard extends StatelessWidget {
  final SupplierBloc supplierBloc;
  final Supplier supplier;

  const SupplierAddressCard({super.key, required this.supplier, required this.supplierBloc});

  @override
  Widget build(BuildContext context) {
    final address = Address.empty().copyWith(
      companyName: supplier.company,
      firstName: supplier.firstName,
      lastName: supplier.lastName,
      street: supplier.street,
      street2: supplier.street2,
      postcode: supplier.postcode,
      city: supplier.city,
      country: supplier.country,
      phone: supplier.phone,
      phoneMobile: supplier.phoneMobile,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Adresse', style: TextStyles.h3BoldPrimary),
            const Divider(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (supplier.company.isNotEmpty) Text(supplier.company),
                    if (supplier.name.isNotEmpty) Text(supplier.name),
                    if (supplier.street.isNotEmpty) Text(supplier.street),
                    if (supplier.street2.isNotEmpty) Text(supplier.street2),
                    if (supplier.postcode.isNotEmpty && supplier.city.isNotEmpty)
                      Text.rich(TextSpan(children: [
                        TextSpan(text: supplier.postcode),
                        const TextSpan(text: ' '),
                        TextSpan(text: supplier.city),
                      ])),
                    if (supplier.country.name.isNotEmpty) Text(supplier.country.name),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => MyAddressUpdateSheet(
                          address: address,
                          onSave: (newAddress) => supplierBloc.add(OnEditSupplierAddressEvent(address: newAddress)),
                          comeFromSupplier: true,
                        ),
                      ),
                      icon: const Icon(Icons.edit, color: CustomColors.primaryColor),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
