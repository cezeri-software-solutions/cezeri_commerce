import 'package:flutter_dropzone/flutter_dropzone.dart';

Future incomingInvoiceDropFile(dynamic event, DropzoneViewController controller) async {
  final name = event.name;
  final mime = await controller.getFileMIME(event);
  final bytes = await controller.getFileSize(event);
  final url = await controller.createFileUrl(event);

  print('Name: $name');
  print('Mime: $mime');
  print('Bytes: $bytes');
  print('Url: $url');
}
