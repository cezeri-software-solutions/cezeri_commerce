import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/settings/settings/widgets/my_settings_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';

import '../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../../3_domain/entities/settings/main_settings.dart';
import '../../../3_domain/entities/settings/my_printer.dart';
import '../../../3_domain/entities/settings/payment_method.dart';
import '../../../constants.dart';
import '../../app_drawer.dart';
import '../../core/core.dart';
import 'widgets/add_payment_method.dart';

class MainSettingsPage extends StatefulWidget {
  final MainSettings mSettings;

  const MainSettingsPage({super.key, required this.mSettings});

  @override
  State<MainSettingsPage> createState() => _MainSettingsPageState();
}

const currencyItems = ['€', 'Fr', '\$'];

class _MainSettingsPageState extends State<MainSettingsPage> {
  bool _isSmallBusiness = false;
  String _selectedCurrencyItem = '€';
  List<PaymentMethod> _paymentMethods = [];
  MyPrinter? _printerMain;
  MyPrinter? _printerLabel;

  late TextEditingController _offerDocumentTextController = TextEditingController();
  late TextEditingController _appointmentDocumentTextController = TextEditingController();
  late TextEditingController _deliveryNoteDocumentTextController = TextEditingController();
  late TextEditingController _invoiceDocumentTextController = TextEditingController();
  late TextEditingController _creditDocumentTextController = TextEditingController();
  late TextEditingController _termOfPaymentController = TextEditingController();

  late TextEditingController _offerPraefixController = TextEditingController();
  late TextEditingController _appointmentPraefixController = TextEditingController();
  late TextEditingController _deliveryNotePraefixController = TextEditingController();
  late TextEditingController _invoicePraefixController = TextEditingController();
  late TextEditingController _creditPraefixController = TextEditingController();
  late TextEditingController _nextOfferNumberController = TextEditingController();
  late TextEditingController _nextAppointmentNumberController = TextEditingController();
  late TextEditingController _nextDeliveryNoteNumberController = TextEditingController();
  late TextEditingController _nextInvoiceNumberController = TextEditingController();
  late TextEditingController _nextCustomerNumberController = TextEditingController();
  late TextEditingController _nextSupplierNumberController = TextEditingController();
  late TextEditingController _nextReorderNumberController = TextEditingController();

  late TextEditingController _bankNameController = TextEditingController();
  late TextEditingController _bankIbanController = TextEditingController();
  late TextEditingController _bankBicController = TextEditingController();
  late TextEditingController _paypalEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _isSmallBusiness = widget.mSettings.isSmallBusiness;
    _selectedCurrencyItem = widget.mSettings.currency;
    _paymentMethods = widget.mSettings.paymentMethods;
    _printerMain = widget.mSettings.printerMain;
    _printerLabel = widget.mSettings.printerLabel;

    _offerDocumentTextController = TextEditingController(text: widget.mSettings.offerDocumentText);
    _appointmentDocumentTextController = TextEditingController(text: widget.mSettings.appointmentDocumentText);
    _deliveryNoteDocumentTextController = TextEditingController(text: widget.mSettings.deliveryNoteDocumentText);
    _invoiceDocumentTextController = TextEditingController(text: widget.mSettings.invoiceDocumentText);
    _creditDocumentTextController = TextEditingController(text: widget.mSettings.creditDocumentText);
    _termOfPaymentController = TextEditingController(text: widget.mSettings.termOfPayment.toString());

    _offerPraefixController = TextEditingController(text: widget.mSettings.offerPraefix);
    _appointmentPraefixController = TextEditingController(text: widget.mSettings.appointmentPraefix);
    _deliveryNotePraefixController = TextEditingController(text: widget.mSettings.deliveryNotePraefix);
    _invoicePraefixController = TextEditingController(text: widget.mSettings.invoicePraefix);
    _creditPraefixController = TextEditingController(text: widget.mSettings.creditPraefix);
    _nextOfferNumberController = TextEditingController(text: widget.mSettings.nextOfferNumber.toString());
    _nextAppointmentNumberController = TextEditingController(text: widget.mSettings.nextAppointmentNumber.toString());
    _nextDeliveryNoteNumberController = TextEditingController(text: widget.mSettings.nextDeliveryNoteNumber.toString());
    _nextInvoiceNumberController = TextEditingController(text: widget.mSettings.nextInvoiceNumber.toString());
    _nextCustomerNumberController = TextEditingController(text: widget.mSettings.nextCustomerNumber.toString());
    _nextSupplierNumberController = TextEditingController(text: widget.mSettings.nextSupplierNumber.toString());
    _nextReorderNumberController = TextEditingController(text: widget.mSettings.nextReorderNumber.toString());

    _bankNameController = TextEditingController(text: widget.mSettings.bankDetails.bankName);
    _bankIbanController = TextEditingController(text: widget.mSettings.bankDetails.bankIban);
    _bankBicController = TextEditingController(text: widget.mSettings.bankDetails.bankBic);
    _paypalEmailController = TextEditingController(text: widget.mSettings.bankDetails.paypalEmail);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainSettingsBloc, MainSettingsState>(
      builder: (context, state) {
        final appBar = AppBar(
          title: const Text('Einstellungen'),
          actions: [
            IconButton(onPressed: () => context.read<MainSettingsBloc>().add(GetMainSettingsEvent()), icon: const Icon(Icons.refresh)),
            MyOutlinedButton(buttonText: 'Speichern', onPressed: () => _onSaveSettings(), isLoading: state.isLoadingMainSettingsOnUpdate),
            Gaps.w16,
          ],
        );

        const drawer = AppDrawer();

        if ((state.mainSettings == null && state.firebaseFailure == null) || state.isLoadingMainSettingsOnObserve) {
          return Scaffold(appBar: appBar, drawer: drawer, body: const Center(child: CircularProgressIndicator()));
        }

        if (state.firebaseFailure != null && state.isAnyFailure) {
          return Scaffold(appBar: appBar, drawer: drawer, body: const Center(child: Text('Ein Fehler ist aufgetreten.')));
        }
        return Scaffold(
          appBar: appBar,
          drawer: drawer,
          body: SafeArea(
            child: SizedBox(
              width: 600,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: ListView(
                  children: [
                    MyFormFieldContainer(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Allgemein', style: TextStyles.h3BoldPrimary),
                          const Divider(),
                          MySettingsListTile(
                            title: 'Zahlungsziel in Tagen',
                            trailing: TextField(controller: _termOfPaymentController),
                          ),
                          // TODO: Implement UI for selecting default USt.
                          MySettingsListTile(
                            title: 'USt.',
                            trailing: TextField(controller: _termOfPaymentController),
                          ),
                          MySettingsListTile(
                            title: 'Kleinunternehmerregelung',
                            trailing: Switch.adaptive(value: _isSmallBusiness, onChanged: (value) => setState(() => _isSmallBusiness = value)),
                          ),
                          MySettingsListTile(
                            title: 'Währung',
                            divider: false,
                            trailing: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCurrencyItem,
                                items: currencyItems
                                    .map((currencyItem) => DropdownMenuItem<String>(value: currencyItem, child: Text(currencyItem)))
                                    .toList(),
                                onChanged: (currencyItem) => setState(() => _selectedCurrencyItem = currencyItem!),
                              ),
                            ),
                            trailingWidth: 100,
                          ),
                        ],
                      ),
                    ),
                    Gaps.h24,
                    MyFormFieldContainer(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Dokumente', style: TextStyles.h3BoldPrimary),
                          const Divider(),
                          MySettingsListTile(
                            title: 'Präfix Angebot.',
                            trailing: TextField(
                              controller: _offerPraefixController,
                              textCapitalization: TextCapitalization.characters,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Präfix Auftrag.',
                            trailing: TextField(
                              controller: _appointmentPraefixController,
                              textCapitalization: TextCapitalization.characters,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Präfix Lieferschein.',
                            trailing: TextField(
                              controller: _deliveryNotePraefixController,
                              textCapitalization: TextCapitalization.characters,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Präfix Rechnung.',
                            trailing: TextField(
                              controller: _invoicePraefixController,
                              textCapitalization: TextCapitalization.characters,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Präfix Rechnungskorrektur.',
                            trailing: TextField(
                              controller: _creditPraefixController,
                              textCapitalization: TextCapitalization.characters,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Nächste Angebotsnummer.',
                            trailing: TextField(
                              controller: _nextOfferNumberController,
                              keyboardType: TextInputType.number,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Nächste Auftragsnummer.',
                            trailing: TextField(
                              controller: _nextAppointmentNumberController,
                              keyboardType: TextInputType.number,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Nächste Lieferscheinnummer.',
                            trailing: TextField(
                              controller: _nextDeliveryNoteNumberController,
                              keyboardType: TextInputType.number,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Nächste Rechnungsnummer.',
                            trailing: TextField(
                              controller: _nextInvoiceNumberController,
                              keyboardType: TextInputType.number,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Nächste Kundennummer.',
                            trailing: TextField(
                              controller: _nextCustomerNumberController,
                              keyboardType: TextInputType.number,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Nächste Lieferantennummer.',
                            trailing: TextField(
                              controller: _nextSupplierNumberController,
                              keyboardType: TextInputType.number,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Nächste Nachbestellnummer.',
                            trailing: TextField(
                              controller: _nextReorderNumberController,
                              keyboardType: TextInputType.number,
                            ),
                            trailingWidth: 80,
                          ),
                        ],
                      ),
                    ),
                    Gaps.h24,
                    MyFormFieldContainer(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(),
                              const Text('Zahlungsarten', style: TextStyles.h3BoldPrimary),
                              IconButton(
                                onPressed: () => showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (_) => AddPaymentMethode(addToPaymentMethods: _addToPaymentMethods)),
                                icon: const Icon(Icons.add, color: Colors.green),
                              ),
                            ],
                          ),
                          const Divider(),
                          if (_paymentMethods.isEmpty)
                            const SizedBox(
                              height: 100,
                              child: Center(
                                child: Text('Keine Zahlungsarten vorhanden'),
                              ),
                            ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: _paymentMethods.length,
                            itemBuilder: (context, index) {
                              return MySettingsListTile(
                                title: _paymentMethods[index].name,
                                divider: index != _paymentMethods.length - 1,
                                onPressed: () {},
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () => showMyDialogDelete(
                                    context: context,
                                    onConfirm: () {
                                      _removeFromPaymentMethods(index);
                                      context.router.pop();
                                    },
                                    content: 'Bist du sicher, dass du diese Zahlungsmethode löschen willst?',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Gaps.h24,
                    MyFormFieldContainer(
                      child: Column(
                        children: [
                          const Text('Bankdaten', style: TextStyles.h3BoldPrimary),
                          const Divider(),
                          Gaps.h10,
                          MyTextFormField(
                            controller: _bankNameController,
                            labelText: 'Bankname',
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          Gaps.h16,
                          MyTextFormField(
                            controller: _bankIbanController,
                            labelText: 'IBAN',
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          Gaps.h16,
                          MyTextFormField(
                            controller: _bankBicController,
                            labelText: 'BIC',
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          Gaps.h16,
                          MyTextFormField(
                            controller: _paypalEmailController,
                            labelText: 'PayPal E-Mail',
                            textCapitalization: TextCapitalization.none,
                          ),
                        ],
                      ),
                    ),
                    Gaps.h24,
                    MyFormFieldContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('A4 Drucker:', style: TextStyles.infoOnTextField),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_printerMain != null && _printerMain!.name != null) Text(_printerMain!.name!) else const SizedBox(),
                              IconButton(
                                onPressed: () async {
                                  final pickedPrinter = await Printing.pickPrinter(context: context);
                                  if (pickedPrinter != null) setState(() => _printerMain = MyPrinter.fromPrinter(pickedPrinter));
                                },
                                icon: const Icon(Icons.edit, color: Colors.blue),
                              ),
                            ],
                          ),
                          const Text('Label Drucker:', style: TextStyles.infoOnTextField),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_printerLabel != null && _printerLabel!.name != null) Text(_printerLabel!.name!) else const SizedBox(),
                              IconButton(
                                onPressed: () async {
                                  final pickedPrinter = await Printing.pickPrinter(context: context);
                                  if (pickedPrinter != null) setState(() => _printerLabel = MyPrinter.fromPrinter(pickedPrinter));
                                },
                                icon: const Icon(Icons.edit, color: Colors.blue),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Gaps.h24,
                    MyFormFieldContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: Column(
                        children: [
                          const Text('Dokumenttexte', style: TextStyles.h3BoldPrimary),
                          const Divider(),
                          Gaps.h10,
                          MyTextFormField(
                            controller: _offerDocumentTextController,
                            labelText: 'Angebotstext',
                            maxLines: 3,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          const SizedBox(height: 20),
                          MyTextFormField(
                            controller: _appointmentDocumentTextController,
                            labelText: 'Auftragstext',
                            maxLines: 3,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          const SizedBox(height: 20),
                          MyTextFormField(
                            controller: _deliveryNoteDocumentTextController,
                            labelText: 'Lieferscheintext',
                            maxLines: 3,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          const SizedBox(height: 20),
                          MyTextFormField(
                            controller: _invoiceDocumentTextController,
                            labelText: 'Rechnungstext',
                            maxLines: 3,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          const SizedBox(height: 20),
                          MyTextFormField(
                            controller: _creditDocumentTextController,
                            labelText: 'Rechnungskorrekturtext',
                            maxLines: 3,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ],
                      ),
                    ),
                    Gaps.h54,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _addToPaymentMethods(String paymentMethod) {
    // if (_paymentMethods.any((e) => e == paymentMethod)) return;
    // setState(() => _paymentMethods.add(paymentMethod));
  }

  void _removeFromPaymentMethods(int index) {
    setState(() => _paymentMethods.removeAt(index));
  }

  void _onSaveSettings() {
    final updatedMainSettings = widget.mSettings.copyWith(
      offerPraefix: _offerPraefixController.text,
      appointmentPraefix: _appointmentPraefixController.text,
      deliveryNotePraefix: _deliveryNotePraefixController.text,
      invoicePraefix: _invoicePraefixController.text,
      creditPraefix: _creditPraefixController.text,
      currency: _selectedCurrencyItem,
      offerDocumentText: _offerDocumentTextController.text,
      appointmentDocumentText: _appointmentDocumentTextController.text,
      deliveryNoteDocumentText: _deliveryNoteDocumentTextController.text,
      invoiceDocumentText: _invoiceDocumentTextController.text,
      creditDocumentText: _creditDocumentTextController.text,
      nextOfferNumber: int.parse(_nextOfferNumberController.text),
      nextAppointmentNumber: int.parse(_nextAppointmentNumberController.text),
      nextDeliveryNoteNumber: int.parse(_nextDeliveryNoteNumberController.text),
      nextInvoiceNumber: int.parse(_nextInvoiceNumberController.text),
      nextCustomerNumber: int.parse(_nextCustomerNumberController.text),
      nextSupplierNumber: int.parse(_nextSupplierNumberController.text),
      nextReorderNumber: int.parse(_nextReorderNumberController.text),
      termOfPayment: int.parse(_termOfPaymentController.text),
      isSmallBusiness: _isSmallBusiness,
      paymentMethods: _paymentMethods,
      bankDetails: widget.mSettings.bankDetails.copyWith(
        bankName: _bankNameController.text,
        bankIban: _bankIbanController.text,
        bankBic: _bankBicController.text,
        paypalEmail: _paypalEmailController.text,
      ),
      printerMain: _printerMain,
      printerLabel: _printerLabel,
    );
    context.read<MainSettingsBloc>().add(UpdateMainSettingsEvent(mainSettings: updatedMainSettings));
  }
}
