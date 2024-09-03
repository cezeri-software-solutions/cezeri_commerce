import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/settings/carrier/carrier_detail/carrier_detail_page.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CarrierDetailScreen extends StatelessWidget {
  final int index;

  const CarrierDetailScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return CarrierDetailPage(index: index);
  }
}
