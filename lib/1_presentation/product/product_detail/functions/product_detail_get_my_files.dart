import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

import '../../../../3_domain/entities/my_file.dart';
import '../../../../constants.dart';

Future<List<MyFile>?> productDetailGetMyFilesFromFilePicker() async {
  List<PlatformFile> imageFiles = [];

  try {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );
    if (result == null) return null;
    logger.i('Neues Artikelbild erfolgreich gepickt');
    imageFiles = result.files;
  } on PlatformException {
    logger.e('Fehler beim Auswählen des Produktbildes');
  }

  if (imageFiles.isEmpty) return null;

  final myFiles = await convertPlatfomFilesToMyFiles(imageFiles);

  return myFiles;
}
