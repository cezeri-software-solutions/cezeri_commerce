import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/product/product_detail/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../2_application/firebase/product_detail/product_detail_bloc.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../constants.dart';
import '../../../injection.dart';
import '../../../routes/router.gr.dart';
import '../../core/functions/my_scaffold_messanger.dart';
import '../../core/widgets/my_dialog_suppliers.dart';
import '../../core/widgets/my_outlined_button.dart';
import 'widgets/description_page.dart';
import 'widgets/set_articles/show_select_product_sheet.dart';

enum ProductCreateOrEdit { create, edit }

@RoutePage()
class ProductDetailScreen extends StatefulWidget {
  final String? productId;
  final List<Product> listOfProducts;

  const ProductDetailScreen({super.key, this.productId, required this.listOfProducts});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with AutomaticKeepAliveClientMixin {
  late final ProductDetailBloc productDetailBloc;

  @override
  void initState() {
    super.initState();
    productDetailBloc = sl<ProductDetailBloc>();

    if (widget.productId == null) {
      productDetailBloc.add(SetListOfProductsEvent(listOfProducts: widget.listOfProducts));
    } else {
      productDetailBloc.add(GetProductEvent(id: widget.productId!));
      productDetailBloc.add(SetListOfProductsEvent(listOfProducts: widget.listOfProducts));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: productDetailBloc,
      child: MultiBlocListener(
        listeners: _getProductDetailBlocListeners(productDetailBloc, widget.listOfProducts),
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

List<BlocListener<ProductDetailBloc, ProductDetailState>> _getProductDetailBlocListeners(
  ProductDetailBloc productDetailBloc,
  List<Product> listOfProducts,
) {
  return [
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
            (failure) => myScaffoldMessenger(context, null, null, null, 'Artikel konnte in mindestens einem Marktplatz nicht aktualisert werden'),
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
              productDetailBloc.add(GetProductAfterExportNewProductToMarketplaceEvent(id: curProduct.id, listOfAllProducts: listOfProducts));
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
              context.router.popTop();
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
  ];
}

List<Widget>? _getProductDetailActions(BuildContext context, ProductDetailBloc productDetailBloc, ProductDetailState state, String? productId) {
  return [
    if (state.product != null)
      Switch.adaptive(
        value: state.product!.isActive,
        onChanged: (_) => productDetailBloc.add(OnProductIsActiveChangedEvent()),
      ),
    ResponsiveBreakpoints.of(context).isTablet ? Gaps.w16 : Gaps.w8,
    if (productId != null) ...[
      IconButton(
        onPressed: () => productDetailBloc.add(GetProductEvent(
          id: state.product!.id,
        )),
        icon: const Icon(Icons.refresh, size: 30),
      ),
      ResponsiveBreakpoints.of(context).isTablet ? Gaps.w16 : Gaps.w8,
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
    ResponsiveBreakpoints.of(context).isTablet ? Gaps.w32 : Gaps.w8,
  ];
}
