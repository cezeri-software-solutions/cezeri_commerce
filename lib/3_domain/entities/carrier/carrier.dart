import 'package:json_annotation/json_annotation.dart';

import 'carrier_key.dart';
import 'carrier_product.dart';

part 'carrier.g.dart';

@JsonSerializable(explicitToJson: true)
class Carrier {
  final String internalName;
  final String name;
  final String marketplaceMapping;
  final String imagePath;
  final String trackingUrl;
  final CarrierKey carrierKey;
  final List<CarrierProduct> carrierProducts;
  final List<CarrierProduct> carrierAutomations;
  final List<String> listOfPaperLayout;
  final String paperLayout;
  final List<String> listOfLabelSizes;
  final String labelSize;
  final List<String> listOfPrinterLanguages;
  final String printerLanguage;
  final bool isDefault;

  Carrier({
    required this.internalName,
    required this.name,
    required this.marketplaceMapping,
    required this.imagePath,
    required this.trackingUrl,
    required this.carrierKey,
    required this.carrierProducts,
    required this.carrierAutomations,
    required this.listOfPaperLayout,
    required this.paperLayout,
    required this.listOfLabelSizes,
    required this.labelSize,
    required this.listOfPrinterLanguages,
    required this.printerLanguage,
    required this.isDefault,
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
      carrierProducts: [],
      carrierAutomations: [],
      listOfPaperLayout: [],
      paperLayout: '',
      listOfLabelSizes: [],
      labelSize: '',
      listOfPrinterLanguages: [],
      printerLanguage: '',
      isDefault: false,
    );
  }

  Carrier copyWith({
    String? internalName,
    String? name,
    String? marketplaceMapping,
    String? imagePath,
    String? trackingUrl,
    CarrierKey? carrierKey,
    List<CarrierProduct>? carrierProducts,
    List<CarrierProduct>? carrierAutomations,
    List<String>? listOfPaperLayout,
    String? paperLayout,
    List<String>? listOfLabelSizes,
    String? labelSize,
    List<String>? listOfPrinterLanguages,
    String? printerLanguage,
    bool? isDefault,
  }) {
    return Carrier(
      internalName: internalName ?? this.internalName,
      name: name ?? this.name,
      marketplaceMapping: marketplaceMapping ?? this.marketplaceMapping,
      imagePath: imagePath ?? this.imagePath,
      trackingUrl: trackingUrl ?? this.trackingUrl,
      carrierKey: carrierKey ?? this.carrierKey,
      carrierProducts: carrierProducts ?? this.carrierProducts,
      carrierAutomations: carrierAutomations ?? this.carrierAutomations,
      listOfPaperLayout: listOfPaperLayout ?? this.listOfPaperLayout,
      paperLayout: paperLayout ?? this.paperLayout,
      listOfLabelSizes: listOfLabelSizes ?? this.listOfLabelSizes,
      labelSize: labelSize ?? this.labelSize,
      listOfPrinterLanguages: listOfPrinterLanguages ?? this.listOfPrinterLanguages,
      printerLanguage: printerLanguage ?? this.printerLanguage,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  String toString() {
    return 'Carrier(internalName: $internalName, name: $name, marketplaceMapping: $marketplaceMapping, imagePath: $imagePath, trackingUrl: $trackingUrl, carrierKey: $carrierKey, carrierProducts: $carrierProducts, carrierAutomations: $carrierAutomations, listOfPaperLayout: $listOfPaperLayout, paperLayout: $paperLayout, listOfLabelSizes: $listOfLabelSizes, labelSize: $labelSize, listOfPrinterLanguages: $listOfPrinterLanguages, printerLanguage: $printerLanguage, isDefault: $isDefault)';
  }

  static List<Carrier> carrierList = [
    Carrier.empty().copyWith(
      internalName: 'Austrian Post',
      name: 'Österreichische Post',
      imagePath: 'assets/carriers/AustrianPost.jpg',
      trackingUrl: 'https://www.post.at/s/sendungsdetails?snr=',
      listOfPaperLayout: ['2xA5inA4', 'A5', 'A4'],
      paperLayout: '2xA5inA4',
      listOfLabelSizes: ['100x150', '100x200'],
      labelSize: '100x150',
      listOfPrinterLanguages: ['PDF', 'ZPL2'],
      printerLanguage: 'PDF',
    ),
    Carrier.empty().copyWith(internalName: 'DPD', name: 'DPD', imagePath: 'assets/carriers/DPD.jpg'),
  ];
}
