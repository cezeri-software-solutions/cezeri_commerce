import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../2_application/database/incoming_invoice_detail/incoming_invoice_detail_bloc.dart';
import 'widgets/widgets.dart';

class IncomingInvoiceDetailPage extends StatelessWidget {
  final IncomingInvoiceDetailBloc incomingInvoiceDetailBloc;

  const IncomingInvoiceDetailPage({super.key, required this.incomingInvoiceDetailBloc});

  @override
  Widget build(BuildContext context) {
    const padding = 12.0;
    final screenWidth = MediaQuery.sizeOf(context).width;

    final isMobile = ResponsiveBreakpoints.of(context).equals(MOBILE);
    final containerWidthWrap = isMobile ? screenWidth - (padding * 2) : screenWidth / 3 - (padding + padding / 2);

    return BlocBuilder<IncomingInvoiceDetailBloc, IncomingInvoiceDetailState>(
      bloc: incomingInvoiceDetailBloc,
      builder: (context, state) {
        return CustomScrollView(
          controller: state.scrollController,
          slivers: [
            // Der restliche Inhalt vor IncomingInvoiceAddItemBar
            SliverPadding(
              padding: const EdgeInsets.only(left: padding, right: padding, top: padding),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    IncomingInvoiceFilesView(
                      bloc: incomingInvoiceDetailBloc,
                      listOfIncomingInvoiceFiles: state.invoice!.listOfIncomingInvoiceFiles,
                      padding: padding,
                    ),
                    const SizedBox(height: padding),
                    Wrap(
                      runSpacing: padding / 2,
                      children: [
                        IncomingInvoiceSupplierView(supplier: state.invoice!.supplier, containerWidth: containerWidthWrap),
                        const SizedBox(width: padding),
                        IncomingInvoiceTotalPositionsView(invoice: state.invoice!, containerWidth: containerWidthWrap),
                        const SizedBox(width: padding),
                        IncomingInvoiceTotalInvoiceView(bloc: incomingInvoiceDetailBloc, invoice: state.invoice!, containerWidth: containerWidthWrap),
                      ],
                    ),
                    const SizedBox(height: padding),
                    IncomingInvoiceDataView(bloc: incomingInvoiceDetailBloc, containerWidth: screenWidth - padding * 2),
                    const SizedBox(height: padding * 2),
                  ],
                ),
              ),
            ),

            // IncomingInvoiceAddItemBar, die sich oben fixiert
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                bloc: incomingInvoiceDetailBloc,
                minHeight: 60.0,
                maxHeight: 60.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: padding),
                  child: IncomingInvoiceAddItemBar(
                    bloc: incomingInvoiceDetailBloc,
                    supplierId: state.invoice!.supplier.supplierId,
                    padding: padding,
                  ),
                ),
              ),
            ),

            // Der restliche Inhalt nach der IncomingInvoiceAddItemBar
            SliverPadding(
              padding: const EdgeInsets.only(left: padding, right: padding, top: padding, bottom: 200),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    IncomingInvoiceItemsView(
                      bloc: incomingInvoiceDetailBloc,
                      listOfIncomingInvoiceItems: state.invoice!.listOfIncomingInvoiceItems,
                      padding: padding,
                    ),
                    if (kIsWeb) const SizedBox(height: padding * 2),
                    IncomingInvoiceCommentView(bloc: incomingInvoiceDetailBloc),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Custom Delegate für SliverPersistentHeader
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final IncomingInvoiceDetailBloc bloc;
  final double minHeight;
  final double maxHeight;
  final Widget child;

  bool _isSticked = false;

  _SliverAppBarDelegate({required this.bloc, required this.minHeight, required this.maxHeight, required this.child});

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // Bestimme, ob die AddItemBar angedockt ist
    bool isStickedNow = shrinkOffset >= 10.0;

    // Prüfe, ob sich der Zustand geändert hat, um unnötige State-Updates zu vermeiden
    if (isStickedNow != _isSticked) _isSticked = isStickedNow;

    // Setze die Farbe basierend auf dem Zustand
    return Container(
      color: _isSticked ? Colors.white : null,
      child: Column(
        children: [
          Expanded(child: SizedBox.expand(child: child)),
          // Füge einen Divider hinzu, wenn _isSticked true ist
          if (_isSticked) const Divider(height: 0),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
