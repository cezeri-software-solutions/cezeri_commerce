import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../../../3_domain/entities/id.dart';
import '../../../../3_domain/entities/settings/dimensions.dart';
import '../../../../3_domain/entities/settings/packaging_box.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

void showAddEditPackagingBoxSheet(BuildContext context, PackagingBox? packagingBox) {
  WoltModalSheet.show(
    context: context,
    showDragHandle: false,
    useSafeArea: false,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          topBarTitle: Text(packagingBox != null ? packagingBox.shortName : 'Neues Karton', style: TextStyles.h2Bold),
          isTopBarLayerAlwaysVisible: true,
          hasTopBarLayer: true,
          child: _AddEditPackagingBox(packagingBox: packagingBox),
        )
      ];
    },
  );
}

class _AddEditPackagingBox extends StatefulWidget {
  final PackagingBox? packagingBox;

  const _AddEditPackagingBox({this.packagingBox});

  @override
  State<_AddEditPackagingBox> createState() => _AddEditPackagingBoxState();
}

class _AddEditPackagingBoxState extends State<_AddEditPackagingBox> {
  // File? _imageFile;

  late TextEditingController _nameController;
  late TextEditingController _shortNameController;

  late TextEditingController _insideLengthController;
  late TextEditingController _insideWidthController;
  late TextEditingController _insideHeightController;

  late TextEditingController _outsideLengthController;
  late TextEditingController _outsideWidthController;
  late TextEditingController _outsideHeightController;

  late TextEditingController _weightController;
  late TextEditingController _wholesalePriceController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();

    if (widget.packagingBox != null) {
      _nameController = TextEditingController(text: widget.packagingBox!.name);
      _shortNameController = TextEditingController(text: widget.packagingBox!.shortName);
      _insideLengthController = TextEditingController(text: widget.packagingBox!.dimensionsInside.length.toString());
      _insideWidthController = TextEditingController(text: widget.packagingBox!.dimensionsInside.width.toString());
      _insideHeightController = TextEditingController(text: widget.packagingBox!.dimensionsInside.height.toString());
      _outsideLengthController = TextEditingController(text: widget.packagingBox!.dimensionsOutside.length.toString());
      _outsideWidthController = TextEditingController(text: widget.packagingBox!.dimensionsOutside.width.toString());
      _outsideHeightController = TextEditingController(text: widget.packagingBox!.dimensionsOutside.height.toString());
      _weightController = TextEditingController(text: widget.packagingBox!.weight.toString());
      _wholesalePriceController = TextEditingController(text: widget.packagingBox!.wholesalePrice.toString());
      _quantityController = TextEditingController(text: widget.packagingBox!.quantity.toString());
    } else {
      _nameController = TextEditingController();
      _shortNameController = TextEditingController();
      _insideLengthController = TextEditingController();
      _insideWidthController = TextEditingController();
      _insideHeightController = TextEditingController();
      _outsideLengthController = TextEditingController();
      _outsideWidthController = TextEditingController();
      _outsideHeightController = TextEditingController();
      _weightController = TextEditingController();
      _wholesalePriceController = TextEditingController();
      _quantityController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: max(MediaQuery.paddingOf(context).bottom, 16)),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.h24,
            MyTextFormFieldSmall(
              labelText: 'Name',
              controller: _nameController,
              textCapitalization: TextCapitalization.sentences,
            ),
            Gaps.h8,
            MyTextFormFieldSmall(
              labelText: 'Abgekürzter Name',
              controller: _shortNameController,
              textCapitalization: TextCapitalization.sentences,
            ),
            Gaps.h24,
            const Text('Abmessungen Innen:', style: TextStyles.h3Bold),
            Gaps.h8,
            MyTextFormFieldSmall(
              labelText: 'Innen: Länge',
              controller: _insideLengthController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            Gaps.h8,
            MyTextFormFieldSmall(
              labelText: 'Innen: Breite',
              controller: _insideWidthController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            Gaps.h8,
            MyTextFormFieldSmall(
              labelText: 'Innen: Höhe',
              controller: _insideHeightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            Gaps.h24,
            const Text('Abmessungen Außen:', style: TextStyles.h3Bold),
            Gaps.h8,
            MyTextFormFieldSmall(
              labelText: 'Außen: Länge',
              controller: _outsideLengthController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            Gaps.h8,
            MyTextFormFieldSmall(
              labelText: 'Außen: Breite',
              controller: _outsideWidthController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            Gaps.h8,
            MyTextFormFieldSmall(
              labelText: 'Außen: Höhe',
              controller: _outsideHeightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            Gaps.h42,
            MyTextFormFieldSmall(
              labelText: 'Gewicht',
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            Gaps.h8,
            MyTextFormFieldSmall(
              labelText: 'EK-Preis Netto',
              controller: _wholesalePriceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            Gaps.h8,
            MyTextFormFieldSmall(
              labelText: 'Lagerbestand',
              controller: _quantityController,
              keyboardType: const TextInputType.numberWithOptions(decimal: false),
            ),
            Gaps.h42,
            BlocBuilder<MainSettingsBloc, MainSettingsState>(
              builder: (context, state) {
                return Align(
                  alignment: Alignment.center,
                  child: MyOutlinedButton(
                    buttonText: 'Speichern',
                    onPressed: () {
                      final packagingBox = PackagingBox(
                        id: widget.packagingBox != null ? widget.packagingBox!.id : UniqueID().value,
                        pos: widget.packagingBox != null ? widget.packagingBox!.pos : 0,
                        name: _nameController.text,
                        shortName: _shortNameController.text,
                        imageUrl: widget.packagingBox?.imageUrl,
                        deliveryNoteId: widget.packagingBox?.deliveryNoteId,
                        dimensionsInside: Dimensions(
                          length: _insideLengthController.text.toMyDouble(),
                          width: _insideWidthController.text.toMyDouble(),
                          height: _insideHeightController.text.toMyDouble(),
                        ),
                        dimensionsOutside: Dimensions(
                          length: _outsideLengthController.text.toMyDouble(),
                          width: _outsideWidthController.text.toMyDouble(),
                          height: _outsideHeightController.text.toMyDouble(),
                        ),
                        weight: _weightController.text.toMyDouble(),
                        wholesalePrice: _wholesalePriceController.text.toMyDouble(),
                        quantity: _quantityController.text.toMyInt(),
                      );

                      if (widget.packagingBox == null) {
                        context.read<MainSettingsBloc>().add(PackagingBoxMainSettingsAddEvent(packagingBox: packagingBox));
                      } else {
                        context.read<MainSettingsBloc>().add(PackagingBoxMainSettingsUpdateEvent(packagingBox: packagingBox));
                      }
                      context.router.maybePop();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
