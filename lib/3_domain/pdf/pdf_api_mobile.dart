import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class PdfApiMobile {
  static Future<void> saveDocument({
    required String name,
    required Uint8List byteList,
  }) async {
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
}
