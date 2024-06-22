import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../2_application/database/general_ledger_account/general_ledger_account_bloc.dart';
import '../../3_domain/entities/settings/general_ledger_account.dart';
import '../../injection.dart';
import '../../routes/router.gr.dart';
import '../app_drawer.dart';
import '../core/core.dart';
import 'general_ledger_account_page.dart';
import 'widgets/add_edit_general_ledger_account.dart';

@RoutePage()
class GeneralLedgerAccountScreen extends StatefulWidget {
  const GeneralLedgerAccountScreen({super.key});

  @override
  State<GeneralLedgerAccountScreen> createState() => _GeneralLedgerAccountScreenState();
}

class _GeneralLedgerAccountScreenState extends State<GeneralLedgerAccountScreen> with AutomaticKeepAliveClientMixin {
  final gLAccountBloc = sl<GeneralLedgerAccountBloc>()..add(GetAllGLAccountsEvent());

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: gLAccountBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<GeneralLedgerAccountBloc, GeneralLedgerAccountState>(
            listenWhen: (p, c) => p.fosGLAccountsOnObserveOption != c.fosGLAccountsOnObserveOption,
            listener: (context, state) {
              state.fosGLAccountsOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (listOfProducts) => myScaffoldMessenger(context, null, null, 'Sachkontos erfolgreich geladen', null),
                ),
              );
            },
          ),
          BlocListener<GeneralLedgerAccountBloc, GeneralLedgerAccountState>(
            listenWhen: (p, c) => p.fosGLAccountOnCreateOption != c.fosGLAccountOnCreateOption,
            listener: (context, state) {
              state.fosGLAccountOnCreateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (listOfProducts) {
                    myScaffoldMessenger(context, null, null, 'Sachkonto erfolgreich erstellt', null);
                    context.router.popUntilRouteWithName(GeneralLedgerAccountRoute.name);
                  },
                ),
              );
            },
          ),
          BlocListener<GeneralLedgerAccountBloc, GeneralLedgerAccountState>(
            listenWhen: (p, c) => p.fosGLAccountOnUpdateOption != c.fosGLAccountOnUpdateOption,
            listener: (context, state) {
              state.fosGLAccountOnUpdateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (listOfProducts) {
                    myScaffoldMessenger(context, null, null, 'Sachkonto erfolgreich aktualisiert', null);
                    context.router.popUntilRouteWithName(GeneralLedgerAccountRoute.name);
                  },
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<GeneralLedgerAccountBloc, GeneralLedgerAccountState>(
          builder: (context, state) {
            const drawer = AppDrawer();
            final appbar = AppBar(
              title: const Text('Sachkontos'),
              actions: [IconButton(onPressed: () => gLAccountBloc.add(GetAllGLAccountsEvent()), icon: const Icon(Icons.refresh))],
            );
            final fab = FloatingActionButton(
              onPressed: () {
                gLAccountBloc.add(SetGLAccountEvent(gLAccount: GeneralLedgerAccount.empty()));
                addEditGLSAccount(context, gLAccountBloc, null);
              },
              child: const Icon(Icons.add, color: Colors.white),
            );

            if (state.isLoadingGLAccountsOnObserve) {
              return Scaffold(drawer: drawer, appBar: appbar, body: const Center(child: MyCircularProgressIndicator()));
            }
            if (state.abstractFailure != null && state.isAnyFailure) {
              return Scaffold(drawer: drawer, appBar: appbar, body: const Center(child: Text('Ein Fehler ist aufgetreten')));
            }
            if (state.listOfAllGLAccounts == null) {
              return Scaffold(drawer: drawer, appBar: appbar, body: const Center(child: MyCircularProgressIndicator()));
            }

            return Scaffold(
              drawer: drawer,
              appBar: appbar,
              floatingActionButton: fab,
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: CupertinoSearchTextField(
                      controller: state.searchController,
                      onChanged: (value) => gLAccountBloc.add(OnGLAccountSearchControllerChangedEvent()),
                      onSuffixTap: () => gLAccountBloc.add(OnGLAccountSearchControllerClearedEvent()),
                    ),
                  ),
                  Expanded(child: GeneralLedgerAccountPage(gLAccountBloc: gLAccountBloc)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
