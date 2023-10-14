// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:open_document/open_document.dart';
// import 'package:path_provider/path_provider.dart';

// class PdfApi {
//   static Future<void> saveDocument({
//     required String name,
//     required Uint8List byteList,
//   }) async {
//     if (Platform.isIOS) {
//       final output = await getTemporaryDirectory();
//       final filePath = '${output.path}/$name';
//       final file = File(filePath);

//       await file.writeAsBytes(byteList);
//       await OpenDocument.openDocument(filePath: filePath);
//     } else {
//       final output = await getExternalStorageDirectory();
//       final filePath = '${output!.path}/$name';
//       final file = File(filePath);

//       await file.writeAsBytes(byteList);
//       await OpenDocument.openDocument(filePath: filePath);
//     }
//   }

//   /* static Future openFile(File file) async {
//     final url = file.path;

//     await OpenFile.open(url);
//   } */
// }

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

// class PdfApi {
//   static Future<void> saveDocument({
//     required String name,
//     required Uint8List byteList,
//   }) async {
//     final output = await getExternalStorageDirectory();
//     final filePath = '${output!.path}/$name';
//     final file = File(filePath);

//     await file.writeAsBytes(byteList);
//     await OpenFilex.open(filePath);
//   }
// }

class PdfApi {
  static Future<void> saveDocument({
    required String name,
    required Uint8List byteList,
  }) async {
    if (kIsWeb) {
      final output = await getExternalStorageDirectory();
      final filePath = '${output!.path}/$name';
      final file = File(filePath);

      await file.writeAsBytes(byteList);
      await OpenFilex.open(filePath);
    }
    if (Platform.isIOS) {
      final output = await getTemporaryDirectory();
      final filePath = '${output.path}/$name';
      final file = File(filePath);

      await file.writeAsBytes(byteList);
      await OpenFilex.open(filePath);
    } else {
      final output = await getExternalStorageDirectory();
      final filePath = '${output!.path}/$name';
      final file = File(filePath);

      await file.writeAsBytes(byteList);
      await OpenFilex.open(filePath);
    }
  }

  /* static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  } */
}
