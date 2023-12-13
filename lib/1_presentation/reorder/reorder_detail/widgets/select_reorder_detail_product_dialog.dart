import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/reorder_detail/reorder_detail_bloc.dart';
import '../../../../3_domain/entities/product/product.dart';
import '../../../../constants.dart';
import '../../../core/widgets/my_avatar.dart';

class SelectReorderDetailProductDialog extends StatelessWidget {
  final ReorderDetailBloc reorderDetailBloc;
  final double screenHeight;
  final double screenWidth;

  const SelectReorderDetailProductDialog({super.key, required this.reorderDetailBloc, required this.screenHeight, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReorderDetailBloc, ReorderDetailState>(
      bloc: reorderDetailBloc,
      builder: (context, state) {
        if (state.listOfProducts == null) reorderDetailBloc.add(OnReorderDetailGetProductsEvent());

        if (state.firebaseFailure != null && state.isAnyFailure) {
          return Dialog(child: SizedBox(width: 600, height: 1200, child: Center(child: Text(state.firebaseFailure.toString()))));
        }
        if (state.isLoadingOnObserveReorderDetailProducts || state.listOfProducts == null) {
          return const Dialog(child: SizedBox(width: 600, height: 1200, child: Center(child: CircularProgressIndicator())));
        }

        List<Product> productList = state.listOfFilteredProducts!;

        return Dialog(
          child: SizedBox(
            height: screenHeight > 1200 ? 1200 : screenHeight,
            width: screenWidth > 600 ? 600 : screenWidth,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoSearchTextField(
                        controller: state.productSearchController,
                        onChanged: (value) => reorderDetailBloc.add(OnReorderDetailSetFilteredProductsEvent()),
                        onSuffixTap: () => reorderDetailBloc.add(OnReorderDetailProductSearchTextClearedEvent()),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: productList.length,
                    itemBuilder: ((context, index) {
                      final product = productList[index];
                      return Column(
                        children: [
                          if (index == 0) Gaps.h10,
                          ListTile(
                            leading: SizedBox(
                              width: 40,
                              child: MyAvatar(
                                name: product.name,
                                imageUrl: product.listOfProductImages.isNotEmpty
                                    ? product.listOfProductImages.where((e) => e.isDefault).first.fileUrl
                                    : null,
                                radius: 20,
                                fontSize: 16,
                                //fit: BoxFit.scaleDown,
                              ),
                            ),
                            title: Text(product.name, style: TextStyles.defaultt),
                            trailing: IconButton(
                              onPressed: () => reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: product)),
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.green,
                              ),
                            ),
                            onTap: () {
                              reorderDetailBloc.add(OnReorderDetailControllerClearedEvent());
                              context.router.pop();
                              reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: product));
                            },
                          ),
                          const Divider(height: 0),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
