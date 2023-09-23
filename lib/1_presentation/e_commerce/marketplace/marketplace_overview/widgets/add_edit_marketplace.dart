import 'package:cezeri_commerce/1_presentation/core/widgets/my_outlined_button.dart';
import 'package:cezeri_commerce/1_presentation/core/widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../2_application/firebase/marketplace/marketplace_bloc.dart';
import '../../../../../3_domain/entities/marketplace.dart';
import '../../../../../constants.dart';
import '../../../../core/widgets/my_modal_scrollable.dart';

class AddEditMarketplace extends StatefulWidget {
  final MarketplaceBloc marketplaceBloc;
  final Marketplace? marketplace;

  const AddEditMarketplace({super.key, required this.marketplaceBloc, required this.marketplace});

  @override
  State<AddEditMarketplace> createState() => _AddEditMarketplaceState();
}

class _AddEditMarketplaceState extends State<AddEditMarketplace> {
  late TextEditingController _nameController;
  late TextEditingController _shortNameController;
  late TextEditingController _keyController;
  late TextEditingController _endpointUrlController;
  late TextEditingController _urlController;
  late TextEditingController _shopSuffixController;

  @override
  void initState() {
    super.initState();

    if (widget.marketplace != null) {
      _nameController = TextEditingController(text: widget.marketplace!.name);
      _shortNameController = TextEditingController(text: widget.marketplace!.shortName);
      _keyController = TextEditingController(text: widget.marketplace!.key);
      _endpointUrlController = TextEditingController(text: widget.marketplace!.endpointUrl);
      _urlController = TextEditingController(text: widget.marketplace!.url);
      _shopSuffixController = TextEditingController(text: widget.marketplace!.shopSuffix);
    } else {
      _nameController = TextEditingController();
      _shortNameController = TextEditingController();
      _keyController = TextEditingController();
      _endpointUrlController = TextEditingController(text: 'https://');
      _urlController = TextEditingController();
      _shopSuffixController = TextEditingController(text: 'api/');
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
                  const Text('Prestashop', style: TextStyles.h2),
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
                          endpointUrl: _endpointUrlController.text,
                          url: _urlController.text,
                          shopSuffix: _shopSuffixController.text,
                          fullUrl: _endpointUrlController.text + _urlController.text + _shopSuffixController.text,
                          lastEditingDate: DateTime.now(),
                        );
                        context.read<MarketplaceBloc>().add(UpdateMarketplaceEvent(marketplace: updatedMarketplace));
                      } else {
                        final newMarketplace = Marketplace.empty().copyWith(
                          name: _nameController.text,
                          shortName: _shortNameController.text,
                          key: _keyController.text,
                          endpointUrl: _endpointUrlController.text,
                          url: _urlController.text,
                          shopSuffix: _shopSuffixController.text,
                          fullUrl: _endpointUrlController.text + _urlController.text + _shopSuffixController.text,
                          lastEditingDate: DateTime.now(),
                          createnDate: DateTime.now(),
                        );
                        context.read<MarketplaceBloc>().add(CreateMarketplaceEvent(marketplace: newMarketplace));
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
}
