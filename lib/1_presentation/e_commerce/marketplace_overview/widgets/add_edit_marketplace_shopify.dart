import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../2_application/database/marketplace/marketplace_bloc.dart';
import '../../../../3_domain/entities/address.dart';
import '../../../../3_domain/entities/country.dart';
import '../../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../../3_domain/entities/marketplace/marketplace_settings.dart';
import '../../../../3_domain/entities/marketplace/marketplace_shopify.dart';
import '../../../../3_domain/entities/settings/bank_details.dart';
import '../../../../4_infrastructur/repositories/shopify_api/api/shopify_api.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

class AddEditMarketplaceShopify extends StatefulWidget {
  final MarketplaceBloc marketplaceBloc;
  final MarketplaceShopify? marketplace;

  const AddEditMarketplaceShopify({super.key, required this.marketplaceBloc, required this.marketplace});

  @override
  State<AddEditMarketplaceShopify> createState() => _AddEditMarketplaceShopifyState();
}

class _AddEditMarketplaceShopifyState extends State<AddEditMarketplaceShopify> {
  bool _isActive = false;
  DateTime _lastImportDateTime = DateTime.now();
  File? _imageFile;

  Country _country = Country.countryList.where((e) => e.name == 'Österreich').first;

  late TextEditingController _nameController;
  late TextEditingController _shortNameController;
  late TextEditingController _urlController;
  late TextEditingController _endpointUrlController;
  late TextEditingController _storeNameController;
  late TextEditingController _adminAccessTokenController;
  late TextEditingController _storefrontAccessTokenController;
  late TextEditingController _shopSuffixController;

  late TextEditingController _nextIdToImportController;

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
      _lastImportDateTime = widget.marketplace!.marketplaceSettings.lastImportDateTime;
      _country = widget.marketplace!.address.country.name != ''
          ? widget.marketplace!.address.country
          : Country.countryList.where((e) => e.name == 'Österreich').first;
      _nameController = TextEditingController(text: widget.marketplace!.name);
      _shortNameController = TextEditingController(text: widget.marketplace!.shortName);
      _urlController = TextEditingController(text: widget.marketplace!.url);
      _endpointUrlController = TextEditingController(text: widget.marketplace!.endpointUrl);
      _storeNameController = TextEditingController(text: widget.marketplace!.storeName);
      _adminAccessTokenController = TextEditingController(text: widget.marketplace!.adminAccessToken);
      _storefrontAccessTokenController = TextEditingController(text: widget.marketplace!.storefrontAccessToken);
      _shopSuffixController = TextEditingController(text: widget.marketplace!.shopSuffix);
      _nextIdToImportController = TextEditingController(text: widget.marketplace!.marketplaceSettings.nextIdToImport.toString());
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
      _lastImportDateTime = DateTime.now();
      _nameController = TextEditingController();
      _shortNameController = TextEditingController();
      _urlController = TextEditingController();
      _endpointUrlController = TextEditingController(text: 'https://');
      _storeNameController = TextEditingController();
      _adminAccessTokenController = TextEditingController();
      _storefrontAccessTokenController = TextEditingController();
      _shopSuffixController = TextEditingController(text: 'admin/');
      _nextIdToImportController = TextEditingController();
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
                          child: SvgPicture.asset(getMarketplaceLogoAsset(MarketplaceType.shopify)),
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
                SizedBox(height: 30, child: SvgPicture.asset(getMarketplaceFontAsset(MarketplaceType.shopify), fit: BoxFit.fitWidth)),
                Gaps.h24,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Aktiv:', style: TextStyles.h2),
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
                    MyTextFormField(
                      controller: _urlController,
                      labelText: 'Marktplatz URL:',
                    ),
                    Gaps.h10,
                    MyTextFormField(
                      controller: _storeNameController,
                      labelText: 'Shop Name:',
                    ),
                    Gaps.h10,
                    MyTextFormField(
                      controller: _adminAccessTokenController,
                      labelText: 'Admin-API-Zugriffstoken:',
                    ),
                    Gaps.h10,
                    MyTextFormField(
                      controller: _storefrontAccessTokenController,
                      labelText: 'API-Schlüssel:',
                    ),
                    Gaps.h10,
                    const Text('http:// oder https://', style: TextStyles.infoOnTextField),
                    Gaps.h10,
                    MyTextFormField(
                      controller: _endpointUrlController,
                      labelText: 'Endpunkt URL:',
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
                    Gaps.h10,
                    const Text('Zuletzt importiert am:', style: TextStyles.infoOnTextField),
                    TextButton(
                      onPressed: () async => await _pickLastImportDateTime(),
                      child: Text(DateFormat('dd.MM.yyy - HH:mm:ss', 'de').format(_lastImportDateTime)),
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
                        url: _urlController.text,
                        isActive: _isActive,
                        endpointUrl: _endpointUrlController.text,
                        storeName: _storeNameController.text,
                        adminAccessToken: _adminAccessTokenController.text,
                        storefrontAccessToken: _storefrontAccessTokenController.text,
                        shopSuffix: _shopSuffixController.text,
                        marketplaceSettings: widget.marketplace!.marketplaceSettings.copyWith(
                          nextIdToImport: int.parse(_nextIdToImportController.text),
                          lastImportDateTime: _lastImportDateTime,
                        ),
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
                      final newMarketplace = MarketplaceShopify.empty().copyWith(
                        name: _nameController.text,
                        shortName: _shortNameController.text,
                        url: _urlController.text,
                        isActive: _isActive,
                        endpointUrl: _endpointUrlController.text,
                        storeName: _storeNameController.text,
                        adminAccessToken: _adminAccessTokenController.text,
                        storefrontAccessToken: _storefrontAccessTokenController.text,
                        shopSuffix: _shopSuffixController.text,
                        marketplaceSettings: MarketplaceSettings.empty().copyWith(
                          nextIdToImport: int.parse(_nextIdToImportController.text),
                          lastImportDateTime: _lastImportDateTime,
                        ),
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
                Gaps.h24,
                MyOutlinedButton(
                  buttonText: 'Test',
                  buttonBackgroundColor: Colors.red,
                  isLoading: state.isLoadingMarketplaceOnDelete,
                  onPressed: () async => await checkAccessScopes(),
                ),
                Text(
                    '${_endpointUrlController.text}${_storeNameController.text}.myShopify.com/${_shopSuffixController.text}oauth/access_scopes.json'),
                if (widget.marketplace != null) Text(widget.marketplace!.fullUrl),
                Gaps.h10,
                MyOutlinedButton(
                  buttonText: 'Test Order',
                  buttonBackgroundColor: Colors.red,
                  isLoading: state.isLoadingMarketplaceOnDelete,
                  onPressed: () async => await _getOrder(),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> checkAccessScopes() async {
    final String url =
        '${_endpointUrlController.text}${_storeNameController.text}.myShopify.com/${_shopSuffixController.text}oauth/access_scopes.json';
    final String authHeader = base64Encode(utf8.encode('${_storefrontAccessTokenController.text}:${_adminAccessTokenController.text}'));

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Basic $authHeader',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      // Verarbeitung der Antwort, z.B. Überprüfung spezifischer Scopes
    } else {
      throw Exception('Failed to connect to Shopify');
    }
  }

  Future<void> _getOrder() async {
    final phUrl = '${_endpointUrlController.text}${_storeNameController.text}.myShopify.com/${_shopSuffixController.text}';
    final url = phUrl.substring(0, phUrl.length - 1);
    final api = ShopifyApi(
      ShopifyApiConfig(storefrontToken: _storefrontAccessTokenController.text, adminToken: _adminAccessTokenController.text),
      url,
    );

    final order = await api.getOrdersByCreatedAtMin(_lastImportDateTime);
    print('---------------- ORDER ----------------');
    print(order);
    print('---------------- ORDER ----------------');
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

  Future<void> _pickLastImportDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    pickedDate ??= _lastImportDateTime;

    if (!mounted) return;
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    pickedTime ??= TimeOfDay(hour: _lastImportDateTime.hour, minute: _lastImportDateTime.minute);

    setState(() {
      _lastImportDateTime = DateTime(
        pickedDate!.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime!.hour,
        pickedTime.minute,
      );
    });
  }
}
