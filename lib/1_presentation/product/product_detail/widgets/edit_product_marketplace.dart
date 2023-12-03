import 'package:cezeri_commerce/1_presentation/core/widgets/my_text_form_field.dart';
import 'package:flutter/cupertino.dart';

import '../../../../3_domain/entities/product/product_marketplace.dart';
import '../../../core/widgets/my_modal_scrollable.dart';

class EditProductMarketplace extends StatefulWidget {
  final ProductMarketplace productMarketplace;

  const EditProductMarketplace({super.key, required this.productMarketplace});

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
