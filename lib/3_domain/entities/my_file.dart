import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import '../../constants.dart';

class MyFile {
  final Uint8List fileBytes;
  final String name;
  final String? mimeType;

  const MyFile({required this.fileBytes, required this.name, this.mimeType});

  factory MyFile.empty() {
    return MyFile(fileBytes: Uint8List(0), name: '', mimeType: null);
  }

  MyFile copyWith({
    Uint8List? fileBytes,
    String? name,
    String? mimeType,
  }) {
    return MyFile(
      fileBytes: fileBytes ?? this.fileBytes,
      name: name ?? this.name,
      mimeType: mimeType ?? this.mimeType,
    );
  }

  @override
  String toString() => 'MyFile(fileBytes: $fileBytes, name: $name, mimeType: $mimeType)';
}

Future<MyFile> convertPlatfomFileToMyFile(PlatformFile platformFile) async {
  final name = platformFile.name;
  Uint8List? fileBytes;

  if (platformFile.bytes != null) {
    // Für Web oder wenn Bytes verfügbar sind
    fileBytes = platformFile.bytes;
  } else if (platformFile.path != null) {
    // Für mobile Plattformen
    final file = File(platformFile.path!);
    fileBytes = await file.readAsBytes();
  } else {
    logger.e('Konnte die Datei für ${platformFile.name} nicht lesen');
  }

  return MyFile(name: name, fileBytes: fileBytes!);
}

Future<List<MyFile>> convertPlatfomFilesToMyFiles(List<PlatformFile> platformFiles) async {
  final List<MyFile> myFiles = [];

  for (final platformFile in platformFiles) {
    final myFile = await convertPlatfomFileToMyFile(platformFile);

    myFiles.add(myFile);
  }

  return myFiles;
}

Future<MyFile> convertIoFileToMyFile(File file) async {
  final name = file.path;
  final fileBytes = await file.readAsBytes();

  return MyFile(name: name, fileBytes: fileBytes);
}

Future<List<MyFile>> convertIoFilesToMyFiles(List<File> files) async {
  final List<MyFile> myFiles = [];

  for (final file in files) {
    final myFile = await convertIoFileToMyFile(file);

    myFiles.add(myFile);
  }

  return myFiles;
}
