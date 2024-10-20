import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'incoming_invoice_file.g.dart';

@JsonSerializable()
class IncomingInvoiceFile extends Equatable {
  final String id;
  @JsonKey(name: 'sort_id')
  final int sortId;
  final String name;
  final String url;
  @JsonKey(name: 'file_bytes', includeToJson: false, includeFromJson: false)
  final Uint8List? fileBytes;
  @JsonKey(name: 'mime_type')
  final String? mimeType;

  const IncomingInvoiceFile({required this.id, required this.sortId, required this.name, required this.url, this.fileBytes, this.mimeType});

  factory IncomingInvoiceFile.fromJson(Map<String, dynamic> json) => _$IncomingInvoiceFileFromJson(json);
  Map<String, dynamic> toJson() => _$IncomingInvoiceFileToJson(this);

  IncomingInvoiceFile copyWith({
    String? id,
    int? sortId,
    String? name,
    String? url,
    Uint8List? fileBytes,
    String? mimeType,
  }) {
    return IncomingInvoiceFile(
      id: id ?? this.id,
      sortId: sortId ?? this.sortId,
      name: name ?? this.name,
      url: url ?? this.url,
      fileBytes: fileBytes ?? this.fileBytes,
      mimeType: mimeType ?? this.mimeType,
    );
  }

  @override
  List<Object?> get props => [id, sortId, name, url, fileBytes, mimeType];

  @override
  bool get stringify => true;
}
