import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../2_application/database/general_ledger_account/general_ledger_account_bloc.dart';
import '../../3_domain/entities/settings/general_ledger_account.dart';
import '../../constants.dart';
import 'widgets/add_edit_general_ledger_account.dart';

class GeneralLedgerAccountPage extends StatelessWidget {
  final GeneralLedgerAccountBloc gLAccountBloc;

  const GeneralLedgerAccountPage({super.key, required this.gLAccountBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeneralLedgerAccountBloc, GeneralLedgerAccountState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            padding: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                ? const EdgeInsets.all(18)
                : const EdgeInsets.only(top: 10, bottom: 10, right: 10),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GLAccountTitle(gLAccountBloc: gLAccountBloc, title: 'Klasse 0', list: state.listOfFilteredGLAccounts0),
                GLAccountListView(gLAccountBloc: gLAccountBloc, list: state.listOfFilteredGLAccounts0),
                GLAccountTitle(gLAccountBloc: gLAccountBloc, title: 'Klasse 1', list: state.listOfFilteredGLAccounts1),
                GLAccountListView(gLAccountBloc: gLAccountBloc, list: state.listOfFilteredGLAccounts1),
                GLAccountTitle(gLAccountBloc: gLAccountBloc, title: 'Klasse 2', list: state.listOfFilteredGLAccounts2),
                GLAccountListView(gLAccountBloc: gLAccountBloc, list: state.listOfFilteredGLAccounts2),
                GLAccountTitle(gLAccountBloc: gLAccountBloc, title: 'Klasse 3', list: state.listOfFilteredGLAccounts3),
                GLAccountListView(gLAccountBloc: gLAccountBloc, list: state.listOfFilteredGLAccounts3),
                GLAccountTitle(gLAccountBloc: gLAccountBloc, title: 'Klasse 4', list: state.listOfFilteredGLAccounts4),
                GLAccountListView(gLAccountBloc: gLAccountBloc, list: state.listOfFilteredGLAccounts4),
                GLAccountTitle(gLAccountBloc: gLAccountBloc, title: 'Klasse 5', list: state.listOfFilteredGLAccounts5),
                GLAccountListView(gLAccountBloc: gLAccountBloc, list: state.listOfFilteredGLAccounts5),
                GLAccountTitle(gLAccountBloc: gLAccountBloc, title: 'Klasse 6', list: state.listOfFilteredGLAccounts6),
                GLAccountListView(gLAccountBloc: gLAccountBloc, list: state.listOfFilteredGLAccounts6),
                GLAccountTitle(gLAccountBloc: gLAccountBloc, title: 'Klasse 7', list: state.listOfFilteredGLAccounts7),
                GLAccountListView(gLAccountBloc: gLAccountBloc, list: state.listOfFilteredGLAccounts7),
                GLAccountTitle(gLAccountBloc: gLAccountBloc, title: 'Klasse 8', list: state.listOfFilteredGLAccounts8),
                GLAccountListView(gLAccountBloc: gLAccountBloc, list: state.listOfFilteredGLAccounts8),
                GLAccountTitle(gLAccountBloc: gLAccountBloc, title: 'Klasse 9', list: state.listOfFilteredGLAccounts9),
                GLAccountListView(gLAccountBloc: gLAccountBloc, list: state.listOfFilteredGLAccounts9),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GLAccountTitle extends StatelessWidget {
  final GeneralLedgerAccountBloc gLAccountBloc;
  final String title;
  final List<GeneralLedgerAccount> list;

  const GLAccountTitle({super.key, required this.gLAccountBloc, required this.title, required this.list});

  @override
  Widget build(BuildContext context) {
    return list.isEmpty
        ? const SizedBox()
        : Padding(
            padding: ResponsiveBreakpoints.of(context).largerThan(MOBILE) ? EdgeInsets.zero : const EdgeInsets.only(left: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyles.h2Bold),
                const Row(
                  children: [
                    SizedBox(width: 60, child: Center(child: Text('Aktiv'))),
                    SizedBox(width: 60, child: Center(child: Text('Sichtbar'))),
                  ],
                )
              ],
            ),
          );
  }
}

class GLAccountListView extends StatelessWidget {
  final GeneralLedgerAccountBloc gLAccountBloc;
  final List<GeneralLedgerAccount> list;

  const GLAccountListView({super.key, required this.gLAccountBloc, required this.list});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeneralLedgerAccountBloc, GeneralLedgerAccountState>(
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final gLAccount = list[index];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Checkbox.adaptive(
                        value: state.selectedGLAccounts.any((e) => e.id == gLAccount.id),
                        onChanged: (_) => gLAccountBloc.add(OnSelectGLAccountEvent(gLAccount: gLAccount)),
                      ),
                      TextButton(
                        onPressed: () {
                          gLAccountBloc.add(SetGLAccountEvent(gLAccount: gLAccount));
                          addEditGLAccount(context, gLAccountBloc, gLAccount);
                        },
                        child: Text(gLAccount.generalLedgerAccount),
                      ),
                      if (ResponsiveBreakpoints.of(context).largerThan(MOBILE)) Gaps.w16,
                      Expanded(child: Text(gLAccount.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Center(
                        child: IconButton(
                          onPressed: () => gLAccountBloc.add(UpdateGLAccountIsActiveEvent(gLAccount: gLAccount)),
                          icon: gLAccount.isActive ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.close, color: Colors.red),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Center(
                        child: IconButton(
                          onPressed: () => gLAccountBloc.add(UpdateGLAccountIsVisibleEvent(gLAccount: gLAccount)),
                          icon: gLAccount.isVisible ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.close, color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
