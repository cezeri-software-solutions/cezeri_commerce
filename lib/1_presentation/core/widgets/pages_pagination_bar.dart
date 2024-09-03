import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../constants.dart';
import '../../core/core.dart';

class PagesPaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int itemsPerPage;
  final int totalItems;
  final Function(int) onPageChanged;
  final Function(int) onItemsPerPageChanged;
  final AlignmentGeometry? itemsAlignment;

  const PagesPaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.itemsPerPage,
    required this.totalItems,
    required this.onPageChanged,
    required this.onItemsPerPageChanged,
    this.itemsAlignment,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);

    int maxPagesToShow = 3;
    int half = maxPagesToShow ~/ 2;
    int maxStartPage = (totalPages - maxPagesToShow + 1).clamp(1, totalPages);

    int startPage = (currentPage - half).clamp(1, maxStartPage);
    int endPage = (startPage + maxPagesToShow - 1).clamp(1, totalPages);

    if (endPage - startPage < maxPagesToShow - 1) startPage = (endPage - maxPagesToShow + 1).clamp(1, maxStartPage);

    List<Widget> pageButtons = [];
    for (int i = startPage; i <= endPage; i++) {
      pageButtons.add(
        SizedBox(
          width: 50,
          child: TextButton(
            isSemanticButton: false,
            onPressed: i != currentPage ? () => onPageChanged(i) : () {},
            style: TextButton.styleFrom(foregroundColor: i == currentPage ? CustomColors.primaryColor : Colors.grey),
            child: Text(i.toString()),
          ),
        ),
      );
    }

    int startItem = ((currentPage - 1) * itemsPerPage) + 1;
    int endItem = (currentPage * itemsPerPage).clamp(1, totalItems);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isTablet) ...[
          const Text('Pro Seite'),
          Gaps.w16,
        ],
        SizedBox(
          width: 75,
          child: MyDropdownButtonSmall(
            value: itemsPerPage.toString(),
            onChanged: (value) => onItemsPerPageChanged(value.toMyInt()),
            items: const ['20', '30', '50', '100', '500', '10000'],
            itemsAlignment: itemsAlignment ?? AlignmentDirectional.centerStart,
          ),
        ),
        if (isTablet) ...[
          Gaps.w16,
          Text('$startItem - $endItem von $totalItems'),
        ],
        IconButton(
          icon: const Icon(Icons.keyboard_double_arrow_left),
          onPressed: currentPage > 1 ? () => onPageChanged(1) : null,
        ),
        ...pageButtons,
        IconButton(
          icon: const Icon(Icons.keyboard_double_arrow_right),
          onPressed: currentPage < totalPages ? () => onPageChanged(totalPages) : null,
        ),
      ],
    );
  }
}
