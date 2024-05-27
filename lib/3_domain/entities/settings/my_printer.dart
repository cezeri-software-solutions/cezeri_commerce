import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:printing/printing.dart';

part 'my_printer.g.dart';

@JsonSerializable(explicitToJson: true)
class MyPrinter extends Equatable {
  final String url;
  final String? name;
  final String? model;
  final String? location;
  final String? comment;
  // @JsonKey(name: 'is_default')
  final bool? isDefault;
  // @JsonKey(name: 'is_available')
  final bool? isAvailable;

  const MyPrinter({
    required this.url,
    required this.name,
    required this.model,
    required this.location,
    required this.comment,
    required this.isDefault,
    required this.isAvailable,
  });

  factory MyPrinter.fromJson(Map<String, dynamic> json) => _$MyPrinterFromJson(json);
  Map<String, dynamic> toJson() => _$MyPrinterToJson(this);

  factory MyPrinter.empty() {
    return const MyPrinter(url: '', name: null, model: null, location: null, comment: null, isDefault: false, isAvailable: true);
  }

  factory MyPrinter.fromPrinter(Printer printer) {
    return MyPrinter(
      url: printer.url,
      name: printer.name,
      model: printer.model,
      location: printer.location,
      comment: printer.comment,
      isDefault: printer.isDefault,
      isAvailable: printer.isAvailable,
    );
  }

  MyPrinter copyWith({
    String? url,
    String? name,
    String? model,
    String? location,
    String? comment,
    bool? isDefault,
    bool? isAvailable,
  }) {
    return MyPrinter(
      url: url ?? this.url,
      name: name ?? this.name,
      model: model ?? this.model,
      location: location ?? this.location,
      comment: comment ?? this.comment,
      isDefault: isDefault ?? this.isDefault,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  @override
  List<Object?> get props => [];

  @override
  bool get stringify => true;
}
