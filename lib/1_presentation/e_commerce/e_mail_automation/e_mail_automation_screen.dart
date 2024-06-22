import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/marketplace/marketplace_bloc.dart';
import '../../../injection.dart';
import '../../app_drawer.dart';
import '../../core/core.dart';
import 'e_mail_automation_page.dart';

@RoutePage()
class EMailAutomationScreen extends StatelessWidget {
  const EMailAutomationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final marketplaceBloc = sl<MarketplaceBloc>()..add(GetAllMarketplacesEvent());

    return BlocProvider(
      create: (context) => marketplaceBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<MarketplaceBloc, MarketplaceState>(
            listenWhen: (p, c) => p.fosMarketplacesOnObserveOption != c.fosMarketplacesOnObserveOption,
            listener: (context, state) {
              state.fosMarketplacesOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (marketplaces) => null,
                ),
              );
            },
          ),
          BlocListener<MarketplaceBloc, MarketplaceState>(
            listenWhen: (p, c) => p.fosMarketplaceOnUpdateOption != c.fosMarketplaceOnUpdateOption,
            listener: (context, state) {
              state.fosMarketplaceOnUpdateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (unit) {
                    myScaffoldMessenger(context, null, null, 'Marktplätze erfolgreich aktualisiert', null);
                    marketplaceBloc.add(GetAllMarketplacesEvent());
                  },
                ),
              );
            },
          ),
        ],
        child: Scaffold(
          drawer: const AppDrawer(),
          appBar: AppBar(title: const Text('E-Mail Automatisierung')),
          body: EMailAutomationBody(marketplaceBloc: marketplaceBloc),
        ),
      ),
    );
  }
}

class EMailAutomationBody extends StatelessWidget {
  final MarketplaceBloc marketplaceBloc;

  const EMailAutomationBody({super.key, required this.marketplaceBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketplaceBloc, MarketplaceState>(
      builder: (context, state) {
        if (state.isLoadingMarketplacesOnObserve) return const Center(child: MyCircularProgressIndicator());

        if (state.firebaseFailure != null && state.isAnyFailure) {
          return const Center(child: Text('Ein Fehler beim Laden der Marktplätze ist aufgetreten!'));
        }

        if (state.listOfMarketplace == null) return const Center(child: MyCircularProgressIndicator());
        if (state.listOfMarketplace!.isEmpty) return const Center(child: Text('Sie haben bisher keine Marktplätze angelegt'));

        return EMailAutomationPage(marketplaceBloc: marketplaceBloc);
      },
    );
  }
}
