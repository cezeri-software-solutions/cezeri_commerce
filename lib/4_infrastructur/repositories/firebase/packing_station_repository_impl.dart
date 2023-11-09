import 'package:cezeri_commerce/3_domain/entities/product/product.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../3_domain/repositories/firebase/packing_station_repository.dart';

class PackingStationRepositoryImpl implements PackingStationRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;

  PackingStationRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<FirebaseFailure, List<Product>>> getListOfProducts(List<String> productIds) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final colRef = db.collection(currentUserUid).doc(currentUserUid).collection('Products');

    List<Product> listOfProducts = [];

    try {
      for (final productId in productIds) {
        final docRef = colRef.doc(productId);
        final productSnapshot = await docRef.get();
        if (productSnapshot.data() != null) listOfProducts.add(Product.fromJson(productSnapshot.data()!));
      }

      if (listOfProducts.isEmpty) return left(EmptyFailure());
      return right(listOfProducts);
    } on FirebaseException {
      return left(GeneralFailure());
    } catch (_) {
      return left(GeneralFailure());
    }
  }
}
