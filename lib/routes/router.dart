import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/routes/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
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
        AutoRoute(page: ProductImportRoute.page, path: '/product_import'),
        AutoRoute(page: ProductsOverviewRoute.page, path: '/products_overview'),
        AutoRoute(page: ProductDetailRoute.page, path: '/products_overview/products_detail'),
        AutoRoute(page: MarketplaceOverviewRoute.page, path: '/marketplace_overview'),
        AutoRoute(page: MainSettingsRoute.page, path: '/main_settings'),
        AutoRoute(page: TaxRulesRoute.page, path: '/main_settings/tax_rules'),
        AutoRoute(page: PaymentMethodRoute.page, path: '/main_settings/payment_method'),
        AutoRoute(page: AppointmentsOverviewRoute.page, path: '/appointments_overview'),
        AutoRoute(page: AppointmentDetailRoute.page, path: '/appointments_overview/appointment_detail'),
        AutoRoute(page: CustomersOverviewRoute.page, path: '/customers_overview'),
        AutoRoute(page: CustomerDetailRoute.page, path: '/customers_overview/customer_detail'),
        //
        AutoRoute(page: MyFullscreenImageRoute.page, path: '/fullscreen_image'),
        AutoRoute(page: ShippingLabelRoute.page, path: '/shipping_label'),
      ];
}
