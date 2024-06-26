import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/splash_page.dart';
import 'package:flutter/material.dart';

import '../3_domain/entities/receipt/receipt.dart';
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
                          context.router.maybePop();
                        } else {
                          context.router.replaceAll([const HomeRoute()]);
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.dashboard),
                      title: const Text('Dashboard'),
                      onTap: () {
                        if (context.router.current.name == DashboardRoute.name) {
                          context.router.maybePop();
                        } else {
                          context.router.replaceAll([const DashboardRoute()]);
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.warehouse),
                      title: const Text('Artikel'),
                      onTap: () {
                        if (context.router.current.name == ProductsOverviewRoute.name) {
                          context.router.maybePop();
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
                          context.router.maybePop();
                        } else {
                          context.router.replaceAll([const CustomersOverviewRoute()]);
                        }
                      },
                    ),
                    ExpansionTile(
                      title: const Text('Einkauf / Buchhaltung'),
                      leading: const Icon(Icons.account_balance),
                      childrenPadding: const EdgeInsets.only(left: 20),
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person_4_outlined),
                          title: const Text('Lieferanten'),
                          onTap: () {
                            if (context.router.current.name == SuppliersOverviewRoute.name) {
                              context.router.maybePop();
                            } else {
                              context.router.replaceAll([const SuppliersOverviewRoute()]);
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.dashboard_customize_rounded),
                          title: const Text('Bestellungen'),
                          onTap: () {
                            if (context.router.current.name == ReordersOverviewRoute.name) {
                              context.router.maybePop();
                            } else {
                              context.router.replaceAll([const ReordersOverviewRoute()]);
                            }
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: const Text('Lager'),
                      leading: const Icon(Icons.warehouse),
                      childrenPadding: const EdgeInsets.only(left: 20),
                      children: [
                        ListTile(
                          leading: const Icon(Icons.subdirectory_arrow_right),
                          title: const Text('Warenausgang'),
                          onTap: () {
                            // if (context.router.current.name == SuppliersOverviewRoute.name) {
                            //   context.router.maybePop();
                            // } else {
                            //   context.router.replaceAll([const SuppliersOverviewRoute()]);
                            // }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.subdirectory_arrow_left),
                          title: const Text('Wareneingang'),
                          onTap: () {
                            if (context.router.current.name == ProductsBookingRoute.name) {
                              context.router.maybePop();
                            } else {
                              context.router.replaceAll([const ProductsBookingRoute()]);
                            }
                          },
                        ),
                      ],
                    ),
                    ListTile(
                      leading: const Icon(Icons.delivery_dining),
                      title: const Text('Packstation'),
                      onTap: () {
                        if (context.router.current.name == PackingStationOverviewRoute.name) {
                          context.router.maybePop();
                        } else {
                          context.router.replaceAll([const PackingStationOverviewRoute()]);
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.shopping_cart),
                      title: const Text('POS'),
                      onTap: () {
                        // if (context.router.current.name == PackingStationOverviewRoute.name) {
                        //   context.router.maybePop();
                        // } else {
                        //   context.router.replaceAll([const PackingStationOverviewRoute()]);
                        // }
                      },
                    ),
                    ExpansionTile(
                      title: const Text('Dokumente'),
                      leading: const Icon(Icons.receipt),
                      childrenPadding: const EdgeInsets.only(left: 20),
                      children: [
                        ListTile(
                          leading: const Icon(Icons.receipt),
                          title: const Text('Angebote'),
                          onTap: () {
                            if (context.router.current.name == OffersOverviewRoute.name) {
                              context.router.maybePop();
                            } else {
                              context.router.replaceAll([OffersOverviewRoute(receiptTyp: ReceiptType.offer)]);
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.receipt),
                          title: const Text('Aufträge'),
                          onTap: () {
                            if (context.router.current.name == AppointmentsOverviewRoute.name) {
                              context.router.maybePop();
                            } else {
                              context.router.replaceAll([AppointmentsOverviewRoute(receiptTyp: ReceiptType.appointment)]);
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.receipt),
                          title: const Text('Lieferscheine'),
                          onTap: () {
                            if (context.router.current.name == DeliveryNotesOverviewRoute.name) {
                              context.router.maybePop();
                            } else {
                              context.router.replaceAll([DeliveryNotesOverviewRoute(receiptTyp: ReceiptType.deliveryNote)]);
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.receipt),
                          title: const Text('Rechnungen'),
                          onTap: () {
                            if (context.router.current.name == InvoicesOverviewRoute.name) {
                              context.router.maybePop();
                            } else {
                              context.router.replaceAll([InvoicesOverviewRoute(receiptTyp: ReceiptType.invoice)]);
                            }
                          },
                        ),
                      ],
                    ),
                    ListTile(
                      leading: const Icon(Icons.send),
                      title: const Text('Versandlabel'),
                      onTap: () {
                        if (context.router.current.name == ShippingLabelRoute.name) {
                          context.router.maybePop();
                        } else {
                          context.router.replaceAll([const ShippingLabelRoute()]);
                        }
                      },
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.maps_home_work_rounded),
                      title: const Text('E-Commerce'),
                      childrenPadding: const EdgeInsets.only(left: 20),
                      children: [
                        ListTile(
                          leading: const Icon(Icons.import_export),
                          title: const Text('Artikel importieren'),
                          onTap: () {
                            if (context.router.current.name == ProductImportRoute.name) {
                              context.router.maybePop();
                            } else {
                              context.router.replaceAll([const ProductImportRoute()]);
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.import_export),
                          title: const Text('Artikel exportieren'),
                          onTap: () {
                            if (context.router.current.name == ProductExportRoute.name) {
                              context.router.maybePop();
                            } else {
                              context.router.replaceAll([const ProductExportRoute()]);
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.business),
                          title: const Text('Marktplätze'),
                          onTap: () {
                            if (context.router.current.name == MarketplaceOverviewRoute.name) {
                              context.router.maybePop();
                            } else {
                              context.router.replaceAll([const MarketplaceOverviewRoute()]);
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.mail),
                          title: const Text('E-Mail Automatisierungen'),
                          onTap: () {
                            if (context.router.current.name == EMailAutomationRoute.name) {
                              context.router.maybePop();
                            } else {
                              context.router.replaceAll([const EMailAutomationRoute()]);
                            }
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: const Text('Buchhaltung'),
                      leading: const Icon(Icons.balance),
                      childrenPadding: const EdgeInsets.only(left: 20),
                      children: [
                        ListTile(
                          leading: const Icon(Icons.table_chart_outlined),
                          title: const Text('Sachkontos'),
                          onTap: () {
                            if (context.router.current.name == GeneralLedgerAccountRoute.name) {
                              context.router.maybePop();
                            } else {
                              context.router.replaceAll([const GeneralLedgerAccountRoute()]);
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.document_scanner),
                          title: const Text('Eingangsrechnungen'),
                          onTap: () {
                            if (context.router.current.name == ReordersOverviewRoute.name) {
                              context.router.maybePop();
                            } else {
                              context.router.replaceAll([const ReordersOverviewRoute()]);
                            }
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Einstellungen'),
                      childrenPadding: const EdgeInsets.only(left: 20),
                      children: [
                        ListTile(
                          leading: const Icon(Icons.percent),
                          title: const Text('Steuerregeln'),
                          onTap: () {
                            if (context.router.current.name == TaxRulesRoute.name) {
                              context.router.maybePop();
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
                              context.router.maybePop();
                            } else {
                              context.router.replaceAll([const PaymentMethodRoute()]);
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.local_shipping_outlined),
                          title: const Text('Versanddienstleister'),
                          onTap: () {
                            if (context.router.current.name == CarriersOverviewRoute.name) {
                              context.router.maybePop();
                            } else {
                              context.router.replaceAll([const CarriersOverviewRoute()]);
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.archive),
                          title: const Text('Verpackungskartons'),
                          onTap: () {
                            if (context.router.current.name == PackagingBoxesRoute.name) {
                              context.router.maybePop();
                            } else {
                              context.router.replaceAll([const PackagingBoxesRoute()]);
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text('Grundeinstellungen'),
                          onTap: () {
                            if (context.router.current.name == MainSettingsRoute.name) {
                              context.router.maybePop();
                            } else {
                              context.router.replaceAll([const MainSettingsRoute()]);
                            }
                          },
                        ),
                      ],
                    ),
                    Gaps.h42,
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
