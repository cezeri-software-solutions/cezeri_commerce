import 'dart:convert';

import 'package:cezeri_commerce/1_presentation/core/widgets/my_outlined_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../3_domain/pdf/pdf_api_mobile.dart';
import '../../3_domain/pdf/pdf_api_web.dart';
import '../../constants.dart';
import '../core/widgets/my_form_field_container_small.dart';
import 'post_labelcenter_service.dart';

class ShippingLabelPage extends StatefulWidget {
  const ShippingLabelPage({super.key});

  @override
  State<ShippingLabelPage> createState() => _ShippingLabelPageState();
}

class _ShippingLabelPageState extends State<ShippingLabelPage> {
  late TextEditingController _senderCompanyName;
  late TextEditingController _senderName;
  late TextEditingController _sender;

  String generateSoapRequest() {
    return '''
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:post="http://post.ondot.at">
  <soapenv:Header/>
  <soapenv:Body>
    <post:ImportShipment>
      <post:row>
        <post:ClientID>-1</post:ClientID>
        <post:ColloList>
          <post:ColloRow>
            <post:Weight>17</post:Weight>
          </post:ColloRow>
        </post:ColloList>
        <post:CustomDataBit1>false</post:CustomDataBit1>
        <post:DeliveryServiceThirdPartyID>10</post:DeliveryServiceThirdPartyID>
        <post:OURecipientAddress>
          <post:AddressLine1>Teststrasse</post:AddressLine1>
          <post:AddressLine2/>
          <post:City>Wien</post:City>
          <post:CountryID>AT</post:CountryID>
          <post:Email/>
          <post:HouseNumber>1</post:HouseNumber>
          <post:Name1>Test Recipient</post:Name1>
          <post:PostalCode>1030</post:PostalCode>
        </post:OURecipientAddress>
        <post:OUShipperAddress>
          <post:AddressLine1>Musergasse</post:AddressLine1>
          <post:City>Wien</post:City>
          <post:CountryID>AT</post:CountryID>
          <post:Name1>test &amp; test</post:Name1>
          <post:Name2/>
          <post:PostalCode>1010</post:PostalCode>
        </post:OUShipperAddress>
        <post:OrgUnitGuid>cd96848d-6552-4653-a992-f0f411710fb4</post:OrgUnitGuid>
        <post:OrgUnitID>1461448</post:OrgUnitID>
        <post:PrinterObject>
          <post:LabelFormatID>100x150</post:LabelFormatID>
          <post:LanguageID>pdf</post:LanguageID>
          <post:PaperLayoutID>A6</post:PaperLayoutID>
        </post:PrinterObject>
      </post:row>
    </post:ImportShipment>
  </soapenv:Body>
</soapenv:Envelope>
  ''';
  }

  @override
  Widget build(BuildContext context) {
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
                      labelText: 'Firmenname',
                    ),
                    MyOutlinedButton(
                      buttonText: 'Label erstellen',
                      onPressed: () async {
                        final service = PostLabelcenterService();
                        final soapRequest = generateSoapRequest();
                        String pdfString = '';

                        try {
                          final response = await service.createShipment(soapRequest);
                          pdfString = response;
                          print('Response: $response');
                        } catch (e) {
                          print('Error: $e');
                        }
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
