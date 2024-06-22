// ignore_for_file: avoid_print

import 'dart:convert';

//* Printet ein JSON Objekt in einem lesbaren Stil
extension JsonPrint on Object {
  void myJsonPrint() {
    var encoder = const JsonEncoder.withIndent('  ');
    String prettyPrint;

    try {
      prettyPrint = encoder.convert(this);
    } catch (e) {
      throw 'Das Objekt konnte nicht in JSON konvertiert werden. Stellen Sie sicher, dass das Objekt eine gültige toJson-Methode hat.';
    }

    print(prettyPrint);
  }
}

//* Printet eine Liste von JSON Objekten in einem lesbaren Stil
extension JsonPrintList on List<Object> {
  void myJsonListPrint() {
    var encoder = const JsonEncoder.withIndent('  ');

    for (var obj in this) {
      String prettyPrint;
      try {
        prettyPrint = encoder.convert(obj);
      } catch (e) {
        print('Das Objekt konnte nicht in JSON konvertiert werden. Stellen Sie sicher, dass das Objekt eine gültige toJson-Methode hat.');
        continue;
      }
      print(prettyPrint);
    }
  }
}
