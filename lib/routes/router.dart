import 'package:auto_route/auto_route.dart';

import 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, path: '/'),
        AutoRoute(page: SignInRoute.page, path: '/sign_in'),
        AutoRoute(page: SignUpRoute.page, path: '/sign_up'),
        AutoRoute(page: RegisterUserDataRoute.page, path: '/register_user_data'),
        AutoRoute(page: ResetPasswordRoute.page, path: '/reset_password'),
        AutoRoute(page: HomeRoute.page, path: '/home'),
        AutoRoute(page: DashboardRoute.page, path: '/dashboard'),
        AutoRoute(page: ProductImportRoute.page, path: '/product_import'),
        AutoRoute(page: ProductExportRoute.page, path: '/product_export'),
        AutoRoute(page: ProductsOverviewRoute.page, path: '/products_overview'),
        AutoRoute(page: ProductDetailRoute.page, path: '/products_overview/products_detail'),
        AutoRoute(page: ProductDescriptionRoute.page, path: '/products_overview/products_detail/product_description'),
        AutoRoute(page: MarketplacesOverviewRoute.page, path: '/marketplace_overview'),
        AutoRoute(page: PosOverviewRoute.page, path: '/pos_overview'),
        AutoRoute(page: PosDetailRoute.page, path: '/pos_overview/pos_detail'),
        AutoRoute(page: EMailAutomationRoute.page, path: '/e_mail_automation'),
        AutoRoute(page: MainSettingsRoute.page, path: '/main_settings'),
        AutoRoute(page: TaxRulesRoute.page, path: '/main_settings/tax_rules'),
        AutoRoute(page: PaymentMethodRoute.page, path: '/main_settings/payment_method'),
        AutoRoute(page: PackagingBoxesRoute.page, path: '/main_settings/packaging_boxes'),
        AutoRoute(page: CarriersOverviewRoute.page, path: '/main_settings/carriers_overview'),
        AutoRoute(page: CarrierDetailRoute.page, path: '/main_settings/carriers_overview/carrier_detail'),
        AutoRoute(page: OffersOverviewRoute.page, path: '/offers_overview'),
        AutoRoute(page: AppointmentsOverviewRoute.page, path: '/appointments_overview'),
        AutoRoute(page: DeliveryNotesOverviewRoute.page, path: '/delivery_notes_overview'),
        AutoRoute(page: InvoicesOverviewRoute.page, path: '/invoices_overview'),
        AutoRoute(page: ReceiptDetailRoute.page, path: '/receipts_overview/receipt_detail'),
        AutoRoute(page: CustomersOverviewRoute.page, path: '/customers_overview'),
        AutoRoute(page: CustomerDetailRoute.page, path: '/customers_overview/customer_detail'),
        AutoRoute(page: SuppliersOverviewRoute.page, path: '/suppliers_overview'),
        AutoRoute(page: SupplierDetailRoute.page, path: '/suppliers_overview/supplier_detail'),
        AutoRoute(page: ReordersOverviewRoute.page, path: '/reorders_overview'),
        AutoRoute(page: ReorderDetailRoute.page, path: '/reorders_overview/reorder_detail'),
        AutoRoute(page: PackingStationOverviewRoute.page, path: '/packing_station'),
        AutoRoute(page: PackingStationDetailRoute.page, path: '/packing_station_overview/packing_station_detail'),
        AutoRoute(page: PicklistsOverviewRoute.page, path: '/picklists_overview'),
        AutoRoute(page: PicklistDetailRoute.page, path: '/picklist_detail'),
        AutoRoute(page: ProductsBookingRoute.page, path: '/products_booking'),
        AutoRoute(page: GeneralLedgerAccountRoute.page, path: '/general_ledger_account'),
        AutoRoute(page: IncomingInvoicesOverviewRoute.page, path: '/incoming_invoices_overview'),
        AutoRoute(page: IncomingInvoiceDetailRoute.page, path: '/incoming_invoices_overview/incoming_invoice_detail'),
        //
        AutoRoute(page: MyFullscreenImageRoute.page, path: '/fullscreen_image'),
        AutoRoute(page: ShippingLabelRoute.page, path: '/shipping_label'),
      ];
}
