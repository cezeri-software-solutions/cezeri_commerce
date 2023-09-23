import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../2_application/firebase/marketplace/marketplace_bloc.dart';
import '../../../../../3_domain/entities/marketplace.dart';
import '../widgets/add_edit_marketplace.dart';

void addEditMarketplacepressed({required BuildContext context, required MarketplaceBloc marketplaceBloc, Marketplace? marketplace}) =>
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: marketplaceBloc,
        child: AddEditMarketplace(marketplaceBloc: marketplaceBloc, marketplace: marketplace),
      ),
    );
