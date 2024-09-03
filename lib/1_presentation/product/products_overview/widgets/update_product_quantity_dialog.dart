import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/product/product_bloc.dart';
import '../../../../3_domain/entities/product/product.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

enum QuantityUpdateWay { edit, set }

class UpdateProductQuantityDialog extends StatefulWidget {
  final ProductBloc productBloc;
  final Product product;

  const UpdateProductQuantityDialog({super.key, required this.productBloc, required this.product});

  @override
  State<UpdateProductQuantityDialog> createState() => _UpdateProductQuantityDialogState();
}

class _UpdateProductQuantityDialogState extends State<UpdateProductQuantityDialog> {
  QuantityUpdateWay _quantityUpdateWay = QuantityUpdateWay.edit;
  int _quantity = 0;
  int _editedQuantity = 0;
  bool _updateOnlyAvailableQuantity = false;
  bool _isReduce = false;

  @override
  void initState() {
    super.initState();
    setState(() => _quantity = widget.product.availableStock);
  }

  @override
  Widget build(BuildContext context) {
    int newQuantity = _quantity + _editedQuantity;
    _isReduce = _editedQuantity < 0 ? true : false;
    final sliderValue = _isReduce
        ? _editedQuantity.roundToDouble() < -50
            ? -50
            : _editedQuantity.roundToDouble()
        : _editedQuantity.roundToDouble() > 50
            ? 50
            : _editedQuantity.roundToDouble();

    return BlocBuilder<ProductBloc, ProductState>(
      bloc: widget.productBloc,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(top: 24, bottom: max(MediaQuery.paddingOf(context).bottom, 24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gaps.h16,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Text(widget.product.articleNumber, style: TextStyles.defaultBold),
                    Gaps.h8,
                    Text(widget.product.name, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                  ],
                ),
              ),
              Gaps.h16,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox.adaptive(
                    value: _updateOnlyAvailableQuantity,
                    onChanged: (value) => setState(() => _updateOnlyAvailableQuantity = value!),
                  ),
                  const Text('Nur verfügbaren Bestand aktualisieren?'),
                ],
              ),
              Gaps.h16,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilterChip(
                    label: const Text('Menge + / -'),
                    labelStyle: const TextStyle(color: Colors.black),
                    selected: _quantityUpdateWay == QuantityUpdateWay.edit ? true : false,
                    selectedColor: CustomColors.chipSelectedColor,
                    backgroundColor: CustomColors.chipBackgroundColor,
                    onSelected: (bool isSelected) => isSelected ? setState(() => _quantityUpdateWay = QuantityUpdateWay.edit) : null,
                  ),
                  FilterChip(
                    label: const Text('Bestand ändern'),
                    labelStyle: const TextStyle(color: Colors.black),
                    selected: _quantityUpdateWay == QuantityUpdateWay.set ? true : false,
                    selectedColor: CustomColors.chipSelectedColor,
                    backgroundColor: CustomColors.chipBackgroundColor,
                    onSelected: (bool isSelected) => isSelected ? setState(() => _quantityUpdateWay = QuantityUpdateWay.set) : null,
                  ),
                ],
              ),
              Gaps.h32,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: () => setState(() => _editedQuantity--), icon: const Icon(Icons.remove, color: Colors.red, size: 40)),
                  Text(_editedQuantity.toString(), style: TextStyles.h1),
                  IconButton(onPressed: () => setState(() => _editedQuantity++), icon: const Icon(Icons.add, color: Colors.green, size: 40)),
                ],
              ),
              Gaps.h32,
              const Text('Neuer Bestand:', style: TextStyles.h2),
              Gaps.h16,
              Text(newQuantity.toString(), style: TextStyles.h1),
              Gaps.h32,
              Slider(
                value: sliderValue.roundToDouble(),
                min: -50,
                max: 50,
                divisions: 100,
                label: _editedQuantity.round().toString(),
                onChanged: (double value) => setState(() => _editedQuantity = value.toInt()),
              ),
              Gaps.h32,
              MyOutlinedButton(
                buttonText: 'Speichern',
                onPressed: state.isLoadingProductOnUpdateQuantity
                    ? () {}
                    : () => widget.productBloc.add(UpdateQuantityOfProductEvent(
                          product: widget.product,
                          incQuantity: _editedQuantity,
                          updateOnlyAvailableQuantity: _updateOnlyAvailableQuantity,
                        )),
                buttonBackgroundColor: Colors.green,
                isLoading: state.isLoadingProductOnUpdateQuantity,
              ),
            ],
          ),
        );
      },
    );
  }
}
