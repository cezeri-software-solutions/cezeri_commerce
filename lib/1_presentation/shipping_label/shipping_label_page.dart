// ignore_for_file: unused_field

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../3_domain/entities/address.dart';
import '../../3_domain/entities/carrier/carrier_product.dart';
import '../../3_domain/entities/country.dart';
import '../../3_domain/pdf/pdf_api_mobile.dart';
import '../../3_domain/pdf/pdf_api_web.dart';
import '../../4_infrastructur/repositories/shipping_methods/austrian_post/austrian_post_api.dart';
import '../../constants.dart';
import '../core/core.dart';

class ShippingLabelPage extends StatefulWidget {
  const ShippingLabelPage({super.key});

  @override
  State<ShippingLabelPage> createState() => _ShippingLabelPageState();
}

class _ShippingLabelPageState extends State<ShippingLabelPage> {
  final TextEditingController _senderCompanyName = TextEditingController();
  final TextEditingController _senderName = TextEditingController();
  final TextEditingController _senderStreet = TextEditingController();
  final TextEditingController _senderCity = TextEditingController();
  final TextEditingController _senderEmail = TextEditingController();
  final TextEditingController _senderPhone = TextEditingController();
  final TextEditingController _senderPhoneMobile = TextEditingController();
  final Country _senderCountry = Country.countryList.where((e) => e.isoCode == 'AT').first;

  final TextEditingController _recipientCompanyName = TextEditingController();
  final TextEditingController _recipientName = TextEditingController();
  final TextEditingController _recipientStreet = TextEditingController();
  final TextEditingController _recipientCity = TextEditingController();
  final TextEditingController _recipeintEmail = TextEditingController();
  final TextEditingController _recipeintPhone = TextEditingController();
  final TextEditingController _recipeintPhoneMobile = TextEditingController();
  final Country _recipientCountry = Country.countryList.where((e) => e.isoCode == 'AT').first;

  final TextEditingController _weight = TextEditingController();
  CarrierProduct carrierProduct = CarrierProduct.carrierProductListAustrianPost.first;

  @override
  Widget build(BuildContext context) {
    final ms = context.read<MainSettingsBloc>().state.mainSettings!;
    final defaultCarrier = ms.listOfCarriers.where((e) => e.isDefault).first;
    final cCredentials = defaultCarrier.carrierKey;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: 800,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Text('Absender', style: TextStyles.h3BoldPrimary),
                    const Divider(height: 30),
                    const MyTextFormFieldSmall(
                      fieldTitle: 'Firmenname',
                    ),
                    MyOutlinedButton(
                      buttonText: 'Label erstellen',
                      onPressed: () async {
                        final service = AustrianPostApi(
                          AustrianPostApiConfig(
                            clientId: cCredentials.clientId,
                            orgUnitId: cCredentials.orgUnitId,
                            orgUnitGuide: cCredentials.orgUnitGuide,
                          ),
                          AustrianPostApiSettings(
                            paperLayout: defaultCarrier.paperLayout,
                            labelSize: defaultCarrier.labelSize,
                            printerLanguage: defaultCarrier.printerLanguage,
                          ),
                          '10',
                          1,
                          Address(
                            id: '',
                            companyName: 'CCF-Miettextilien',
                            firstName: 'Mehmet',
                            lastName: 'Ince',
                            street: 'Sankt-Mang-Straße 39',
                            street2: '',
                            postcode: '6600',
                            city: 'Lechaschau',
                            country: Country.countryList.where((e) => e.isoCode == 'AT').first,
                            phone: '+43676942605',
                            phoneMobile: '',
                            addressType: AddressType.delivery,
                            isDefault: true,
                            creationDate: DateTime.now(),
                            lastEditingDate: DateTime.now(),
                          ),
                          'info@ccf-miettextilien.at',
                          Address(
                            id: '',
                            companyName: 'CCF-Autopflege',
                            firstName: 'Ali',
                            lastName: 'Ince',
                            street: 'Schmittenweg 4',
                            street2: '',
                            postcode: '6600',
                            city: 'Pflach',
                            country: Country.countryList.where((e) => e.isoCode == 'AT').first,
                            phone: '+436602234844',
                            phoneMobile: '',
                            addressType: AddressType.delivery,
                            isDefault: true,
                            creationDate: DateTime.now(),
                            lastEditingDate: DateTime.now(),
                          ),
                          'info@ccf-autopflege.at',
                          false,
                        );
                        final soapRequest = service.generateSoapRequest();

                        final response = await service.createShipment(soapRequest);
                        if (response.isLeft()) return;

                        final pdfString = response.getRight();
                        final base64String = service.getPdfLabel(pdfString);
                        final pdfBytes = base64.decode(base64String);
                        if (kIsWeb) {
                          await PdfApiWeb.saveDocument(name: 'testlabel.pdf', byteList: pdfBytes, showInBrowser: true);
                        } else {
                          await PdfApiMobile.saveDocument(name: 'testlabel.pdf', byteList: pdfBytes);
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
