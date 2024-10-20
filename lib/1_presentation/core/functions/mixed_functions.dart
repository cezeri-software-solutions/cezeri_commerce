import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';

String getMarketplaceLogoAsset(MarketplaceType marketplaceType) {
  return switch (marketplaceType) {
    MarketplaceType.prestashop => 'assets/marketplaces/presta_logo.svg',
    MarketplaceType.shopify => 'assets/marketplaces/shopify_logo.svg',
    MarketplaceType.shop => 'assets/marketplaces/store_logo.svg',
  };
}

String getMarketplaceFontAsset(MarketplaceType marketplaceType) {
  return switch (marketplaceType) {
    MarketplaceType.prestashop => 'assets/marketplaces/presta_font.svg',
    MarketplaceType.shopify => 'assets/marketplaces/shopify_font.svg',
    MarketplaceType.shop => 'assets/marketplaces/store_logo.svg',
  };
}

double getAspectRatio(double width) => 0.00192 * width + 0.873;

String generateFriendlyUrl(String productName) {
  // Ersetzt Umlaute
  String url = productName
      .replaceAll('ä', 'ae')
      .replaceAll('ö', 'oe')
      .replaceAll('ü', 'ue')
      .replaceAll('Ä', 'Ae')
      .replaceAll('Ö', 'Oe')
      .replaceAll('Ü', 'Ue')
      .replaceAll('ß', 'ss');

  // Entfernt alle Sonderzeichen außer Bindestrichen und Alphanumerischen Zeichen
  url = url.replaceAll(RegExp(r'[^\w\s-]'), '');

  // Ersetzt Leerzeichen gefolgt von einem Bindestrich oder umgekehrt durch einen Bindestrich
  url = url.replaceAll(RegExp(r'\s?-\s?'), '-');

  // Ersetzt alle verbleibenden Leerzeichen und Unterstriche durch Bindestriche
  url = url.replaceAll(RegExp(r'[\s_]+'), '-');

  // Konvertiert den gesamten String in Kleinbuchstaben
  url = url.toLowerCase();

  return url;
}

String convertHtmlToString(String htmlString) {
  // Parsen des HTML-Strings
  Document document = parse(htmlString);

  // Konvertieren in normalen String
  String parsedString = document.body?.text ?? '';

  return parsedString;
}

durationToStringFormatter(Duration d) => d.toString().split('.').first.padLeft(8, '0');

String getInitials(String name) => name.split(' ').where((str) => str.isNotEmpty).take(2).map((str) => str[0].toUpperCase()).join(' ');

//* Ausgabe: Der Betrag, der die eingegebenen Prozente ausmacht
//* z.B. 20% von 100 = 20
double calcPercentageAmount(double amount, double percentage) {
  return amount * (percentage / 100);
}

//* Ausgabe: Die Prozent, der den Rabatt ausmacht
//* z.B. 100 & 80 = 20%
double calcPercentageOfTwoDoubles(double amount, double amountWithDiscount) {
  if (amount == 0) return 0;
  double newAmount;
  newAmount = amount * (1 - (amountWithDiscount / amount) * 100);
  return newAmount;
}

//* Ausgabe: Die Prozent, der den Rabatt ausmacht
//* z.B. 100 & 20 = 20%
double calcDiscountPercentage(double amount, double amountDiscount) {
  if (amount == 0) return 0;
  double newAmount;
  newAmount = (amountDiscount / amount) * 100;
  return newAmount;
}

//* Ausgabe: Berechnet den prozentualen Anteil aus zwei Durations
//* z.B. 3h = 30% von 10h
double calculatePercentagePortion(Duration totalDuration, Duration duration) {
  double percentage;
  percentage = (double.parse(duration.inMilliseconds.toString()) * 100) / double.parse(totalDuration.inMilliseconds.toString());
  return percentage;
}

//* Macht aus einer UsSt. eine rechenbare UsSt.
//* zb. 20% = 1,2
double taxToCalc(int vat) => vat / 100 + 1;

//* Berechnet die Vorsteuer in Prozent.
//* zb. 20% | Brutto: 100 / Netto: 83,3333 = 20%
//* zb. 19% | Brutto: 100 / Netto: 84,03 = 19%
int calcTaxPercent(double grossAmount, double netAmount) {
  double taxAmount = grossAmount - netAmount;
  double taxPercentage = (taxAmount / netAmount) * 100;

  return taxPercentage.round();
}

//* Berechnet die Vorsteuer in Zahl.
double calcTaxAmountFromGross(double grossAmount, int tax) {
  return grossAmount - (grossAmount / taxToCalc(tax));
}

//* Berechnet die Vorsteuer in Zahl.
double calcTaxAmountFromNet(double netAmount, int tax) {
  return (netAmount * taxToCalc(tax) + netAmount);
}

bool stringToBool(String str) {
  final trueValues = ['true', 'True', 'TRUE', '1'];
  if (trueValues.contains(str)) return true;
  return false;
}

Widget myBottomSheetHeader({Function()? backFunction, Function()? closeFunction}) {
  return SizedBox(
    height: 40,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        backFunction != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: backFunction,
              )
            : const Icon(
                Icons.arrow_back,
                color: Colors.transparent,
              ),
        const Icon(
          Icons.maximize,
          color: Colors.grey,
          size: 40,
        ),
        backFunction != null
            ? IconButton(
                onPressed: closeFunction,
                icon: const Icon(Icons.close_sharp),
              )
            : const Icon(
                Icons.close_sharp,
                color: Colors.transparent,
              ),
      ],
    ),
  );
}

String convertIntToWeekDay(int weekDay) {
  if (weekDay == 0) {
    return 'Mo';
  } else if (weekDay == 1) {
    return 'Di';
  } else if (weekDay == 2) {
    return 'Mi';
  } else if (weekDay == 3) {
    return 'Do';
  } else if (weekDay == 4) {
    return 'Fr';
  } else if (weekDay == 5) {
    return 'Sa';
  } else {
    return 'So';
  }
}

class CommaTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String truncated = newValue.text;
    final TextSelection newSelection = newValue.selection;

    if (newValue.text.contains(',')) {
      truncated = newValue.text.replaceFirst(RegExp(','), '.');
    }
    return TextEditingValue(
      text: truncated,
      selection: newSelection,
    );
  }
}

String generateRandomString(int length) {
  const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
  Random random = Random();

  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => characters.codeUnitAt(random.nextInt(characters.length)),
  ));
}

String sanitizeFileName(String input) {
  // Ersetzt ungültige Zeichen durch Unterstriche
  String sanitized = input.replaceAll(RegExp(r'[^\w\s.-]'), '_');
  // Entfernt Leerzeichen
  return sanitized.replaceAll(' ', '_');
}