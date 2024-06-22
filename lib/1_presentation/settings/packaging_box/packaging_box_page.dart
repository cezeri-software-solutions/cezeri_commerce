import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants.dart';
import '../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../../3_domain/entities/settings/packaging_box.dart';
import '../../../3_domain/enums/enums.dart';
import '../../app_drawer.dart';
import '../../core/core.dart';
import 'widgets/add_edit_packaging_box.dart';

class PackagingBoxesPage extends StatelessWidget {
  const PackagingBoxesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainSettingsBloc, MainSettingsState>(
      builder: (context, state) {
        final appBar = AppBar(
          title: const Text('Verpackungskartons'),
          actions: [
            IconButton(onPressed: () => context.read<MainSettingsBloc>().add(GetMainSettingsEvent()), icon: const Icon(Icons.refresh)),
            Gaps.w8,
            IconButton(
              onPressed: () => showModalBottomSheet(context: context, isScrollControlled: true, builder: (context) => const AddEditPackagingBox()),
              icon: const Icon(Icons.add, color: Colors.green),
            ),
            Gaps.w8,
            MyOutlinedButton(
              buttonText: 'Speichern',
              isLoading: state.isLoadingMainSettingsOnUpdate,
              buttonBackgroundColor: Colors.green,
              onPressed: () => context.read<MainSettingsBloc>().add(PackagingBoxMainSettingsSaveEvent()),
            ),
            Gaps.w8,
          ],
        );

        const drawer = AppDrawer();

        if ((state.mainSettings == null && state.firebaseFailure == null) || state.isLoadingMainSettingsOnObserve) {
          return Scaffold(appBar: appBar, drawer: drawer, body: const Center(child: CircularProgressIndicator()));
        }

        if (state.firebaseFailure != null && state.isAnyFailure) {
          return Scaffold(appBar: appBar, drawer: drawer, body: const Center(child: Text('Ein Fehler ist aufgetreten.')));
        }

        return Scaffold(
          appBar: appBar,
          drawer: drawer,
          body: Column(
            children: [
              Gaps.h42,
              if (state.mainSettings!.listOfPackagingBoxes.isEmpty)
                const SizedBox(
                  height: 150,
                  child: Center(
                    child: Text('Keine Verpackungskartons vorhanden'),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.mainSettings!.listOfPackagingBoxes.length,
                  itemBuilder: (context, index) {
                    final packagingBox = state.mainSettings!.listOfPackagingBoxes[index];
                    return Column(
                      children: [
                        if (index == 0) const Divider(height: 2),
                        _PackagingBoxListTile(packagingBox: packagingBox, index: index),
                        const Divider(height: 2),
                      ],
                    );
                  },
                ),
              ),
              Gaps.h42,
            ],
          ),
        );
      },
    );
  }
}

class _PackagingBoxListTile extends StatelessWidget {
  final PackagingBox packagingBox;
  final int index;

  const _PackagingBoxListTile({required this.packagingBox, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          packagingBox.imageUrl != null && packagingBox.imageUrl != ''
              ? Image.asset(
                  packagingBox.imageUrl!,
                  height: 25,
                  width: 65,
                  fit: BoxFit.scaleDown,
                )
              : const SizedBox(height: 65, width: 65, child: Icon(Icons.question_mark)),
          Gaps.w8,
          InkWell(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => AddEditPackagingBox(packagingBox: packagingBox),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(packagingBox.name, style: TextStyles.h3BoldPrimary),
                Text(packagingBox.shortName),
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              IconButton(
                onPressed: () => context
                    .read<MainSettingsBloc>()
                    .add(PackagingBoxMainSettingsUpdatePosEvent(packagingBox: packagingBox, positionTo: PositionTo.up)),
                icon: const Icon(Icons.move_up, color: Colors.green),
              ),
              Gaps.w8,
              IconButton(
                onPressed: () => context
                    .read<MainSettingsBloc>()
                    .add(PackagingBoxMainSettingsUpdatePosEvent(packagingBox: packagingBox, positionTo: PositionTo.down)),
                icon: const Icon(Icons.move_down, color: CustomColors.primaryColor),
              ),
              Gaps.w8,
              Text(packagingBox.pos.toString(), style: TextStyles.h2),
              Gaps.w16,
            ],
          ),
        ],
      ),
    );
  }
}
