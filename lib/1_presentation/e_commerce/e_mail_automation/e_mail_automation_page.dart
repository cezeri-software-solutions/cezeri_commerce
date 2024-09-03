import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/3_domain/entities/e_mail_automation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import '../../../2_application/database/marketplace/marketplace_bloc.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/placeholder.dart';
import '../../../4_infrastructur/repositories/firebase/receipt_repository_impl.dart';
import '../../../constants.dart';
import '../../core/core.dart';

class EMailAutomationPage extends StatelessWidget {
  final MarketplaceBloc marketplaceBloc;

  const EMailAutomationPage({super.key, required this.marketplaceBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketplaceBloc, MarketplaceState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: ListView.builder(
            itemCount: state.listOfMarketplace!.length,
            itemBuilder: (context, index) {
              final marketplace = state.listOfMarketplace![index];
              final eMailAutomations = marketplace.marketplaceSettings.listOfEMailAutomations;
              final eMailAutomationOffer = eMailAutomations.where((e) => e.eMailAutomationType == EMailAutomationType.offer).firstOrNull;
              final eMailAutomationAppointment = eMailAutomations.where((e) => e.eMailAutomationType == EMailAutomationType.appointment).firstOrNull;
              final eMailAutomationDeliveryNote =
                  eMailAutomations.where((e) => e.eMailAutomationType == EMailAutomationType.deliveryNote).firstOrNull;
              final eMailAutomationInvoice = eMailAutomations.where((e) => e.eMailAutomationType == EMailAutomationType.invoice).firstOrNull;
              final eMailAutomationCredit = eMailAutomations.where((e) => e.eMailAutomationType == EMailAutomationType.credit).firstOrNull;
              final eMailAutomationShipmentTracking =
                  eMailAutomations.where((e) => e.eMailAutomationType == EMailAutomationType.shipmentTracking).firstOrNull;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(marketplace.name, style: TextStyles.h2Bold),
                  _AutomationRow(
                    marketplaceBloc: marketplaceBloc,
                    marketplace: marketplace,
                    title: 'Angebot:',
                    eMailAutomation: eMailAutomationOffer,
                    eMailAutomationType: EMailAutomationType.offer,
                  ),
                  _AutomationRow(
                    marketplaceBloc: marketplaceBloc,
                    marketplace: marketplace,
                    title: 'Auftrag:',
                    eMailAutomation: eMailAutomationAppointment,
                    eMailAutomationType: EMailAutomationType.appointment,
                  ),
                  _AutomationRow(
                    marketplaceBloc: marketplaceBloc,
                    marketplace: marketplace,
                    title: 'Lieferschein:',
                    eMailAutomation: eMailAutomationDeliveryNote,
                    eMailAutomationType: EMailAutomationType.deliveryNote,
                  ),
                  _AutomationRow(
                    marketplaceBloc: marketplaceBloc,
                    marketplace: marketplace,
                    title: 'Rechnung:',
                    eMailAutomation: eMailAutomationInvoice,
                    eMailAutomationType: EMailAutomationType.invoice,
                  ),
                  _AutomationRow(
                    marketplaceBloc: marketplaceBloc,
                    marketplace: marketplace,
                    title: 'Gutschrift:',
                    eMailAutomation: eMailAutomationCredit,
                    eMailAutomationType: EMailAutomationType.credit,
                  ),
                  _AutomationRow(
                    marketplaceBloc: marketplaceBloc,
                    marketplace: marketplace,
                    title: 'Sendungsverfolgung:',
                    eMailAutomation: eMailAutomationShipmentTracking,
                    eMailAutomationType: EMailAutomationType.shipmentTracking,
                  ),
                  const Divider(),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _AutomationRow extends StatelessWidget {
  final MarketplaceBloc marketplaceBloc;
  final AbstractMarketplace marketplace;
  final String title;
  final EMailAutomation? eMailAutomation;
  final EMailAutomationType eMailAutomationType;

  const _AutomationRow({
    required this.marketplaceBloc,
    required this.marketplace,
    required this.title,
    required this.eMailAutomation,
    required this.eMailAutomationType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyles.h3),
        IconButton(
          onPressed: () => showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => BlocProvider.value(
              value: marketplaceBloc,
              child: _EMailAutomationDialog(
                marketplaceBloc: marketplaceBloc,
                marketplace: marketplace,
                title: title,
                eMailAutomation: eMailAutomation,
                eMailAutomationType: eMailAutomationType,
              ),
            ),
          ),
          icon: eMailAutomation == null ? const Icon(Icons.add, color: Colors.green) : const Icon(Icons.edit, color: CustomColors.primaryColor),
        ),
      ],
    );
  }
}

class _EMailAutomationDialog extends StatefulWidget {
  final MarketplaceBloc marketplaceBloc;
  final AbstractMarketplace marketplace;
  final String title;
  final EMailAutomation? eMailAutomation;
  final EMailAutomationType eMailAutomationType;

  const _EMailAutomationDialog({
    required this.marketplaceBloc,
    required this.marketplace,
    required this.title,
    required this.eMailAutomation,
    required this.eMailAutomationType,
  });

  @override
  State<_EMailAutomationDialog> createState() => _EMailAutomationDialogState();
}

class _EMailAutomationDialogState extends State<_EMailAutomationDialog> {
  final _htmlController = HtmlEditorController();
  final _toEmailController = TextEditingController();
  TextEditingController _fromEmailController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _bccController = TextEditingController();

  final FocusNode _subjectFocusNode = FocusNode();

  bool isFocusOnHtmlEditor = false;
  bool isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.eMailAutomation != null) {
      _fromEmailController = TextEditingController(text: widget.eMailAutomation!.fromEmail);
      _subjectController = TextEditingController(text: widget.eMailAutomation!.subject);
      _bccController = TextEditingController(text: widget.eMailAutomation!.bcc);
      isActive = widget.eMailAutomation!.isActive;
    } else {
      _fromEmailController = TextEditingController();
      _subjectController = TextEditingController();
      _bccController = TextEditingController();
      isActive = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.title, style: TextStyles.h2Bold),
                  Switch.adaptive(value: isActive, onChanged: (value) => setState(() => isActive = value)),
                ],
              ),
              Gaps.h16,
              Row(
                children: [
                  Expanded(child: MyTextFormFieldSmall(labelText: 'Absender E-Mail:', controller: _fromEmailController)),
                  Gaps.w16,
                  Expanded(
                    child: MyTextFormFieldSmall(
                      labelText: 'Betreff:',
                      controller: _subjectController,
                      focusNode: _subjectFocusNode,
                    ),
                  ),
                ],
              ),
              Gaps.h8,
              Row(
                children: [
                  Expanded(child: MyTextFormFieldSmall(labelText: 'Bcc:', controller: _bccController)),
                  if (widget.eMailAutomation != null) ...[
                    Gaps.w16,
                    Expanded(child: MyTextFormFieldSmall(labelText: 'Empfänger E-Mail zum Testen:', controller: _toEmailController)),
                    TextButton(
                      onPressed: () async {
                        final html = await _htmlController.getText();
                        sendEmail(
                          to: _toEmailController.text,
                          from: _fromEmailController.text,
                          subject: _subjectController.text,
                          bcc: _bccController.text,
                          html: html,
                          text: 'Hallo das ist eine Test E-Mail',
                        );
                      },
                      child: const Text('Testmail verschicken'),
                    ),
                  ],
                ],
              ),
              Gaps.h16,
              Expanded(
                child: MyHtmlEditor(
                  controller: _htmlController,
                  initialText: widget.eMailAutomation?.htmlContent,
                  onChangeContent: (content) {}, //widget.marketplaceBloc.add(OnProductDescriptionChangedEvent(content: content)),
                  onFocus: () => setState(() => isFocusOnHtmlEditor = true),
                  onBlur: () => setState(() => isFocusOnHtmlEditor = false),
                ),
              ),
              Gaps.h10,
              MyOutlinedButton(
                buttonText: 'Marktplatz Logo einfügen',
                onPressed: () => _htmlController.insertNetworkImage(widget.marketplace.logoUrl),
              ),
              Gaps.h10,
              const Text('Platzhalter:', style: TextStyles.h3Bold),
              Gaps.h10,
              SizedBox(
                height: 30,
                child: ListView.builder(
                  itemCount: EMailPlaceholder.listOfPlaceholders.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final placeholder = EMailPlaceholder.listOfPlaceholders[index];
                    return Row(
                      children: [
                        _PlaceholderContainer(
                          placeholder: placeholder,
                          subjectController: _subjectController,
                          subjectFocusNode: _subjectFocusNode,
                          htmlController: _htmlController,
                          isFocusOnHtmlEditor: isFocusOnHtmlEditor,
                        ),
                        Gaps.w16,
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('* Die ${widget.title.substring(0, widget.title.length - 1)} wird automatisch mitgeschickt.'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyOutlinedButton(
                        buttonText: 'Abbrechen',
                        buttonBackgroundColor: Colors.red,
                        onPressed: () => context.router.pop(),
                      ),
                      Gaps.w16,
                      MyOutlinedButton(
                        buttonText: 'Speichern',
                        buttonBackgroundColor: Colors.green,
                        onPressed: () async {
                          final htmlContent = await _htmlController.getText();
                          if (widget.eMailAutomation == null) {
                            widget.marketplaceBloc.add(
                              OnAddMarketplaceEMailAutomationEvent(
                                marketplace: widget.marketplace,
                                eMailAutomation: EMailAutomation.empty().copyWith(
                                  isActive: isActive,
                                  eMailAutomationType: widget.eMailAutomationType,
                                  fromEmail: _fromEmailController.text,
                                  subject: _subjectController.text,
                                  bcc: _bccController.text,
                                  htmlContent: htmlContent,
                                ),
                              ),
                            );
                          } else {
                            widget.marketplaceBloc.add(
                              OnUpdateMarketplaceEMailAutomationEvent(
                                marketplace: widget.marketplace,
                                eMailAutomation: widget.eMailAutomation!.copyWith(
                                  isActive: isActive,
                                  eMailAutomationType: widget.eMailAutomationType,
                                  fromEmail: _fromEmailController.text,
                                  subject: _subjectController.text,
                                  bcc: _bccController.text,
                                  htmlContent: htmlContent,
                                ),
                              ),
                            );
                          }
                          if (context.mounted) context.router.pop();
                        },
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceholderContainer extends StatelessWidget {
  final EMailPlaceholder placeholder;
  final TextEditingController subjectController;
  final FocusNode subjectFocusNode;
  final HtmlEditorController htmlController;
  final bool isFocusOnHtmlEditor;

  const _PlaceholderContainer({
    required this.placeholder,
    required this.subjectController,
    required this.subjectFocusNode,
    required this.htmlController,
    required this.isFocusOnHtmlEditor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //* Betreff
        String textToInsert = placeholder.key;
        if (subjectFocusNode.hasFocus) {
          int cursorPos = subjectController.selection.baseOffset;
          String newText = subjectController.text.substring(0, cursorPos) + textToInsert + subjectController.text.substring(cursorPos);
          subjectController.text = newText;
          subjectController.selection = TextSelection.fromPosition(TextPosition(offset: cursorPos + textToInsert.length));
        }
        //* HTML Feld
        if (isFocusOnHtmlEditor) htmlController.insertText(textToInsert);
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 7),
        decoration: BoxDecoration(color: Colors.lightBlue[200], borderRadius: BorderRadius.circular(15)),
        child: Center(child: Text(placeholder.displayName)),
      ),
    );
  }
}
