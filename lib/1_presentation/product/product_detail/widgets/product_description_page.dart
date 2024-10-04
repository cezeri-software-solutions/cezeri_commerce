import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../2_application/database/product_detail/product_detail_bloc.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

@RoutePage()
class ProductDescriptionPage extends StatelessWidget {
  final ProductDetailBloc productDetailBloc;
  final String description;
  final String descriptionShort;
  final bool isDescriptionChanged;

  const ProductDescriptionPage({
    super.key,
    required this.productDetailBloc,
    required this.description,
    required this.descriptionShort,
    required this.isDescriptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    // final mobileOrSmaller = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);

    if (ResponsiveBreakpoints.of(context).largerThan(TABLET)) {
      return _ProductDescriptionPageWeb(
        productDetailBloc: productDetailBloc,
        description: description,
        descriptionShort: descriptionShort,
        isDescriptionChanged: isDescriptionChanged,
      );
    }

    return _ProductDescriptionPageMobile(
      productDetailBloc: productDetailBloc,
      description: description,
      descriptionShort: descriptionShort,
      isDescriptionChanged: isDescriptionChanged,
    );
  }
}

class _ProductDescriptionPageMobile extends StatefulWidget {
  final ProductDetailBloc productDetailBloc;
  final String description;
  final String descriptionShort;
  final bool isDescriptionChanged;

  const _ProductDescriptionPageMobile({
    required this.productDetailBloc,
    required this.description,
    required this.descriptionShort,
    required this.isDescriptionChanged,
  });

  @override
  State<_ProductDescriptionPageMobile> createState() => _ProductDescriptionPageMobileState();
}

class _ProductDescriptionPageMobileState extends State<_ProductDescriptionPageMobile> {
  final ScrollController _scrollController = ScrollController();
  final HtmlEditorController _descriptionController = HtmlEditorController();
  final HtmlEditorController _descriptionShortController = HtmlEditorController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _descriptionController.disable();
    _descriptionShortController.disable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
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
            onTap: () async {
              final description = await _descriptionController.getText();
              final descriptionShort = await _descriptionShortController.getText();
              widget.productDetailBloc.add(OnSaveProductDescriptionEvent(description: description, descriptionShort: descriptionShort));
              if (mounted) Navigator.of(context).pop();
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
            onTap: _scrollToBottom,
          ),
          SpeedDialChild(
            child: const Icon(Icons.arrow_upward),
            // backgroundColor: Colors.green,
            label: 'Nach oben',
            onTap: _scrollToTop,
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)
            ? Padding(
                padding: const EdgeInsets.all(8),
                child: ListView(
                  controller: _scrollController,
                  children: [
                    const Text('Artikelbeschreibung', style: TextStyles.h2Bold),
                    Gaps.h16,
                    SizedBox(
                      height: 180,
                      child: MyHtmlEditor(
                        controller: _descriptionShortController,
                        initialText: widget.descriptionShort,
                        onChangeContent: (content) => widget.productDetailBloc.add(OnProductDescriptionChangedEvent(content: content)),
                      ),
                    ),
                    Gaps.h16,
                    SizedBox(
                      height: 500,
                      child: MyHtmlEditor(
                        controller: _descriptionController,
                        initialText: widget.description,
                        onChangeContent: widget.isDescriptionChanged
                            ? null
                            : (content) => widget.productDetailBloc.add(OnProductDescriptionChangedEvent(content: content)),
                      ),
                    ),
                    Gaps.h10,
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Artikelbeschreibung', style: TextStyles.h2Bold),
                    Gaps.h16,
                    SizedBox(
                      height: 180,
                      child: MyHtmlEditor(
                        controller: _descriptionShortController,
                        initialText: widget.descriptionShort,
                        onChangeContent: (content) => widget.productDetailBloc.add(OnProductDescriptionChangedEvent(content: content)),
                      ),
                    ),
                    Gaps.h16,
                    Expanded(
                      child: MyHtmlEditor(
                        controller: _descriptionController,
                        initialText: widget.description,
                        onChangeContent: widget.isDescriptionChanged
                            ? null
                            : (content) => widget.productDetailBloc.add(OnProductDescriptionChangedEvent(content: content)),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }
}

class _ProductDescriptionPageWeb extends StatefulWidget {
  final ProductDetailBloc productDetailBloc;
  final String description;
  final String descriptionShort;
  final bool isDescriptionChanged;

  const _ProductDescriptionPageWeb({
    required this.productDetailBloc,
    required this.description,
    required this.descriptionShort,
    required this.isDescriptionChanged,
  });

  @override
  State<_ProductDescriptionPageWeb> createState() => __ProductDescriptionPageWebState();
}

class __ProductDescriptionPageWebState extends State<_ProductDescriptionPageWeb> {
  final ScrollController _scrollController = ScrollController();
  final HtmlEditorController _descriptionController = HtmlEditorController();
  final HtmlEditorController _descriptionShortController = HtmlEditorController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _descriptionController.disable();
    _descriptionShortController.disable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text('Artikelbeschreibung', style: TextStyles.h2Bold),
              Gaps.h16,
              SizedBox(
                height: 180,
                child: MyHtmlEditor(
                  controller: _descriptionShortController,
                  initialText: widget.descriptionShort,
                  onChangeContent: (content) => widget.productDetailBloc.add(OnProductDescriptionChangedEvent(content: content)),
                ),
              ),
              Gaps.h16,
              Expanded(
                child: MyHtmlEditor(
                  controller: _descriptionController,
                  initialText: widget.description,
                  onChangeContent: widget.isDescriptionChanged
                      ? null
                      : (content) => widget.productDetailBloc.add(OnProductDescriptionChangedEvent(content: content)),
                ),
              ),
              Gaps.h10,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Abbrechen')),
                    Gaps.w16,
                    FilledButton(
                      onPressed: () async {
                        final description = await _descriptionController.getText();
                        final descriptionShort = await _descriptionShortController.getText();
                        widget.productDetailBloc.add(OnSaveProductDescriptionEvent(description: description, descriptionShort: descriptionShort));
                        Navigator.of(context).pop();
                      },
                      child: const Text('Übernehmen'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
