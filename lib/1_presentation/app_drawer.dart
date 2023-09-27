import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/e_commerce/marketplace/marketplace_overview/marketplace_overview_screen.dart';
import 'package:cezeri_commerce/1_presentation/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';
import '../routes/router.gr.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Gaps.h16,
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text('Startseite'),
                      onTap: () {
                        if (context.router.current.name == HomeRoute.name) {
                          context.router.pop();
                        } else {
                          context.router.replaceAll([const HomeRoute()]);
                        }
                      },
                    ),
                    ListTile(leading: const Icon(Icons.dashboard), title: const Text('Dashboard'), onTap: () {}),
                    ListTile(
                      leading: const Icon(Icons.article),
                      title: const Text('Artikel'),
                      onTap: () {
                        if (context.router.current.name == ProductsOverviewRoute.name) {
                          context.router.pop();
                        } else {
                          context.router.replaceAll([const ProductsOverviewRoute()]);
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.receipt),
                      title: const Text('Aufträge'),
                      onTap: () {
                        if (context.router.current.name == AppointmentsOverviewRoute.name) {
                          context.router.pop();
                        } else {
                          context.router.replaceAll([const AppointmentsOverviewRoute()]);
                        }
                      },
                    ),
                    ExpansionTile(
                      leading: const Icon(FontAwesomeIcons.cartShopping),
                      title: const Text('E-Commerce'),
                      children: [
                        ListTile(
                          leading: const Icon(Icons.import_export),
                          title: const Text('Artikel importieren'),
                          onTap: () {
                            if (context.router.current.name == ProductImportRoute.name) {
                              context.router.pop();
                            } else {
                              context.router.replaceAll([const ProductImportRoute()]);
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.business),
                          title: const Text('Marktplätze'),
                          onTap: () {
                            context.router.push(const HomeRoute());
                            context.router.replaceAll(
                              [MarketplaceOverviewRoute(comeFromToMarketplaceOverview: ComeFromToMarketplaceOverview.marketplaceOverview)],
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(FontAwesomeIcons.diagramProject),
                          title: const Text('Massenbearbeitung'),
                          onTap: () {
                            context.router.push(const HomeRoute());
                            context.router.replaceAll(
                              [MarketplaceOverviewRoute(comeFromToMarketplaceOverview: ComeFromToMarketplaceOverview.marketplaceMassEditing)],
                            );
                          },
                        ),
                      ],
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Einstellungen'),
                      onTap: () {
                        if (context.router.current.name == MainSettingsRoute.name) {
                          context.router.pop();
                        } else {
                          context.router.replaceAll([const MainSettingsRoute()]);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: CustomColors.todoScaleRedActive),
              title: const Text('Abmelden'),
              onTap: () => context.router.replaceAll([SplashRoute(comeFrom: ComeFromToSplashPage.appDrawer)]),
            ),
            Gaps.h16
          ],
        ),
      ),
    );
  }
}
