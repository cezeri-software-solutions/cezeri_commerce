import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../2_application/database/product_detail/product_detail_bloc.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

@RoutePage()
class ProductDescriptionPage extends StatelessWidget {
  final ProductDetailBloc productDetailBloc;

  const ProductDescriptionPage({super.key, required this.productDetailBloc});

  @override
  Widget build(BuildContext context) {
    final mobileOrSmaller = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    final largerThanTablet = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    final ScrollController scrollController = ScrollController();

    void scrollToTop() {
      scrollController.animateTo(
        0.0,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }

    void scrollToBottom() {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }

    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      bloc: productDetailBloc,
      builder: (context, state) {
        return Scaffold(
          // appBar: AppBar(title: const Text('Artikelbeschreibung'), automaticallyImplyLeading: false),
          floatingActionButton: largerThanTablet
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Abbrechen')),
                      Gaps.w16,
                      FilledButton(
                          onPressed: () {
                            productDetailBloc.add(OnSaveProductDescriptionEvent());
                            Navigator.of(context).pop();
                          },
                          child: const Text('Übernehmen')),
                    ],
                  ),
                )
              : SpeedDial(
                  icon: Icons.more_vert,
                  activeIcon: Icons.close,
                  backgroundColor: CustomColors.primaryColor,
                  overlayColor: Colors.black,
                  overlayOpacity: 0.5,
                  children: [
                    SpeedDialChild(
                      child: const Icon(Icons.save),
                      backgroundColor: Colors.green,
                      label: 'Übernehmen',
                      onTap: () {
                        productDetailBloc.add(OnSaveProductDescriptionEvent());
                        Navigator.of(context).pop();
                      },
                    ),
                    SpeedDialChild(
                      child: const Icon(Icons.cancel),
                      backgroundColor: Colors.red,
                      label: 'Abbrechen',
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    SpeedDialChild(
                      child: const Icon(Icons.arrow_downward),
                      // backgroundColor: Colors.red,
                      label: 'Nach unten',
                      onTap: scrollToBottom,
                    ),
                    SpeedDialChild(
                      child: const Icon(Icons.arrow_upward),
                      // backgroundColor: Colors.green,
                      label: 'Nach oben',
                      onTap: scrollToTop,
                    ),
                  ],
                ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(mobileOrSmaller ? 8 : 20),
              child: mobileOrSmaller
                  ? ListView(
                      controller: scrollController,
                      children: [
                        const Text('Artikelbeschreibung', style: TextStyles.h2Bold),
                        Gaps.h16,
                        SizedBox(
                          height: 180,
                          child: MyHtmlEditor(
                            controller: state.descriptionShortController,
                            initialText: state.product!.descriptionShort,
                            onChangeContent: (content) => productDetailBloc.add(OnProductDescriptionChangedEvent(content: content)),
                          ),
                        ),
                        Gaps.h16,
                        SizedBox(
                          height: 500,
                          child: MyHtmlEditor(
                            controller: state.descriptionController,
                            initialText: state.product!.description,
                            onChangeContent: state.isDescriptionChanged
                                ? null
                                : (content) => productDetailBloc.add(OnProductDescriptionChangedEvent(content: content)),
                          ),
                        ),
                        Gaps.h10,
                      ],
                    )
                  : Column(
                      children: [
                        const Text('Artikelbeschreibung', style: TextStyles.h2Bold),
                        Gaps.h16,
                        SizedBox(
                          height: 180,
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
                            onChangeContent: state.isDescriptionChanged
                                ? null
                                : (content) => productDetailBloc.add(OnProductDescriptionChangedEvent(content: content)),
                          ),
                        ),
                        Gaps.h10,
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
