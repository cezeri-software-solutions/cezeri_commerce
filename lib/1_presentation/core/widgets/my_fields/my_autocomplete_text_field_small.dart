import 'dart:async';

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../constants.dart';
import '../../core.dart';

class MyAutocompleteTextField extends StatelessWidget {
  final String? fieldTitle;
  final bool? isMandatory;
  final bool mustSelect; //* Ob ein Item ausgewählt werden muss
  final TextEditingController? controller;
  final String? initialValue;
  final double maxWidth;
  final double maxHeight;
  final List<String>? items;
  final Future<List<String>> Function(TextEditingValue)? loadItems;
  final void Function(String)? onSelected;

  const MyAutocompleteTextField({
    super.key,
    this.fieldTitle,
    this.isMandatory,
    this.mustSelect = true,
    this.controller,
    this.initialValue,
    required this.maxWidth,
    this.maxHeight = 200,
    this.items,
    this.loadItems,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerOrEqualTo(DESKTOP);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fieldTitle != null) FieldTitle(fieldTitle: fieldTitle!, isMandatory: isMandatory!),
        RawAutocomplete<String>(
          textEditingController: controller,
          focusNode: FocusNode(),
          optionsBuilder: (textEditingValue) async {
            if (items != null) return items!;

            await Future.delayed(const Duration(milliseconds: 500));

            if (loadItems == null) return [];
            return loadItems!(textEditingValue);
          },
          onSelected: onSelected,
          initialValue: initialValue != null ? TextEditingValue(text: initialValue!) : null,
          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              onTapOutside: (_) async {
                if (mustSelect) {
                  final items = await loadItems!(TextEditingValue(text: controller!.text));
                  if (!items.any((e) => controller!.text.contains(e))) {
                    controller!.clear();
                  }
                }

                focusNode.unfocus();
              },
              onFieldSubmitted: (value) async {
                if (mustSelect) {
                  final items = await loadItems!(TextEditingValue(text: controller!.text));
                  if (!items.any((e) => controller!.text.contains(e))) {
                    controller!.clear();
                  }
                }

                focusNode.unfocus();
              },
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                labelStyle: const TextStyle(fontSize: 14),
                hintStyle: const TextStyle().copyWith(letterSpacing: 0),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: isDesktop ? 9 : 5.5),
                isDense: true,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixStyle: const TextStyle(fontSize: 14),
                // suffix: const Text('€'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: CustomColors.borderColorLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: CustomColors.primaryColor),
                ),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            final items = options.toList();

            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: maxWidth),
                  child: Scrollbar(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return ListTile(
                          dense: true,
                          title: Text(item),
                          onTap: () => onSelected(item),
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
