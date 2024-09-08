import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/injection.dart';
import 'package:cezeri_commerce/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../2_application/database/product_detail/product_detail_bloc.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/statistic/product_sales_data.dart';
import '../../../3_domain/repositories/database/product_repository.dart';
import '../../../constants.dart';
import '../../../failures/abstract_failure.dart';
import '../../core/core.dart';
import '../../product/product_detail/widgets/charts/product_bart_chart_items_sold.dart';
import '../../product/product_detail/widgets/charts/product_line_chart_sales_volume.dart';

void showMyProductQuickView({required BuildContext context, required Product product, bool showStatProduct = false}) {
  final trailing = IconButton(
    padding: const EdgeInsets.only(right: 24),
    icon: const Icon(Icons.close),
    onPressed: () => context.router.maybePop(),
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
    onPressed: () => context.router.maybePop(),
  );

  if (!context.mounted) return;

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
          child: product == null
              ? const Center(child: MyCircularProgressIndicator())
              : _ProductQuickView(product: product!, showStatProduct: showStatProduct, failure: abstractFailure),
        ),
      ];
    },
  );
}

class _ProductQuickView extends StatefulWidget {
  final Product product;
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
    if (widget.failure == null) {
      setState(() => _showStatProduct = widget.showStatProduct);
      productDetailBloc.add(SetProductEvent(product: widget.product, loadStatProduct: widget.showStatProduct));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return BlocProvider.value(
      value: productDetailBloc,
      child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          if (state.firebaseFailure != null && state.isAnyFailure || widget.failure != null) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(height: screenHeight * 1.3, child: const Center(child: Text('Ein Fehler ist aufgetreten'))),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProductHeader(product: widget.product),
                Gaps.h16,
                _ShortDescription(product: widget.product),
                _ProductInformations(
                  heading: 'Einkauf',
                  title1: 'EK-Preis',
                  title2: 'Mindestbestand',
                  title3: 'Mindestnachbestellmenge',
                  title4: 'Verpackungseinheit',
                  content1: widget.product.wholesalePrice.toMyCurrencyStringToShow(),
                  content2: widget.product.minimumStock.toString(),
                  content3: widget.product.minimumReorderQuantity.toString(),
                  content4: widget.product.packagingUnitOnReorder.toString(),
                ),
                _ProductInformations(
                  heading: 'Verkauf',
                  title1: 'VK-Preis Netto',
                  title2: 'VK-Preis Brutto',
                  title3: 'UVP Brutto',
                  title4: 'Einheitspreis Netto',
                  content1: widget.product.netPrice.toMyCurrencyStringToShow(),
                  content2: widget.product.grossPrice.toMyCurrencyStringToShow(),
                  content3: widget.product.recommendedRetailPrice.toMyCurrencyStringToShow(),
                  content4: '${widget.product.unitPrice.toMyCurrencyStringToShow()} ${widget.product.unity}',
                ),
                _ProductInformations(
                  heading: 'Gewicht & Abmessungen',
                  title1: 'Gewicht kg',
                  title2: 'Höhe cm:',
                  title3: 'Länge cm',
                  title4: 'Breite cm',
                  content1: widget.product.weight.toMyCurrencyStringToShow(),
                  content2: widget.product.height.toMyCurrencyStringToShow(),
                  content3: widget.product.depth.toMyCurrencyStringToShow(),
                  content4: widget.product.width.toMyCurrencyStringToShow(),
                ),
                if (_showStatProduct)
                  _StatProduct(
                    productDetailBloc: productDetailBloc,
                    listOfProductSalesData: state.listOfProductSalesData,
                    isShowingSalesVolumeOnChart: state.isShowingSalesVolumeOnChart,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProductHeader extends StatelessWidget {
  final Product product;

  const _ProductHeader({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET) ? 70 : 60,
              child: MyAvatar(
                name: product.name,
                imageUrl: product.listOfProductImages.isNotEmpty ? product.listOfProductImages.where((e) => e.isDefault).first.fileUrl : null,
                radius: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET) ? 35 : 30,
                fontSize: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET) ? 25 : 20,
                shape: BoxShape.rectangle,
                onTap: product.listOfProductImages.isNotEmpty
                    ? () => context.router.push(MyFullscreenImageRoute(
                        imagePaths: product.listOfProductImages.map((e) => e.fileUrl).toList(), initialIndex: 0, isNetworkImage: true))
                    : null,
              ),
            ),
            Gaps.w16,
            Expanded(child: Text(product.name, style: TextStyles.defaultBold)),
          ],
        ),
      ],
    );
  }
}

class _ShortDescription extends StatelessWidget {
  final Product product;

  const _ShortDescription({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Kurzbeschreibung:', style: TextStyles.infoOnTextFieldSmall),
        Html(data: product.descriptionShort),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('EAN:', style: TextStyles.infoOnTextFieldSmall),
                  InkWell(
                    onTap: () => Clipboard.setData(ClipboardData(text: product.ean)),
                    child: Text(product.ean),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bestand (Verfügbar / Lager):', style: TextStyles.infoOnTextFieldSmall),
                  Text('${product.availableStock} / ${product.warehouseStock}'),
                ],
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}

class _ProductInformations extends StatelessWidget {
  final String heading;
  final String title1;
  final String title2;
  final String title3;
  final String title4;
  final String content1;
  final String content2;
  final String content3;
  final String content4;

  const _ProductInformations({
    required this.heading,
    required this.title1,
    required this.title2,
    required this.title3,
    required this.title4,
    required this.content1,
    required this.content2,
    required this.content3,
    required this.content4,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(heading, style: TextStyles.h3BoldPrimary),
        Gaps.h10,
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$title1:', style: TextStyles.infoOnTextFieldSmall),
                  Text(content1),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$title2:', style: TextStyles.infoOnTextFieldSmall),
                  Text(content2),
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
                  Text('$title3:', style: TextStyles.infoOnTextFieldSmall),
                  Text(content3),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$title3:', style: TextStyles.infoOnTextFieldSmall),
                  Text(content4),
                ],
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}

class _StatProduct extends StatelessWidget {
  final ProductDetailBloc productDetailBloc;
  final List<ProductSalesData>? listOfProductSalesData;
  final bool isShowingSalesVolumeOnChart;

  const _StatProduct({required this.productDetailBloc, required this.listOfProductSalesData, required this.isShowingSalesVolumeOnChart});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Column(
      children: [
        const Text('Auswertung', style: TextStyles.h3BoldPrimary),
        Gaps.h10,
        if (listOfProductSalesData != null) ...[
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
                        child: !isShowingSalesVolumeOnChart
                            ? ProductLineChartSalesVolume(statProducts: listOfProductSalesData!)
                            : ProductBartChartItemsSold(statProducts: listOfProductSalesData!),
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
                    Text(!isShowingSalesVolumeOnChart ? 'Umsatz Netto' : 'Anzahl Verkäufe', style: TextStyles.defaultBold),
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
    );
  }
}
