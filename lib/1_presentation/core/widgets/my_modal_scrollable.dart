import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

enum KeyboardDissmiss { onScroll, onTab, notDissmissable }

class MyModalScrollable extends StatelessWidget {
  final String title;
  final KeyboardDissmiss keyboardDismiss;
  final List<Widget> children;
  final double maxHeight;
  final double paddingTop;
  final double paddingLeft;
  final double paddingRight;

  const MyModalScrollable({
    super.key,
    required this.title,
    required this.keyboardDismiss,
    required this.children,
    this.maxHeight = HeaderSpace.header1,
    this.paddingTop = 10,
    this.paddingLeft = 18,
    this.paddingRight = 18,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: screenHeight * maxHeight),
      child: keyboardDismiss == KeyboardDissmiss.onTab
          ? GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Padding(
                padding: EdgeInsets.only(top: paddingTop, left: paddingLeft, right: paddingRight, bottom: MediaQuery.viewInsetsOf(context).bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyles.modalHeadTitle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(onPressed: () => context.router.pop(), icon: const Icon(Icons.close)),
                      ],
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: children,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.only(top: paddingTop, left: paddingLeft, right: paddingRight, bottom: MediaQuery.viewInsetsOf(context).bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: TextStyles.modalHeadTitle),
                      IconButton(onPressed: () => context.router.pop(), icon: const Icon(Icons.close)),
                    ],
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior: keyboardDismiss == KeyboardDissmiss.onScroll
                          ? ScrollViewKeyboardDismissBehavior.onDrag
                          : ScrollViewKeyboardDismissBehavior.manual,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: children,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
