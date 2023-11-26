import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/product/product_bloc.dart';
import '../../../../constants.dart';
import '../../../core/widgets/my_html_editor.dart';
import '../../../core/widgets/my_outlined_button.dart';

class DescriptionDialog extends StatelessWidget {
  final ProductBloc productBloc;

  const DescriptionDialog({super.key, required this.productBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Dialog(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Beschreibung', style: TextStyles.h2Bold),
                  Gaps.h16,
                  Expanded(
                    child: MyHtmlEditor(
                      controller: state.descriptionController,
                      initialText: state.product!.description,
                      onChangeContent: (content) => productBloc.add(OnProductDescriptionChangedEvent(content: content)),
                    ),
                  ),
                  Gaps.h10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyOutlinedButton(
                        buttonText: 'Abbrechen',
                        buttonBackgroundColor: Colors.red,
                        onPressed: () => context.router.pop(),
                      ),
                      Gaps.w16,
                      MyOutlinedButton(
                        buttonText: 'Speichern',
                        buttonBackgroundColor: state.isDescriptionChanged ? Colors.green : CustomColors.primaryColor,
                        onPressed: () {
                          productBloc.add(OnSaveProductDescriptionEvent());
                          // context.router.pop();
                        },
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
