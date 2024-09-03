import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../../2_application/database/pos/pos_bloc.dart';
import '../../../../3_domain/entities/receipt/receipt.dart';
import '../../../../constants.dart';
import '../pos_detail_page.dart';

Future<void> enterCashPaymentAmount({
  required BuildContext context,
  required PosBloc posBloc,
  required Receipt receipt,
  required PosPaymentType paymentType,
}) async {
  posBloc.add(SetIsModalSheetOpenEvent(value: true));

  await WoltModalSheet.show<void>(
    context: context,
    useSafeArea: false,
    showDragHandle: false,
    pageListBuilder: (woltContext) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: false,
          isTopBarLayerAlwaysVisible: false,
          child: _CashPaymentSheet(posBloc: posBloc, receipt: receipt, paymentType: paymentType),
        ),
      ];
    },
  );

  posBloc.add(SetIsModalSheetOpenEvent(value: false));
}

class _CashPaymentSheet extends StatefulWidget {
  final PosBloc posBloc;
  final Receipt receipt;
  final PosPaymentType paymentType;

  const _CashPaymentSheet({required this.posBloc, required this.receipt, required this.paymentType});

  @override
  State<_CashPaymentSheet> createState() => __CashPaymentSheetState();
}

class __CashPaymentSheetState extends State<_CashPaymentSheet> {
  String _paidValue = '';
  bool _isErrorOnCreate = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<PosBloc, PosState>(
      bloc: widget.posBloc,
      listenWhen: (p, c) => p.fosPosOnCreateOption != c.fosPosOnCreateOption,
      listener: (context, state) {
        state.fosPosOnCreateOption.fold(
          () => null,
          (a) => a.fold(
            (failure) {
              // failureRenderer(context, [failure]);
              setState(() => _isErrorOnCreate = true);
            },
            (receipts) {},
          ),
        );
      },
      child: BlocBuilder<PosBloc, PosState>(
        bloc: widget.posBloc,
        builder: (context, state) {
          if (_isErrorOnCreate) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 42),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 100, color: Theme.of(context).colorScheme.error),
                  Gaps.h42,
                  const Text('Beim Erstellen der Belege ist ein Fehler aufgetreten!', style: TextStyles.h3Bold),
                  Gaps.h42,
                  MyOutlinedButton(buttonText: 'OK', onPressed: () => context.maybePop()),
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: max(MediaQuery.paddingOf(context).bottom, 24)),
            child: Column(
              children: [
                const Text('Gesamtbetrag', style: TextStyles.h3Bold),
                Text('${widget.receipt.totalGross.toMyCurrencyStringToShow()} ${widget.receipt.currency}', style: TextStyles.h2),
                Gaps.h10,
                SizedBox(
                  width: 316,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.paymentType == PosPaymentType.cash ? 'Barzahlung' : 'Kartenzahlung', style: TextStyles.h2Bold),
                      IconButton(
                        onPressed: () => widget.posBloc.add(SetPrintInvoiceEvent()),
                        icon: state.printInvoice
                            ? const Icon(Icons.print_outlined, color: Colors.green, size: 42)
                            : const Icon(Icons.print_disabled_outlined, color: Colors.red, size: 42),
                      ),
                    ],
                  ),
                ),
                Gaps.h10,
                if (widget.paymentType == PosPaymentType.card) ...[
                  SvgPicture.asset('assets/marketplaces/card_payment.svg', width: 316, height: 316),
                ] else ...[
                  Gaps.h16,
                  _AmountContainer(title: 'Gezahlter Betrag', value: '${_formatCurrency(_paidValue)} ${widget.receipt.currency}', width: 316),
                  const SizedBox(width: 316, child: Divider()),
                  _AmountContainer(title: 'Fälliges Restgeld', value: '${_formatBackMoney(_paidValue)} ${widget.receipt.currency}', width: 316),
                  Gaps.h32,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNumberButton('1'),
                      Gaps.w8,
                      _buildNumberButton('2'),
                      Gaps.w8,
                      _buildNumberButton('3'),
                    ],
                  ),
                  Gaps.h8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNumberButton('4'),
                      Gaps.w8,
                      _buildNumberButton('5'),
                      Gaps.w8,
                      _buildNumberButton('6'),
                    ],
                  ),
                  Gaps.h8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNumberButton('7'),
                      Gaps.w8,
                      _buildNumberButton('8'),
                      Gaps.w8,
                      _buildNumberButton('9'),
                    ],
                  ),
                  Gaps.h8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNumberButton('00'),
                      Gaps.w8,
                      _buildNumberButton('0'),
                      Gaps.w8,
                      _buildClearButton(),
                    ],
                  ),
                ],
                Gaps.h32,
                SizedBox(
                  width: 316,
                  child: ElevatedButton(
                    onPressed: state.isLoadingPosOnCreate ? () {} : () => widget.posBloc.add(CreateReceiptsEvent(receipt: widget.receipt)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: state.isLoadingPosOnCreate
                        ? const MyCircularProgressIndicator(color: Colors.white)
                        : Text(widget.paymentType == PosPaymentType.cash ? 'Bezahlen' : 'Zahlung akzeptiert', style: TextStyles.h3Bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _updateValue(String input) => setState(() => _paidValue += input);

  void _clearValue() => setState(() => _paidValue = '');

  String _formatCurrency(String value) {
    if (value.isEmpty) return '0,00';

    int number = int.parse(value);
    double formattedNumber = number / 100;
    return formattedNumber.toMyCurrencyStringToShow();
  }

  String _formatBackMoney(String value) {
    if (value.isEmpty) return '0,00';

    final paidDouble = value.toMyDouble() / 100;

    if (paidDouble < widget.receipt.totalGross) return '0,00';

    final number = paidDouble - widget.receipt.totalGross;
    return number.toMyCurrencyStringToShow();
  }

  Widget _buildNumberButton(String number) => _KeyboardButton(onPressed: () => _updateValue(number), number: number);

  Widget _buildClearButton() => _KeyboardButton(onPressed: _clearValue);
}

class _AmountContainer extends StatelessWidget {
  final String title;
  final String value;
  final double width;

  const _AmountContainer({required this.title, required this.value, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), Gaps.w16, Text(value, style: TextStyles.h2)],
      ),
    );
  }
}

class _KeyboardButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? number;

  const _KeyboardButton({required this.onPressed, this.number});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 100,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: number == null || (number != null && number! == '00') ? null : Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: number == null
            ? const Center(child: Icon(Icons.backspace, color: CustomColors.primaryColor))
            : Center(child: Text(number!, style: const TextStyle(fontSize: 24))),
      ),
    );
  }
}
