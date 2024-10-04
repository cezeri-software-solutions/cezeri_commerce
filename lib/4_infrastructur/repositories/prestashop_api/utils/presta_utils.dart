import '../../../../3_domain/entities/product/product.dart';
import '../../../../3_domain/entities/product/specific_price.dart';

String getSpecificPriceReduction(Product product) {
  final specificPrice = product.specificPrice!;

  return specificPrice.reductionType == ReductionType.percent
      ? (specificPrice.value / 100).toStringAsFixed(2)
      : specificPrice.value.toStringAsFixed(2);
}

String getSpecificPriceReductionTax(Product product) =>
    product.specificPrice!.reductionType == ReductionType.fixed && product.specificPrice!.fixedReductionType == FixedReductionType.net ? '0' : '1';

String getSpecificPriceReductionType(Product product) => product.specificPrice!.reductionType == ReductionType.fixed ? 'amount' : 'percentage';

String getSpecificPriceTo(Product product) =>
    product.specificPrice!.endDate != null ? product.specificPrice!.endDate!.toPrestaDateTime() : '0000-00-00 00:00:00';

extension ConvertToPrestaDateTimeString on DateTime {
  String toPrestaDateTime() {
    final formattedMonth = month.toString().padLeft(2, '0');
    final formattedDay = day.toString().padLeft(2, '0');

    final formattedHour = hour.toString().padLeft(2, '0');
    final formattedMinute = minute.toString().padLeft(2, '0');
    final formattedSecond = second.toString().padLeft(2, '0');

    return '$year-$formattedMonth-$formattedDay $formattedHour:$formattedMinute:$formattedSecond';
  }
}
