import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redacted/redacted.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../2_application/database/pos/pos_bloc.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/receipt/receipt_product.dart';
import '../../../3_domain/entities/settings/payment_method.dart';
import '../../../constants.dart';
import '../../../routes/router.gr.dart';
import '../../core/core.dart';
import 'sheets/enter_cash_payments_amount.dart';

enum PosPaymentType { cash, card }

class PosDetailPage extends StatelessWidget {
  final PosBloc posBloc;

  const PosDetailPage({super.key, required this.posBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosBloc, PosState>(
      bloc: posBloc,
      builder: (context, state) {
        print('PosDetailPage wird ausgeführt');
        final appBar = AppBar(title: Text(state.marketplace != null ? state.marketplace!.name : 'POS'));

        if (state.marketplace == null || state.customer == null || state.mainSettings == null) {
          return Scaffold(appBar: appBar, body: const Center(child: MyCircularProgressIndicator()));
        }

        return PopScope(
          canPop: state.receipt.listOfReceiptProduct.isEmpty,
          onPopInvokedWithResult: (_, T) async {
            await showMyDialogCustom(
              context: context,
              title: 'Achtung!',
              content: 'Bist du sicher, dass du die Seite verlassen willst?',
              onConfirm: () => context.router.replaceAll([const HomeRoute()]),
            );
          },
          child: Scaffold(
            appBar: appBar,
            body: Row(
              children: [
                Expanded(flex: 60, child: _SelectProductSection(posBloc: posBloc)),
                Expanded(flex: 40, child: Container(color: Colors.grey[100], child: _SelectedProductsSection(posBloc: posBloc))),
              ],
            ),
          ).redacted(context: context, redact: state.marketplace == null || state.customer == null || state.mainSettings == null),
        );
      },
    );
  }
}

class _SelectProductSection extends StatelessWidget {
  final PosBloc posBloc;

  const _SelectProductSection({super.key, required this.posBloc});

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontWeight: FontWeight.bold);

    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('Kunde:'),
                          Gaps.w8,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (state.customer!.company != null && state.customer!.company!.isNotEmpty)
                                Text(state.customer!.company!, style: style),
                              if (state.customer!.name.isNotEmpty) Text(state.customer!.name, style: style),
                              if ((state.customer!.company == null && state.customer!.name.isEmpty) ||
                                  ((state.customer!.company != null && state.customer!.company!.isEmpty) && state.customer!.name.isEmpty))
                                const Text('Der Standartkunde hat weder einen Namen, noch einen Firmennamen', style: style),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () async {
                          final selectedCustomer = await showSelectCustomerSheet(context);
                          if (selectedCustomer != null) posBloc.add(ChangePosCustomerEvent(customer: selectedCustomer));
                        },
                        icon: const Icon(Icons.edit, color: CustomColors.primaryColor),
                      ),
                    ],
                  ),
                  Gaps.h16,
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: MyTextFormFieldSmall(
                          controller: state.searchController,
                          hintText: 'Artikel suchen...',
                          onChanged: (_) => posBloc.add(LoadProductsBySearchTextEvent()),
                          onFieldSubmitted: (_) => posBloc.add(LoadProductsBySearchTextEvent()),
                        ),
                      ),
                      Gaps.w16,
                      const Icon(Icons.barcode_reader, color: CustomColors.primaryColor),
                      Gaps.w4,
                      BarcodeKeyboardListener(
                        child: const Text('EAN/SKU Scannen'),
                        onBarcodeScanned: (barcode) => posBloc.add(LoadProductByEanEvent(context: context, ean: barcode)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 0),
            if (state.listOfSearchResultProducts != null)
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const Divider(height: 0, indent: 18, endIndent: 18, color: CustomColors.backgroundLightGrey),
                  itemCount: state.listOfSearchResultProducts!.length,
                  itemBuilder: (context, index) {
                    final product = state.listOfSearchResultProducts![index];

                    return _ProductContainer(posBloc: posBloc, product: product);
                  },
                ),
              )
          ],
        );
      },
    );
  }
}

class _ProductContainer extends StatelessWidget {
  final PosBloc posBloc;
  final Product product;
  const _ProductContainer({super.key, required this.posBloc, required this.product});

  @override
  Widget build(BuildContext context) {
    final isTabletOrLarger = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);

    return ListTile(
      dense: true,
      onTap: () => posBloc.add(AddProductToBasketEvent(product: product)),
      leading: SizedBox(
        width: isTabletOrLarger ? RWPP.picture : RWMBPP.picture,
        child: MyAvatar(
          name: product.name,
          imageUrl: product.listOfProductImages.isNotEmpty ? product.listOfProductImages.where((e) => e.isDefault).first.fileUrl : null,
          radius: isTabletOrLarger ? 35 : 30,
          fontSize: isTabletOrLarger ? 25 : 20,
          fit: BoxFit.scaleDown,
          shape: BoxShape.rectangle,
          onTap: product.listOfProductImages.isNotEmpty
              ? () => context.router.push(MyFullscreenImageRoute(
                  imagePaths: product.listOfProductImages.map((e) => e.fileUrl).toList(), initialIndex: 0, isNetworkImage: true))
              : null,
        ),
      ),
      title: Text(product.name),
      subtitle: Text(
        '${product.availableStock} Stk. verfügbar',
        style: product.availableStock <= 0 ? const TextStyle(fontSize: 14, color: Colors.red) : TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
      trailing: Text('${product.grossPrice.toMyCurrencyStringToShow()} €', style: TextStyles.defaultt),
    );
  }
}

class _SelectedProductsSection extends StatelessWidget {
  final PosBloc posBloc;

  const _SelectedProductsSection({super.key, required this.posBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosBloc, PosState>(
      bloc: posBloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Warenkorb', style: TextStyles.h2Bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                      onPressed: () {
                        showMyDialogDelete(
                          context: context,
                          title: 'Warenkorb leeren',
                          content: 'Bist du sicher, dass du den Warenkorb leeren willst?',
                          onConfirm: () {
                            Navigator.pop(context);
                            posBloc.add(DeletePosBasketEvent(
                              marketplace: state.marketplace!,
                              customer: state.customer!,
                              settings: state.mainSettings!,
                            ));
                          },
                        );
                      },
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.red)),
                ),
              ],
            ),
            const Divider(height: 0),
            Expanded(
              child: state.receipt.listOfReceiptProduct.isEmpty
                  ? const Center(child: Text('Der Warenkorb ist leer.'))
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => Gaps.h8,
                        itemCount: state.receipt.listOfReceiptProduct.length,
                        itemBuilder: (context, index) {
                          final receiptProduct = state.receipt.listOfReceiptProduct[index];
                          final product = state.listOfSelectedProducts.where((e) => e.id == receiptProduct.productId).firstOrNull;

                          if (index == 0) {
                            return Column(
                              children: [
                                Gaps.h16,
                                Card(
                                  color: Colors.white,
                                  child: _SelectedProductContainer(posBloc: posBloc, index: index, product: product, receiptProduct: receiptProduct),
                                ),
                              ],
                            );
                          }

                          return Card(
                            color: Colors.white,
                            child: _SelectedProductContainer(posBloc: posBloc, index: index, product: product, receiptProduct: receiptProduct),
                          );
                        },
                      ),
                    ),
            ),
            const Divider(height: 0),
            SizedBox(
              height: 240,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Rabatt in %'),
                        Row(
                          children: [
                            const Icon(Icons.remove),
                            MyTextFormFieldSmallDouble(
                              maxWidth: 100,
                              controller: state.discountPercentController,
                              suffix: const Text('%'),
                              onChanged: (value) => posBloc.add(SetTotalDiscountPercentControllerEvent()),
                              // onTapOutside: (_) => receiptDetailProductsBloc.add(SetControllerOnTapOutsideReceiptDetailEvent()),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Gaps.h8,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Rabatt in ${state.receipt.currency}'),
                        Row(
                          children: [
                            const Icon(Icons.remove),
                            MyTextFormFieldSmallDouble(
                              maxWidth: 100,
                              controller: state.discountAmountController,
                              suffix: Text(state.receipt.currency),
                              onChanged: (value) => posBloc.add(SetTotalDiscountAmountGrossControllerEvent()),
                              // onTapOutside: (_) => receiptDetailProductsBloc.add(SetControllerOnTapOutsideReceiptDetailEvent()),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Gaps.h8,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Gesamtbetrag:', style: TextStyles.h3Bold),
                        Text('${state.receipt.totalGross.toMyCurrencyStringToShow()} €', style: TextStyles.h3Bold),
                      ],
                    ),
                    const Spacer(),
                    _PaymentButtonContainer(posBloc: posBloc, receipt: state.receipt),
                    Gaps.h24,
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class _SelectedProductContainer extends StatelessWidget {
  final PosBloc posBloc;
  final int index;
  final Product? product;
  final ReceiptProduct receiptProduct;
  const _SelectedProductContainer({super.key, required this.posBloc, required this.index, required this.product, required this.receiptProduct});

  @override
  Widget build(BuildContext context) {
    final isTabletOrLarger = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);
    final imageUrl = product == null
        ? null
        : product!.listOfProductImages.isNotEmpty
            ? product!.listOfProductImages.where((e) => e.isDefault).first.fileUrl
            : null;
    final onTapAvatar = product == null
        ? null
        : product!.listOfProductImages.isNotEmpty
            ? () => context.router.push(MyFullscreenImageRoute(
                imagePaths: product!.listOfProductImages.map((e) => e.fileUrl).toList(), initialIndex: 0, isNetworkImage: true))
            : null;

    final isQuantityError = product == null ? false : product!.availableStock < receiptProduct.quantity;

    return Stack(
      children: [
        ListTile(
          dense: true,
          onTap: () => posBloc.add(RemoveProductQuantityFromBasketEvent(index: index)),
          onLongPress: () => posBloc.add(RemoveProductFromBasketEvent(index: index)),
          leading: SizedBox(
            height: isTabletOrLarger ? RWPP.picture : RWMBPP.picture,
            width: isTabletOrLarger ? RWPP.picture : RWMBPP.picture,
            child: MyAvatar(
              name: receiptProduct.name,
              imageUrl: imageUrl,
              radius: isTabletOrLarger ? 35 : 30,
              fontSize: isTabletOrLarger ? 25 : 20,
              fit: BoxFit.scaleDown,
              shape: BoxShape.rectangle,
              onTap: onTapAvatar,
            ),
          ),
          title: Text(receiptProduct.name),
          subtitle: isQuantityError
              ? Row(
                  children: [
                    const Icon(Icons.close, color: Colors.red),
                    Gaps.w8,
                    Text(product!.availableStock <= 0 ? 'Ausverkauft' : 'Nur ${product!.availableStock} Stk. verfügbar',
                        style: const TextStyle(color: Colors.red))
                  ],
                )
              : null,
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${(receiptProduct.price * taxToCalc(receiptProduct.tax.taxRate)).toMyCurrencyStringToShow()} €',
                  style: receiptProduct.quantity > 1 ? TextStyles.defaultt : TextStyles.defaultBold),
              if (receiptProduct.quantity > 1)
                Text('${((receiptProduct.price * taxToCalc(receiptProduct.tax.taxRate)) * receiptProduct.quantity).toMyCurrencyStringToShow()} €',
                    style: TextStyles.defaultBold),
            ],
          ),
        ),
        if (receiptProduct.quantity > 1)
          Positioned(
            top: -0,
            left: 70,
            child: Badge.count(
              count: receiptProduct.quantity,
              backgroundColor: isQuantityError ? Colors.red : CustomColors.primaryColor,
              textStyle: TextStyles.defaultBold,
            ),
          ),
      ],
    );
  }
}

class _PaymentButtonContainer extends StatelessWidget {
  final PosBloc posBloc;
  final Receipt receipt;

  const _PaymentButtonContainer({super.key, required this.posBloc, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final receiptCash = receipt.copyWith(paymentMethod: PaymentMethod.paymentMethodList.where((e) => e.name == 'Barzahlung').firstOrNull);
    final receiptCard = receipt.copyWith(paymentMethod: PaymentMethod.paymentMethodList.where((e) => e.name == 'Kartenzahlung').firstOrNull);

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => enterCashPaymentAmount(context: context, posBloc: posBloc, receipt: receiptCash, paymentType: PosPaymentType.cash),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(child: Text('BAR', style: TextStyles.h2Bold)),
            ),
          ),
        ),
        Gaps.w16,
        Expanded(
          child: InkWell(
            onTap: () => enterCashPaymentAmount(context: context, posBloc: posBloc, receipt: receiptCard, paymentType: PosPaymentType.card),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(child: Text('KARTE', style: TextStyles.h2Bold.copyWith(color: Colors.white))),
            ),
          ),
        ),
      ],
    );
  }
}
