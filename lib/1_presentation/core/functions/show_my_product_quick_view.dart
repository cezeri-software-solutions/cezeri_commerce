import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_commerce/injection.dart';
import 'package:cezeri_commerce/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../2_application/firebase/product_detail/product_detail_bloc.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../constants.dart';
import '../../../failures/abstract_failure.dart';
import '../../product/product_detail/widgets/charts/product_bart_chart_items_sold.dart';
import '../../product/product_detail/widgets/charts/product_line_chart_sales_volume.dart';
import '../widgets/my_avatar.dart';
import '../widgets/my_circular_progress_indicator.dart';
import 'mixed_functions.dart';

void showMyProductQuickView({required BuildContext context, required Product product, bool showStatProduct = false}) {
  final trailing = IconButton(
    padding: const EdgeInsets.only(right: 24),
    icon: const Icon(Icons.close),
    onPressed: () => context.router.pop(),
  );

  WoltModalSheet.show(
    context: context,
    useSafeArea: false,
    pageListBuilder: (woltContext) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: true,
          isTopBarLayerAlwaysVisible: true,
          topBarTitle: Text(product.articleNumber, style: TextStyles.h3Bold),
          trailingNavBarWidget: trailing,
          child: _ProductQuickView(product: product, showStatProduct: showStatProduct),
        ),
      ];
    },
  );
}

Future<void> showMyProductQuickViewById({required BuildContext context, required String productId, bool showStatProduct = false}) async {
  Product? product;
  AbstractFailure? abstractFailure;

  final productRepository = GetIt.I.get<ProductRepository>();
  final fosProduct = await productRepository.getProduct(productId);
  fosProduct.fold(
    (failure) => abstractFailure = failure,
    (loadedProduct) => product = loadedProduct,
  );

  final trailing = IconButton(
    padding: const EdgeInsets.only(right: 24),
    icon: const Icon(Icons.close),
    onPressed: () => context.router.pop(),
  );

  if (context.mounted) {
    WoltModalSheet.show(
      context: context,
      useSafeArea: false,
      pageListBuilder: (woltContext) {
        return [
          WoltModalSheetPage(
            hasTopBarLayer: true,
            isTopBarLayerAlwaysVisible: true,
            topBarTitle: Text(product != null ? product!.articleNumber : 'Fehler', style: TextStyles.h3Bold),
            trailingNavBarWidget: trailing,
            child: _ProductQuickView(product: product, showStatProduct: showStatProduct, failure: abstractFailure),
          ),
        ];
      },
    );
  }
}

class _ProductQuickView extends StatefulWidget {
  final Product? product;
  final bool showStatProduct;
  final AbstractFailure? failure;

  const _ProductQuickView({required this.product, required this.showStatProduct, this.failure});

  @override
  State<_ProductQuickView> createState() => _ProductQuickViewState();
}

class _ProductQuickViewState extends State<_ProductQuickView> {
  final productDetailBloc = sl<ProductDetailBloc>();
  bool _showStatProduct = false;

  @override
  void initState() {
    if (widget.product != null && widget.failure == null) {
      setState(() => _showStatProduct = widget.showStatProduct);
      productDetailBloc.add(SetProductEvent(product: widget.product!, loadStatProduct: widget.showStatProduct));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return BlocProvider.value(
      value: productDetailBloc,
      child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          if (state.firebaseFailure != null && state.isAnyFailure || widget.product == null || widget.failure != null) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(height: screenHeight * 1.3, child: const Center(child: Text('Ein Fehler ist aufgetreten'))),
            );
          }

          {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET) ? 70 : 60,
                        child: MyAvatar(
                          name: widget.product!.name,
                          imageUrl: widget.product!.listOfProductImages.isNotEmpty
                              ? widget.product!.listOfProductImages.where((e) => e.isDefault).first.fileUrl
                              : null,
                          radius: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET) ? 35 : 30,
                          fontSize: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET) ? 25 : 20,
                          shape: BoxShape.rectangle,
                          onTap: widget.product!.listOfProductImages.isNotEmpty
                              ? () => context.router.push(MyFullscreenImageRoute(
                                  imagePaths: widget.product!.listOfProductImages.map((e) => e.fileUrl).toList(),
                                  initialIndex: 0,
                                  isNetworkImage: true))
                              : null,
                        ),
                      ),
                      Gaps.w16,
                      Expanded(child: Text(widget.product!.name, style: TextStyles.defaultBold)),
                    ],
                  ),
                  Gaps.h16,
                  const Text('Kurzbeschreibung:', style: TextStyles.infoOnTextFieldSmall),
                  Html(data: widget.product!.descriptionShort),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('EAN:', style: TextStyles.infoOnTextFieldSmall),
                            InkWell(
                              onTap: () => Clipboard.setData(ClipboardData(text: widget.product!.ean)),
                              child: Text(widget.product!.ean),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Bestand (Verfügbar / Lager):', style: TextStyles.infoOnTextFieldSmall),
                            Text('${widget.product!.availableStock} / ${widget.product!.warehouseStock}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const Text('Einkauf', style: TextStyles.h3BoldPrimary),
                  Gaps.h10,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('EK-Preis:', style: TextStyles.infoOnTextFieldSmall),
                            Text(widget.product!.wholesalePrice.toMyCurrencyStringToShow()),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Mindestbestand:', style: TextStyles.infoOnTextFieldSmall),
                            Text(widget.product!.minimumStock.toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gaps.h10,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Mindestnachbestellmenge:', style: TextStyles.infoOnTextFieldSmall),
                            Text(widget.product!.minimumReorderQuantity.toString()),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Verpackungseinheit:', style: TextStyles.infoOnTextFieldSmall),
                            Text(widget.product!.packagingUnitOnReorder.toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const Text('Verkauf', style: TextStyles.h3BoldPrimary),
                  Gaps.h10,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('VK-Preis Netto:', style: TextStyles.infoOnTextFieldSmall),
                            Text(widget.product!.netPrice.toMyCurrencyStringToShow()),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('VK-Preis Brutto:', style: TextStyles.infoOnTextFieldSmall),
                            Text(widget.product!.grossPrice.toMyCurrencyStringToShow()),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gaps.h10,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('UVP Brutto:', style: TextStyles.infoOnTextFieldSmall),
                            Text(widget.product!.recommendedRetailPrice.toMyCurrencyStringToShow()),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Einheitspreis Netto:', style: TextStyles.infoOnTextFieldSmall),
                            Text('${widget.product!.unitPrice.toMyCurrencyStringToShow()} ${widget.product!.unity}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const Text('Gewicht & Abmessungen', style: TextStyles.h3BoldPrimary),
                  Gaps.h10,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Gewicht kg:', style: TextStyles.infoOnTextFieldSmall),
                            Text(widget.product!.weight.toMyCurrencyStringToShow()),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Höhe cm:', style: TextStyles.infoOnTextFieldSmall),
                            Text(widget.product!.height.toMyCurrencyStringToShow()),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gaps.h10,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Länge cm:', style: TextStyles.infoOnTextFieldSmall),
                            Text(widget.product!.depth.toMyCurrencyStringToShow()),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Breite cm:', style: TextStyles.infoOnTextFieldSmall),
                            Text(widget.product!.width.toMyCurrencyStringToShow()),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_showStatProduct) ...[
                    const Divider(),
                    const Text('Auswertung', style: TextStyles.h3BoldPrimary),
                    Gaps.h10,
                    if (state.listOfStatProducts != null) ...[
                      AspectRatio(
                        aspectRatio: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET) ? 2.5 : getAspectRatio(screenWidth),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Gaps.h54,
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16, left: 6),
                                    child: !state.isShowingSalesVolumeOnChart
                                        ? ProductLineChartSalesVolume(statProducts: state.listOfStatProducts!)
                                        : ProductBartChartItemsSold(statProducts: state.listOfStatProducts!),
                                  ),
                                ),
                                Gaps.h10,
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.sync, color: CustomColors.primaryColor),
                                  onPressed: () => productDetailBloc.add(OnProductChangeChartModeEvent()),
                                ),
                                Text(!state.isShowingSalesVolumeOnChart ? 'Umsatz Netto' : 'Anzahl Verkäufe', style: TextStyles.defaultBold),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      AspectRatio(
                        aspectRatio: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET) ? 2.5 : getAspectRatio(screenWidth),
                        child: const Center(child: MyCircularProgressIndicator()),
                      ),
                    ],
                  ],
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
