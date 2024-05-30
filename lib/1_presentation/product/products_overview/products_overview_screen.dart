import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/app_drawer.dart';
import 'package:cezeri_commerce/1_presentation/core/renderer/failure_renderer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../2_application/database/product/product_bloc.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/pdf/pdf_api_mobile.dart';
import '../../../3_domain/pdf/pdf_api_web.dart';
import '../../../3_domain/pdf/pdf_products_generator.dart';
import '../../../constants.dart';
import '../../../injection.dart';
import '../../../routes/router.gr.dart';
import '../../core/functions/dialogs.dart';
import '../../core/functions/my_scaffold_messanger.dart';
import '../../core/widgets/my_circular_progress_indicator.dart';
import 'functions/get_products_app_bar_title.dart';
import 'functions/products_overview_create_export.dart';
import 'products_overview_page.dart';
import 'widgets/products_mass_editing_failure_dialog.dart';
import 'widgets/products_mass_editing_select_marketplaces_dialog.dart';

@RoutePage()
class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> with AutomaticKeepAliveClientMixin {
  final productBloc = sl<ProductBloc>()..add(GetAllProductsEvent());
  final iconButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: productBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProductBloc, ProductState>(
            listenWhen: (p, c) => p.fosProductsOnObserveOption != c.fosProductsOnObserveOption,
            listener: (context, state) {
              state.fosProductsOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (listOfProducts) => null,
                ),
              );
            },
          ),
          BlocListener<ProductBloc, ProductState>(
            listenWhen: (p, c) => p.fosProductOnUpdateQuantityOption != c.fosProductOnUpdateQuantityOption,
            listener: (context, state) {
              state.fosProductOnUpdateQuantityOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) {
                    failureRenderer(context, [failure]);
                    context.router.popUntilRouteWithName(ProductsOverviewRoute.name);
                  },
                  (unit) {
                    myScaffoldMessenger(context, null, null, 'Bestand erfolgreich aktualisiert', null);
                    context.router.popUntilRouteWithName(ProductsOverviewRoute.name);
                  },
                ),
              );
            },
          ),
          BlocListener<ProductBloc, ProductState>(
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
          BlocListener<ProductBloc, ProductState>(
            listenWhen: (p, c) => p.fosProductOnEditQuantityPrestaOption != c.fosProductOnEditQuantityPrestaOption,
            listener: (context, state) {
              state.fosProductOnEditQuantityPrestaOption.fold(
                () => null,
                (a) => a.fold(
                  (prestaFailure) => myScaffoldMessenger(context, null, null, null, 'Bestand konnte in den Marktplätzen nicht aktualisiert werden'),
                  (unit) => myScaffoldMessenger(context, null, null, 'Bestand wurde erfolgreich in den Marktplätzen aktualisiert', null),
                ),
              );
            },
          ),
          BlocListener<ProductBloc, ProductState>(
            listenWhen: (p, c) => p.fosMassEditActivateProductMarketplaceOption != c.fosMassEditActivateProductMarketplaceOption,
            listener: (context, state) {
              state.fosMassEditActivateProductMarketplaceOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) =>
                      myScaffoldMessenger(context, null, null, null, 'Marktplätze konnten für die gewählten Artikel nicht aktiviert werden.'),
                  (unit) => myScaffoldMessenger(context, null, null, 'Marktplätze erfolgreich bei allen ausgewählten Artikeln aktiviert', null),
                ),
              );
            },
          ),
          BlocListener<ProductBloc, ProductState>(
            bloc: productBloc,
            listenWhen: (p, c) => p.fosMassEditProductsOption != c.fosMassEditProductsOption,
            listener: (context, state) {
              state.fosMassEditProductsOption.fold(
                () => null,
                (a) => a.fold((failure) {
                  context.router.popUntilRouteWithName(ProductsOverviewRoute.name);
                  myScaffoldMessenger(context, null, null, null, 'Beim Aktualisieren der Artikel ist ein Fehler aufgetreten');
                  showDialog(
                    context: context,
                    builder: (context) => ProductsMassEditingFailureDialog(productsList: state.listOfNotUpdatedProductsOnMassEditing),
                  );
                }, (_) {
                  context.router.popUntilRouteWithName(ProductsOverviewRoute.name);
                  myScaffoldMessenger(context, null, null, 'Alle Artikel wurden erfolgreich aktualisiert', null);
                }),
              );
            },
          ),
        ],
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            return Scaffold(
              drawer: const AppDrawer(),
              appBar: AppBar(
                title: getProductsAppBarTitle(context, state.listOfFilteredProducts, state.selectedProducts),
                actions: [
                  IconButton(
                    key: iconButtonKey,
                    onPressed: () async {
                      await generateTableExportFromProductsOverview(context, iconButtonKey, state.selectedProducts);
                    },
                    icon: const Icon(Icons.table_chart_outlined, color: CustomColors.primaryColor),
                  ),
                  IconButton(
                    onPressed: () async {
                      showMyDialogLoading(context: context, text: 'PDF wird erstellt...');
                      productBloc.add(SetProductIsLoadingPdfEvent(value: true));
                      final generatedPdf = await PdfProductsGenerator.generate(listOfProducts: state.selectedProducts);

                      if (context.mounted) context.router.popUntilRouteWithName(ProductsOverviewRoute.name);

                      if (kIsWeb) {
                        await PdfApiWeb.saveDocument(name: 'Ausgewählte Artikel.pdf', byteList: generatedPdf, showInBrowser: true);
                      } else {
                        await PdfApiMobile.saveDocument(name: 'Ausgewählte Artikel.pdf', byteList: generatedPdf);
                      }

                      productBloc.add(SetProductIsLoadingPdfEvent(value: false));
                    },
                    icon: state.isLoadingPdf
                        ? const MyCircularProgressIndicator(color: Colors.red)
                        : const Icon(Icons.picture_as_pdf, color: Colors.red),
                  ),
                  IconButton(onPressed: () => productBloc.add(GetAllProductsEvent()), icon: const Icon(Icons.refresh)),
                  TextButton.icon(
                    onPressed: state.selectedProducts.isEmpty
                        ? () => showMyDialogAlert(context: context, title: 'Achtung!', content: 'Bitte wähle mindestens einen Artikel aus.')
                        : () => showDialog(
                              context: context,
                              builder: (_) => BlocProvider.value(
                                value: productBloc,
                                child: ProductsMassEditingSelectMarketplacesDialog(productBloc: productBloc),
                              ),
                            ),
                    icon: state.isLoadingOnMassEditActivateProductMarketplace
                        ? const CircularProgressIndicator()
                        : const Icon(FontAwesomeIcons.diagramProject),
                    label: const Text('Massenbearbeitung'),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.add, color: Colors.green)),
                  IconButton(
                    onPressed: () => _onRemovePressed(context, state.selectedProducts),
                    icon: state.isLoadingProductOnDelete
                        ? const CircularProgressIndicator(color: Colors.red)
                        : const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoSearchTextField(
                            controller: state.productSearchController,
                            onChanged: (value) => context.read<ProductBloc>().add(OnSearchFieldSubmittedEvent()),
                            onSubmitted: (value) => context.read<ProductBloc>().add(OnSearchFieldSubmittedEvent()),
                            onSuffixTap: () => context.read<ProductBloc>().add(OnProductSearchControllerClearedEvent()),
                          ),
                        ),
                        if (ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET)) ...[
                          Gaps.w16,
                          const Text('Erweiterte Suche:'),
                          Gaps.w8,
                          Switch.adaptive(
                            value: state.isWidthSearchActive,
                            onChanged: (value) => productBloc.add(SetProductsWidthSearchEvent(value: value)),
                          ),
                        ] else ...[
                          Gaps.w8,
                          Tooltip(
                            message: 'Erweiterte Suche',
                            child: Switch.adaptive(
                              value: state.isWidthSearchActive,
                              onChanged: (value) => productBloc.add(SetProductsWidthSearchEvent(value: value)),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  ProductOverviewPage(productBloc: productBloc),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onRemovePressed(BuildContext context, List<Product> selectedProducts) {
    if (selectedProducts.isEmpty) {
      showMyDialogAlert(context: context, title: 'Achtung!', content: 'Bitte wähle mindestens einen Artikel aus.');
      return;
    }

    if (selectedProducts.any((e) => e.listOfIsPartOfSetIds.isNotEmpty)) {
      showMyDialogAlert(
          context: context,
          title: 'Achtung!',
          content:
              'Ihre Auswahl beinhaltet Artikel, die Bestandteil von Set-Artikel sind.\nDiese müssen zuerst aus den Set-Artikeln entfernt werden.');
      return;
    }

    showMyDialogDelete(
      context: context,
      content: 'Bist du sicher, dass du alle ausgewählten Artikel unwiederruflich löschen willst?',
      onConfirm: () {
        context.read<ProductBloc>().add(DeleteSelectedProductsEvent(selectedProducts: selectedProducts));
        context.router.pop();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
