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
        AutoRoute(page: ProductDetailRoute.page, path: '/products_detail'),
        AutoRoute(page: MarketplaceOverviewRoute.page, path: '/marketplace_overview'),
        AutoRoute(page: MarketplaceMassEditingRoute.page, path: '/marketplace_mass_editing'),
        AutoRoute(page: MainSettingsRoute.page, path: '/main_settings'),
      ];
}
