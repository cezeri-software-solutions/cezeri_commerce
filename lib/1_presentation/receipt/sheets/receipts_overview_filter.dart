import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../2_application/database/receipt/receipt_bloc.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/repositories/firebase/marketplace_repository.dart';
import '../../../constants.dart';
import '../../../failures/failures.dart';
import '../../core/core.dart';

void filterReceiptsOverview(BuildContext context, ReceiptBloc receiptBloc) async {
  AbstractFailure? abstractFailure;
  List<AbstractMarketplace>? listOfMarketplaces;

  final marketplaceRepository = GetIt.I.get<MarketplaceRepository>();
  final fosMarketplaces = await marketplaceRepository.getListOfMarketplaces();
  if (fosMarketplaces.isLeft()) abstractFailure = fosMarketplaces.getLeft();
  listOfMarketplaces = fosMarketplaces.getRight();

  final trailing = IconButton(
    padding: const EdgeInsets.only(right: 24),
    icon: const Icon(Icons.close),
    onPressed: () => context.router.maybePop(),
  );

  Widget getContent() {
    if (listOfMarketplaces == null && abstractFailure == null) {
      return const SizedBox(height: 100, child: Center(child: MyCircularProgressIndicator()));
    }
    if (abstractFailure != null) const SizedBox(height: 100, child: Center(child: Text('Beim laden der Marktplätze ist ein Fehler aufgetreten')));
    return _FilterOptions(receiptBloc: receiptBloc, listOfMarketplaces: listOfMarketplaces!);
  }

  if (!context.mounted) return;

  WoltModalSheet.show(
    context: context,
    useSafeArea: false,
    pageListBuilder: (woltContext) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: true,
          isTopBarLayerAlwaysVisible: true,
          topBarTitle: const Text('Filteroptionen', style: TextStyles.h3Bold),
          trailingNavBarWidget: trailing,
          child: getContent(),
        ),
      ];
    },
  );
}

class _FilterOptions extends StatelessWidget {
  final ReceiptBloc receiptBloc;
  final List<AbstractMarketplace> listOfMarketplaces;

  const _FilterOptions({required this.receiptBloc, required this.listOfMarketplaces});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FilterOptionsHeadline(title: 'Marktplätze'),
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: listOfMarketplaces.length,
          itemBuilder: (context, index) {
            final marketplace = listOfMarketplaces[index];

            return _FilterListTile(
              leading: Checkbox.adaptive(value: false, onChanged: (_) {}),
              title: Text(marketplace.name),
            );
          },
        ),
        Gaps.h16,
      ],
    );
  }
}

class _FilterOptionsHeadline extends StatelessWidget {
  final String title;

  const _FilterOptionsHeadline({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: CustomColors.backgroundLightGrey,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(title, style: TextStyles.h3Bold),
    );
  }
}

class _FilterListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;

  const _FilterListTile({this.leading, this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (leading != null) leading!,
        if (title != null) title!,
      ],
    );
  }
}
