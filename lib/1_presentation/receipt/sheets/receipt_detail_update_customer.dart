import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/get_either.dart';
import 'package:cezeri_commerce/1_presentation/core/widgets/my_outlined_button.dart';
import 'package:cezeri_commerce/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../2_application/database/customer/customer_bloc.dart';
import '../../../2_application/database/receipt/receipt_bloc.dart';
import '../../../3_domain/entities/address.dart';
import '../../../3_domain/entities/country.dart';
import '../../../3_domain/entities/customer/customer.dart';
import '../../../3_domain/entities/id.dart';
import '../../../3_domain/repositories/firebase/customer_repository.dart';
import '../../../constants.dart';
import '../../../failures/failures.dart';
import '../../core/functions/dialogs.dart';
import '../../core/functions/my_scaffold_messanger.dart';
import '../../core/renderer/failure_renderer.dart';
import '../../core/widgets/my_button_small.dart';
import '../../core/widgets/my_circular_progress_indicator.dart';
import '../../core/widgets/my_country_flag.dart';
import '../../core/widgets/my_dialog_countries.dart';
import '../../core/widgets/my_dialog_taxes.dart';
import '../../core/widgets/my_dropdown_button_small.dart';
import '../../core/widgets/my_form_field_small.dart';

void updateCustomerFromReceiptDetail({required BuildContext context, required ReceiptBloc receiptBloc, required String customerId}) async {
  AbstractFailure? abstractFailure;
  Customer? customer;

  final customerRepository = GetIt.I.get<CustomerRepository>();
  final fosCustomer = await customerRepository.getCustomer(customerId);
  if (fosCustomer.isLeft()) abstractFailure = fosCustomer.getLeft();
  customer = fosCustomer.getRight();

  final trailing = IconButton(
    padding: const EdgeInsets.only(right: 24),
    icon: const Icon(Icons.close),
    onPressed: () => context.router.maybePop(),
  );

  if (!context.mounted) return;

  String getTopBarTitle() {
    if (customer != null) {
      if (customer.company != null && customer.company!.isNotEmpty) return customer.company!;
      return customer.name;
    }

    return '';
  }

  Widget getContent() {
    if (customer == null && abstractFailure == null) return const SizedBox(height: 100, child: Center(child: MyCircularProgressIndicator()));
    if (abstractFailure != null) const SizedBox(height: 100, child: Center(child: Text('Beim laden des Kunden ist ein Fehler aufgetreten')));
    return _CustomerDetail(receiptBloc: receiptBloc, customer: customer!);
  }

  WoltModalSheet.show(
    context: context,
    useSafeArea: false,
    pageListBuilder: (woltContext) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: true,
          isTopBarLayerAlwaysVisible: true,
          topBarTitle: Text(getTopBarTitle(), style: TextStyles.h3Bold),
          trailingNavBarWidget: trailing,
          child: getContent(),
        ),
      ];
    },
  );
}

class _CustomerDetail extends StatefulWidget {
  final ReceiptBloc receiptBloc;
  final Customer customer;

  const _CustomerDetail({required this.receiptBloc, required this.customer});

  @override
  State<_CustomerDetail> createState() => __CustomerDetailState();
}

class __CustomerDetailState extends State<_CustomerDetail> {
  final customerBloc = sl<CustomerBloc>();

  Address? deliveryAddress;
  Address? invoiceAddress;
  Address? updatedDeliveryAddress;
  Address? updatedInvoiceAddress;

  late TextEditingController _deliveryCompanyNameController;
  late TextEditingController _deliveryFirstNameController;
  late TextEditingController _deliveryLastNameController;
  late TextEditingController _deliveryStreetNameController;
  late TextEditingController _deliveryStreet2NameController;
  late TextEditingController _deliveryPostcodeNameController;
  late TextEditingController _deliveryCityNameController;
  late TextEditingController _deliveryPhoneNameController;
  late TextEditingController _deliveryPhoneMobileNameController;

  Country _deliverySelectedCountry = Country.countryList.first;
  AddressType _deliveryAddressType = AddressType.delivery;
  bool _deliveryIsDefault = false;

  late TextEditingController _invoiceCompanyNameController;
  late TextEditingController _invoiceFirstNameController;
  late TextEditingController _invoiceLastNameController;
  late TextEditingController _invoiceStreetNameController;
  late TextEditingController _invoiceStreet2NameController;
  late TextEditingController _invoicePostcodeNameController;
  late TextEditingController _invoiceCityNameController;
  late TextEditingController _invoicePhoneNameController;
  late TextEditingController _invoicePhoneMobileNameController;

  Country _invoiceSelectedCountry = Country.countryList.first;
  AddressType _invoiceAddressType = AddressType.invoice;
  bool _invoiceIsDefault = false;

  bool _useAddressInReceipt = true;

  @override
  void initState() {
    super.initState();

    customerBloc.add((SetCustomerEvent(customer: widget.customer)));

    deliveryAddress = widget.customer.listOfAddress.where((e) => e.addressType == AddressType.delivery && e.isDefault).firstOrNull;
    invoiceAddress = widget.customer.listOfAddress.where((e) => e.addressType == AddressType.invoice && e.isDefault).firstOrNull;

    if (deliveryAddress != null) {
      _deliveryCompanyNameController = TextEditingController(text: deliveryAddress!.companyName);
      _deliveryFirstNameController = TextEditingController(text: deliveryAddress!.firstName);
      _deliveryLastNameController = TextEditingController(text: deliveryAddress!.lastName);
      _deliveryStreetNameController = TextEditingController(text: deliveryAddress!.street);
      _deliveryStreet2NameController = TextEditingController(text: deliveryAddress!.street2);
      _deliveryPostcodeNameController = TextEditingController(text: deliveryAddress!.postcode);
      _deliveryCityNameController = TextEditingController(text: deliveryAddress!.city);
      _deliveryPhoneNameController = TextEditingController(text: deliveryAddress!.phone);
      _deliveryPhoneMobileNameController = TextEditingController(text: deliveryAddress!.phoneMobile);

      _deliverySelectedCountry = deliveryAddress!.country;
      _deliveryAddressType = deliveryAddress!.addressType;
      _deliveryIsDefault = deliveryAddress!.isDefault;
    } else {
      _deliveryCompanyNameController = TextEditingController();
      _deliveryFirstNameController = TextEditingController();
      _deliveryLastNameController = TextEditingController();
      _deliveryStreetNameController = TextEditingController();
      _deliveryStreet2NameController = TextEditingController();
      _deliveryPostcodeNameController = TextEditingController();
      _deliveryCityNameController = TextEditingController();
      _deliveryPhoneNameController = TextEditingController();
      _deliveryPhoneMobileNameController = TextEditingController();
    }

    if (invoiceAddress != null) {
      _invoiceCompanyNameController = TextEditingController(text: invoiceAddress!.companyName);
      _invoiceFirstNameController = TextEditingController(text: invoiceAddress!.firstName);
      _invoiceLastNameController = TextEditingController(text: invoiceAddress!.lastName);
      _invoiceStreetNameController = TextEditingController(text: invoiceAddress!.street);
      _invoiceStreet2NameController = TextEditingController(text: invoiceAddress!.street2);
      _invoicePostcodeNameController = TextEditingController(text: invoiceAddress!.postcode);
      _invoiceCityNameController = TextEditingController(text: invoiceAddress!.city);
      _invoicePhoneNameController = TextEditingController(text: invoiceAddress!.phone);
      _invoicePhoneMobileNameController = TextEditingController(text: invoiceAddress!.phoneMobile);

      _invoiceSelectedCountry = invoiceAddress!.country;
      _invoiceAddressType = invoiceAddress!.addressType;
      _invoiceIsDefault = invoiceAddress!.isDefault;
    } else {
      _invoiceCompanyNameController = TextEditingController();
      _invoiceFirstNameController = TextEditingController();
      _invoiceLastNameController = TextEditingController();
      _invoiceStreetNameController = TextEditingController();
      _invoiceStreet2NameController = TextEditingController();
      _invoicePostcodeNameController = TextEditingController();
      _invoiceCityNameController = TextEditingController();
      _invoicePhoneNameController = TextEditingController();
      _invoicePhoneMobileNameController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: customerBloc,
      child: BlocListener<CustomerBloc, CustomerState>(
        bloc: customerBloc,
        listenWhen: (p, c) => p.fosCustomerOnUpdateOption != c.fosCustomerOnUpdateOption,
        listener: (context, state) {
          state.fosCustomerOnUpdateOption.fold(
            () => null,
            (a) => a.fold(
              (failure) => failureRenderer(context, [failure]),
              (updatedCustomer) {
                if (_useAddressInReceipt) {
                  widget.receiptBloc.add(OnEditAddressReceiptDetailEvent(address: updatedDeliveryAddress!));
                  widget.receiptBloc.add(OnEditAddressReceiptDetailEvent(address: updatedInvoiceAddress!));
                  widget.receiptBloc.add(OnReceiptCustomerUpdatedEvent(customer: updatedCustomer));
                  widget.receiptBloc.add(OnReceiptCustomerEmailChangedEvent(email: updatedCustomer.email));
                }

                context.router.maybePop();

                myScaffoldMessenger(context, null, null, 'Kunde wurde erfolgreich aktualisiert', null);
              },
            ),
          );
        },
        child: BlocBuilder<CustomerBloc, CustomerState>(
          bloc: customerBloc,
          builder: (context, state) {
            if (state.customer == null) return const SizedBox(height: 100, child: Center(child: MyCircularProgressIndicator()));

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CustomerMaster(customerBloc: customerBloc, state: state),
                  Gaps.h16,
                  const Text('Lieferadresse', style: TextStyles.h3BoldPrimary),

                  Gaps.h16,
                  //* Nur wenn eine neue Adresse hinzugefügt werden soll
                  if (deliveryAddress == null) ...[
                    Row(
                      children: [
                        const Text('Standardadresse:'),
                        Switch.adaptive(value: _deliveryIsDefault, onChanged: (value) => setState(() => _deliveryIsDefault = value)),
                      ],
                    ),
                    Gaps.h16,
                  ],
                  MyTextFormFieldSmall(labelText: 'Firmenname', controller: _deliveryCompanyNameController),
                  Gaps.h16,
                  Row(
                    children: [
                      Expanded(
                        child: MyTextFormFieldSmall(
                          labelText: 'Vorname',
                          controller: _deliveryFirstNameController,
                        ),
                      ),
                      Gaps.w8,
                      Expanded(
                        child: MyTextFormFieldSmall(
                          labelText: 'Nachname',
                          controller: _deliveryLastNameController,
                        ),
                      ),
                    ],
                  ),
                  Gaps.h16,

                  Row(
                    children: [
                      Expanded(
                        child: MyTextFormFieldSmall(
                          labelText: 'Straße & Hausnummer',
                          controller: _deliveryStreetNameController,
                        ),
                      ),
                      Gaps.w8,
                      Expanded(child: MyTextFormFieldSmall(labelText: '2. Straße & Hausnummer', controller: _deliveryStreet2NameController)),
                    ],
                  ),
                  Gaps.h16,
                  Row(
                    children: [
                      Expanded(
                        child: MyTextFormFieldSmall(
                          labelText: 'PLZ',
                          controller: _deliveryPostcodeNameController,
                        ),
                      ),
                      Gaps.w8,
                      Expanded(
                        child: MyTextFormFieldSmall(
                          labelText: 'Stadt',
                          controller: _deliveryCityNameController,
                        ),
                      ),
                    ],
                  ),
                  Gaps.h16,
                  Row(
                    children: [
                      Expanded(child: MyTextFormFieldSmall(labelText: 'Tel. 1:', controller: _deliveryPhoneNameController)),
                      Gaps.w8,
                      Expanded(child: MyTextFormFieldSmall(labelText: 'Tel. 2:', controller: _deliveryPhoneMobileNameController)),
                    ],
                  ),
                  Gaps.h16,

                  MyDialogSelectCountry(
                    labelText: 'Land',
                    selectedCountry: _deliverySelectedCountry.name,
                    onSelectCountry: (country) => setState(() => _deliverySelectedCountry = country),
                  ),
                  Gaps.h24,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Rechnungsadresse übernehmen:'),
                      IconButton(
                        onPressed: () => setState(() => _setControllerInvoice()),
                        icon: const Icon(Icons.arrow_downward, color: Colors.green),
                      )
                    ],
                  ),
                  Gaps.h16,
                  const Text('Rechnungsadresse', style: TextStyles.h3BoldPrimary),
                  Gaps.h16,
                  //* Nur wenn eine neue Adresse hinzugefügt werden soll
                  if (invoiceAddress == null) ...[
                    Row(
                      children: [
                        const Text('Standardadresse:'),
                        Switch.adaptive(value: _invoiceIsDefault, onChanged: (value) => setState(() => _invoiceIsDefault = value)),
                      ],
                    ),
                    Gaps.h16,
                  ],
                  MyTextFormFieldSmall(labelText: 'Firmenname', controller: _invoiceCompanyNameController),
                  Gaps.h16,
                  Row(
                    children: [
                      Expanded(
                        child: MyTextFormFieldSmall(
                          labelText: 'Vorname',
                          controller: _invoiceFirstNameController,
                        ),
                      ),
                      Gaps.w8,
                      Expanded(
                        child: MyTextFormFieldSmall(
                          labelText: 'Nachname',
                          controller: _invoiceLastNameController,
                        ),
                      ),
                    ],
                  ),
                  Gaps.h16,

                  Row(
                    children: [
                      Expanded(
                        child: MyTextFormFieldSmall(
                          labelText: 'Straße & Hausnummer',
                          controller: _invoiceStreetNameController,
                        ),
                      ),
                      Gaps.w8,
                      Expanded(child: MyTextFormFieldSmall(labelText: '2. Straße & Hausnummer', controller: _invoiceStreet2NameController)),
                    ],
                  ),
                  Gaps.h16,
                  Row(
                    children: [
                      Expanded(
                        child: MyTextFormFieldSmall(
                          labelText: 'PLZ',
                          controller: _invoicePostcodeNameController,
                        ),
                      ),
                      Gaps.w8,
                      Expanded(
                        child: MyTextFormFieldSmall(
                          labelText: 'Stadt',
                          controller: _invoiceCityNameController,
                        ),
                      ),
                    ],
                  ),
                  Gaps.h16,
                  Row(
                    children: [
                      Expanded(child: MyTextFormFieldSmall(labelText: 'Tel. 1:', controller: _invoicePhoneNameController)),
                      Gaps.w8,
                      Expanded(child: MyTextFormFieldSmall(labelText: 'Tel. 2:', controller: _invoicePhoneMobileNameController)),
                    ],
                  ),
                  Gaps.h16,

                  MyDialogSelectCountry(
                    labelText: 'Land',
                    selectedCountry: _invoiceSelectedCountry.name,
                    onSelectCountry: (country) => setState(() => _invoiceSelectedCountry = country),
                  ),
                  Gaps.h24,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Auch als Dokumentadressen übernehmen:'),
                      Checkbox.adaptive(value: _useAddressInReceipt, onChanged: (val) => setState(() => _useAddressInReceipt = val!))
                    ],
                  ),
                  Gaps.h16,
                  Align(
                    alignment: Alignment.center,
                    child: MyOutlinedButton(buttonText: 'Speichern', onPressed: _saveChanges, isLoading: state.isLoadingCustomerOnUpdate),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _setControllerInvoice() {
    _invoiceCompanyNameController = _deliveryCompanyNameController;
    _invoiceFirstNameController = _deliveryFirstNameController;
    _invoiceLastNameController = _deliveryLastNameController;
    _invoiceStreetNameController = _deliveryStreetNameController;
    _invoiceStreet2NameController = _deliveryStreet2NameController;
    _invoicePostcodeNameController = _deliveryPostcodeNameController;
    _invoiceCityNameController = _deliveryCityNameController;
    _invoicePhoneNameController = _deliveryPhoneNameController;
    _invoicePhoneMobileNameController = _deliveryPhoneMobileNameController;

    _invoiceSelectedCountry = _deliverySelectedCountry;
  }

  void _saveChanges() {
    if (_deliverySelectedCountry.name.isEmpty) {
      showMyDialogAlert(context: context, title: 'Achtung', content: 'Wähle bitte ein Land für die Lieferadresse aus');
      return;
    }

    if (_invoiceSelectedCountry.name.isEmpty) {
      showMyDialogAlert(context: context, title: 'Achtung', content: 'Wähle bitte ein Land für die Rechnungsadresse aus');
      return;
    }

    final now = DateTime.now();
    String deliveryId = UniqueID().value;
    if (deliveryAddress != null) deliveryId = deliveryAddress!.id;
    DateTime deliveryCreationDate = now;
    if (deliveryAddress != null) deliveryCreationDate = deliveryAddress!.creationDate;
    updatedDeliveryAddress = Address(
      id: deliveryId,
      companyName: _deliveryCompanyNameController.text,
      firstName: _deliveryFirstNameController.text,
      lastName: _deliveryLastNameController.text,
      street: _deliveryStreetNameController.text,
      street2: _deliveryStreet2NameController.text,
      postcode: _deliveryPostcodeNameController.text,
      city: _deliveryCityNameController.text,
      country: _deliverySelectedCountry,
      phone: _deliveryPhoneNameController.text,
      phoneMobile: _deliveryPhoneMobileNameController.text,
      addressType: AddressType.delivery,
      isDefault: _deliveryIsDefault,
      creationDate: deliveryCreationDate,
      lastEditingDate: now,
    );
    if (updatedDeliveryAddress != null) customerBloc.add(OnAddEditCustomerAddressEvent(address: updatedDeliveryAddress!));

    String invoiceId = UniqueID().value;
    if (invoiceAddress != null) invoiceId = invoiceAddress!.id;
    DateTime invoiceCreationDate = now;
    if (invoiceAddress != null) invoiceCreationDate = invoiceAddress!.creationDate;
    updatedInvoiceAddress = Address(
      id: invoiceId,
      companyName: _invoiceCompanyNameController.text,
      firstName: _invoiceFirstNameController.text,
      lastName: _invoiceLastNameController.text,
      street: _invoiceStreetNameController.text,
      street2: _invoiceStreet2NameController.text,
      postcode: _invoicePostcodeNameController.text,
      city: _invoiceCityNameController.text,
      country: _invoiceSelectedCountry,
      phone: _invoicePhoneNameController.text,
      phoneMobile: _invoicePhoneMobileNameController.text,
      addressType: AddressType.invoice,
      isDefault: _invoiceIsDefault,
      creationDate: invoiceCreationDate,
      lastEditingDate: now,
    );

    if (updatedInvoiceAddress != null) customerBloc.add(OnAddEditCustomerAddressEvent(address: updatedInvoiceAddress!));

    if (updatedDeliveryAddress != null && updatedInvoiceAddress != null) customerBloc.add(UpdateCustomerEvent());
  }
}

class _CustomerMaster extends StatelessWidget {
  final CustomerBloc customerBloc;
  final CustomerState state;

  const _CustomerMaster({required this.customerBloc, required this.state});

  @override
  Widget build(BuildContext context) {
    final invoiceTypeValue = switch (state.customer!.customerInvoiceType) {
      CustomerInvoiceType.standardInvoice => 'Stand- Einzelrechnung',
      CustomerInvoiceType.collectiveInvoice => 'Sammelrechnung',
    };

    final invoiceTypeItems = ['Stand- Einzelrechnung', 'Sammelrechnung'];

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MyTextFormFieldSmall(
                readOnly: true,
                labelText: 'Kundennummer',
                hintText: state.customer!.customerNumber.toString(),
              ),
            ),
            Gaps.w8,
            Expanded(
              child: MyTextFormFieldSmall(
                labelText: 'Firmenname',
                controller: state.companyNameController,
                onChanged: (_) => customerBloc.add(OnCustomerControllerChangedEvent()),
              ),
            ),
          ],
        ),
        Gaps.h8,
        Row(
          children: [
            Expanded(
              child: MyTextFormFieldSmall(
                labelText: 'Vorname',
                controller: state.firstNameController,
                onChanged: (_) => customerBloc.add(OnCustomerControllerChangedEvent()),
              ),
            ),
            Gaps.w8,
            Expanded(
              child: MyTextFormFieldSmall(
                labelText: 'Nachname',
                controller: state.lastNameController,
                onChanged: (_) => customerBloc.add(OnCustomerControllerChangedEvent()),
              ),
            ),
          ],
        ),
        Gaps.h8,
        MyTextFormFieldSmall(
          labelText: 'E-Mail',
          controller: state.emailController,
          onChanged: (_) => customerBloc.add(OnCustomerControllerChangedEvent()),
        ),
        Gaps.h8,
        Row(
          children: [
            Expanded(
              child: MyTextFormFieldSmall(
                labelText: 'Telefonnummer',
                controller: state.phoneController,
                onChanged: (_) => customerBloc.add(OnCustomerControllerChangedEvent()),
              ),
            ),
            Gaps.w8,
            Expanded(
              child: MyTextFormFieldSmall(
                labelText: 'Telefonnummer Mobil',
                controller: state.phoneMobileController,
                onChanged: (_) => customerBloc.add(OnCustomerControllerChangedEvent()),
              ),
            ),
          ],
        ),
        Gaps.h8,
        Row(
          children: [
            Expanded(
              child: MyTextFormFieldSmall(
                labelText: 'UID-Nummer',
                controller: state.uidNumberController,
                onChanged: (_) => customerBloc.add(OnCustomerControllerChangedEvent()),
              ),
            ),
            Gaps.w8,
            Expanded(
              child: MyTextFormFieldSmall(
                labelText: 'Steuernummer',
                controller: state.taxNumberController,
                onChanged: (_) => customerBloc.add(OnCustomerControllerChangedEvent()),
              ),
            ),
          ],
        ),
        Gaps.h16,
        MyDropdownButtonSmall(
          value: invoiceTypeValue,
          onChanged: (type) => customerBloc.add(OnCustomerInvoiceTypeChangedEvent(
            customerInvoiceType: switch (type!) {
              'Stand- Einzelrechnung' => CustomerInvoiceType.standardInvoice,
              'Sammelrechnung' => CustomerInvoiceType.collectiveInvoice,
              _ => throw Error,
            },
          )),
          items: invoiceTypeItems,
        ),
        Gaps.h16,
        GestureDetector(
          onTap: () => showDialog(
            context: context,
            builder: (_) => MyDialogTaxes(onChanged: (taxRule) => customerBloc.add(SetCustomerTaxEvent(tax: taxRule))),
          ),
          child: MyButtonSmall(
            child: Row(
              children: [
                MyCountryFlag(country: state.customer!.tax.country),
                Gaps.w8,
                Text(
                  state.customer!.tax.taxName,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        Gaps.h16,
      ],
    );
  }
}
