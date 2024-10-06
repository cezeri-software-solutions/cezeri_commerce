import 'package:flutter/material.dart';

typedef SortMenuItem<T extends Enum> = ({T value, String label});

class MySortBar<T extends Enum> extends StatefulWidget {
  final T sortingType;
  final T? defaultType;
  final bool isSortedAscending;
  final bool isLabelVisible;
  final String Function(T) translate;
  final List<SortMenuItem<T>> sortMenuItem;
  final void Function({required T type, required bool isSortedAscending}) onSortingConditionChanged;

  const MySortBar({
    required this.sortingType,
    this.defaultType,
    required this.isSortedAscending,
    required this.isLabelVisible,
    required this.onSortingConditionChanged,
    required this.sortMenuItem,
    required this.translate,
    super.key,
  });

  @override
  State<MySortBar<T>> createState() => MySortBarState();
}

class MySortBarState<T extends Enum> extends State<MySortBar<T>> {
  bool _isOpened = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (widget.isLabelVisible) Text(_isOpened ? 'Sortieren nach ...' : widget.translate(widget.sortingType)),
        PopupMenuButton(
          icon: Badge(isLabelVisible: widget.defaultType != null && widget.defaultType! != widget.sortingType, child: const Icon(Icons.sort)),
          offset: const Offset(40, 48),
          onOpened: () => setState(() => _isOpened = true),
          onCanceled: () => setState(() => _isOpened = false),
          onSelected: (type) {
            setState(() => _isOpened = false);

            widget.onSortingConditionChanged(type: type, isSortedAscending: widget.isSortedAscending);
          },
          itemBuilder: (context) {
            return widget.sortMenuItem.map((item) {
              return PopupMenuItem(
                  value: item.value,
                  child: Text(item.label, style: item.value == widget.sortingType ? const TextStyle(fontWeight: FontWeight.bold) : null));
            }).toList();
          },
        ),
        IconButton(
          onPressed: () => widget.onSortingConditionChanged(type: widget.sortingType, isSortedAscending: !widget.isSortedAscending),
          icon: Icon(widget.isSortedAscending ? Icons.arrow_upward : Icons.arrow_downward),
        ),
      ],
    );
  }
}
