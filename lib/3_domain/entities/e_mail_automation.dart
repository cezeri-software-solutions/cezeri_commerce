import 'package:json_annotation/json_annotation.dart';

part 'e_mail_automation.g.dart';

enum EMailAutomationType { offer, appointment, deliveryNote, invoice, credit, shipmentTracking }

@JsonSerializable(explicitToJson: true)
class EMailAutomation {
  final String id;
  final bool isActive;
  final EMailAutomationType eMailAutomationType;
  final String fromEmail;
  final String subject;
  final String bcc;
  final String htmlContent;

  EMailAutomation({
    required this.id,
    required this.isActive,
    required this.eMailAutomationType,
    required this.fromEmail,
    required this.subject,
    required this.bcc,
    required this.htmlContent,
  });

  factory EMailAutomation.fromJson(Map<String, dynamic> json) => _$EMailAutomationFromJson(json);
  Map<String, dynamic> toJson() => _$EMailAutomationToJson(this);

  factory EMailAutomation.empty() {
    return EMailAutomation(
      id: '',
      isActive: false,
      eMailAutomationType: EMailAutomationType.appointment,
      fromEmail: '',
      subject: '',
      bcc: '',
      htmlContent: '',
    );
  }

  EMailAutomation copyWith({
    String? id,
    bool? isActive,
    EMailAutomationType? eMailAutomationType,
    String? fromEmail,
    String? subject,
    String? bcc,
    String? htmlContent,
  }) {
    return EMailAutomation(
      id: id ?? this.id,
      isActive: isActive ?? this.isActive,
      eMailAutomationType: eMailAutomationType ?? this.eMailAutomationType,
      fromEmail: fromEmail ?? this.fromEmail,
      subject: subject ?? this.subject,
      bcc: bcc ?? this.bcc,
      htmlContent: htmlContent ?? this.htmlContent,
    );
  }

  @override
  String toString() {
    return 'EMailAutomation(id: $id, isActive: $isActive, eMailAutomationType: $eMailAutomationType, fromEmail: $fromEmail, subject: $subject, htmlContent: $htmlContent)';
  }
}
