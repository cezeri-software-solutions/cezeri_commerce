import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/product_detail/product_detail_bloc.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

class ProductImagesContainer extends StatelessWidget {
  final ProductDetailBloc productDetailBloc;

  const ProductImagesContainer({super.key, required this.productDetailBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      bloc: productDetailBloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(thickness: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Bilder', style: TextStyles.h2Bold),
                    Gaps.w16,
                    IconButton(
                      onPressed: () => showMyDialogDelete(
                        context: context,
                        content: 'Willst du wirklich alle ausgewählten Artikelbilder unwiederruflich löschen?',
                        onConfirm: () {
                          productDetailBloc.add(RemoveSelectedProductImages());
                          context.router.pop();
                        },
                      ),
                      icon: state.isLoadingProductOnUpdateImages
                          ? const MyCircularProgressIndicator(color: Colors.red)
                          : const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
                MyOutlinedButton(
                  buttonText: 'Hochladen',
                  isLoading: state.isLoadingProductOnUploadImages,
                  buttonBackgroundColor: !state.isProductImagesEdited ? CustomColors.backgroundLightGrey : CustomColors.primaryColor,
                  onPressed: () => productDetailBloc.add(UploadProductImageToPrestaEvent()),
                ),
              ],
            ),
            Checkbox.adaptive(
              value: state.isSelectedAllImages,
              onChanged: (value) => productDetailBloc.add(OnAllProdcutImagesSelectedEvent(value: value!)),
            ),
            ReorderableListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.listOfProductImages.length,
              itemBuilder: (context, index) {
                final image = state.listOfProductImages[index];

                return Column(
                  key: ValueKey(image),
                  children: [
                    if (index == 0) const Divider(color: CustomColors.backgroundLightGrey, height: 0),
                    Row(
                      children: [
                        Checkbox.adaptive(
                          value: state.selectedProductImages.any((e) => e.fileUrl == image.fileUrl),
                          onChanged: (_) => productDetailBloc.add(OnProductImageSelectedEvent(image: image)),
                        ),
                        Container(
                          width: 60,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(color: CustomColors.backgroundLightGrey),
                              right: BorderSide(color: CustomColors.backgroundLightGrey),
                            ),
                          ),
                          child:
                              MyAvatar(name: image.fileName, radius: 30, imageUrl: image.fileUrl, shape: BoxShape.rectangle, fit: BoxFit.scaleDown),
                        ),
                        Gaps.w8,
                        Text(image.fileName, style: image.isDefault ? TextStyles.defaultBold : TextStyles.defaultt, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    const Divider(color: CustomColors.backgroundLightGrey, height: 0),
                  ],
                );
              },
              onReorder: (oldIndex, newIndex) => productDetailBloc.add(OnReorderProductImagesEvent(oldIndex: oldIndex, newIndex: newIndex)),
            ),
            TextButton.icon(
              onPressed: () async => productDetailBloc.add(OnPickNewProductPictureEvent()),
              icon: const Icon(Icons.add, color: Colors.green),
              label: const Text('Bild/er hinzufügen'),
            ),
          ],
        );
      },
    );
  }
}
