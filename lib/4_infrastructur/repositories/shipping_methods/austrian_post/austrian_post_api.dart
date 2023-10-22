import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:xml/xml.dart';

class AustrianPostApiConfig {
  final String clientId;
  final String orgUnitId;
  final String orgUnitGuide;

  const AustrianPostApiConfig({required this.clientId, required this.orgUnitId, required this.orgUnitGuide});
}

class AustrianPostApiSettings {
  final String paperLayout;
  final String labelSize;
  final String printerLanguage;

  AustrianPostApiSettings({required this.paperLayout, required this.labelSize, required this.printerLanguage});
}

class AustrianPostApi {
  final String _baseUrl = 'https://abn-plc.post.at/DataService/Post.Webservice/ShippingService.svc/secure';
  final AustrianPostApiConfig _config;
  final AustrianPostApiSettings _settings;
  final bool _isReturn;

  AustrianPostApi(this._config, this._settings, this._isReturn);

  Future<String> createShipment(String soapRequest) async {
    final logger = Logger();
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'text/xml',
        'SOAPAction': 'http://post.ondot.at/IShippingService/ImportShipment',
      },
      body: soapRequest,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      logger.e(response.body);
      logger.e(response.statusCode);
      throw Exception('Failed to create shipment');
    }
  }

  String generateSoapRequest() {
    final builder = XmlBuilder();

    builder.element('soapenv:Envelope', nest: () {
      builder.attribute('xmlns:soapenv', 'http://schemas.xmlsoap.org/soap/envelope/');
      builder.attribute('xmlns:post', 'http://post.ondot.at');

      builder.element('soapenv:Header');
      builder.element('soapenv:Body', nest: () {
        builder.element('post:ImportShipment', nest: () {
          builder.element('post:row', nest: () {
            builder.element('post:ClientID', nest: _config.clientId);
            builder.element('post:ColloList', nest: () {
              builder.element('post:ColloRow', nest: () {
                builder.element('post:Weight', nest: '17');
              });
            });
            builder.element('post:CustomDataBit1', nest: 'false');
            builder.element('post:DeliveryServiceThirdPartyID', nest: '10');
            builder.element('post:OURecipientAddress', nest: () {
              builder.element('post:AddressLine1', nest: 'Teststrasse');
              builder.element('post:AddressLine2');
              builder.element('post:City', nest: 'Wien');
              builder.element('post:CountryID', nest: 'AT');
              builder.element('post:Email');
              builder.element('post:HouseNumber', nest: '1');
              builder.element('post:Name1', nest: 'Test Recipient');
              builder.element('post:PostalCode', nest: '1030');
            });
            builder.element('post:OUShipperAddress', nest: () {
              builder.element('post:AddressLine1', nest: 'Musergasse');
              builder.element('post:City', nest: 'Wien');
              builder.element('post:CountryID', nest: 'AT');
              builder.element('post:Name1', nest: 'test & test');
              builder.element('post:Name2');
              builder.element('post:PostalCode', nest: '1010');
            });
            builder.element('post:OrgUnitGuid', nest: _config.orgUnitGuide);
            builder.element('post:OrgUnitID', nest: _config.orgUnitId);
            builder.element('post:PrinterObject', nest: () {
              builder.element('post:LabelFormatID', nest: _settings.labelSize);
              builder.element('post:LanguageID', nest: _settings.printerLanguage);
              builder.element('post:PaperLayoutID', nest: _settings.paperLayout);
            });
          });
        });
      });
    });

    final document = builder.buildDocument();
    return document.toXmlString();
  }

  String getPdfLabel(String response) {
    final document = XmlDocument.parse(response);
    final pdfDataElement = document.findAllElements('pdfData').first;
    return pdfDataElement.innerText;
  }
}
