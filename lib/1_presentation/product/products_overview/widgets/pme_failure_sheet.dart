import 'package:flutter/material.dart';

import '../../../../3_domain/entities/product/product.dart';
import '../../../../constants.dart';

class PMEFailureSheet extends StatelessWidget {
  final List<Product> productsList;

  const PMEFailureSheet({super.key, required this.productsList});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Dialog(
      child: SizedBox(
        width: screenWidth > 600 ? 600 : screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Artikel', style: TextStyles.h1),
              Gaps.h32,
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: productsList.length,
                  itemBuilder: (context, index) {
                    final product = productsList[index];

                    return ListTile(
                      title: Text(product.name),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
