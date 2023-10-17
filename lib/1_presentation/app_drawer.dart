import 'package:auto_route/auto_route.dart';
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
                      leading: const Icon(Icons.warehouse),
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
                      leading: const Icon(Icons.person),
                      title: const Text('Kunden'),
                      onTap: () {
                        if (context.router.current.name == CustomersOverviewRoute.name) {
                          context.router.pop();
                        } else {
                          context.router.replaceAll([const CustomersOverviewRoute()]);
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
                    ListTile(
                      leading: const Icon(Icons.send),
                      title: const Text('Versandlabel'),
                      onTap: () {
                        if (context.router.current.name == ShippingLabelRoute.name) {
                          context.router.pop();
                        } else {
                          context.router.replaceAll([const ShippingLabelRoute()]);
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
                            if (context.router.current.name == MarketplaceOverviewRoute.name) {
                              context.router.pop();
                            } else {
                              context.router.replaceAll([const MarketplaceOverviewRoute()]);
                            }
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Einstellungen'),
                      children: [
                        ListTile(
                          leading: const Icon(Icons.percent),
                          title: const Text('Steuerregeln'),
                          onTap: () {
                            if (context.router.current.name == TaxRulesRoute.name) {
                              context.router.pop();
                            } else {
                              context.router.replaceAll([const TaxRulesRoute()]);
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.payment),
                          title: const Text('Zahlungsarten'),
                          onTap: () {
                            if (context.router.current.name == PaymentMethodRoute.name) {
                              context.router.pop();
                            } else {
                              context.router.replaceAll([const PaymentMethodRoute()]);
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text('Grundeinstellungen'),
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
