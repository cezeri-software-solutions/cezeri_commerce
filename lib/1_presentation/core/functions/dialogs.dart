import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '/constants.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../routes/router.gr.dart';
import '../widgets/my_avatar.dart';
import '../widgets/my_outlined_button.dart';

Future<void> showMyDialogLoading({required BuildContext context, String text = '', bool canPop = false}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: canPop,
    builder: (_) {
      return PopScope(
        canPop: canPop,
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 60, width: 60, child: CircularProgressIndicator(strokeWidth: 12)),
                if (text.isNotEmpty) ...[
                  const SizedBox(height: 38),
                  Text(text, style: TextStyles.h2, textAlign: TextAlign.center),
                ],
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showMyDialogAlert({required BuildContext context, required String title, required String content, bool canPop = true}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: canPop,
    builder: (_) {
      return PopScope(
        canPop: canPop,
        child: Dialog(
          child: SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: TextStyles.h1),
                  Gaps.h16,
                  Text(content, style: TextStyles.h3, textAlign: TextAlign.center),
                  Gaps.h32,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [MyOutlinedButton(buttonText: 'OK', onPressed: () => Navigator.pop(context))],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showMyDialogDelete({
  required BuildContext context,
  String? title,
  String? content,
  required VoidCallback onConfirm,
  bool canPop = true,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: canPop,
    builder: (_) {
      return PopScope(
        canPop: canPop,
        child: Dialog(
          child: SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title ?? 'Löschen', style: TextStyles.h1),
                  Gaps.h16,
                  Text(content ?? 'Bist du sicher, dass es unwiederruflich löschen willst?', style: TextStyles.h3, textAlign: TextAlign.center),
                  Gaps.h32,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton(child: const Text('Abbrechen'), onPressed: () => context.router.pop()),
                      MyOutlinedButton(buttonText: 'Löschen', onPressed: onConfirm, buttonBackgroundColor: Colors.red),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showMyDialogCustom({
  required BuildContext context,
  String? title,
  required String content,
  String? buttonTextCancel,
  String? buttonTextConfirm,
  required VoidCallback onConfirm,
  bool canPop = true,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: canPop,
    builder: (_) {
      return PopScope(
        canPop: canPop,
        child: Dialog(
          child: SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title ?? 'Achtung', style: TextStyles.h1),
                  Gaps.h16,
                  Text(content, style: TextStyles.h3, textAlign: TextAlign.center),
                  Gaps.h32,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton(child: Text(buttonTextCancel ?? 'Abbrechen'), onPressed: () => context.router.maybePop()),
                      MyOutlinedButton(buttonText: buttonTextConfirm ?? 'JA', onPressed: onConfirm, buttonBackgroundColor: CustomColors.primaryColor),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showMyDialogProducts({
  required BuildContext context,
  String? title = 'Artikel',
  required List<Product> productsList,
  bool canPop = true,
}) async {
  final screenWidth = MediaQuery.sizeOf(context).width;

  await showDialog<void>(
    context: context,
    barrierDismissible: canPop,
    builder: (_) {
      return PopScope(
        canPop: canPop,
        child: Dialog(
          child: SizedBox(
            width: screenWidth > 700 ? 1000 : screenWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('${title!} (${productsList.length})', style: TextStyles.h1),
                  ),
                  Gaps.h32,
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: productsList.length,
                      itemBuilder: (context, index) {
                        final product = productsList[index];

                        return ListTile(
                          leading: SizedBox(
                            width: 60,
                            child: MyAvatar(
                              name: product.name,
                              imageUrl:
                                  product.listOfProductImages.isNotEmpty ? product.listOfProductImages.where((e) => e.isDefault).first.fileUrl : null,
                              radius: 30,
                              fontSize: 20,
                              shape: BoxShape.circle,
                              onTap: product.listOfProductImages.isNotEmpty
                                  ? () => context.router.push(MyFullscreenImageRoute(
                                      imagePaths: product.listOfProductImages.map((e) => e.fileUrl).toList(), initialIndex: 0, isNetworkImage: true))
                                  : null,
                            ),
                          ),
                          title: Text(product.name),
                          subtitle: Text(product.articleNumber),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(height: 0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
