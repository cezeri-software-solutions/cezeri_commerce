import 'dart:convert';

extension JsonPrint on Object {
  void myJsonPrint() {
    var encoder = const JsonEncoder.withIndent('  '); // 2 Leerzeichen Einrückung
    String prettyPrint;

    try {
      prettyPrint = encoder.convert(this);
    } catch (e) {
      throw 'Das Objekt konnte nicht in JSON konvertiert werden. Stellen Sie sicher, dass das Objekt eine gültige toJson-Methode hat.';
    }

    print(prettyPrint);
  }
}

extension JsonPrintList on List<Object> {
  void myJsonListPrint() {
    var encoder = const JsonEncoder.withIndent('  '); // 2 Leerzeichen Einrückung

    for (var obj in this) {
      String prettyPrint;
      try {
        prettyPrint = encoder.convert(obj);
      } catch (e) {
        print('Das Objekt konnte nicht in JSON konvertiert werden. Stellen Sie sicher, dass das Objekt eine gültige toJson-Methode hat.');
        continue; // Zum nächsten Objekt in der Liste gehen
      }
      print(prettyPrint);
    }
  }
}


