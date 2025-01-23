import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/reorder_detail/reorder_detail_bloc.dart';
import '../../../core/core.dart';
import '../widgets/select_reorder_detail_product_dialog.dart';

void showReorderDetailProductsDialog(BuildContext context, ReorderDetailBloc reorderDetailBloc) {
  showDialog(
    context: context,
    builder: (context) {
      final screenHeight = context.screenHeight;
      final screenWidth = context.screenWidth;
      return BlocProvider.value(
        value: reorderDetailBloc,
        child: SelectReorderDetailProductDialog(reorderDetailBloc: reorderDetailBloc, screenHeight: screenHeight, screenWidth: screenWidth),
      );
    },
  );
}
