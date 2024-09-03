class MailWorkflow {
  final String id;
  final String description;
  final String emailSubject;
  final String emailCc;
  final String emailBcc;
  final String emailMessage;
  final bool isActive;
  MailWorkflow({
    required this.id,
    required this.description,
    required this.emailSubject,
    required this.emailCc,
    required this.emailBcc,
    required this.emailMessage,
    required this.isActive,
  });
}
 