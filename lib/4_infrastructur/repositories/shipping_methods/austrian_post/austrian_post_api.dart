import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:xml/xml.dart';

import '../../../../3_domain/entities/address.dart';
import '../../../../constants.dart';
import '../../../../failures/failures.dart';

class AustrianPostApiConfig {
  final String clientId;
  final String orgUnitId;
  final String orgUnitGuide;

  const AustrianPostApiConfig({required this.clientId, required this.orgUnitId, required this.orgUnitGuide});

  @override
  String toString() => 'AustrianPostApiConfig(clientId: $clientId, orgUnitId: $orgUnitId, orgUnitGuide: $orgUnitGuide)';
}

class AustrianPostApiSettings {
  final String paperLayout;
  final String labelSize;
  final String printerLanguage;

  AustrianPostApiSettings({required this.paperLayout, required this.labelSize, required this.printerLanguage});

  @override
  String toString() => 'AustrianPostApiSettings(paperLayout: $paperLayout, labelSize: $labelSize, printerLanguage: $printerLanguage)';
}

class AustrianPostApi {
  final AustrianPostApiConfig _config;
  final AustrianPostApiSettings _settings;
  final String _carrierProductId;
  final double _weight;
  final Address _recipientAddress;
  final String _recipientEMail;
  final Address _shipperAddress;
  final String _shipperEMail;
  final bool _isReturn;

  AustrianPostApi(
    this._config,
    this._settings,
    this._carrierProductId,
    this._weight,
    this._recipientAddress,
    this._recipientEMail,
    this._shipperAddress,
    this._shipperEMail,
    this._isReturn,
  );

  Future<Either<AbstractFailure, String>> createShipment(String soapRequest) async {
    try {
      final response = await supabase.functions.invoke('austrian_post_api', body: jsonEncode({'soapRequest': soapRequest}));
      return Right(response.data);
    } catch (e) {
      logger.e('Error: $e');
      return Left(GeneralFailure(customMessage: 'Error on create austrian post label: $e'));
    }
  }

  String generateSoapRequest() {
    final name1 =
        _recipientAddress.companyName.isEmpty || _recipientAddress.companyName == '' ? _recipientAddress.name : _recipientAddress.companyName;
    final name2 = _recipientAddress.companyName.isEmpty || _recipientAddress.companyName == '' ? '' : _recipientAddress.name;
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
                builder.element('post:Weight', nest: _weight);
              });
            });
            builder.element('post:CustomDataBit1', nest: 'false');
            builder.element('post:DeliveryServiceThirdPartyID', nest: _carrierProductId);
            builder.element('post:OURecipientAddress', nest: () {
              builder.element('post:AddressLine1', nest: _recipientAddress.street);
              builder.element('post:AddressLine2', nest: _recipientAddress.street2);
              builder.element('post:City', nest: _recipientAddress.city);
              builder.element('post:CountryID', nest: _recipientAddress.country.isoCode);
              builder.element('post:Email', nest: _recipientEMail);
              builder.element('post:Name1', nest: name1);
              builder.element('post:Name2', nest: name2);
              builder.element('post:PostalCode', nest: _recipientAddress.postcode);
              builder.element('post:Tel1', nest: _recipientAddress.phone);
              builder.element('post:Tel2', nest: _recipientAddress.phoneMobile);
            });
            builder.element('post:OUShipperAddress', nest: () {
              builder.element('post:AddressLine1', nest: _shipperAddress.street);
              builder.element('post:City', nest: _shipperAddress.city);
              builder.element('post:CountryID', nest: _shipperAddress.country.isoCode);
              builder.element('post:Email', nest: _shipperEMail);
              builder.element('post:Name1', nest: _shipperAddress.companyName);
              builder.element('post:Name2');
              builder.element('post:PostalCode', nest: _shipperAddress.postcode);
              builder.element('post:Tel1', nest: _shipperAddress.phone);
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

  ({String trackingNumber, String? trackingNumber2}) getTrackingNumber(String response) {
    final document = XmlDocument.parse(response);
    final code2 = document.findAllElements('Code').elementAtOrNull(1);
    if (code2 != null) code2.innerText;
    final trackingCode = document.findAllElements('Code').first;
    final trackingCode2 = code2?.innerText;
    return (trackingNumber: trackingCode.innerText, trackingNumber2: trackingCode2);
  }

  String getPdfLabel(String response) {
    final document = XmlDocument.parse(response);
    final pdfDataElement = document.findAllElements('pdfData').first;
    return pdfDataElement.innerText;
  }

  @override
  String toString() {
    return 'AustrianPostApi(_config: $_config, _settings: $_settings, _carrierProductId: $_carrierProductId, _weight: $_weight, _recipientAddress: $_recipientAddress, _recipientEMail: $_recipientEMail, _shipperAddress: $_shipperAddress, _shipperEMail: $_shipperEMail, _isReturn: $_isReturn)';
  }
}
