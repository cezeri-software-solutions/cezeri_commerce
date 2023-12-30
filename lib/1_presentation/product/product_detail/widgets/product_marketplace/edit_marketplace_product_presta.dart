import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../2_application/firebase/marketplace_product/marketplace_product_bloc.dart';
import '../../../../../2_application/firebase/product_detail/product_detail_bloc.dart';
import '../../../../../3_domain/entities/product/marketplace_product_presta.dart';
import '../../../../../3_domain/entities/product/product_marketplace.dart';
import '../../../../../3_domain/entities_presta/category_presta.dart';
import '../../../../../constants.dart';
import '../../../../core/widgets/my_circular_progress_indicator.dart';
import '../../../../core/widgets/my_outlined_button.dart';

class EditMarketplaceProductPresta extends StatelessWidget {
  final ProductDetailBloc productDetailBloc;
  final MarketplaceProductBloc marketplaceProductBloc;
  final ProductMarketplace productMarketplace;
  final MarketplaceProductPresta marketplaceProductPresta;
  final VoidCallback setPage;

  const EditMarketplaceProductPresta({
    super.key,
    required this.productDetailBloc,
    required this.marketplaceProductBloc,
    required this.productMarketplace,
    required this.marketplaceProductPresta,
    required this.setPage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketplaceProductBloc, MarketplaceProductState>(
      bloc: marketplaceProductBloc,
      builder: (context, state) {
        if (state.marketplaceProductPresta == null) return const Center(child: MyCircularProgressIndicator());

        return Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Aktiv:', style: TextStyles.defaultBold),
                  Switch.adaptive(
                    value: switch (state.marketplaceProductPresta!.active) {
                      '0' => false,
                      '1' => true,
                      _ => throw Exception(),
                    },
                    onChanged: (value) => marketplaceProductBloc.add(SetMarketplaceProductIsActiveEvent(value: value)),
                  ),
                ],
              ),
              Gaps.h16,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Kategorien:', style: TextStyles.defaultBold),
                  IconButton(
                    onPressed: state.listOfCategoriesPresta != null ? () => setPage() : null,
                    icon: const Icon(Icons.edit, color: CustomColors.primaryColor),
                  )
                ],
              ),
              Text(state.marketplaceProductPresta!.associations!.associationsCategories!.map((e) => e.id).toList().toString()),
              Gaps.h42,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => context.router.pop(),
                    child: Text('Abbrechen', style: TextStyles.textButtonText.copyWith(color: Colors.red)),
                  ),
                  Gaps.w8,
                  MyOutlinedButton(
                    buttonText: 'Speichern',
                    buttonBackgroundColor: Colors.green,
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

class EditMarketplaceProductPrestaCategories extends StatefulWidget {
  final MarketplaceProductBloc marketplaceProductBloc;

  const EditMarketplaceProductPrestaCategories({super.key, required this.marketplaceProductBloc});

  @override
  State<EditMarketplaceProductPrestaCategories> createState() => _EditMarketplaceProductPrestaCategoriesState();
}

class _EditMarketplaceProductPrestaCategoriesState extends State<EditMarketplaceProductPrestaCategories> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketplaceProductBloc, MarketplaceProductState>(
      bloc: widget.marketplaceProductBloc,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.listOfCategoriesPresta!.length,
            itemBuilder: (BuildContext context, int index) {
              final categories = state.listOfCategoriesPresta!;
              return Text(categories[index].name); //CategoryWidget(category: categories[index]);
            },
          ),
        );
      },
    );
  }
}

class CategoryWidget extends StatefulWidget {
  final CategoryPresta category;

  const CategoryWidget({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  bool isExpanded = false;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.category.name),
          leading: Checkbox(
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
              });
            },
          ),
          trailing: widget.category.associations!.categoryIds!.isNotEmpty
              ? IconButton(
                  icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                )
              : null,
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: widget.category.associations!.categoryIds!.map((subCategory) => CategoryWidget(category: widget.category)).toList(),
            ),
          ),
      ],
    );
  }
}
