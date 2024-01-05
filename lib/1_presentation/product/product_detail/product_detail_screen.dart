import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/product/product_detail/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/product_detail/product_detail_bloc.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../constants.dart';
import '../../../injection.dart';
import '../../../routes/router.gr.dart';
import '../../core/functions/my_scaffold_messanger.dart';
import '../../core/widgets/my_dialog_suppliers.dart';
import '../../core/widgets/my_outlined_button.dart';
import 'widgets/description_page.dart';

enum ProductCreateOrEdit { create, edit }

@RoutePage()
class ProductDetailScreen extends StatelessWidget {
  final String? productId;

  const ProductDetailScreen({super.key, this.productId});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final responsiveness = screenWidth > 700 ? Responsiveness.isTablet : Responsiveness.isMobil;

    final productDetailBloc = switch (productId) {
      null => sl<ProductDetailBloc>(),
      _ => sl<ProductDetailBloc>()..add(GetProductEvent(id: productId!)),
    };

    return BlocProvider(
      create: (context) => productDetailBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProductDetailBloc, ProductDetailState>(
            listenWhen: (p, c) => p.fosProductSuppliersOnObserveOption != c.fosProductSuppliersOnObserveOption,
            listener: (context, state) {
              state.fosProductSuppliersOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => myScaffoldMessenger(context, null, null, null, 'Beim Laen der Lieferanten ist ein Fehler aufgetreten'),
                  (_) => showDialog(
                    context: context,
                    builder: (_) => MyDialogSuppliers(
                      listOfSuppliers: state.listOfSuppliers!,
                      onChanged: (supplier) => productDetailBloc.add(OnProductSetSupplierEvent(supplierName: supplier.company)),
                    ),
                  ),
                ),
              );
            },
          ),
          BlocListener<ProductDetailBloc, ProductDetailState>(
            listenWhen: (p, c) => p.fosProductOnUpdateOption != c.fosProductOnUpdateOption,
            listener: (context, state) {
              state.fosProductOnUpdateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
                  (listOfProducts) => myScaffoldMessenger(context, null, null, 'Artikel erfolgreich aktualisiert', null),
                ),
              );
            },
          ),
          BlocListener<ProductDetailBloc, ProductDetailState>(
            listenWhen: (p, c) => p.fosProductOnUpdateInMarketplaceOption != c.fosProductOnUpdateInMarketplaceOption,
            listener: (context, state) {
              state.fosProductOnUpdateInMarketplaceOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) =>
                      myScaffoldMessenger(context, null, null, null, 'Artikel konnte in mindestens einem Marktplatz nicht aktualisert werden'),
                  (listOfProducts) => myScaffoldMessenger(context, null, null, 'Artikel erfolgreich im Marktplatz aktualisiert', null),
                ),
              );
            },
          ),
          BlocListener<ProductDetailBloc, ProductDetailState>(
            listenWhen: (p, c) => p.fosProductOnUploadImagesInMarketplaceOption != c.fosProductOnUploadImagesInMarketplaceOption,
            listener: (context, state) {
              state.fosProductOnUploadImagesInMarketplaceOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) {
                    myScaffoldMessenger(context, null, null, 'Artikel erfolgreich im Marktplatz aktualisiert', null);
                    myScaffoldMessenger(context, null, null, null, 'Artikelbilder konnten in mindestens einem Marktplatz nicht aktualisert werden');
                  },
                  (listOfProducts) {
                    myScaffoldMessenger(context, null, null, 'Artikel erfolgreich im Marktplatz aktualisiert', null);
                  },
                ),
              );
            },
          ),
          BlocListener<ProductDetailBloc, ProductDetailState>(
            listenWhen: (p, c) => p.fosProductOnCreateInMarketplaceOption != c.fosProductOnCreateInMarketplaceOption,
            listener: (context, state) {
              state.fosProductOnCreateInMarketplaceOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) {
                    context.router.popTop();
                    myScaffoldMessenger(context, null, null, null, 'Artikel konnte nicht im Marktplatz angelegt werden');
                  },
                  (unit) {
                    final curProduct = state.product!;
                    productDetailBloc.add(GetProductAfterExportNewProductToMarketplaceEvent(id: curProduct.id));
                    context.router.popUntilRouteWithName(ProductDetailRoute.name);
                    myScaffoldMessenger(context, null, null, 'Artikel erfolgreich im Marktplatz angelegt', null);
                  },
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            final appBar = AppBar(title: const Text('Artikel'));

            if (state.isLoadingProductOnObserve) return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));
            if (state.firebaseFailure != null && state.isAnyFailure) {
              return Scaffold(appBar: appBar, body: const Center(child: Text('Ein Fehler ist aufgetreten')));
            }
            if (state.product == null) return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));

            if (state.showHtmlTexts) return DescriptionPage(productDetailBloc: productDetailBloc);

            return Scaffold(
              appBar: AppBar(
                title: const Text('Artikel'),
                actions: [
                  if (state.product != null)
                    Switch.adaptive(
                      value: state.product!.isActive,
                      onChanged: (_) => productDetailBloc.add(OnProductIsActiveChangedEvent()),
                    ),
                  responsiveness == Responsiveness.isTablet ? Gaps.w16 : Gaps.w8,
                  if (productId != null) ...[
                    IconButton(
                      onPressed: () => productDetailBloc.add(GetProductEvent(id: state.product!.id)),
                      icon: const Icon(Icons.refresh, size: 30),
                    ),
                    responsiveness == Responsiveness.isTablet ? Gaps.w16 : Gaps.w8,
                  ],
                  MyOutlinedButton(
                    buttonText: 'Speichern',
                    onPressed: () {
                      if (productId != null) {
                        productDetailBloc.add(UpdateProductEvent());
                      } else {
                        // TODO: Handle create new product
                      }
                    },
                    isLoading: state.isLoadingProductOnUpdate,
                    buttonBackgroundColor: Colors.green,
                  ),
                  responsiveness == Responsiveness.isTablet ? Gaps.w32 : Gaps.w8,
                ],
              ),
              body: ProductDetailPage(
                productDetailBloc: productDetailBloc,
                productCreateOrEdit: productId != null ? ProductCreateOrEdit.edit : ProductCreateOrEdit.create,
              ),
            );
          },
        ),
      ),
    );
  }
}
