import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:xml/xml.dart';

class PostLabelcenterService {
  final String baseUrl = 'https://abn-plc.post.at/DataService/Post.Webservice/ShippingService.svc/secure';
  final String username = 'demo';
  final String password = 'demo';

  Future<String> createShipment(String soapRequest) async {
    final logger = Logger();
    final response = await http.post(
      Uri.parse(baseUrl),
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

  String getPdfLabel(String response) {
  final document = XmlDocument.parse(response);
  final pdfDataElement = document.findAllElements('pdfData').first;
  return pdfDataElement.text;
}

}
