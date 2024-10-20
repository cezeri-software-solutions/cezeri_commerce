import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../../../../1_presentation/core/core.dart';
import '../../../../3_domain/entities/incoming_invoice/incoming_invoice_file.dart';
import '../../../../3_domain/entities/my_file.dart';
import '../../../../3_domain/entities/product/product_image.dart';
import '../../../../constants.dart';

Future<Uint8List?> downloadFileFromUrl(String url) async {
  try {
    // Lade die PDF-Datei von der URL herunter
    final response = await http.get(Uri.parse(url));

    // Prüfe, ob der Download erfolgreich war
    if (response.statusCode == 200) {
      // Konvertiere die heruntergeladenen Daten in eine Uint8List
      return response.bodyBytes;
    } else {
      logger.e("Fehler beim Herunterladen der Datei: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    logger.e("Exception beim Herunterladen der Datei: $e");
    return null;
  }
}

Future<List<ProductImage>> uploadImageFilesToStorageFromFlutter(
  List<ProductImage> listOfProductImages,
  List<MyFile> listOfMyFiles,
  String supabaseStoragePath,
) async {
  final List<ProductImage> newListOfProductImages = [];

  int sortId = listOfProductImages.length;

  for (final myFile in listOfMyFiles) {
    sortId++;

    final fileName = sanitizeFileName(basename(myFile.name));
    print('fileName: $fileName');
    final phFilePath = '$supabaseStoragePath/${generateRandomString(4)}_$fileName';
    print('phFilePath: $phFilePath');
    final filePath = Uri.encodeFull(phFilePath);
    print('filePath: $filePath');

    try {
      // Hochladen der Datei zu Supabase Storage mit uploadBinary()
      final String uploadedFilePath = await supabase.storage.from('product-images').uploadBinary(filePath, myFile.fileBytes);
      print('uploadedFilePath: $uploadedFilePath');
      final pathWithoutBucketName = extractPathFromUrl(uploadedFilePath, 'product-images');
      print('pathWithoutBucketName: $pathWithoutBucketName');

      // Erfolgreich hochgeladen, jetzt die öffentliche URL abrufen
      final String fileUrl = supabase.storage.from('product-images').getPublicUrl(pathWithoutBucketName);
      print('----------------------------------------------------------------------------------------------------------------------');
      print(fileUrl);
      print('----------------------------------------------------------------------------------------------------------------------');

      final imageFile = ProductImage.empty().copyWith(
        fileName: fileName,
        fileUrl: fileUrl,
        sortId: sortId,
        isDefault: listOfProductImages.isEmpty && sortId == 1,
      );
      newListOfProductImages.add(imageFile);
    } catch (e) {
      // Fehler beim Hochladen oder Abrufen der URL
      logger.e('Fehler beim Hochladen der Datei oder Abrufen der URL: $e');
      continue;
    }
  }
  return newListOfProductImages;
}

Future<List<IncomingInvoiceFile>> uploadIncomingInvoiceFilesToStorageFromFlutter(
  List<IncomingInvoiceFile>? listOfIncomingInvoiceFiles,
  String supabaseStoragePath,
) async {
  final List<IncomingInvoiceFile> newListOfInvoiceFiles = [];
  if (listOfIncomingInvoiceFiles == null) return newListOfInvoiceFiles;

  int sortId = listOfIncomingInvoiceFiles.length;

  for (final invoiceFile in listOfIncomingInvoiceFiles) {
    sortId++;

    final fileName = sanitizeFileName(basename(invoiceFile.name));
    print('fileName: $fileName');
    final phFilePath = '$supabaseStoragePath/${generateRandomString(4)}_$fileName';
    print('phFilePath: $phFilePath');
    final filePath = Uri.encodeFull(phFilePath);
    print('filePath: $filePath');

    try {
      // Hochladen der Datei zu Supabase Storage mit uploadBinary()
      final String uploadedFilePath = await supabase.storage.from('incoming-invoice-files').uploadBinary(filePath, invoiceFile.fileBytes!);
      print('uploadedFilePath: $uploadedFilePath');
      final pathWithoutBucketName = extractPathFromUrl(uploadedFilePath, 'incoming-invoice-files');
      print('pathWithoutBucketName: $pathWithoutBucketName');

      // Erfolgreich hochgeladen, jetzt die öffentliche URL abrufen
      final String fileUrl = supabase.storage.from('incoming-invoice-files').getPublicUrl(pathWithoutBucketName);
      print('----------------------------------------------------------------------------------------------------------------------');
      print(fileUrl);
      print('----------------------------------------------------------------------------------------------------------------------');

      final updatedInvoiceFile = invoiceFile.copyWith(name: fileName, url: fileUrl, sortId: sortId);

      newListOfInvoiceFiles.add(updatedInvoiceFile);
    } catch (e) {
      // Fehler beim Hochladen oder Abrufen der URL
      logger.e('Fehler beim Hochladen der Datei oder Abrufen der URL: $e');
      continue;
    }
  }
  return newListOfInvoiceFiles;
}

String extractPathFromUrl(String url, String path) {
  Uri uri = Uri.parse(url);
  int bucketIndex = uri.pathSegments.indexOf(path) + 1; // Findet den Index des Bucket-Namens und addiert 1
  return uri.pathSegments.sublist(bucketIndex).join('/'); // Extrahiert alles nach 'product-images'
}
