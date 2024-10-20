import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

import '../../../3_domain/entities/my_file.dart';
import '../../../constants.dart';

class MyDropzoneWeb extends StatefulWidget {
  final Widget? title;
  final Icon? icon;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? highlightColor;
  final List<String>? mime;
  final Future<void> Function(List<MyFile>) getMyFiles;

  const MyDropzoneWeb({
    super.key,
    this.title,
    this.icon,
    this.height = 150,
    this.width = 300,
    this.borderRadius = 10.0,
    this.backgroundColor = Colors.green,
    this.highlightColor = CustomColors.primaryColor,
    this.mime = const [],
    required this.getMyFiles,
  });

  @override
  State<MyDropzoneWeb> createState() => _MyDropzoneWebState();
}

class _MyDropzoneWebState extends State<MyDropzoneWeb> {
  late DropzoneViewController _controller;
  bool _isHighlighted = false;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        final events = await _controller.pickFiles(multiple: true, mime: widget.mime!);
        if (events.isEmpty) return;

        final myFiles = await incomingInvoiceDropFiles(events, _controller);

        widget.getMyFiles(myFiles);
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: EdgeInsets.all(widget.borderRadius!),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius!),
          color: _isHighlighted ? widget.highlightColor : widget.backgroundColor,
        ),
        child: DottedBorder(
          borderType: BorderType.RRect,
          color: Colors.white,
          strokeWidth: 3,
          padding: EdgeInsets.zero,
          dashPattern: const [8, 4],
          radius: Radius.circular(widget.borderRadius!),
          child: Stack(
            children: [
              DropzoneView(
                onCreated: (controller) => _controller = controller,
                onDrop: (events) async {
                  final myFiles = await incomingInvoiceDropFile(events, _controller);

                  setState(() => _isHighlighted = false);

                  widget.getMyFiles([myFiles]);
                },
                onHover: () => setState(() => _isHighlighted = true),
                onLeave: () => setState(() => _isHighlighted = false),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.icon ?? const Icon(Icons.cloud_upload, size: 50, color: Colors.white),
                    widget.title ?? Text('Dokument/e hochladen', style: TextStyles.h3.copyWith(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<MyFile> incomingInvoiceDropFile(dynamic event, DropzoneViewController controller) async {
    final name = event.name;
    final mime = await controller.getFileMIME(event);
    final size = await controller.getFileSize(event);
    final bytes = await controller.getFileData(event);
    // final url = await controller.createFileUrl(event);

    print(name);

    final myFile = MyFile(fileBytes: bytes, name: name, mimeType: mime, size: size);

    return myFile;
  }

  Future<List<MyFile>> incomingInvoiceDropFiles(List<dynamic> events, DropzoneViewController controller) async {
    final myFiles = <MyFile>[];

    for (final event in events) {
      final myFile = await incomingInvoiceDropFile(event, controller);
      myFiles.add(myFile);
    }

    return myFiles;
  }
}
