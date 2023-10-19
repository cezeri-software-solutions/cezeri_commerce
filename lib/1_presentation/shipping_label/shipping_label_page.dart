import 'dart:convert';

import 'package:cezeri_commerce/1_presentation/core/widgets/my_outlined_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../3_domain/pdf/pdf_api_mobile.dart';
import '../../3_domain/pdf/pdf_api_web.dart';
import '../../4_infrastructur/repositories/shipping_methods/austrian_post/austrian_post_api.dart';
import '../../constants.dart';
import '../core/widgets/my_form_field_container_small.dart';

class ShippingLabelPage extends StatefulWidget {
  const ShippingLabelPage({super.key});

  @override
  State<ShippingLabelPage> createState() => _ShippingLabelPageState();
}

class _ShippingLabelPageState extends State<ShippingLabelPage> {
  late TextEditingController _senderCompanyName;
  late TextEditingController _senderName;
  late TextEditingController _sender;

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
                        final service = AustrianPostApi();
                        final soapRequest = service.generateSoapRequest(); //generateSoapRequest();
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
