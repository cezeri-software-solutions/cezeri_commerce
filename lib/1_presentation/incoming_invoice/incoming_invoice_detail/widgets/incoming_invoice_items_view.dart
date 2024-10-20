import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../2_application/database/incoming_invoice_detail/incoming_invoice_detail_bloc.dart';
import '../../../../3_domain/entities/incoming_invoice/incoming_invoice_item.dart';
import '../../../../3_domain/enums/enums.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';
import '../functions/functions.dart';

class IncomingInvoiceItemsView extends StatelessWidget {
  final IncomingInvoiceDetailBloc bloc;
  final List<IncomingInvoiceItem> listOfIncomingInvoiceItems;
  final double padding;

  const IncomingInvoiceItemsView({
    super.key,
    required this.bloc,
    required this.listOfIncomingInvoiceItems,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: listOfIncomingInvoiceItems.length,
      separatorBuilder: (context, index) => ResponsiveBreakpoints.of(context).largerOrEqualTo(DESKTOP) ? Gaps.h8 : Gaps.h4,
      itemBuilder: (context, index) {
        final item = listOfIncomingInvoiceItems[index];

        if (index == 0 || index > 0 && item.itemType != listOfIncomingInvoiceItems[index - 1].itemType) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(item.itemType.convert(), style: TextStyles.defaultBoldPrimary),
              ),
              _PositionView(bloc: bloc, item: item, itemIndex: index, padding: padding),
            ],
          );
        }

        return _PositionView(bloc: bloc, item: item, itemIndex: index, padding: padding);
      },
    );
  }
}

class _PositionView extends StatelessWidget {
  final IncomingInvoiceDetailBloc bloc;
  final IncomingInvoiceItem item;
  final int itemIndex;
  final double padding;

  const _PositionView({required this.bloc, required this.item, required this.itemIndex, required this.padding});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncomingInvoiceDetailBloc, IncomingInvoiceDetailState>(
      bloc: bloc,
      builder: (context, state) {
        return MyFormFieldContainer(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          borderRadius: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: ResponsiveBreakpoints.of(context).largerOrEqualTo(DESKTOP) ? padding : padding / 2,
                runSpacing: ResponsiveBreakpoints.of(context).largerOrEqualTo(DESKTOP) ? padding : padding / 2,
                children: [
                  SizedBox(
                    width: 400,
                    child: MyDropdownButtonSmall(
                      value: item.accountAsString,
                      onChanged: (val) => bloc.add(OnItemGLAccountChangedEvent(gLAccount: val!, index: itemIndex)),
                      fieldTitle: 'Sachkonto',
                      isMandatory: true,
                      cacheItems: false,
                      loadItems: (filter, loadProps) async => await incomingInvoiceDetailLoadAccounts(filter),
                    ),
                  ),
                  if (item.itemType == ItemType.position)
                    SizedBox(
                      width: 400,
                      child: MyAutocompleteTextField(
                        controller: TextEditingController(text: item.title),
                        onSelected: (val) => bloc.add(OnItemItemTitleChangedEvent(value: val, index: itemIndex)),
                        fieldTitle: 'Artikelbezeichnung',
                        isMandatory: true,
                        maxWidth: 400,
                        loadItems: (filter) async => await incomingInvoiceDetailLoadProducts(filter.text),
                      ),
                    )
                  else
                    SizedBox(
                      width: 400,
                      child: MyTextFormFieldSmall(
                        fieldTitle: 'Bezeichnung',
                        initialValue: item.title,
                        onChanged: (val) => bloc.add(OnItemItemTitleChangedEvent(value: val, index: itemIndex)),
                      ),
                    ),
                  if (item.itemType == ItemType.position)
                    SizedBox(
                      width: 60,
                      child: MyTextFormFieldSmall(
                        fieldTitle: 'Menge',
                        isMandatory: true,
                        initialValue: item.quantity.toString(),
                        textAlign: TextAlign.end,
                        inputType: FieldInputType.integer,
                        onChanged: (val) => bloc.add(OnItemQuantityChangedEvent(value: val, index: itemIndex)),
                      ),
                    ),
                  SizedBox(
                    width: 150,
                    child: MyDropdownButtonSmall(
                      value: item.taxRate.toString(),
                      itemAsString: (val) => 'Vorsteuer $val%',
                      onChanged: (val) => bloc.add(OnItemTaxChangedEvent(value: val!, index: itemIndex)),
                      fieldTitle: 'Steuer',
                      isMandatory: true,
                      cacheItems: false,
                      loadItems: (filter, loadProps) async => await incomingInvoiceDetailLoadTaxRates(),
                      itemBuilder: (context, item, isSelected, isDisabled) {
                        return ListTile(
                          dense: true,
                          title: Text('Vorsteuer $item%', style: isDisabled ? TextStyles.defaultBold : null),
                          selected: isDisabled,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                        );
                      },
                    ),
                  ),
                  if (item.itemType != ItemType.discount) ...[
                    SizedBox(
                      width: 80,
                      child: MyTextFormFieldSmall(
                        fieldTitle: 'Preis netto',
                        isMandatory: true,
                        initialValue: item.unitPriceNet.toString(),
                        textAlign: TextAlign.end,
                        onChanged: (val) => bloc.add(OnItemUnitNetPriceChangedEvent(value: val, index: itemIndex)),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: MyButtonSmall(
                        fieldTitle: 'St.-Betrag',
                        child: Text(
                          (item.unitPriceGross - item.unitPriceNet).toMyCurrencyStringToShow(),
                          style: const TextStyle(fontSize: 14, letterSpacing: 0),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: MyButtonSmall(
                        fieldTitle: 'Preis brutto',
                        child: Text(
                          item.unitPriceGross.toMyCurrencyStringToShow(),
                          style: const TextStyle(fontSize: 14, letterSpacing: 0),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                  if (item.itemType == ItemType.position || item.itemType == ItemType.discount) ...[
                    SizedBox(
                      width: 80,
                      child: MyTextFormFieldSmall(
                        fieldTitle: 'Rabatt',
                        isMandatory: true,
                        initialValue: item.discount.toString(),
                        textAlign: TextAlign.end,
                        onChanged: (val) => bloc.add(OnItemDiscountChangedEvent(value: val, index: itemIndex)),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: MyDropdownButtonSmall(
                        fieldTitle: 'Rabatt-Typ',
                        showSearch: false,
                        value: item.discountType.convert(),
                        items: const ['€', '%'],
                        onChanged: (val) => bloc.add(OnItemDiscountTypeChangedEvent(discountType: val!.toDiscountType(), index: itemIndex)),
                      ),
                    ),
                  ],
                  if (item.itemType != ItemType.discount || (item.itemType == ItemType.discount && item.discountType == DiscountType.amount)) ...[
                    SizedBox(
                      width: 100,
                      child: Column(
                        children: [
                          const Text('Ges. Netto', style: TextStyles.infoOnTextFieldSmall),
                          Gaps.h12,
                          Text('${item.totalNetAmount.toMyCurrencyStringToShow()} €')
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Column(
                        children: [
                          const Text('Ges. St.-Betrag', style: TextStyles.infoOnTextFieldSmall),
                          Gaps.h12,
                          Text('${item.taxAmount.toMyCurrencyStringToShow()} €')
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Column(
                        children: [
                          const Text('Ges. Brutto', style: TextStyles.infoOnTextFieldSmall),
                          Gaps.h12,
                          Text('${item.totalGrossAmount.toMyCurrencyStringToShow()} €')
                        ],
                      ),
                    ),
                  ],
                  IconButton(
                    onPressed: () => bloc.add(OnRemoveItemFromListEvent(index: itemIndex)),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DefaultView extends StatelessWidget {
  final IncomingInvoiceDetailBloc bloc;
  final IncomingInvoiceItem item;
  final double padding;

  const _DefaultView({required this.bloc, required this.item, required this.padding});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
