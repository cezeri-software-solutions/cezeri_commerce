import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';

class MyDocumentScannerBasic extends StatefulWidget {
  final void Function(Uint8List imageBytes) onSave;

  const MyDocumentScannerBasic({super.key, required this.onSave});

  @override
  State<MyDocumentScannerBasic> createState() => _MyDocumentScannerBasicState();
}

class _MyDocumentScannerBasicState extends State<MyDocumentScannerBasic> {
  final _controller = DocumentScannerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DocumentScanner(
        controller: _controller,
        resolutionCamera: ResolutionPreset.veryHigh,
        cropPhotoDocumentStyle: CropPhotoDocumentStyle(
          top: MediaQuery.of(context).padding.top,
          textButtonSave: 'SPEICHERN',
          dotSize: 32,
        ),
        onSave: (Uint8List imageBytes) {
          // ? Bytes of the document/image already processed
          widget.onSave(imageBytes);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
