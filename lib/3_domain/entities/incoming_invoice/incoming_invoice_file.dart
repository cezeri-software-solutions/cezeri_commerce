import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'incoming_invoice_file.g.dart';

@JsonSerializable()
class IncomingInvoiceFile extends Equatable {
  final String id;
  final String sortId;
  final String name;
  final String url;

  const IncomingInvoiceFile({required this.id, required this.sortId, required this.name, required this.url});

  factory IncomingInvoiceFile.fromJson(Map<String, dynamic> json) => _$IncomingInvoiceFileFromJson(json);
  Map<String, dynamic> toJson() => _$IncomingInvoiceFileToJson(this);

  IncomingInvoiceFile copyWith({
    String? id,
    String? sortId,
    String? name,
    String? url,
  }) {
    return IncomingInvoiceFile(
      id: id ?? this.id,
      sortId: sortId ?? this.sortId,
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  @override
  List<Object?> get props => [id, sortId, name, url];

  @override
  bool get stringify => true;
}
