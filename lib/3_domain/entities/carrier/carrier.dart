import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'carrier_key.dart';
import 'carrier_product.dart';

part 'carrier.g.dart';

enum CarrierTyp { empty, austrianPost, dpd }

@JsonSerializable(explicitToJson: true)
class Carrier extends Equatable {
  // @JsonKey(toJson: null)
  // final String id;
  // @JsonKey(name: 'internal_name')
  final String internalName;
  final String name;
  // @JsonKey(name: 'marketplace_mapping')
  final String marketplaceMapping;
  // @JsonKey(name: 'image_path')
  final String imagePath;
  // @JsonKey(name: 'tracking_url')
  final String trackingUrl;
  // @JsonKey(name: 'tracking_url_2')
  final String? trackingUrl2;
  // @JsonKey(name: 'carrier_key')
  final CarrierKey carrierKey;
  // @JsonKey(name: 'carrier_typ')
  final CarrierTyp carrierTyp;
  // @JsonKey(name: 'carrier_automations')
  final List<CarrierProduct> carrierAutomations;
  // @JsonKey(name: 'list_of_paper_layout')
  final List<String> listOfPaperLayout;
  // @JsonKey(name: 'paper_layout')
  final String paperLayout;
  // @JsonKey(name: 'list_of_label_sizes')
  final List<String> listOfLabelSizes;
  // @JsonKey(name: 'label_size')
  final String labelSize;
  // @JsonKey(name: 'list_of_printer_languages')
  final List<String> listOfPrinterLanguages;
  // @JsonKey(name: 'printer_language')
  final String printerLanguage;
  // @JsonKey(name: 'is_default')
  final bool isDefault;
  // @JsonKey(name: 'is_active')
  final bool isActive;

  const Carrier({
    // required this.id,
    required this.internalName,
    required this.name,
    required this.marketplaceMapping,
    required this.imagePath,
    required this.trackingUrl,
    this.trackingUrl2,
    required this.carrierKey,
    required this.carrierTyp,
    required this.carrierAutomations,
    required this.listOfPaperLayout,
    required this.paperLayout,
    required this.listOfLabelSizes,
    required this.labelSize,
    required this.listOfPrinterLanguages,
    required this.printerLanguage,
    required this.isDefault,
    required this.isActive,
  });

  factory Carrier.fromJson(Map<String, dynamic> json) => _$CarrierFromJson(json);

  Map<String, dynamic> toJson() => _$CarrierToJson(this);

  factory Carrier.empty() {
    return Carrier(
      // id: '',
      internalName: '',
      name: '',
      marketplaceMapping: '',
      imagePath: '',
      trackingUrl: '',
      trackingUrl2: null,
      carrierKey: CarrierKey.empty(),
      carrierTyp: CarrierTyp.empty,
      carrierAutomations: const [],
      listOfPaperLayout: const [],
      paperLayout: '',
      listOfLabelSizes: const [],
      labelSize: '',
      listOfPrinterLanguages: const [],
      printerLanguage: '',
      isDefault: false,
      isActive: false,
    );
  }

  Carrier copyWith({
    // String? id,
    String? internalName,
    String? name,
    String? marketplaceMapping,
    String? imagePath,
    String? trackingUrl,
    String? trackingUrl2,
    CarrierKey? carrierKey,
    CarrierTyp? carrierTyp,
    List<CarrierProduct>? carrierAutomations,
    List<String>? listOfPaperLayout,
    String? paperLayout,
    List<String>? listOfLabelSizes,
    String? labelSize,
    List<String>? listOfPrinterLanguages,
    String? printerLanguage,
    bool? isDefault,
    bool? isActive,
  }) {
    return Carrier(
      // id: id ?? this.id,
      internalName: internalName ?? this.internalName,
      name: name ?? this.name,
      marketplaceMapping: marketplaceMapping ?? this.marketplaceMapping,
      imagePath: imagePath ?? this.imagePath,
      trackingUrl: trackingUrl ?? this.trackingUrl,
      trackingUrl2: trackingUrl2 ?? this.trackingUrl2,
      carrierKey: carrierKey ?? this.carrierKey,
      carrierTyp: carrierTyp ?? this.carrierTyp,
      carrierAutomations: carrierAutomations ?? this.carrierAutomations,
      listOfPaperLayout: listOfPaperLayout ?? this.listOfPaperLayout,
      paperLayout: paperLayout ?? this.paperLayout,
      listOfLabelSizes: listOfLabelSizes ?? this.listOfLabelSizes,
      labelSize: labelSize ?? this.labelSize,
      listOfPrinterLanguages: listOfPrinterLanguages ?? this.listOfPrinterLanguages,
      printerLanguage: printerLanguage ?? this.printerLanguage,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [];

  @override
  bool get stringify => true;

  static List<Carrier> carrierList = [
    Carrier.empty().copyWith(
      // id: '1',
      internalName: 'Austrian Post',
      name: 'Österreichische Post',
      imagePath: 'assets/carriers/AustrianPost.jpg',
      trackingUrl: 'https://www.post.at/s/sendungsdetails?snr=',
      trackingUrl2: 'https://www.dhl.de/de/privatkunden/dhl-sendungsverfolgung.html?piececode=',
      carrierTyp: CarrierTyp.austrianPost,
      listOfPaperLayout: ['2xA5inA4', 'A6', 'A5', 'A4'],
      paperLayout: '2xA5inA4',
      listOfLabelSizes: ['100x150', '100x200'],
      labelSize: '100x150',
      listOfPrinterLanguages: ['PDF', 'ZPL2'],
      printerLanguage: 'PDF',
    ),
    Carrier.empty().copyWith(
      // id: '2',
      internalName: 'DPD',
      name: 'DPD',
      imagePath: 'assets/carriers/DPD.jpg',
    ),
  ];
}
