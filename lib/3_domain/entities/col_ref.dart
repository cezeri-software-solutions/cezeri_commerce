import 'package:cloud_firestore/cloud_firestore.dart';

enum ColRefType { users, settings, generalLedgerAccount }

class ColRef {
  static CollectionReference<Map<String, dynamic>> get(ColRefType colRefType, FirebaseFirestore db, String doc) {
    return switch (colRefType) {
      ColRefType.users => db.collection('Users'),
      ColRefType.settings => db.collection('Settings').doc(doc).collection('Settings'),
      ColRefType.generalLedgerAccount => db.collection('Settings').doc(doc).collection('Settings'),
    };
  }
}
