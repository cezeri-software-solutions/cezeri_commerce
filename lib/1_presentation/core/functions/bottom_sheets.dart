import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_commerce/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../constants.dart';
import '../widgets/my_avatar.dart';

void showMyProductQuickView(BuildContext context, Product product) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  final responsiveness = screenWidth > 700 ? Responsiveness.isTablet : Responsiveness.isMobil;

  final trailing = IconButton(
    padding: const EdgeInsets.only(right: 24),
    icon: const Icon(Icons.close),
    onPressed: () => context.router.pop(),
  );

  WoltModalSheet.show(
    context: context,
    pageListBuilder: (woltContext) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: true,
          isTopBarLayerAlwaysVisible: true,
          topBarTitle: Text(product.articleNumber, style: TextStyles.h3Bold),
          trailingNavBarWidget: trailing,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: responsiveness == Responsiveness.isTablet ? 70 : 60,
                      child: MyAvatar(
                        name: product.name,
                        imageUrl: product.listOfProductImages.isNotEmpty ? product.listOfProductImages.where((e) => e.isDefault).first.fileUrl : null,
                        radius: responsiveness == Responsiveness.isTablet ? 35 : 30,
                        fontSize: responsiveness == Responsiveness.isTablet ? 25 : 20,
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
                Gaps.h16,
                const Text('Kurzbeschreibung:', style: TextStyles.infoOnTextFieldSmall),
                Html(data: product.descriptionShort),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('EAN:', style: TextStyles.infoOnTextFieldSmall),
                          Text(product.ean),
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
                const Text('Einkauf', style: TextStyles.h3BoldPrimary),
                Gaps.h10,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('EK-Preis:', style: TextStyles.infoOnTextFieldSmall),
                          Text(product.wholesalePrice.toMyCurrencyStringToShow()),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Mindestbestand:', style: TextStyles.infoOnTextFieldSmall),
                          Text(product.minimumStock.toString()),
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
                          Text(product.minimumReorderQuantity.toString()),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Verpackungseinheit:', style: TextStyles.infoOnTextFieldSmall),
                          Text(product.packagingUnitOnReorder.toString()),
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
                          Text(product.netPrice.toMyCurrencyStringToShow()),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('VK-Preis Brutto:', style: TextStyles.infoOnTextFieldSmall),
                          Text(product.grossPrice.toMyCurrencyStringToShow()),
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
                          Text(product.recommendedRetailPrice.toMyCurrencyStringToShow()),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Einheitspreis Netto:', style: TextStyles.infoOnTextFieldSmall),
                          Text('${product.unitPrice.toMyCurrencyStringToShow()} ${product.unity}'),
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
                          Text(product.weight.toMyCurrencyStringToShow()),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Höhe cm:', style: TextStyles.infoOnTextFieldSmall),
                          Text(product.height.toMyCurrencyStringToShow()),
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
                          Text(product.depth.toMyCurrencyStringToShow()),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Breite cm:', style: TextStyles.infoOnTextFieldSmall),
                          Text(product.width.toMyCurrencyStringToShow()),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ];
    },
  );
}
