import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../../../2_application/database/customer_detail/customer_detail_bloc.dart';
import '../../../../../3_domain/entities/address.dart';
import '../../../../../3_domain/entities/customer/customer.dart';
import '../../../../../constants.dart';
import '../../../../core/core.dart';

enum CustomerDetailAddressTyp { shipping, invoice }

class CustomerAddressCard extends StatefulWidget {
  final CustomerDetailBloc customerDetailBloc;
  final Customer customer;

  const CustomerAddressCard({super.key, required this.customer, required this.customerDetailBloc});

  @override
  State<CustomerAddressCard> createState() => _CustomerAddressCardState();
}

class _CustomerAddressCardState extends State<CustomerAddressCard> {
  CustomerDetailAddressTyp _addressType = CustomerDetailAddressTyp.shipping;

  @override
  Widget build(BuildContext context) {
    Address? deliveryAddress = widget.customer.listOfAddress.where((e) => e.addressType == AddressType.delivery && e.isDefault).firstOrNull;
    Address? invoiceAddress = widget.customer.listOfAddress.where((e) => e.addressType == AddressType.invoice && e.isDefault).firstOrNull;
    final shownAddress = switch (_addressType) {
      CustomerDetailAddressTyp.shipping => deliveryAddress,
      CustomerDetailAddressTyp.invoice => invoiceAddress,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(alignment: Alignment.center, child: Text(widget.customer.name, style: TextStyles.h3BoldPrimary)),
            const Divider(height: 30),
            DefaultTabController(
              length: 2,
              child: TabBar(
                tabs: const [Tab(text: 'Lieferadresse'), Tab(text: 'Rechnungsadresse')],
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(),
                onTap: (value) =>
                    setState(() => value == 0 ? _addressType = CustomerDetailAddressTyp.shipping : _addressType = CustomerDetailAddressTyp.invoice),
              ),
            ),
            Gaps.h16,
            _CustomerDetailCustomerAddressContainer(customerBloc: widget.customerDetailBloc, address: shownAddress)
          ],
        ),
      ),
    );
  }
}

class _CustomerDetailCustomerAddressContainer extends StatelessWidget {
  final CustomerDetailBloc customerBloc;
  final Address? address;

  const _CustomerDetailCustomerAddressContainer({required this.address, required this.customerBloc});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        address != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (address!.companyName.isNotEmpty) Text(address!.companyName),
                  if (address!.name.isNotEmpty) Text(address!.name),
                  if (address!.street.isNotEmpty) Text(address!.street),
                  if (address!.street2.isNotEmpty) Text(address!.street2),
                  if (address!.postcode.isNotEmpty && address!.city.isNotEmpty)
                    Text.rich(TextSpan(children: [
                      TextSpan(text: address!.postcode),
                      const TextSpan(text: ' '),
                      TextSpan(text: address!.city),
                    ])),
                  if (address!.country.name.isNotEmpty) Text(address!.country.name),
                ],
              )
            : const SizedBox(),
        const Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => _showAddEditAddressModal(context, customerBloc, address),
              icon: address != null ? const Icon(Icons.edit, color: CustomColors.primaryColor) : const Icon(Icons.add, color: Colors.green),
            ),
            if (address != null)
              IconButton(
                onPressed: () => _showAddEditAddressModal(context, customerBloc, null),
                icon: const Icon(Icons.add, color: Colors.green),
              ),
            IconButton(
              onPressed: () {}, //TODO: es soll ein Dialog oder Sheet aufgehen, wo alle adressen des kunden aufgelistet sind
              icon: const Icon(Icons.list, color: CustomColors.primaryColor),
            ),
          ],
        ),
      ],
    );
  }
}

void _showAddEditAddressModal(BuildContext context, CustomerDetailBloc customerDetailBloc, Address? address) {
  final title = Padding(
    padding: const EdgeInsets.only(left: 24, top: 20),
    child: Text(address == null ? 'Neue Adresse' : 'Adresse bearbeiten', style: TextStyles.h2),
  );

  final closeButton = Padding(
    padding: const EdgeInsets.only(right: 8),
    child: IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        context.router.maybePop();
      },
    ),
  );

  WoltModalSheet.show<void>(
    context: context,
    barrierDismissible: false,
    enableDrag: false,
    useSafeArea: false,
    pageListBuilder: (context) => [
      WoltModalSheetPage(
        leadingNavBarWidget: title,
        trailingNavBarWidget: closeButton,
        child: MyAddressUpdateSheet(
          address: address,
          onSave: (newAddress) => customerDetailBloc.add(CustomerDetailUpdateCustomerAddressEvent(address: newAddress)),
        ),
      ),
    ],
  );
}
