import 'package:cezeri_commerce/2_application/database/incoming_invoice_detail/incoming_invoice_detail_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../3_domain/repositories/database/main_settings_respository.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

class IncomingInvoiceDataView extends StatelessWidget {
  final IncomingInvoiceDetailBloc bloc;
  final double containerWidth;

  const IncomingInvoiceDataView({super.key, required this.bloc, required this.containerWidth});

  final padding = 10.0;

  @override
  Widget build(BuildContext context) {
    return MyFormFieldContainer(
      padding: EdgeInsets.all(padding),
      borderRadius: 10,
      width: containerWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Daten Eingangsrechnung', style: TextStyles.defaultBoldPrimary),
          const Divider(),
          ResponsiveBreakpoints.of(context).equals(MOBILE)
              ? _DataViewMobile(bloc: bloc, containerWidth: containerWidth, padding: padding)
              : _DataViewTabletDesktop(bloc: bloc, containerWidth: containerWidth, padding: padding),
        ],
      ),
    );
  }
}

class _DataViewMobile extends StatelessWidget {
  final IncomingInvoiceDetailBloc bloc;
  final double containerWidth;
  final double padding;

  const _DataViewMobile({required this.bloc, required this.containerWidth, required this.padding});

  @override
  Widget build(BuildContext context) {
    final width5 = (containerWidth - (2 * padding));

    return BlocBuilder<IncomingInvoiceDetailBloc, IncomingInvoiceDetailState>(
      bloc: bloc,
      builder: (context, state) {
        return Column(
          children: [
            MyTextFormFieldSmall(
              controller: state.invoiceNumberController,
              fieldTitle: 'Externe Re. Nr.',
              isMandatory: true,
              maxWidth: width5,
              onChanged: (val) => bloc.add(OnInvoiceNumberControllerChangedEvent()),
            ),
            Gaps.h8,
            MyDropdownButtonSmall(
              value: state.invoice!.currency,
              onChanged: (val) => bloc.add(OnCurrencyChangedEvent(currency: val!)),
              showSearch: false,
              maxWidth: width5,
              fieldTitle: 'Währung',
              isMandatory: true,
              items: const ['€', 'Fr', '\$'],
            ),
            Gaps.h8,
            MyDropdownButtonSmall(
              value: state.invoice!.paymentMethod,
              onChanged: (val) => bloc.add(OnPaymentMethodChangedEvent(paymentMethod: val!)),
              maxWidth: width5,
              fieldTitle: 'Zahlungsart',
              isMandatory: true,
              loadItems: (filter, loadProps) async {
                final settingsRepo = GetIt.I<MainSettingsRepository>();
                final fos = await settingsRepo.getSettings();
                if (fos.isLeft()) return [];
                final settings = fos.getRight();
                final list = settings.paymentMethods.map((e) => e.name).toList();
                return list;
              },
            ),
            Gaps.h8,
            MyTextFormFieldSmall(
              controller: state.earlyPaymentDiscountController,
              fieldTitle: 'Skonto %',
              isMandatory: true,
              maxWidth: width5,
              suffix: const Text('%'),
              inputType: FieldInputType.double,
              onChanged: (val) => bloc.add(OnEarlyPaymentControllerChangedEvent()),
            ),
            Gaps.h8,
            MyButtonSmall(
              fieldTitle: 'Skonto gültig bis',
              onTap: () async {
                final newDate = await _showDatePicker(context, DateTime.now(), 'Skonto endet am');
                if (newDate != null) bloc.add(OnEarlyPaymentDiscountDateChangedEvent(date: newDate));
              },
              trailing: const Icon(CupertinoIcons.clear_circled_solid, size: 20, color: Colors.grey),
              onTrailingTap: () => bloc.add(OnEarlyPaymentDiscountDateChangedEvent(date: null)),
              maxWidth: width5,
              child: state.invoice!.discountDeadline != null
                  ? Text(state.invoice!.discountDeadline!.toFormattedDayMonthYear())
                  : const Text('tt.mm.yyyy', style: TextStyles.infoOnTextField),
            ),
            Gaps.h8,
            MyButtonSmall(
              fieldTitle: 'Rechnungsdatum',
              isMandatory: true,
              onTap: () async {
                final newDate = await _showDatePicker(context, DateTime.now(), 'Rechnungsdatum');
                if (newDate != null) bloc.add(OnInvoiceDateChangedEvent(date: newDate));
              },
              maxWidth: width5,
              child: Text(state.invoice!.invoiceDate.toFormattedDayMonthYear()),
            ),
            Gaps.h8,
            MyButtonSmall(
              fieldTitle: 'Buchungsdatum',
              onTap: () async {
                final newDate = await _showDatePicker(context, DateTime.now(), 'Buchungsdatum');
                if (newDate != null) bloc.add(OnBookingDateChangedEvent(date: newDate));
              },
              trailing: const Icon(CupertinoIcons.clear_circled_solid, size: 20, color: Colors.grey),
              onTrailingTap: () => bloc.add(OnBookingDateChangedEvent(date: null)),
              maxWidth: width5,
              child: state.invoice!.bookingDate != null
                  ? Text(state.invoice!.bookingDate!.toFormattedDayMonthYear())
                  : const Text('tt.mm.yyyy', style: TextStyles.infoOnTextField),
            ),
            Gaps.h8,
            MyButtonSmall(
              fieldTitle: 'Fälligkeitsdatum',
              onTap: () async {
                final newDate = await _showDatePicker(context, DateTime.now(), 'Fälligkeitsdatum');
                if (newDate != null) bloc.add(OnDueDateChangedEvent(date: newDate));
              },
              trailing: const Icon(CupertinoIcons.clear_circled_solid, size: 20, color: Colors.grey),
              onTrailingTap: () => bloc.add(OnDueDateChangedEvent(date: null)),
              maxWidth: width5,
              child: state.invoice!.dueDate != null
                  ? Text(state.invoice!.dueDate!.toFormattedDayMonthYear())
                  : const Text('tt.mm.yyyy', style: TextStyles.infoOnTextField),
            ),
            Gaps.h8,
            MyButtonSmall(
              fieldTitle: 'Lieferdatum',
              onTap: () async {
                final newDate = await _showDatePicker(context, DateTime.now(), 'Lieferdatum');
                if (newDate != null) bloc.add(OnDeliveryDateChangedEvent(date: newDate));
              },
              trailing: const Icon(CupertinoIcons.clear_circled_solid, size: 20, color: Colors.grey),
              onTrailingTap: () => bloc.add(OnDeliveryDateChangedEvent(date: null)),
              maxWidth: width5,
              child: state.invoice!.deliveryDate != null
                  ? Text(state.invoice!.deliveryDate!.toFormattedDayMonthYear())
                  : const Text('tt.mm.yyyy', style: TextStyles.infoOnTextField),
            ),
          ],
        );
      },
    );
  }
}

class _DataViewTabletDesktop extends StatelessWidget {
  final IncomingInvoiceDetailBloc bloc;
  final double containerWidth;
  final double padding;

  const _DataViewTabletDesktop({required this.bloc, required this.containerWidth, required this.padding});

  @override
  Widget build(BuildContext context) {
    final width5 = (containerWidth - (6 * padding)) / 5 - 0.5;

    return BlocBuilder<IncomingInvoiceDetailBloc, IncomingInvoiceDetailState>(
      bloc: bloc,
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                MyTextFormFieldSmall(
                  controller: state.invoiceNumberController,
                  fieldTitle: 'Externe Re. Nr.',
                  isMandatory: true,
                  maxWidth: width5,
                  onChanged: (val) => bloc.add(OnInvoiceNumberControllerChangedEvent()),
                ),
                Gaps.w10,
                MyDropdownButtonSmall(
                  value: state.invoice!.currency,
                  onChanged: (val) => bloc.add(OnCurrencyChangedEvent(currency: val!)),
                  showSearch: false,
                  maxWidth: width5,
                  fieldTitle: 'Währung',
                  isMandatory: true,
                  items: const ['€', 'Fr', '\$'],
                ),
                Gaps.w10,
                MyDropdownButtonSmall(
                  value: state.invoice!.paymentMethod,
                  onChanged: (val) => bloc.add(OnPaymentMethodChangedEvent(paymentMethod: val!)),
                  maxWidth: width5,
                  fieldTitle: 'Zahlungsart',
                  isMandatory: true,
                  loadItems: (filter, loadProps) async {
                    final settingsRepo = GetIt.I<MainSettingsRepository>();
                    final fos = await settingsRepo.getSettings();
                    if (fos.isLeft()) return [];
                    final settings = fos.getRight();
                    final list = settings.paymentMethods.map((e) => e.name).toList();
                    return list;
                  },
                ),
                Gaps.w10,
                MyTextFormFieldSmall(
                  controller: state.earlyPaymentDiscountController,
                  fieldTitle: 'Skonto %',
                  isMandatory: true,
                  maxWidth: width5,
                  suffix: const Text('%'),
                  inputType: FieldInputType.double,
                  onChanged: (val) => bloc.add(OnEarlyPaymentControllerChangedEvent()),
                ),
                Gaps.w10,
                MyButtonSmall(
                  fieldTitle: 'Skonto gültig bis',
                  onTap: () async {
                    final newDate = await _showDatePicker(context, DateTime.now(), 'Skonto endet am');
                    if (newDate != null) bloc.add(OnEarlyPaymentDiscountDateChangedEvent(date: newDate));
                  },
                  trailing: const Icon(CupertinoIcons.clear_circled_solid, size: 20, color: Colors.grey),
                  onTrailingTap: () => bloc.add(OnEarlyPaymentDiscountDateChangedEvent(date: null)),
                  maxWidth: width5,
                  child: state.invoice!.discountDeadline != null
                      ? Text(state.invoice!.discountDeadline!.toFormattedDayMonthYear())
                      : const Text('tt.mm.yyyy', style: TextStyles.infoOnTextField),
                ),
              ],
            ),
            SizedBox(height: padding),
            Row(
              children: [
                MyButtonSmall(
                  fieldTitle: 'Rechnungsdatum',
                  isMandatory: true,
                  onTap: () async {
                    final newDate = await _showDatePicker(context, DateTime.now(), 'Rechnungsdatum');
                    if (newDate != null) bloc.add(OnInvoiceDateChangedEvent(date: newDate));
                  },
                  maxWidth: width5,
                  child: Text(state.invoice!.invoiceDate.toFormattedDayMonthYear()),
                ),
                Gaps.w10,
                MyButtonSmall(
                  fieldTitle: 'Buchungsdatum',
                  onTap: () async {
                    final newDate = await _showDatePicker(context, DateTime.now(), 'Buchungsdatum');
                    if (newDate != null) bloc.add(OnBookingDateChangedEvent(date: newDate));
                  },
                  trailing: const Icon(CupertinoIcons.clear_circled_solid, size: 20, color: Colors.grey),
                  onTrailingTap: () => bloc.add(OnBookingDateChangedEvent(date: null)),
                  maxWidth: width5,
                  child: state.invoice!.bookingDate != null
                      ? Text(state.invoice!.bookingDate!.toFormattedDayMonthYear())
                      : const Text('tt.mm.yyyy', style: TextStyles.infoOnTextField),
                ),
                Gaps.w10,
                MyButtonSmall(
                  fieldTitle: 'Fälligkeitsdatum',
                  onTap: () async {
                    final newDate = await _showDatePicker(context, DateTime.now(), 'Fälligkeitsdatum');
                    if (newDate != null) bloc.add(OnDueDateChangedEvent(date: newDate));
                  },
                  trailing: const Icon(CupertinoIcons.clear_circled_solid, size: 20, color: Colors.grey),
                  onTrailingTap: () => bloc.add(OnDueDateChangedEvent(date: null)),
                  maxWidth: width5,
                  child: state.invoice!.dueDate != null
                      ? Text(state.invoice!.dueDate!.toFormattedDayMonthYear())
                      : const Text('tt.mm.yyyy', style: TextStyles.infoOnTextField),
                ),
                Gaps.w10,
                MyButtonSmall(
                  fieldTitle: 'Lieferdatum',
                  onTap: () async {
                    final newDate = await _showDatePicker(context, DateTime.now(), 'Lieferdatum');
                    if (newDate != null) bloc.add(OnDeliveryDateChangedEvent(date: newDate));
                  },
                  trailing: const Icon(CupertinoIcons.clear_circled_solid, size: 20, color: Colors.grey),
                  onTrailingTap: () => bloc.add(OnDeliveryDateChangedEvent(date: null)),
                  maxWidth: width5,
                  child: state.invoice!.deliveryDate != null
                      ? Text(state.invoice!.deliveryDate!.toFormattedDayMonthYear())
                      : const Text('tt.mm.yyyy', style: TextStyles.infoOnTextField),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

Future<DateTime?> _showDatePicker(BuildContext context, DateTime initialDate, String? helpText) async {
  final newDate = await showDatePicker(
    helpText: helpText,
    context: context,
    initialDate: initialDate,
    firstDate: initialDate.subtract(const Duration(days: 1000)),
    lastDate: initialDate.add(const Duration(days: 1000)),
  );

  if (newDate == null) return null;
  return newDate;
}
