import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/marketplace/product_import/product_import_bloc.dart';
import '../../../constants.dart';
import '../../core/core.dart';

class ProductsImportPage extends StatelessWidget {
  final ProductImportBloc productImportBloc;

  const ProductsImportPage({super.key, required this.productImportBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductImportBloc, ProductImportState>(
      builder: (context, state) {
        if (state.isLoadingProductsPrestaOnObserve) {
          return const Center(
            child: MyCircularProgressIndicator(),
          );
        }

        if (state.isAnyFailure) {
          return const Center(
            child: Text('Beim Laden der Podukte ist ein Fehler aufgetreten'),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.h16,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyOutlinedButton(
                    buttonText: 'Alle Artikel importieren',
                    isLoading: state.isLoadingProductsPrestaOnObserve,
                    onPressed: () {
                      productImportBloc.add(GetAllProductsFromPrestaEvent(onlyActive: false));
                      showDialog(
                        context: context,
                        builder: (context) => BlocProvider.value(
                          value: productImportBloc,
                          child: _MyLoadingDialogOnLoadingProducts(productImportBloc: productImportBloc),
                        ),
                      );
                    },
                  ),
                  MyOutlinedButton(
                    buttonText: 'Alle aktiven Artikel importieren',
                    buttonBackgroundColor: Colors.orange,
                    isLoading: state.isLoadingProductsPrestaOnObserve,
                    onPressed: () {
                      productImportBloc.add(GetAllProductsFromPrestaEvent(onlyActive: true));
                      showDialog(
                        context: context,
                        builder: (context) => BlocProvider.value(
                          value: productImportBloc,
                          child: _MyLoadingDialogOnLoadingProducts(productImportBloc: productImportBloc),
                        ),
                      );
                    },
                  ),
                  state.listOfProductsPresta != null && state.listOfProductsPresta!.isNotEmpty
                      ? MyOutlinedButton(
                          buttonText: 'Alle Artikel speichern',
                          buttonBackgroundColor: Colors.green,
                          isLoading: state.isLoadingProductsPrestaOnObserve,
                          onPressed: () {
                            productImportBloc.add(OnUploadAllProductsToFirestoreEvent());
                            showDialog(
                              context: context,
                              builder: (context) => BlocProvider.value(
                                value: productImportBloc,
                                child: _MyLoadingDialogOnLoadingProducts(productImportBloc: productImportBloc),
                              ),
                            );
                          },
                        )
                      : const SizedBox(width: 250),
                ],
              ),
            ),
            state.listOfProductsPresta == null
                ? const Expanded(child: Center(child: Text('Es wurden aktuell noch keine Artikel geladen.')))
                : Expanded(
                    child: ListView.builder(
                      itemCount: state.listOfProductsPresta!.length,
                      itemBuilder: (context, index) {
                        final productPresta = state.listOfProductsPresta![index];
                        return ListTile(
                          leading: MyAvatar(
                            name: 'name',
                            imageBytes: productPresta.imageFiles != null && productPresta.imageFiles!.isNotEmpty
                                ? productPresta.imageFiles!.first.imageFile.fileBytes
                                : null,
                          ),
                          title: Text(productPresta.name!),
                          subtitle: Text('ID: ${productPresta.id} / Artikelnummer: ${productPresta.reference}'),
                        );
                      },
                    ),
                  ),
          ],
        );
      },
    );
  }
}

class _MyLoadingDialogOnLoadingProducts extends StatelessWidget {
  final ProductImportBloc productImportBloc;

  const _MyLoadingDialogOnLoadingProducts({required this.productImportBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductImportBloc, ProductImportState>(
      bloc: productImportBloc,
      builder: (context, state) {
        return Dialog(
          child: SizedBox(
            width: 250,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  Gaps.h24,
                  Text('${state.loadedProducts} / ${state.numberOfToLoadProducts}', style: TextStyles.h2Bold),
                  Gaps.h24,
                  Text(state.loadingText, textAlign: TextAlign.center, style: TextStyles.h3),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
