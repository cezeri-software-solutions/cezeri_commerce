import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../core/firebase_failures.dart';
import '../../entities/marketplace/marketplace.dart';

abstract class MarketplaceRepository {
  Future<Either<FirebaseFailure, Unit>> createMarketplace(Marketplace marketplace, File? imageFile);
  Future<Either<FirebaseFailure, Unit>> updateMarketplace(Marketplace marketplace, File? imageFile);
  Future<Either<FirebaseFailure, Unit>> deleteMarketplace(String id);
  Future<Either<FirebaseFailure, Marketplace>> getMarketplace(String id);
  Future<Either<FirebaseFailure, List<Marketplace>>> getListOfMarketplaces();
}
