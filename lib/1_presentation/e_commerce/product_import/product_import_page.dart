import 'package:cezeri_commerce/1_presentation/core/widgets/my_outlined_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../2_application/firebase/main_settings/main_settings_bloc.dart';
import '../../../2_application/prestashop/product_import/product_import_bloc.dart';
import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../constants.dart';
import '../../core/widgets/my_avatar.dart';

class ProductImportPage extends StatelessWidget {
  final ProductImportBloc productImportBloc;
  final Marketplace marketplace;

  const ProductImportPage({
    super.key,
    required this.productImportBloc,
    required this.marketplace,
  });

  @override
  Widget build(BuildContext context) {
    final idController = TextEditingController();
    final logger = Logger();

    return BlocBuilder<ProductImportBloc, ProductImportState>(
      builder: (context, state) {
        final mainSettings = context.read<MainSettingsBloc>().state.mainSettings!;
        print(state.productPresta);
        print(state.isLoadingProductPrestaOnObserve);
        print(state.isAnyFailure);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.prestaFailure != null && state.isAnyFailure) const Text('Ein Fehler ist aufgetreten'),
              if (state.isLoadingProductPrestaOnObserve && !state.isAnyFailure) const CircularProgressIndicator(),
              if (state.productPresta != null && !state.isLoadingProductPrestaOnObserve && !state.isAnyFailure) ...[
                ListTile(
                  leading: MyAvatar(
                    name: 'name',
                    file: state.productPresta!.imageFiles != null && state.productPresta!.imageFiles!.isNotEmpty
                        ? state.productPresta!.imageFiles!.first.imageFile
                        : null,
                  ),
                  title: Text(state.productPresta!.name!),
                  subtitle: Text('ID: ${state.productPresta!.id} / Artikelnummer: ${state.productPresta!.reference}'),
                  trailing: MyOutlinedButton(
                    buttonText: 'Artikel speichern',
                    isLoading: state.isLoadingProductOnCreate,
                    onPressed: () => !state.isLoadingProductOnCreate ? productImportBloc.add(OnUploadProductToFirestoreEvent()) : null,
                  ),
                ),
              ],
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Gaps.h16,
                  const Text('Gib die ID des Artikels ein, welches importiert werden soll.', style: TextStyles.h3),
                  Gaps.h16,
                  SizedBox(
                      width: 100,
                      child: CupertinoTextField(
                        controller: idController,
                        keyboardType: TextInputType.number,
                        onSubmitted: (_) => productImportBloc.add(GetProductByIdAsJsonFromPrestaEvent(
                          id: int.parse(idController.text),
                          marketplace: state.selectedMarketplace!,
                        )),
                      )),
                  Gaps.h16,
                  OutlinedButton(
                    onPressed: () => (_) => productImportBloc.add(GetProductByIdAsJsonFromPrestaEvent(
                          id: int.parse(idController.text),
                          marketplace: state.selectedMarketplace!,
                        )),
                    child: const Text('Import Neu Starten'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
