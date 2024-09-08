import 'dart:io';

import 'package:cezeri_commerce/failures/abstract_failure.dart';
import 'package:dartz/dartz.dart';

import '../../entities/e_mail_automation.dart';
import '../../entities/marketplace/abstract_marketplace.dart';

abstract class MarketplaceRepository {
  Future<Either<AbstractFailure, Unit>> createMarketplace(AbstractMarketplace marketplace, File? imageFile);
  Future<Either<AbstractFailure, Unit>> updateMarketplace(AbstractMarketplace marketplace, File? imageFile);
  Future<Either<AbstractFailure, Unit>> deleteMarketplace(String id);
  Future<Either<AbstractFailure, AbstractMarketplace>> getMarketplace(String id);
  Future<Either<AbstractFailure, List<AbstractMarketplace>>> getListOfMarketplaces({bool onlyActive});
  Future<Either<AbstractFailure, List<AbstractMarketplace>>> getListOfMarketplacesByType({required MarketplaceType type, bool onlyActive});
  Future<Either<AbstractFailure, Unit>> addMarketplaceEMailAutomation(AbstractMarketplace marketplace, EMailAutomation eMailAutomation);
  Future<Either<AbstractFailure, Unit>> updateMarketplaceEMailAutomation(AbstractMarketplace marketplace, EMailAutomation eMailAutomation);
}
