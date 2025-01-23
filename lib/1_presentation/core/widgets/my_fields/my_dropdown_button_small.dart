import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../core.dart';

//* Wenn "openToTop == true" dann muss "maxWidth" mit übergeben werden

class MyDropdownButtonSmall extends StatelessWidget {
  final String? fieldTitle;
  final bool? isMandatory;
  final String? value;
  final bool showSearch;
  final bool? autoFocusOnSearch; //* Ob der Fokus direkt auf das Suchfeld gelegt werden soll
  final bool openToTop; //* Wenn das Menü über dem DropdownButton erscheinen soll
  final bool cacheItems; //* Wenn die geladenen Items cached werden sollen
  final bool disableFilter; //* Wenn die Repository-Funktion die Filerung direkt übernimmt, dann true
  final double menuMaxHeight; //* Maximale Höhe des Menus
  final void Function(String?)? onChanged;
  final List<String>? items;
  final String Function(String)? itemAsString;
  final FutureOr<List<String>> Function(String, LoadProps?)? loadItems;
  final Widget Function(BuildContext, String, bool, bool)? itemBuilder;
  final double maxWidth;
  final AlignmentGeometry? itemsAlignment;

  const MyDropdownButtonSmall({
    super.key,
    this.fieldTitle,
    this.isMandatory = false,
    required this.value,
    this.showSearch = true,
    this.autoFocusOnSearch,
    this.openToTop = false,
    this.cacheItems = true,
    this.disableFilter = false,
    this.menuMaxHeight = 400,
    required this.onChanged,
    this.items,
    this.loadItems,
    this.maxWidth = double.infinity,
    this.itemAsString,
    this.itemsAlignment,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fieldTitle != null) FieldTitle(fieldTitle: fieldTitle!, isMandatory: isMandatory!),
        SizedBox(
          width: maxWidth,
          child: DropdownSearch<String>(
            items: loadItems ?? (filter, loadProps) => items ?? [],
            onChanged: onChanged,
            selectedItem: value,
            suffixProps: const DropdownSuffixProps(dropdownButtonProps: DropdownButtonProps(splashRadius: 1, padding: EdgeInsets.zero)),
            itemAsString: itemAsString,
            popupProps: PopupProps.menu(
              disableFilter: disableFilter,
              cacheItems: cacheItems,
              constraints: BoxConstraints(maxHeight: menuMaxHeight), // Höhe des Dialogs
              showSearchBox: showSearch,
              menuProps: MenuProps(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                align: openToTop ? MenuAlign.topCenter : null,
                positionCallback: openToTop
                    ? (RenderBox buttonBox, RenderBox overlayBox) {
                        return RelativeRect.fromLTRB(
                          buttonBox.localToGlobal(Offset.zero).dx,
                          buttonBox.localToGlobal(Offset.zero).dy - 405, // Verschiebe das Menü über das Dropdown
                          screenWidth - buttonBox.localToGlobal(Offset.zero).dx - maxWidth,
                          00,
                        );
                      }
                    : null,
                elevation: 8,
              ),
              fit: FlexFit.loose,
              searchDelay: items != null ? Duration.zero : const Duration(milliseconds: 500),
              searchFieldProps: TextFieldProps(
                onSubmitted: (val) {
                  Navigator.of(context).pop();
                  onChanged!(val);
                },
                autofocus: autoFocusOnSearch ?? showSearch,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  labelStyle: const TextStyle(fontSize: 14),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  prefixIcon: const Icon(Icons.search, size: 20),
                  prefixIconConstraints: const BoxConstraints(maxWidth: 32, minWidth: 32, maxHeight: 32, minHeight: 32),
                  constraints: const BoxConstraints(
                    minHeight: 32, // Mindesthöhe festlegen
                    maxHeight: 32, // Maximale Höhe festlegen
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: CustomColors.primaryColor),
                  ),
                ),
              ),
              loadingBuilder: (context, String? searchEntry) {
                return Center(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.white,
                    child: const MyCircularProgressIndicator(),
                  ),
                );
              },
              emptyBuilder: (context, String? searchEntry) {
                return const Center(child: Text('Keine Daten gefunden'));
              },
              errorBuilder: (context, String? searchEntry, error) {
                return const Center(child: Text('Fehler beim Laden'));
              },
              itemBuilder: itemBuilder ??
                  (context, item, isSelected, isDisabled) {
                    return ListTile(
                      dense: true,
                      title: Text(item, style: isSelected ? TextStyles.defaultBold : null),
                      selected: isSelected,
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                    );
                  },
            ),
            decoratorProps: DropDownDecoratorProps(
              baseStyle: const TextStyle(fontSize: 14).copyWith(letterSpacing: 0),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                suffixIcon: const Icon(Icons.payment_outlined),
                suffixIconConstraints: const BoxConstraints(
                  minHeight: 32, // Mindesthöhe festlegen
                  maxHeight: 32, // Maximale Höhe festlegen
                ),
                isDense: true,
                constraints: const BoxConstraints(
                  minHeight: 32, // Mindesthöhe festlegen
                  maxHeight: 32, // Maximale Höhe festlegen
                ),
                suffixStyle: const TextStyle(fontSize: 14),
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
            ),
          ),
        ),
      ],
    );
  }
}
