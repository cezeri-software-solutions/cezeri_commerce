import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../2_application/database/marketplace/marketplace_bloc.dart';
import '../../../../3_domain/entities/address.dart';
import '../../../../3_domain/entities/country.dart';
import '../../../../3_domain/entities/customer/customer.dart';
import '../../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../../3_domain/entities/marketplace/marketplace_shop.dart';
import '../../../../3_domain/entities/settings/bank_details.dart';
import '../../../../3_domain/repositories/database/customer_repository.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

class AddEditMarketplaceShop extends StatefulWidget {
  final MarketplaceBloc marketplaceBloc;
  final MarketplaceShop? marketplace;

  const AddEditMarketplaceShop({super.key, required this.marketplaceBloc, this.marketplace});

  @override
  State<AddEditMarketplaceShop> createState() => _AddEditMarketplaceShopState();
}

class _AddEditMarketplaceShopState extends State<AddEditMarketplaceShop> {
  bool _isActive = false;
  File? _imageFile;
  String? _defaultCustomerId;
  Customer? _defaultCustomer;

  Country _country = Country.countryList.where((e) => e.name == 'Österreich').first;

  late TextEditingController _nameController;
  late TextEditingController _shortNameController;

  late TextEditingController _companyNameController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _streetController;
  late TextEditingController _street2Controller;
  late TextEditingController _postcodeController;
  late TextEditingController _cityController;
  late TextEditingController _phoneController;
  late TextEditingController _phoneMobileController;

  late TextEditingController _bankNameController;
  late TextEditingController _bankIbanController;
  late TextEditingController _bankBicController;
  late TextEditingController _paypalEmailController;

  @override
  void initState() {
    super.initState();

    if (widget.marketplace != null) {
      _isActive = widget.marketplace!.isActive;
      _defaultCustomerId = widget.marketplace!.defaultCustomerId;
      _country = widget.marketplace!.address.country.name != ''
          ? widget.marketplace!.address.country
          : Country.countryList.where((e) => e.name == 'Österreich').first;
      _nameController = TextEditingController(text: widget.marketplace!.name);
      _shortNameController = TextEditingController(text: widget.marketplace!.shortName);
      _companyNameController = TextEditingController(text: widget.marketplace!.address.companyName);
      _firstNameController = TextEditingController(text: widget.marketplace!.address.firstName);
      _lastNameController = TextEditingController(text: widget.marketplace!.address.lastName);
      _streetController = TextEditingController(text: widget.marketplace!.address.street);
      _street2Controller = TextEditingController(text: widget.marketplace!.address.street2);
      _postcodeController = TextEditingController(text: widget.marketplace!.address.postcode);
      _cityController = TextEditingController(text: widget.marketplace!.address.city);
      _phoneController = TextEditingController(text: widget.marketplace!.address.phone);
      _phoneMobileController = TextEditingController(text: widget.marketplace!.address.phoneMobile);
      _bankNameController = TextEditingController(text: widget.marketplace!.bankDetails.bankName);
      _bankIbanController = TextEditingController(text: widget.marketplace!.bankDetails.bankIban);
      _bankBicController = TextEditingController(text: widget.marketplace!.bankDetails.bankBic);
      _paypalEmailController = TextEditingController(text: widget.marketplace!.bankDetails.paypalEmail);
    } else {
      _isActive = false;
      _defaultCustomerId = null;
      _nameController = TextEditingController();
      _shortNameController = TextEditingController();
      _companyNameController = TextEditingController();
      _firstNameController = TextEditingController();
      _lastNameController = TextEditingController();
      _streetController = TextEditingController();
      _street2Controller = TextEditingController();
      _postcodeController = TextEditingController();
      _cityController = TextEditingController();
      _phoneController = TextEditingController();
      _phoneMobileController = TextEditingController();
      _bankNameController = TextEditingController();
      _bankIbanController = TextEditingController();
      _bankBicController = TextEditingController();
      _paypalEmailController = TextEditingController();
    }

    if (_defaultCustomerId != null) _getDefaultCustomer();
  }

  @override
  Widget build(BuildContext context) {
    if (_defaultCustomerId != null && _defaultCustomer == null) return const Center(child: MyCircularProgressIndicator());

    return BlocBuilder<MarketplaceBloc, MarketplaceState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            child: Column(
              children: [
                Gaps.h10,
                SizedBox(
                  height: 160,
                  child: _imageFile == null && (widget.marketplace == null || (widget.marketplace != null && widget.marketplace!.logoUrl == ''))
                      ? InkWell(
                          onTap: () async => await _pickFile(ImageSource.gallery),
                          child: SvgPicture.asset(getMarketplaceLogoAsset(MarketplaceType.shop)),
                        )
                      : MyAvatar(
                          name: _shortNameController.text,
                          file: _imageFile,
                          radius: 80,
                          shape: BoxShape.rectangle,
                          fit: BoxFit.scaleDown,
                          fontSize: 60,
                          imageUrl: widget.marketplace?.logoUrl,
                          onTap: () async => await _pickFile(ImageSource.gallery),
                        ),
                ),
                Gaps.h24,
                SizedBox(height: 30, child: SvgPicture.asset(getMarketplaceFontAsset(MarketplaceType.shop))),
                Gaps.h24,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Aktiv:', style: TextStyles.h2),
                    Switch.adaptive(value: _isActive, onChanged: (value) => setState(() => _isActive = value)),
                  ],
                ),
                Gaps.h16,
                _DefaultCustomer(
                  defaultCustomer: _defaultCustomer,
                  defaultCustomerId: _defaultCustomerId,
                  setSelectedCustomer: (customer) {
                    setState(() {
                      _defaultCustomer = customer;
                      _defaultCustomerId = customer.id;
                    });
                  },
                ),
                Gaps.h16,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Beliebiger Name', style: TextStyles.infoOnTextField),
                    Gaps.h10,
                    MyTextFormField(
                      controller: _nameController,
                      labelText: 'Marktplatz Name:',
                    ),
                    Gaps.h10,
                    const Text('Marktplatz Kürzel aus max. 3 Zeichen', style: TextStyles.infoOnTextField),
                    Gaps.h10,
                    MyTextFormField(
                      controller: _shortNameController,
                      labelText: 'Marktplatz Kürzel:',
                    ),
                    Gaps.h10,
                    const Divider(height: 50),
                    MyTextFormField(labelText: 'Firmenname', controller: _companyNameController),
                    Gaps.h16,
                    MyTextFormField(labelText: 'Vorname', controller: _firstNameController),
                    Gaps.h16,
                    MyTextFormField(labelText: 'Nachname', controller: _lastNameController),
                    Gaps.h16,
                    MyTextFormField(labelText: 'Straße & Hausnummer', controller: _streetController),
                    Gaps.h16,
                    MyTextFormField(labelText: 'Straße & Hausnummer 2', controller: _street2Controller),
                    Gaps.h16,
                    MyTextFormField(labelText: 'Postleitzahl', controller: _postcodeController),
                    Gaps.h16,
                    MyTextFormField(labelText: 'Stadt', controller: _cityController),
                    Gaps.h16,
                    MyDialogSelectCountry(
                      labelText: 'Land wählen',
                      selectedCountry: _country.name,
                      onSelectCountry: (country) => setState(() => _country = country),
                    ),
                    Gaps.h16,
                    MyTextFormField(labelText: 'Telefonnummer', controller: _phoneController),
                    Gaps.h16,
                    MyTextFormField(labelText: 'Mobile Telefonnummer', controller: _phoneMobileController),
                    const Divider(height: 50),
                    MyTextFormField(labelText: 'Bankname', controller: _bankNameController),
                    Gaps.h16,
                    MyTextFormField(labelText: 'IBAN', controller: _bankIbanController),
                    Gaps.h16,
                    MyTextFormField(labelText: 'BIC', controller: _bankBicController),
                    Gaps.h16,
                    MyTextFormField(labelText: 'PayPal E-Mail', controller: _paypalEmailController),
                    Gaps.h16,
                    const Divider(height: 50),
                    Gaps.h16,
                  ],
                ),
                MyOutlinedButton(
                  buttonText: 'Speichern',
                  isLoading: state.isLoadingMarketplaceOnCreate || state.isLoadingMarketplaceOnUpdate,
                  onPressed: () {
                    if (widget.marketplace != null) {
                      final updatedMarketplace = widget.marketplace!.copyWith(
                        name: _nameController.text,
                        shortName: _shortNameController.text,
                        isActive: _isActive,
                        defaultCustomerId: _defaultCustomerId,
                        address: widget.marketplace!.address.copyWith(
                          companyName: _companyNameController.text,
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          street: _streetController.text,
                          street2: _street2Controller.text,
                          postcode: _postcodeController.text,
                          city: _cityController.text,
                          country: _country,
                          phone: _phoneController.text,
                          phoneMobile: _phoneMobileController.text,
                        ),
                        bankDetails: BankDetails(
                          bankName: _bankNameController.text,
                          bankIban: _bankIbanController.text,
                          bankBic: _bankBicController.text,
                          paypalEmail: _paypalEmailController.text,
                        ),
                        lastEditingDate: DateTime.now(),
                      );
                      context.read<MarketplaceBloc>().add(UpdateMarketplaceEvent(marketplace: updatedMarketplace, imageFile: _imageFile));
                    } else {
                      final newMarketplace = MarketplaceShop.empty().copyWith(
                        name: _nameController.text,
                        shortName: _shortNameController.text,
                        isActive: _isActive,
                        defaultCustomerId: _defaultCustomerId,
                        address: Address.empty().copyWith(
                          companyName: _companyNameController.text,
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          street: _streetController.text,
                          street2: _street2Controller.text,
                          postcode: _postcodeController.text,
                          city: _cityController.text,
                          country: _country,
                          phone: _phoneController.text,
                          phoneMobile: _phoneMobileController.text,
                        ),
                        bankDetails: BankDetails(
                          bankName: _bankNameController.text,
                          bankIban: _bankIbanController.text,
                          bankBic: _bankBicController.text,
                          paypalEmail: _paypalEmailController.text,
                        ),
                        lastEditingDate: DateTime.now(),
                        createnDate: DateTime.now(),
                      );
                      context.read<MarketplaceBloc>().add(CreateMarketplaceEvent(marketplace: newMarketplace, imageFile: _imageFile));
                    }
                  },
                ),
                if (widget.marketplace != null) ...[
                  Gaps.h24,
                  MyOutlinedButton(
                    buttonText: 'Löschen',
                    buttonBackgroundColor: Colors.red,
                    isLoading: state.isLoadingMarketplaceOnDelete,
                    // TODO: Dialog zum Bestätigen vom Löschvorgang hinzufügen
                    onPressed: () => context.read<MarketplaceBloc>().add(DeleteMarketplaceEvent(id: widget.marketplace!.id)),
                  ),
                ],
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickFile(ImageSource imageSource) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result == null) return;

      setState(() => _imageFile = File(result.files.single.path!));
    } on PlatformException catch (e) {
      logger.e('Fehler: $e');
    }
  }

  void _getDefaultCustomer() async {
    final customerRepository = GetIt.I<CustomerRepository>();

    final fosDefaultCustomer = await customerRepository.getCustomer(_defaultCustomerId!);
    if (fosDefaultCustomer.isRight()) {
      final defaultCustomer = fosDefaultCustomer.getRight();

      setState(() {
        _defaultCustomer = defaultCustomer;
        _defaultCustomerId = defaultCustomer.id;
      });
    }
  }
}

class _DefaultCustomer extends StatelessWidget {
  final Customer? defaultCustomer;
  final String? defaultCustomerId;
  final void Function(Customer) setSelectedCustomer;

  const _DefaultCustomer({required this.defaultCustomer, required this.defaultCustomerId, required this.setSelectedCustomer});

  @override
  Widget build(BuildContext context) {
    void onIconButtonPressed() async {
      final selectedCustomer = await showSelectCustomerSheet(context);
      if (selectedCustomer != null) setSelectedCustomer(selectedCustomer);
    }

    const titleWidget = Text('Standartkunde:', style: TextStyles.infoOnTextField);

    const style = TextStyle(fontWeight: FontWeight.bold);

    if (defaultCustomer != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget,
              Gaps.h10,
              if (defaultCustomer!.company != null && defaultCustomer!.company!.isNotEmpty) Text(defaultCustomer!.company!, style: style),
              if (defaultCustomer!.name.isNotEmpty) Text(defaultCustomer!.name, style: style),
              if ((defaultCustomer!.company == null && defaultCustomer!.name.isEmpty) ||
                  ((defaultCustomer!.company != null && defaultCustomer!.company!.isEmpty) && defaultCustomer!.name.isEmpty))
                const Text('Der Standartkunde hat weder einen Namen, noch einen Firmennamen', style: style),
            ],
          ),
          IconButton(onPressed: onIconButtonPressed, icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary)),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gaps.h10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleWidget,
                Text('Standartkunde auswählen'),
              ],
            ),
            IconButton(onPressed: onIconButtonPressed, icon: const Icon(Icons.add, color: Colors.green)),
          ],
        ),
      ],
    );
  }
}
