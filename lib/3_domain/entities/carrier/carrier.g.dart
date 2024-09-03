// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carrier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Carrier _$CarrierFromJson(Map<String, dynamic> json) => Carrier(
      internalName: json['internalName'] as String,
      name: json['name'] as String,
      marketplaceMapping: json['marketplaceMapping'] as String,
      imagePath: json['imagePath'] as String,
      trackingUrl: json['trackingUrl'] as String,
      trackingUrl2: json['trackingUrl2'] as String?,
      carrierKey:
          CarrierKey.fromJson(json['carrierKey'] as Map<String, dynamic>),
      carrierTyp: $enumDecode(_$CarrierTypEnumMap, json['carrierTyp']),
      carrierAutomations: (json['carrierAutomations'] as List<dynamic>)
          .map((e) => CarrierProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      listOfPaperLayout: (json['listOfPaperLayout'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      paperLayout: json['paperLayout'] as String,
      listOfLabelSizes: (json['listOfLabelSizes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      labelSize: json['labelSize'] as String,
      listOfPrinterLanguages: (json['listOfPrinterLanguages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      printerLanguage: json['printerLanguage'] as String,
      isDefault: json['isDefault'] as bool,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$CarrierToJson(Carrier instance) => <String, dynamic>{
      'internalName': instance.internalName,
      'name': instance.name,
      'marketplaceMapping': instance.marketplaceMapping,
      'imagePath': instance.imagePath,
      'trackingUrl': instance.trackingUrl,
      'trackingUrl2': instance.trackingUrl2,
      'carrierKey': instance.carrierKey.toJson(),
      'carrierTyp': _$CarrierTypEnumMap[instance.carrierTyp]!,
      'carrierAutomations':
          instance.carrierAutomations.map((e) => e.toJson()).toList(),
      'listOfPaperLayout': instance.listOfPaperLayout,
      'paperLayout': instance.paperLayout,
      'listOfLabelSizes': instance.listOfLabelSizes,
      'labelSize': instance.labelSize,
      'listOfPrinterLanguages': instance.listOfPrinterLanguages,
      'printerLanguage': instance.printerLanguage,
      'isDefault': instance.isDefault,
      'isActive': instance.isActive,
    };

const _$CarrierTypEnumMap = {
  CarrierTyp.empty: 'empty',
  CarrierTyp.austrianPost: 'austrianPost',
  CarrierTyp.dpd: 'dpd',
};
