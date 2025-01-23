import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '/1_presentation/core/core.dart';
import '/1_presentation/splash_page.dart';
import '../3_domain/entities/receipt/receipt.dart';
import '../constants.dart';
import '../routes/router.gr.dart';

class AppDrawer extends StatefulWidget {
  final bool isPersistent;

  const AppDrawer({super.key, this.isPersistent = false});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    void navigateToRoute(PageRouteInfo route) {
      if (widget.isPersistent) {
        context.router.current.name == route.routeName ? null : context.router.replaceAll([route]);
        setState(() {});
      } else {
        if (context.router.current.name != route.routeName) context.router.replaceAll([route]);
        context.pop(); // Schließt den Drawer
      }
    }

    return Drawer(child: _AppDrawerContent(navigateToRoute: navigateToRoute));
  }
}

class _AppDrawerContent extends StatelessWidget {
  final void Function(PageRouteInfo route) navigateToRoute;

  const _AppDrawerContent({required this.navigateToRoute});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Gaps.h16,
                  _MyDrawerTile(
                    route: const HomeRoute(),
                    icon: Icons.home,
                    title: 'Startseite',
                    navigateToRoute: navigateToRoute,
                  ),
                  _MyDrawerTile(
                    route: const DashboardRoute(),
                    icon: Icons.dashboard,
                    title: 'Dashboard',
                    navigateToRoute: navigateToRoute,
                  ),
                  _MyDrawerTile(
                    route: const ProductsOverviewRoute(),
                    icon: Icons.warehouse,
                    title: 'Artikel',
                    navigateToRoute: navigateToRoute,
                  ),
                  _MyDrawerTile(
                    route: const CustomersOverviewRoute(),
                    icon: Icons.person,
                    title: 'Kunden',
                    navigateToRoute: navigateToRoute,
                  ),
                  _MyDrawerExpansionTile(
                    title: 'Einkauf / Buchhaltung',
                    icon: Icons.account_balance,
                    children: [
                      _MyDrawerTile(
                        route: const SuppliersOverviewRoute(),
                        icon: Icons.person_4_outlined,
                        title: 'Lieferanten',
                        navigateToRoute: navigateToRoute,
                      ),
                      _MyDrawerTile(
                        route: const ReordersOverviewRoute(),
                        icon: Icons.dashboard_customize_rounded,
                        title: 'Bestellungen',
                        navigateToRoute: navigateToRoute,
                      ),
                    ],
                  ),
                  _MyDrawerExpansionTile(
                    title: 'Lager',
                    icon: Icons.warehouse,
                    children: [
                      _MyDrawerTile(
                        route: const HomeRoute(),
                        icon: Icons.subdirectory_arrow_right,
                        title: 'Warenausgang',
                        navigateToRoute: navigateToRoute,
                      ),
                      _MyDrawerTile(
                        route: const ProductsBookingRoute(),
                        icon: Icons.subdirectory_arrow_left,
                        title: 'Wareneingang',
                        navigateToRoute: navigateToRoute,
                      ),
                    ],
                  ),
                  _MyDrawerTile(
                    route: const PackingStationOverviewRoute(),
                    icon: Icons.delivery_dining,
                    title: 'Packstation',
                    navigateToRoute: navigateToRoute,
                  ),
                  _MyDrawerTile(
                    route: const PosOverviewRoute(),
                    icon: Icons.shopping_cart,
                    title: 'POS',
                    navigateToRoute: navigateToRoute,
                  ),
                  _MyDrawerExpansionTile(
                    title: 'Dokumente',
                    icon: Icons.receipt,
                    children: [
                      _MyDrawerTile(
                        route: OffersOverviewRoute(receiptTyp: ReceiptType.offer.name),
                        icon: Icons.receipt,
                        title: 'Angebote',
                        navigateToRoute: navigateToRoute,
                      ),
                      _MyDrawerTile(
                        route: AppointmentsOverviewRoute(receiptTyp: ReceiptType.appointment.name),
                        icon: Icons.receipt,
                        title: 'Aufträge',
                        navigateToRoute: navigateToRoute,
                      ),
                      _MyDrawerTile(
                        route: DeliveryNotesOverviewRoute(receiptTyp: ReceiptType.deliveryNote.name),
                        icon: Icons.receipt,
                        title: 'Lieferscheine',
                        navigateToRoute: navigateToRoute,
                      ),
                      _MyDrawerTile(
                        route: InvoicesOverviewRoute(receiptTyp: ReceiptType.invoice.name),
                        icon: Icons.receipt,
                        title: 'Rechnungen',
                        navigateToRoute: navigateToRoute,
                      ),
                    ],
                  ),
                  _MyDrawerTile(
                    route: const ShippingLabelRoute(),
                    icon: Icons.send,
                    title: 'Versandlabel',
                    navigateToRoute: navigateToRoute,
                  ),
                  _MyDrawerExpansionTile(
                    title: 'E-Commerce',
                    icon: Icons.maps_home_work_rounded,
                    children: [
                      _MyDrawerTile(
                        route: const ProductImportRoute(),
                        icon: Icons.import_export,
                        title: 'Artikel importieren',
                        navigateToRoute: navigateToRoute,
                      ),
                      _MyDrawerTile(
                        route: const ProductExportRoute(),
                        icon: Icons.import_export,
                        title: 'Artikel exportieren',
                        navigateToRoute: navigateToRoute,
                      ),
                      _MyDrawerTile(
                        route: MarketplacesOverviewRoute(),
                        icon: Icons.business,
                        title: 'Marktplätze',
                        navigateToRoute: navigateToRoute,
                      ),
                      _MyDrawerTile(
                        route: const EMailAutomationRoute(),
                        icon: Icons.mail,
                        title: 'E-Mail Automatisierungen',
                        navigateToRoute: navigateToRoute,
                      ),
                    ],
                  ),
                  _MyDrawerExpansionTile(
                    title: 'Buchhaltung',
                    icon: Icons.balance,
                    children: [
                      _MyDrawerTile(
                        route: const GeneralLedgerAccountRoute(),
                        icon: Icons.table_chart_outlined,
                        title: 'Sachkontos',
                        navigateToRoute: navigateToRoute,
                      ),
                      _MyDrawerTile(
                        route: const IncomingInvoicesOverviewRoute(),
                        icon: Icons.document_scanner,
                        title: 'Eingangsrechnungen',
                        navigateToRoute: navigateToRoute,
                      ),
                    ],
                  ),
                  _MyDrawerExpansionTile(
                    title: 'Einstellungen',
                    icon: Icons.settings,
                    children: [
                      _MyDrawerTile(
                        route: const TaxRulesRoute(),
                        icon: Icons.percent,
                        title: 'Steuerregeln',
                        navigateToRoute: navigateToRoute,
                      ),
                      _MyDrawerTile(
                        route: const PaymentMethodRoute(),
                        icon: Icons.payment,
                        title: 'Zahlungsarten',
                        navigateToRoute: navigateToRoute,
                      ),
                      _MyDrawerTile(
                        route: const CarriersOverviewRoute(),
                        icon: Icons.local_shipping_outlined,
                        title: 'Versanddienstleister',
                        navigateToRoute: navigateToRoute,
                      ),
                      _MyDrawerTile(
                        route: const PackagingBoxesRoute(),
                        icon: Icons.archive,
                        title: 'Verpackungskartons',
                        navigateToRoute: navigateToRoute,
                      ),
                      _MyDrawerTile(
                        route: const MainSettingsRoute(),
                        icon: Icons.settings,
                        title: 'Grundeinstellungen',
                        navigateToRoute: navigateToRoute,
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
    );
  }
}

class _MyDrawerTile extends StatelessWidget {
  final PageRouteInfo<dynamic> route;
  final IconData icon;
  final String title;
  final void Function(PageRouteInfo route) navigateToRoute;

  const _MyDrawerTile({
    required this.route,
    required this.icon,
    required this.title,
    required this.navigateToRoute,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: context.router.isRouteActive(route.routeName),
      selectedTileColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      leading: Icon(icon),
      title: Text(title, style: context.textTheme.bodyMedium),
      onTap: () => navigateToRoute(route),
    );
  }
}

class _MyDrawerExpansionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _MyDrawerExpansionTile({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title, style: context.textTheme.bodyMedium),
      leading: Icon(icon),
      childrenPadding: const EdgeInsets.only(left: 14),
      children: children,
    );
  }
}
