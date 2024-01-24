import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../2_application/firebase/general_ledger_account/general_ledger_account_bloc.dart';
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
            padding: const EdgeInsets.all(18),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GLAccountTitle(gLAccountBloc: gLAccountBloc, title: 'Klasse 0'),
                GLAccountListView(gLAccountBloc: gLAccountBloc, list: state.listOfFilteredGLAccounts0),
                GLAccountTitle(gLAccountBloc: gLAccountBloc, title: 'Klasse 1'),
                GLAccountListView(gLAccountBloc: gLAccountBloc, list: state.listOfFilteredGLAccounts1),
                GLAccountTitle(gLAccountBloc: gLAccountBloc, title: 'Klasse 2'),
                GLAccountListView(gLAccountBloc: gLAccountBloc, list: state.listOfFilteredGLAccounts2),
                GLAccountTitle(gLAccountBloc: gLAccountBloc, title: 'Klasse 3'),
                GLAccountListView(gLAccountBloc: gLAccountBloc, list: state.listOfFilteredGLAccounts3),
                GLAccountTitle(gLAccountBloc: gLAccountBloc, title: 'Klasse 4'),
                GLAccountListView(gLAccountBloc: gLAccountBloc, list: state.listOfFilteredGLAccounts4),
                GLAccountTitle(gLAccountBloc: gLAccountBloc, title: 'Klasse 5'),
                GLAccountListView(gLAccountBloc: gLAccountBloc, list: state.listOfFilteredGLAccounts5),
                GLAccountTitle(gLAccountBloc: gLAccountBloc, title: 'Klasse 6'),
                GLAccountListView(gLAccountBloc: gLAccountBloc, list: state.listOfFilteredGLAccounts6),
                GLAccountTitle(gLAccountBloc: gLAccountBloc, title: 'Klasse 7'),
                GLAccountListView(gLAccountBloc: gLAccountBloc, list: state.listOfFilteredGLAccounts7),
                GLAccountTitle(gLAccountBloc: gLAccountBloc, title: 'Klasse 8'),
                GLAccountListView(gLAccountBloc: gLAccountBloc, list: state.listOfFilteredGLAccounts8),
                GLAccountTitle(gLAccountBloc: gLAccountBloc, title: 'Klasse 9'),
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

  const GLAccountTitle({super.key, required this.gLAccountBloc, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
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
                Row(
                  children: [
                    Checkbox.adaptive(
                      value: state.selectedGLAccounts.any((e) => e.id == gLAccount.id),
                      onChanged: (_) => gLAccountBloc.add(OnSelectGLAccountEvent(gLAccount: gLAccount)),
                    ),
                    TextButton(
                      onPressed: () {
                        gLAccountBloc.add(SetGLAccountEvent(gLAccount: gLAccount));
                        addEditGLSAccount(context, gLAccountBloc, gLAccount);
                      },
                      child: Text(gLAccount.generalLedgerAccount),
                    ),
                    Gaps.w16,
                    Text(gLAccount.name),
                  ],
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
