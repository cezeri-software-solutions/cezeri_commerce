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
  late TextEditingController _incomingInvoicePraefixController = TextEditingController();
  late TextEditingController _nextOfferNumberController = TextEditingController();
  late TextEditingController _nextAppointmentNumberController = TextEditingController();
  late TextEditingController _nextDeliveryNoteNumberController = TextEditingController();
  late TextEditingController _nextInvoiceNumberController = TextEditingController();
  late TextEditingController _nextIncomingInvoiceNumberController = TextEditingController();
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
    _incomingInvoicePraefixController = TextEditingController(text: widget.mSettings.incomingInvoicePraefix);
    _nextOfferNumberController = TextEditingController(text: widget.mSettings.nextOfferNumber.toString());
    _nextAppointmentNumberController = TextEditingController(text: widget.mSettings.nextAppointmentNumber.toString());
    _nextDeliveryNoteNumberController = TextEditingController(text: widget.mSettings.nextDeliveryNoteNumber.toString());
    _nextInvoiceNumberController = TextEditingController(text: widget.mSettings.nextInvoiceNumber.toString());
    _nextIncomingInvoiceNumberController = TextEditingController(text: widget.mSettings.nextIncomingInvoiceNumber.toString());
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
                            trailing: MyTextFormFieldSmall(controller: _termOfPaymentController),
                          ),
                          // TODO: Implement UI for selecting default USt.
                          MySettingsListTile(
                            title: 'USt.',
                            trailing: MyTextFormFieldSmall(controller: _termOfPaymentController),
                          ),
                          MySettingsListTile(
                            title: 'Kleinunternehmerregelung',
                            trailing: Switch.adaptive(value: _isSmallBusiness, onChanged: (value) => setState(() => _isSmallBusiness = value)),
                          ),
                          MySettingsListTile(
                            title: 'Währung',
                            trailing: DropdownButtonHideUnderline(
                              child: MyDropdownButtonSmall(
                                value: _selectedCurrencyItem,
                                onChanged: (currencyItem) => setState(() => _selectedCurrencyItem = currencyItem!),
                                items: currencyItems,
                                maxWidth: 100,
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
                            trailing: MyTextFormFieldSmall(
                              controller: _offerPraefixController,
                              textCapitalization: TextCapitalization.characters,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Präfix Auftrag.',
                            trailing: MyTextFormFieldSmall(
                              controller: _appointmentPraefixController,
                              textCapitalization: TextCapitalization.characters,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Präfix Lieferschein.',
                            trailing: MyTextFormFieldSmall(
                              controller: _deliveryNotePraefixController,
                              textCapitalization: TextCapitalization.characters,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Präfix Rechnung.',
                            trailing: MyTextFormFieldSmall(
                              controller: _invoicePraefixController,
                              textCapitalization: TextCapitalization.characters,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Präfix Rechnungskorrektur.',
                            trailing: MyTextFormFieldSmall(
                              controller: _creditPraefixController,
                              textCapitalization: TextCapitalization.characters,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Präfix Eingangsrechnung.',
                            trailing: MyTextFormFieldSmall(
                              controller: _incomingInvoicePraefixController,
                              textCapitalization: TextCapitalization.characters,
                            ),
                            trailingWidth: 80,
                          ),
                          Gaps.h24,
                          MySettingsListTile(
                            title: 'Nächste Angebotsnummer.',
                            trailing: MyTextFormFieldSmall(
                              controller: _nextOfferNumberController,
                              keyboardType: TextInputType.number,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Nächste Auftragsnummer.',
                            trailing: MyTextFormFieldSmall(
                              controller: _nextAppointmentNumberController,
                              keyboardType: TextInputType.number,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Nächste Lieferscheinnummer.',
                            trailing: MyTextFormFieldSmall(
                              controller: _nextDeliveryNoteNumberController,
                              keyboardType: TextInputType.number,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Nächste Rechnungsnummer.',
                            trailing: MyTextFormFieldSmall(
                              controller: _nextInvoiceNumberController,
                              keyboardType: TextInputType.number,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Nächste Eingangsrechnungsnummer.',
                            trailing: MyTextFormFieldSmall(
                              controller: _nextIncomingInvoiceNumberController,
                              keyboardType: TextInputType.number,
                            ),
                            trailingWidth: 80,
                          ),
                          Gaps.h24,
                          MySettingsListTile(
                            title: 'Nächste Kundennummer.',
                            trailing: MyTextFormFieldSmall(
                              controller: _nextCustomerNumberController,
                              keyboardType: TextInputType.number,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Nächste Lieferantennummer.',
                            trailing: MyTextFormFieldSmall(
                              controller: _nextSupplierNumberController,
                              keyboardType: TextInputType.number,
                            ),
                            trailingWidth: 80,
                          ),
                          MySettingsListTile(
                            title: 'Nächste Nachbestellnummer.',
                            trailing: MyTextFormFieldSmall(
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
                        children: [
                          const Text('Bankdaten', style: TextStyles.h3BoldPrimary),
                          const Divider(),
                          Gaps.h10,
                          MyTextFormFieldSmall(
                            controller: _bankNameController,
                            fieldTitle: 'Bankname',
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          Gaps.h16,
                          MyTextFormFieldSmall(
                            controller: _bankIbanController,
                            fieldTitle: 'IBAN',
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          Gaps.h16,
                          MyTextFormFieldSmall(
                            controller: _bankBicController,
                            fieldTitle: 'BIC',
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          Gaps.h16,
                          MyTextFormFieldSmall(
                            controller: _paypalEmailController,
                            fieldTitle: 'PayPal E-Mail',
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
                          MyTextFormFieldSmall(
                            controller: _offerDocumentTextController,
                            fieldTitle: 'Angebotstext',
                            maxLines: 3,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          const SizedBox(height: 20),
                          MyTextFormFieldSmall(
                            controller: _appointmentDocumentTextController,
                            fieldTitle: 'Auftragstext',
                            maxLines: 3,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          const SizedBox(height: 20),
                          MyTextFormFieldSmall(
                            controller: _deliveryNoteDocumentTextController,
                            fieldTitle: 'Lieferscheintext',
                            maxLines: 3,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          const SizedBox(height: 20),
                          MyTextFormFieldSmall(
                            controller: _invoiceDocumentTextController,
                            fieldTitle: 'Rechnungstext',
                            maxLines: 3,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          const SizedBox(height: 20),
                          MyTextFormFieldSmall(
                            controller: _creditDocumentTextController,
                            fieldTitle: 'Rechnungskorrekturtext',
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

  void _onSaveSettings() {
    final updatedMainSettings = widget.mSettings.copyWith(
      offerPraefix: _offerPraefixController.text,
      appointmentPraefix: _appointmentPraefixController.text,
      deliveryNotePraefix: _deliveryNotePraefixController.text,
      invoicePraefix: _invoicePraefixController.text,
      creditPraefix: _creditPraefixController.text,
      incomingInvoicePraefix: _incomingInvoicePraefixController.text,
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
      nextIncomingInvoiceNumber: int.parse(_nextIncomingInvoiceNumberController.text),
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
