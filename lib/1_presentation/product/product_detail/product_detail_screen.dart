import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/product/product_detail/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../2_application/database/product_detail/product_detail_bloc.dart';
import '../../../constants.dart';
import '../../../injection.dart';
import '../../../routes/router.gr.dart';
import '../../core/core.dart';
import 'widgets/set_articles/show_select_product_sheet.dart';

enum ProductCreateOrEdit { create, edit }

@RoutePage()
class ProductDetailScreen extends StatefulWidget {
  final String? productId;

  const ProductDetailScreen({super.key, this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with AutomaticKeepAliveClientMixin {
  late final ProductDetailBloc productDetailBloc;

  @override
  void initState() {
    super.initState();
    productDetailBloc = sl<ProductDetailBloc>();

    if (widget.productId != null) {
      productDetailBloc.add(GetProductEvent(id: widget.productId!));
    } else {
      productDetailBloc.add(SetEmptyProductEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: productDetailBloc,
      child: MultiBlocListener(
        listeners: _getProductDetailBlocListeners(productDetailBloc),
        child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            final appBar = AppBar(title: const Text('Artikel'));

            if (state.isLoadingProductOnObserve) return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));
            if (state.firebaseFailure != null && state.isAnyFailure) {
              return Scaffold(appBar: appBar, body: const Center(child: Text('Ein Fehler ist aufgetreten')));
            }
            if (state.product == null) return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));
            // if (state.showHtmlTexts) return ProductDescriptionPage(productDetailBloc: productDetailBloc);

            return Scaffold(
              appBar: AppBar(
                title: const Text('Artikel'),
                actions: _getProductDetailActions(context, productDetailBloc, state, widget.productId),
              ),
              body: ProductDetailPage(
                productDetailBloc: productDetailBloc,
                productCreateOrEdit: widget.productId != null ? ProductCreateOrEdit.edit : ProductCreateOrEdit.create,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

List<BlocListener<ProductDetailBloc, ProductDetailState>> _getProductDetailBlocListeners(ProductDetailBloc productDetailBloc) {
  return [
    BlocListener<ProductDetailBloc, ProductDetailState>(
      listenWhen: (p, c) => p.fosProductOnCreateOption != c.fosProductOnCreateOption,
      listener: (context, state) {
        state.fosProductOnCreateOption.fold(
          () => null,
          (a) => a.fold(
            (failure) => failureRenderer(context, [failure]),
            (product) {
              myScaffoldMessenger(context, null, null, 'Artikel erfolgreich erstellt', null);

              final productId = product.id;

              context.router.popUntilRouteWithName(ProductsOverviewRoute.name);
              context.router.push(ProductDetailRoute(productId: productId));
            },
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
            (failure) => failureRenderer(context, [failure]),
            (product) => myScaffoldMessenger(context, null, null, 'Artikel erfolgreich aktualisiert', null),
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
            (failure) => failureRenderer(context, failure),
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
              context.router.maybePopTop();
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
    BlocListener<ProductDetailBloc, ProductDetailState>(
      listenWhen: (p, c) => p.fosProductsOnObserveOption != c.fosProductsOnObserveOption,
      listener: (context, state) {
        state.fosProductsOnObserveOption.fold(
          () => null,
          (a) => a.fold(
            (failure) {
              context.router.maybePopTop();
              myScaffoldMessenger(context, null, null, null, 'Artikel konnten nicht geladen werden');
            },
            (loadedProducts) {
              context.router.popUntilRouteWithName(ProductDetailRoute.name);
              showSelectProductSheet(context, productDetailBloc);
            },
          ),
        );
      },
    ),
    BlocListener<ProductDetailBloc, ProductDetailState>(
      listenWhen: (p, c) => p.fosProductAbstractFailuresOption != c.fosProductAbstractFailuresOption,
      listener: (context, state) {
        state.fosProductAbstractFailuresOption.fold(
          () => null,
          (a) => a.fold(
            (failure) => failureRenderer(context, failure),
            (unit) => null,
          ),
        );
      },
    ),
  ];
}

List<Widget>? _getProductDetailActions(BuildContext context, ProductDetailBloc productDetailBloc, ProductDetailState state, String? productId) {
  void onSafePressed() {
    if (productId != null) {
      productDetailBloc.add(UpdateProductEvent());
    } else {
      productDetailBloc.add(CreateNewProductEvent());
    }
  }

  return [
    if (state.product != null)
      Switch.adaptive(value: state.product!.isActive, onChanged: (_) => productDetailBloc.add(OnProductIsActiveChangedEvent())),
    if (productId != null)
      IconButton(
        onPressed: () => productDetailBloc.add(GetProductEvent(id: state.product!.id)),
        icon: const Icon(Icons.refresh, size: 30),
      ),
    ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET)
        ? MyOutlinedButton(
            buttonText: 'Speichern',
            onPressed: onSafePressed,
            isLoading: state.isLoadingProductOnUpdate,
            buttonBackgroundColor: Colors.green,
          )
        : MyIconButton(
            onPressed: onSafePressed,
            icon: const Icon(Icons.save, color: Colors.green),
            isLoading: state.isLoadingProductOnUpdate,
          ),
    if (ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET)) Gaps.w24,
  ];
}
