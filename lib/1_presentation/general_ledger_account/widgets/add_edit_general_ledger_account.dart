import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../2_application/database/general_ledger_account/general_ledger_account_bloc.dart';
import '../../../3_domain/entities/settings/general_ledger_account.dart';
import '../../../constants.dart';
import '../../core/core.dart';

void addEditGLSAccount(BuildContext context, GeneralLedgerAccountBloc gLAccountBloc, GeneralLedgerAccount? gLAccount) {
  final trailing = IconButton(
    padding: const EdgeInsets.only(right: 24),
    icon: const Icon(Icons.close),
    onPressed: () => context.router.maybePop(),
  );

  final titleNotifier = ValueNotifier<String>(gLAccount != null ? gLAccount.generalLedgerAccount : 'Neues Sachkonto');

  WoltModalSheet.show(
    context: context,
    useSafeArea: false,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: true,
          isTopBarLayerAlwaysVisible: true,
          topBarTitle: ValueListenableBuilder<String>(
            valueListenable: titleNotifier,
            builder: (context, value, child) {
              return Text(value, style: TextStyles.h3Bold);
            },
          ),
          trailingNavBarWidget: trailing,
          child: AddEditGLAccount(
            gLAccountBloc: gLAccountBloc,
            gLAccount: gLAccount,
            setTitle: (title) => titleNotifier.value = title,
          ),
        )
      ];
    },
  );
}

class AddEditGLAccount extends StatelessWidget {
  final GeneralLedgerAccountBloc gLAccountBloc;
  final GeneralLedgerAccount? gLAccount;
  final String Function(String) setTitle;

  const AddEditGLAccount({super.key, required this.gLAccountBloc, required this.gLAccount, required this.setTitle});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeneralLedgerAccountBloc, GeneralLedgerAccountState>(
      bloc: gLAccountBloc,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Kontenklasse:', style: TextStyles.infoOnTextFieldSmall),
                        Text(state.gLAccount!.accountClass),
                      ],
                    ),
                  ),
                  Gaps.w8,
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Kontengruppe:', style: TextStyles.infoOnTextFieldSmall),
                        Text(state.gLAccount!.accountGroup),
                      ],
                    ),
                  ),
                ],
              ),
              Gaps.h16,
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Kontenuntergruppe:', style: TextStyles.infoOnTextFieldSmall),
                        Text(state.gLAccount!.accountSubGroup),
                      ],
                    ),
                  ),
                  Gaps.w8,
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Einzelkonto:', style: TextStyles.infoOnTextFieldSmall),
                        Text(state.gLAccount!.individualAccount),
                      ],
                    ),
                  ),
                ],
              ),
              MyTextFormFieldSmallDouble(
                  aboveText: 'Sachkonto:',
                  controller: state.gLAccountController,
                  onChanged: (value) {
                    gLAccountBloc.add(OnGLAccountControllerChangedEvent());
                    setTitle(value);
                  }),
              Gaps.h16,
              MyTextFormFieldSmall(
                labelText: 'Name:',
                controller: state.nameController,
                onChanged: (_) => gLAccountBloc.add(OnGLAccountControllerChangedEvent()),
              ),
              Gaps.h16,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('Aktiv: '),
                        Checkbox.adaptive(value: state.gLAccount!.isActive, onChanged: (_) => gLAccountBloc.add(OnGLAccountIsActiveChangedEvent())),
                      ],
                    ),
                  ),
                  Gaps.w8,
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('Sichtbar: '),
                        Checkbox.adaptive(value: state.gLAccount!.isVisible, onChanged: (_) => gLAccountBloc.add(OnGLAccountIsVisibleChangedEvent())),
                      ],
                    ),
                  ),
                ],
              ),
              Gaps.h24,
              MyOutlinedButton(
                buttonText: gLAccount != null ? 'Speichern' : 'Hinzufügen',
                isLoading: state.isLoadingGLAccountOnCreate || state.isLoadingGLAccountOnUpdate,
                onPressed: gLAccount != null ? () => gLAccountBloc.add(UpdateGLAccountEvent()) : () => gLAccountBloc.add(CreateGLAccountEvent()),
                buttonBackgroundColor: gLAccount != null ? CustomColors.primaryColor : Colors.green,
              ),
              Gaps.h24,
            ],
          ),
        );
      },
    );
  }
}
