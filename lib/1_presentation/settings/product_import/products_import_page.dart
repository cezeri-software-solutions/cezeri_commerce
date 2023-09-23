import 'package:flutter/material.dart';

import '../../../2_application/prestashop/product_import/product_import_bloc.dart';

class ProductsImportPage extends StatelessWidget {
  final ProductImportBloc productImportBloc;

  const ProductsImportPage({super.key, required this.productImportBloc});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Artikel importieren'),
    );
  }
}
