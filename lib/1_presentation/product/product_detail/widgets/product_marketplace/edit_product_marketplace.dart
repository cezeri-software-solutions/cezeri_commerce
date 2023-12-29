import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/core/widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../../../2_application/firebase/product_detail/product_detail_bloc.dart';
import '../../../../../3_domain/entities/product/product_marketplace.dart';
import '../../../../../constants.dart';
import '../../../../core/widgets/my_modal_scrollable.dart';

Future<void> showEditProductInMarketplace(BuildContext context, ProductDetailBloc productDetailBloc, ProductMarketplace productMarketplace) async {
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
          topBarTitle: Text(productMarketplace.nameMarketplace, style: TextStyles.h3Bold),
          trailingNavBarWidget: trailing,
          child: EditProductMarketplace(productDetailBloc: productDetailBloc, productMarketplace: productMarketplace),
        ),
      ];
    },
  );
}

class EditProductMarketplace extends StatefulWidget {
  final ProductDetailBloc productDetailBloc;
  final ProductMarketplace productMarketplace;

  const EditProductMarketplace({super.key, required this.productDetailBloc, required this.productMarketplace});

  @override
  State<EditProductMarketplace> createState() => _EditProductMarketplaceState();
}

class _EditProductMarketplaceState extends State<EditProductMarketplace> {
  @override
  Widget build(BuildContext context) {
    return MyModalScrollable(
      title: widget.productMarketplace.nameMarketplace,
      keyboardDismiss: KeyboardDissmiss.onTab,
      children: const [
        MyTextFormField(labelText: 'Kategorien'),
        SizedBox(height: 200),
      ],
    );
  }
}
