import 'dart:io';

import 'package:cezeri_commerce/core/abstract_failure.dart';
import 'package:dartz/dartz.dart';

import '../../entities/e_mail_automation.dart';
import '../../entities/marketplace/marketplace.dart';

abstract class MarketplaceRepository {
  Future<Either<AbstractFailure, Unit>> createMarketplace(Marketplace marketplace, File? imageFile);
  Future<Either<AbstractFailure, Unit>> updateMarketplace(Marketplace marketplace, File? imageFile);
  Future<Either<AbstractFailure, Unit>> deleteMarketplace(String id);
  Future<Either<AbstractFailure, Marketplace>> getMarketplace(String id);
  Future<Either<AbstractFailure, List<Marketplace>>> getListOfMarketplaces();
  Future<Either<AbstractFailure, Unit>> addMarketplaceEMailAutomation(Marketplace marketplace, EMailAutomation eMailAutomation);
  Future<Either<AbstractFailure, Unit>> updateMarketplaceEMailAutomation(Marketplace marketplace, EMailAutomation eMailAutomation);
}
