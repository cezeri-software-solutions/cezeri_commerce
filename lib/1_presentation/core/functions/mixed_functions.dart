import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

durationToStringFormatter(Duration d) => d.toString().split('.').first.padLeft(8, '0');

String getInitials(String name) => name.split(' ').where((str) => str.isNotEmpty).take(2).map((str) => str[0].toUpperCase()).join(' ');

//* Ausgabe: Der Betrag, der nach Abzug der eingegebenen Prozente ausmacht
//* z.B. 100 - 20% = 80
double calculatePercentage(double amount, double percentage) {
  double newAmount;
  newAmount = amount * ((100 - percentage) / 100);
  return newAmount;
}

//* Ausgabe: Berechnet den prozentualen Anteil aus zwei Durations
//* z.B. 3h = 30% von 10h
double calculatePercentagePortion(Duration totalDuration, Duration duration) {
  double percentage;
  percentage = (double.parse(duration.inMilliseconds.toString()) * 100) / double.parse(totalDuration.inMilliseconds.toString());
  return percentage;
}

//* Ausgabe: Der Betrag, der die eingegebenen Prozente ausmacht
//* z.B. 20% von 100 = 20
double calculatePercentageDifferenceAmount(double amount, double percentage) {
  double newAmount;
  newAmount = amount - (amount * ((100 - percentage) / 100));
  return newAmount < 0 ? newAmount * -1 : newAmount;
}

//* Macht aus einer UsSt. eine rechenbare UsSt.
//* zb. 20% = 1,2
double vatToCalc(int vat) => vat / 100 + 1;

Future<bool> checkInternetConnection() async {
  bool isConnected = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connection successful');
      isConnected = true;
    }
  } on SocketException catch (_) {
    print('not connected with the internet!');
    isConnected = false;
  }
  return isConnected;
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
