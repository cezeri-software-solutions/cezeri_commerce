import 'dart:io';

import 'package:cezeri_commerce/core/abstract_failure.dart';
import 'package:dartz/dartz.dart';

import '../../entities/e_mail_automation.dart';
import '../../entities/marketplace/abstract_marketplace.dart';
import '../../entities/marketplace/marketplace_presta.dart';

abstract class MarketplaceRepository {
  Future<Either<AbstractFailure, Unit>> createMarketplace(AbstractMarketplace marketplace, File? imageFile);
  Future<Either<AbstractFailure, Unit>> updateMarketplace(AbstractMarketplace marketplace, File? imageFile);
  Future<Either<AbstractFailure, Unit>> deleteMarketplace(String id);
  Future<Either<AbstractFailure, AbstractMarketplace>> getMarketplace(String id);
  Future<Either<AbstractFailure, List<AbstractMarketplace>>> getListOfMarketplaces();
  Future<Either<AbstractFailure, Unit>> addMarketplaceEMailAutomation(MarketplacePresta marketplace, EMailAutomation eMailAutomation);
  Future<Either<AbstractFailure, Unit>> updateMarketplaceEMailAutomation(MarketplacePresta marketplace, EMailAutomation eMailAutomation);
}
