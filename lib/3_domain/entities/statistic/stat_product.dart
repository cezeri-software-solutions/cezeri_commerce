import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt.dart';
import 'package:json_annotation/json_annotation.dart';

import 'stat_product_detail.dart';

part 'stat_product.g.dart';

@JsonSerializable(explicitToJson: true)
class StatProduct {
  // Wird durch Datum ermittelt
  final String statDashboardId;
  final String name;
  final String articleNumber;
  final String ean;
  // Auftragseingang
  final double incomingOrders;
  // Umsatz
  final double salesVolume;
  // Offene Aufträge
  final double offerVolume;
  // Gewinn nach Rechnungserstellng
  final double profit;
  final List<StatProductDetail> listOfStatProductDetail;
  final DateTime lastEditingDate;
  final DateTime creationDate;

  StatProduct({
    required this.statDashboardId,
    required this.name,
    required this.articleNumber,
    required this.ean,
    required this.listOfStatProductDetail,
    required this.lastEditingDate,
    required this.creationDate,
  })  : incomingOrders = _calcAmount(listOfStatProductDetail, ReceiptTyp.appointment),
        salesVolume = _calcAmount(listOfStatProductDetail, ReceiptTyp.invoice),
        offerVolume = _calcAmount(listOfStatProductDetail, ReceiptTyp.offer),
        profit = _calcProfit(listOfStatProductDetail);

  static double _calcAmount(List<StatProductDetail> listOfStatProductDetail, ReceiptTyp receiptTyp) {
    if (listOfStatProductDetail.isEmpty || listOfStatProductDetail.where((e) => e.receiptTyp == receiptTyp).firstOrNull == null) {
      return 0.0;
    }
    final list = listOfStatProductDetail.where((e) => e.receiptTyp == receiptTyp).toList();
    return (list.map((e) => e.unitPriceNet * e.quantity).toList().reduce((value, element) => value + element)).toMyRoundedDouble();
  }

  static double _calcProfit(List<StatProductDetail> listOfStatProductDetail) {
    if (listOfStatProductDetail.isEmpty || listOfStatProductDetail.where((e) => e.receiptTyp == ReceiptTyp.invoice).firstOrNull == null) {
      return 0.0;
    }
    final list = listOfStatProductDetail.where((e) => e.receiptTyp == ReceiptTyp.invoice).toList();
    return (list.map((e) => e.profit).toList().reduce((value, element) => value + element)).toMyRoundedDouble();
  }

  factory StatProduct.empty() {
    return StatProduct(
      statDashboardId: '',
      name: '',
      articleNumber: '',
      ean: '',
      listOfStatProductDetail: [],
      lastEditingDate: DateTime.now(),
      creationDate: DateTime.now(),
    );
  }

  factory StatProduct.fromJson(Map<String, dynamic> json) => _$StatProductFromJson(json);

  Map<String, dynamic> toJson() => _$StatProductToJson(this);

  StatProduct copyWith({
    String? statDashboardId,
    String? name,
    String? articleNumber,
    String? ean,
    List<StatProductDetail>? listOfStatProductDetail,
    DateTime? lastEditingDate,
    DateTime? creationDate,
  }) {
    return StatProduct(
      statDashboardId: statDashboardId ?? this.statDashboardId,
      name: name ?? this.name,
      articleNumber: articleNumber ?? this.articleNumber,
      ean: ean ?? this.ean,
      listOfStatProductDetail: listOfStatProductDetail ?? this.listOfStatProductDetail,
      lastEditingDate: lastEditingDate ?? this.lastEditingDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  @override
  String toString() {
    return 'StatProduct(statDashboardId: $statDashboardId, name: $name, articleNumber: $articleNumber, ean: $ean, incomingOrders: $incomingOrders, salesVolume: $salesVolume, offerVolume: $offerVolume, profit: $profit, listOfStatProductDetail: $listOfStatProductDetail, lastEditingDate: $lastEditingDate, creationDate: $creationDate)';
  }
}
