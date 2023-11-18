class EMailPlaceholder {
  final String displayName;
  final String key;

  EMailPlaceholder({required this.displayName, required this.key});

  static List<EMailPlaceholder> listOfPlaceholders = [
    EMailPlaceholder(displayName: 'Belegnummer', key: '{receiptNumber}'),
    EMailPlaceholder(displayName: 'Kundennummer', key: '{customerNumer}'),
    EMailPlaceholder(displayName: 'Kundenname', key: '{customerFullName}'),
    EMailPlaceholder(displayName: 'Auftragnummer Marktplatz', key: '{receiptMarketplaceReference}'),
    EMailPlaceholder(displayName: 'Tracking-URL', key: '{trackingUrl}'),
    EMailPlaceholder(displayName: 'Sendeverfolgungsnummer', key: '{trackingNumber}'),
    EMailPlaceholder(displayName: 'Tracking-Link', key: '{trackingLink}'),
  ];
}
