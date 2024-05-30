import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/product_detail/product_detail_bloc.dart';
import '../../../../constants.dart';
import '../../../core/widgets/my_html_editor.dart';
import '../../../core/widgets/my_outlined_button.dart';

class DescriptionPage extends StatelessWidget {
  final ProductDetailBloc productDetailBloc;

  const DescriptionPage({super.key, required this.productDetailBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      bloc: productDetailBloc,
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            appBar: AppBar(title: const Text('Artikelbeschreibung'), automaticallyImplyLeading: false),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 150,
                    child: MyHtmlEditor(
                      controller: state.descriptionShortController,
                      initialText: state.product!.descriptionShort,
                      onChangeContent: (content) => productDetailBloc.add(OnProductDescriptionChangedEvent(content: content)),
                    ),
                  ),
                  Gaps.h16,
                  Expanded(
                    child: MyHtmlEditor(
                      controller: state.descriptionController,
                      initialText: state.product!.description,
                      onChangeContent: (content) => productDetailBloc.add(OnProductDescriptionChangedEvent(content: content)),
                    ),
                  ),
                  Gaps.h10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyOutlinedButton(
                        buttonText: 'Abbrechen',
                        buttonBackgroundColor: Colors.red,
                        onPressed: () => productDetailBloc.add(OnProductShowDescriptionChangedEvent()),
                      ),
                      Gaps.w16,
                      MyOutlinedButton(
                        buttonText: 'Übernehmen',
                        buttonBackgroundColor: state.isDescriptionChanged ? Colors.green : CustomColors.primaryColor,
                        onPressed: () => productDetailBloc.add(OnSaveProductDescriptionEvent()),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
