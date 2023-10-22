import 'package:json_annotation/json_annotation.dart';

import 'carrier_key.dart';
import 'carrier_product.dart';

part 'carrier.g.dart';

enum CarrierTyp { empty, austrianPost, dpd }

@JsonSerializable(explicitToJson: true)
class Carrier {
  final String internalName;
  final String name;
  final String marketplaceMapping;
  final String imagePath;
  final String trackingUrl;
  final CarrierKey carrierKey;
  final CarrierTyp carrierTyp;
  final List<CarrierProduct> carrierAutomations;
  final List<String> listOfPaperLayout;
  final String paperLayout;
  final List<String> listOfLabelSizes;
  final String labelSize;
  final List<String> listOfPrinterLanguages;
  final String printerLanguage;
  final bool isDefault;
  final bool isActive;

  Carrier({
    required this.internalName,
    required this.name,
    required this.marketplaceMapping,
    required this.imagePath,
    required this.trackingUrl,
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
      internalName: '',
      name: '',
      marketplaceMapping: '',
      imagePath: '',
      trackingUrl: '',
      carrierKey: CarrierKey.empty(),
      carrierTyp: CarrierTyp.empty,
      carrierAutomations: [],
      listOfPaperLayout: [],
      paperLayout: '',
      listOfLabelSizes: [],
      labelSize: '',
      listOfPrinterLanguages: [],
      printerLanguage: '',
      isDefault: false,
      isActive: false,
    );
  }

  Carrier copyWith({
    String? internalName,
    String? name,
    String? marketplaceMapping,
    String? imagePath,
    String? trackingUrl,
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
      internalName: internalName ?? this.internalName,
      name: name ?? this.name,
      marketplaceMapping: marketplaceMapping ?? this.marketplaceMapping,
      imagePath: imagePath ?? this.imagePath,
      trackingUrl: trackingUrl ?? this.trackingUrl,
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
  String toString() {
    return 'Carrier(internalName: $internalName, name: $name, marketplaceMapping: $marketplaceMapping, imagePath: $imagePath, trackingUrl: $trackingUrl, carrierKey: $carrierKey, carrierTyp: $carrierTyp, carrierAutomations: $carrierAutomations, listOfPaperLayout: $listOfPaperLayout, paperLayout: $paperLayout, listOfLabelSizes: $listOfLabelSizes, labelSize: $labelSize, listOfPrinterLanguages: $listOfPrinterLanguages, printerLanguage: $printerLanguage, isDefault: $isDefault, isActive: $isActive)';
  }

  static List<Carrier> carrierList = [
    Carrier.empty().copyWith(
      internalName: 'Austrian Post',
      name: 'Österreichische Post',
      imagePath: 'assets/carriers/AustrianPost.jpg',
      trackingUrl: 'https://www.post.at/s/sendungsdetails?snr=',
      carrierTyp: CarrierTyp.austrianPost,
      listOfPaperLayout: ['2xA5inA4', 'A6', 'A5', 'A4'],
      paperLayout: '2xA5inA4',
      listOfLabelSizes: ['100x150', '100x200'],
      labelSize: '100x150',
      listOfPrinterLanguages: ['PDF', 'ZPL2'],
      printerLanguage: 'PDF',
    ),
    Carrier.empty().copyWith(internalName: 'DPD', name: 'DPD', imagePath: 'assets/carriers/DPD.jpg'),
  ];
}
