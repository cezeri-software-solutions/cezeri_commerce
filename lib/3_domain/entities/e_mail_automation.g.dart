// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'e_mail_automation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EMailAutomation _$EMailAutomationFromJson(Map<String, dynamic> json) =>
    EMailAutomation(
      id: json['id'] as String,
      isActive: json['isActive'] as bool,
      eMailAutomationType: $enumDecode(
          _$EMailAutomationTypeEnumMap, json['eMailAutomationType']),
      fromEmail: json['fromEmail'] as String,
      subject: json['subject'] as String,
      bcc: json['bcc'] as String,
      htmlContent: json['htmlContent'] as String,
    );

Map<String, dynamic> _$EMailAutomationToJson(EMailAutomation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isActive': instance.isActive,
      'eMailAutomationType':
          _$EMailAutomationTypeEnumMap[instance.eMailAutomationType]!,
      'fromEmail': instance.fromEmail,
      'subject': instance.subject,
      'bcc': instance.bcc,
      'htmlContent': instance.htmlContent,
    };

const _$EMailAutomationTypeEnumMap = {
  EMailAutomationType.offer: 'offer',
  EMailAutomationType.appointment: 'appointment',
  EMailAutomationType.deliveryNote: 'deliveryNote',
  EMailAutomationType.invoice: 'invoice',
  EMailAutomationType.credit: 'credit',
  EMailAutomationType.shipmentTracking: 'shipmentTracking',
};
