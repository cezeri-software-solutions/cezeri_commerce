import 'package:cloud_firestore/cloud_firestore.dart';

enum ColRefType { users, settings, generalLedgerAccount, incomingInvoice }

class ColRef {
  static CollectionReference<Map<String, dynamic>> get(ColRefType colRefType, FirebaseFirestore db, String doc) {
    return switch (colRefType) {
      ColRefType.users => db.collection('Users'),
      ColRefType.settings => db.collection('Settings').doc(doc).collection('Settings'),
      ColRefType.generalLedgerAccount => db.collection('GLAccounts').doc(doc).collection('GLAccounts'),
      ColRefType.incomingInvoice => db.collection('IncomingInvoices').doc(doc).collection('IncomingInvoices'),
    };
  }
}
