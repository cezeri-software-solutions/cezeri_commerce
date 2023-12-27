import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/product/product_detail/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/product/product_bloc.dart';
import '../../core/functions/my_scaffold_messanger.dart';
import '../../core/widgets/my_dialog_suppliers.dart';

enum ProductCreateOrEdit { create, edit }

@RoutePage()
class ProductDetailScreen extends StatelessWidget {
  final ProductBloc productBloc;
  final ProductCreateOrEdit productCreateOrEdit;

  const ProductDetailScreen({super.key, required this.productBloc, required this.productCreateOrEdit});

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: const Text('Artikel'));
    return MultiBlocListener(
      listeners: [
        BlocListener<ProductBloc, ProductState>(
          bloc: productBloc,
          listenWhen: (p, c) => p.fosProductSuppliersOnObserveOption != c.fosProductSuppliersOnObserveOption,
          listener: (context, state) {
            state.fosProductSuppliersOnObserveOption.fold(
              () => null,
              (a) => a.fold(
                (failure) => myScaffoldMessenger(context, null, null, null, 'Beim Laen der Lieferanten ist ein Fehler aufgetreten'),
                (_) => showDialog(
                  context: context,
                  builder: (_) => MyDialogSuppliers(
                    listOfSuppliers: state.listOfSuppliers!,
                    onChanged: (supplier) => productBloc.add(OnProductSetSupplierEvent(supplierName: supplier.company)),
                  ),
                ),
              ),
            );
          },
        ),
      ],
      child: BlocBuilder<ProductBloc, ProductState>(
        bloc: productBloc,
        builder: (context, state) {
          if (state.isLoadingProductOnObserve) return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));
          if ((state.firebaseFailure != null && state.isAnyFailure) || (productCreateOrEdit == ProductCreateOrEdit.edit && state.product == null)) {
            return Scaffold(appBar: appBar, body: const Center(child: Text('Ein Fehler ist aufgetreten')));
          }

          return ProductDetailPage(product: state.product, productBloc: productBloc, productCreateOrEdit: productCreateOrEdit);
        },
      ),
    );
  }
}
