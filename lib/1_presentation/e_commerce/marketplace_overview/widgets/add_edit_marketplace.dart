import 'dart:io';

import 'package:cezeri_commerce/1_presentation/core/widgets/my_avatar.dart';
import 'package:cezeri_commerce/1_presentation/core/widgets/my_outlined_button.dart';
import 'package:cezeri_commerce/1_presentation/core/widgets/my_text_form_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../../../../2_application/firebase/marketplace/marketplace_bloc.dart';
import '../../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../../3_domain/entities/marketplace/marketplace_settings.dart';
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

  late TextEditingController _nameController;
  late TextEditingController _shortNameController;
  late TextEditingController _keyController;
  late TextEditingController _endpointUrlController;
  late TextEditingController _urlController;
  late TextEditingController _shopSuffixController;

  late TextEditingController _nextIdToImportController;

  @override
  void initState() {
    super.initState();

    if (widget.marketplace != null) {
      _isActive = widget.marketplace!.isActive;
      _nameController = TextEditingController(text: widget.marketplace!.name);
      _shortNameController = TextEditingController(text: widget.marketplace!.shortName);
      _keyController = TextEditingController(text: widget.marketplace!.key);
      _endpointUrlController = TextEditingController(text: widget.marketplace!.endpointUrl);
      _urlController = TextEditingController(text: widget.marketplace!.url);
      _shopSuffixController = TextEditingController(text: widget.marketplace!.shopSuffix);
      _nextIdToImportController = TextEditingController(text: widget.marketplace!.marketplaceSettings.nextIdToImport.toString());
    } else {
      _isActive = false;
      _nameController = TextEditingController();
      _shortNameController = TextEditingController();
      _keyController = TextEditingController();
      _endpointUrlController = TextEditingController(text: 'https://');
      _urlController = TextEditingController();
      _shopSuffixController = TextEditingController(text: 'api/');
      _nextIdToImportController = TextEditingController();
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
                    ],
                  ),
                  Gaps.h24,
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
                          lastEditingDate: DateTime.now(),
                          marketplaceSettings: widget.marketplace!.marketplaceSettings.copyWith(
                            nextIdToImport: int.parse(_nextIdToImportController.text),
                          ),
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
                          lastEditingDate: DateTime.now(),
                          createnDate: DateTime.now(),
                          marketplaceSettings: MarketplaceSettings.empty().copyWith(
                            nextIdToImport: int.parse(_nextIdToImportController.text),
                          ),
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
