import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/product/product_bloc.dart';
import '../../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../../injection.dart';
import '../../../core/functions/my_scaffold_messanger.dart';

// TODO: Ersetzen oder löschen

@RoutePage()
class MarketplaceMassEditingScreen extends StatelessWidget {
  final Marketplace marketplace;

  const MarketplaceMassEditingScreen({super.key, required this.marketplace});

  @override
  Widget build(BuildContext context) {
    final productBloc = sl<ProductBloc>()..add(GetAllProductsEvent());

    return BlocProvider<ProductBloc>(
      create: (context) => productBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProductBloc, ProductState>(
            listenWhen: (p, c) => p.fosProductsOnObserveOption != c.fosProductsOnObserveOption,
            listener: (context, state) {
              state.fosProductsOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
                  (listOfProducts) => null,
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(title: const Text('Massenbearbeitung')),
            );
          },
        ),
      ),
    );
  }
}
