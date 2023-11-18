import 'dart:io';

import 'package:cezeri_commerce/1_presentation/core/widgets/my_avatar.dart';
import 'package:cezeri_commerce/1_presentation/core/widgets/my_dialog_countries.dart';
import 'package:cezeri_commerce/1_presentation/core/widgets/my_outlined_button.dart';
import 'package:cezeri_commerce/1_presentation/core/widgets/my_text_form_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../../../../2_application/firebase/marketplace/marketplace_bloc.dart';
import '../../../../3_domain/entities/address.dart';
import '../../../../3_domain/entities/country.dart';
import '../../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../../3_domain/entities/marketplace/marketplace_settings.dart';
import '../../../../3_domain/entities/settings/bank_details.dart';
import '../../../../constants.dart';
import '../../../core/widgets/my_modal_scrollable.dart';

// TODO: PaymentMethod muss von hier aus gemappt werden können.

class AddEditMarketplace extends StatefulWidget {
  final MarketplaceBloc marketplaceBloc;
  final Marketplace? marketplace;

  const AddEditMarketplace({super.key, required this.marketplaceBloc, required this.marketplace});

  @override
  State<AddEditMarketplace> createState() => _AddEditMarketplaceState();
}

class _AddEditMarketplaceState extends State<AddEditMarketplace> {
  bool _isActive = false;
  File? _imageFile;

  Country _country = Country.countryList.where((e) => e.name == 'Österreich').first;

  late TextEditingController _nameController;
  late TextEditingController _shortNameController;
  late TextEditingController _keyController;
  late TextEditingController _endpointUrlController;
  late TextEditingController _urlController;
  late TextEditingController _shopSuffixController;

  late TextEditingController _nextIdToImportController;

  late TextEditingController _statusIdAfterImportController;
  late TextEditingController _statusIdAfterShippingController;
  late TextEditingController _statusIdAfterCancellationController;
  late TextEditingController _statusIdAfterDeleteController;

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
      _country = widget.marketplace!.address.country.name != ''
          ? widget.marketplace!.address.country
          : Country.countryList.where((e) => e.name == 'Österreich').first;
      _nameController = TextEditingController(text: widget.marketplace!.name);
      _shortNameController = TextEditingController(text: widget.marketplace!.shortName);
      _keyController = TextEditingController(text: widget.marketplace!.key);
      _endpointUrlController = TextEditingController(text: widget.marketplace!.endpointUrl);
      _urlController = TextEditingController(text: widget.marketplace!.url);
      _shopSuffixController = TextEditingController(text: widget.marketplace!.shopSuffix);
      _nextIdToImportController = TextEditingController(text: widget.marketplace!.marketplaceSettings.nextIdToImport.toString());
      _statusIdAfterImportController = TextEditingController(text: widget.marketplace!.marketplaceSettings.statusIdAfterImport.toString());
      _statusIdAfterShippingController = TextEditingController(text: widget.marketplace!.marketplaceSettings.statusIdAfterShipping.toString());
      _statusIdAfterCancellationController =
          TextEditingController(text: widget.marketplace!.marketplaceSettings.statusIdAfterCancellation.toString());
      _statusIdAfterDeleteController = TextEditingController(text: widget.marketplace!.marketplaceSettings.statusIdAfterDelete.toString());
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
      _nameController = TextEditingController();
      _shortNameController = TextEditingController();
      _keyController = TextEditingController();
      _endpointUrlController = TextEditingController(text: 'https://');
      _urlController = TextEditingController();
      _shopSuffixController = TextEditingController(text: 'api/');
      _nextIdToImportController = TextEditingController();
      _statusIdAfterImportController = TextEditingController();
      _statusIdAfterShippingController = TextEditingController();
      _statusIdAfterCancellationController = TextEditingController();
      _statusIdAfterDeleteController = TextEditingController();
      _statusIdAfterDeleteController = TextEditingController();
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketplaceBloc, MarketplaceState>(
      builder: (context, state) {
        return MyModalScrollable(
          title: widget.marketplace == null ? 'Neuer Marktplatz' : widget.marketplace!.name,
          keyboardDismiss: KeyboardDissmiss.onTab,
          children: [
            Form(
              child: Column(
                children: [
                  Gaps.h10,
                  SizedBox(
                    height: 200,
                    child: MyAvatar(
                      name: _shortNameController.text,
                      file: _imageFile,
                      radius: 100,
                      shape: BoxShape.rectangle,
                      fit: BoxFit.scaleDown,
                      fontSize: 60,
                      imageUrl: widget.marketplace?.logoUrl,
                      onTap: () async => await _pickFile(ImageSource.gallery),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Prestashop', style: TextStyles.h2),
                      Switch.adaptive(value: _isActive, onChanged: (value) => setState(() => _isActive = value)),
                    ],
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
                      const Text('Webservice Schlüssel', style: TextStyles.infoOnTextField),
                      Gaps.h10,
                      MyTextFormField(
                        controller: _keyController,
                        labelText: 'Schlüssel:',
                      ),
                      Gaps.h10,
                      const Text('http:// oder https://', style: TextStyles.infoOnTextField),
                      Gaps.h10,
                      MyTextFormField(
                        controller: _endpointUrlController,
                        labelText: 'Endpunkt URL:',
                      ),
                      Gaps.h10,
                      const Text('sampleurl.com/', style: TextStyles.infoOnTextField),
                      Gaps.h10,
                      MyTextFormField(
                        controller: _urlController,
                        labelText: 'URL:',
                      ),
                      Gaps.h10,
                      const Text('z.B.: api/', style: TextStyles.infoOnTextField),
                      Gaps.h10,
                      MyTextFormField(
                        controller: _shopSuffixController,
                        labelText: 'API Suffix:',
                      ),
                      Gaps.h10,
                      const Text('Nächste Auftrags-Id zum Importieren:', style: TextStyles.infoOnTextField),
                      Gaps.h10,
                      MyTextFormField(
                        controller: _nextIdToImportController,
                        labelText: 'Auftrags-Id:',
                      ),
                      const Divider(height: 50),
                      Row(
                        children: [
                          Expanded(child: MyTextFormField(labelText: 'Auftrags-Id nach Import', controller: _statusIdAfterImportController)),
                          Gaps.w16,
                          Expanded(child: MyTextFormField(labelText: 'Auftrags-Id nach Versand', controller: _statusIdAfterShippingController)),
                        ],
                      ),
                      Gaps.h16,
                      Row(
                        children: [
                          Expanded(
                              child: MyTextFormField(labelText: 'Auftrags-Id nach Stornierung', controller: _statusIdAfterCancellationController)),
                          Gaps.w16,
                          Expanded(child: MyTextFormField(labelText: 'Auftrags-Id nach Löschung', controller: _statusIdAfterDeleteController)),
                        ],
                      ),
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
                          key: _keyController.text,
                          isActive: _isActive,
                          endpointUrl: _endpointUrlController.text,
                          url: _urlController.text,
                          shopSuffix: _shopSuffixController.text,
                          fullUrl: _endpointUrlController.text + _urlController.text + _shopSuffixController.text,
                          marketplaceSettings: widget.marketplace!.marketplaceSettings.copyWith(
                            nextIdToImport: int.parse(_nextIdToImportController.text),
                            statusIdAfterImport: int.parse(_statusIdAfterImportController.text),
                            statusIdAfterShipping: int.parse(_statusIdAfterShippingController.text),
                            statusIdAfterCancellation: int.parse(_statusIdAfterCancellationController.text),
                            statusIdAfterDelete: int.parse(_statusIdAfterDeleteController.text),
                          ),
                          address: widget.marketplace!.address.copyWith(
                            companyName: _companyNameController.text,
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            name: '${_firstNameController.text} ${_lastNameController.text}',
                            street: _streetController.text,
                            street2: _street2Controller.text,
                            postcode: _postcodeController.text,
                            city: _cityController.text,
                            country: _country,
                            phone: _phoneController.text,
                            phoneMobile: _phoneMobileController.text,
                          ),
                          bankDetails: BankDetails(
                            _bankNameController.text,
                            _bankIbanController.text,
                            _bankBicController.text,
                            _paypalEmailController.text,
                          ),
                          lastEditingDate: DateTime.now(),
                        );
                        context.read<MarketplaceBloc>().add(UpdateMarketplaceEvent(marketplace: updatedMarketplace, imageFile: _imageFile));
                      } else {
                        final newMarketplace = Marketplace.empty().copyWith(
                          name: _nameController.text,
                          shortName: _shortNameController.text,
                          key: _keyController.text,
                          isActive: _isActive,
                          endpointUrl: _endpointUrlController.text,
                          url: _urlController.text,
                          shopSuffix: _shopSuffixController.text,
                          fullUrl: _endpointUrlController.text + _urlController.text + _shopSuffixController.text,
                          marketplaceSettings: MarketplaceSettings.empty().copyWith(
                            nextIdToImport: int.parse(_nextIdToImportController.text),
                            statusIdAfterImport: int.parse(_statusIdAfterImportController.text),
                            statusIdAfterShipping: int.parse(_statusIdAfterShippingController.text),
                            statusIdAfterCancellation: int.parse(_statusIdAfterCancellationController.text),
                            statusIdAfterDelete: int.parse(_statusIdAfterDeleteController.text),
                          ),
                          address: Address.empty().copyWith(
                            companyName: _companyNameController.text,
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            name: '${_firstNameController.text} ${_lastNameController.text}',
                            street: _streetController.text,
                            street2: _street2Controller.text,
                            postcode: _postcodeController.text,
                            city: _cityController.text,
                            country: _country,
                            phone: _phoneController.text,
                            phoneMobile: _phoneMobileController.text,
                          ),
                          bankDetails: BankDetails(
                            _bankNameController.text,
                            _bankIbanController.text,
                            _bankBicController.text,
                            _paypalEmailController.text,
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
          ],
        );
      },
    );
  }

  Future<void> _pickFile(ImageSource imageSource) async {
    final logger = Logger();
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result == null) return;

      setState(() => _imageFile = File(result.files.single.path!));
    } on PlatformException catch (e) {
      logger.e('Fehler: $e');
    }
  }
}
