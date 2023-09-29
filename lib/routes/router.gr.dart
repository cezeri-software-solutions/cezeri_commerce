// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i14;
import 'package:cezeri_commerce/1_presentation/auth/register_user_data/register_user_data_screen.dart'
    as _i9;
import 'package:cezeri_commerce/1_presentation/auth/reset_password/reset_password_screen.dart'
    as _i10;
import 'package:cezeri_commerce/1_presentation/auth/sign_in/sign_in_screen.dart'
    as _i11;
import 'package:cezeri_commerce/1_presentation/auth/sign_up/sign_up_screen.dart'
    as _i12;
import 'package:cezeri_commerce/1_presentation/e_commerce/marketplace/marketplace_mass_editing/marketplace_mass_editing_screen.dart'
    as _i4;
import 'package:cezeri_commerce/1_presentation/e_commerce/marketplace/marketplace_overview/marketplace_overview_screen.dart'
    as _i5;
import 'package:cezeri_commerce/1_presentation/home_screen.dart' as _i2;
import 'package:cezeri_commerce/1_presentation/product/product_detail/product_detail_screen.dart'
    as _i6;
import 'package:cezeri_commerce/1_presentation/product/products_overview/products_overview_screen.dart'
    as _i8;
import 'package:cezeri_commerce/1_presentation/receipt/appointments_overview/appointments_overview_screen.dart'
    as _i1;
import 'package:cezeri_commerce/1_presentation/settings/product_import/product_import_screen.dart'
    as _i7;
import 'package:cezeri_commerce/1_presentation/settings/settings/main_settings_screen.dart'
    as _i3;
import 'package:cezeri_commerce/1_presentation/splash_page.dart' as _i13;
import 'package:cezeri_commerce/2_application/firebase/product/product_bloc.dart'
    as _i17;
import 'package:cezeri_commerce/3_domain/entities/marketplace/marketplace.dart'
    as _i16;
import 'package:flutter/material.dart' as _i15;

abstract class $AppRouter extends _i14.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i14.PageFactory> pagesMap = {
    AppointmentsOverviewRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AppointmentsOverviewScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.HomeScreen(),
      );
    },
    MainSettingsRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.MainSettingsScreen(),
      );
    },
    MarketplaceMassEditingRoute.name: (routeData) {
      final args = routeData.argsAs<MarketplaceMassEditingRouteArgs>();
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.MarketplaceMassEditingScreen(
          key: args.key,
          marketplace: args.marketplace,
        ),
      );
    },
    MarketplaceOverviewRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.MarketplaceOverviewScreen(),
      );
    },
    ProductDetailRoute.name: (routeData) {
      final args = routeData.argsAs<ProductDetailRouteArgs>();
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.ProductDetailScreen(
          key: args.key,
          productBloc: args.productBloc,
          productCreateOrEdit: args.productCreateOrEdit,
        ),
      );
    },
    ProductImportRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.ProductImportScreen(),
      );
    },
    ProductsOverviewRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.ProductsOverviewScreen(),
      );
    },
    RegisterUserDataRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.RegisterUserDataScreen(),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.ResetPasswordScreen(),
      );
    },
    SignInRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.SignInScreen(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.SignUpScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      final args = routeData.argsAs<SplashRouteArgs>(
          orElse: () => const SplashRouteArgs());
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.SplashPage(
          key: args.key,
          comeFrom: args.comeFrom,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AppointmentsOverviewScreen]
class AppointmentsOverviewRoute extends _i14.PageRouteInfo<void> {
  const AppointmentsOverviewRoute({List<_i14.PageRouteInfo>? children})
      : super(
          AppointmentsOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppointmentsOverviewRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i14.PageRouteInfo<void> {
  const HomeRoute({List<_i14.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i3.MainSettingsScreen]
class MainSettingsRoute extends _i14.PageRouteInfo<void> {
  const MainSettingsRoute({List<_i14.PageRouteInfo>? children})
      : super(
          MainSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainSettingsRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i4.MarketplaceMassEditingScreen]
class MarketplaceMassEditingRoute
    extends _i14.PageRouteInfo<MarketplaceMassEditingRouteArgs> {
  MarketplaceMassEditingRoute({
    _i15.Key? key,
    required _i16.Marketplace marketplace,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          MarketplaceMassEditingRoute.name,
          args: MarketplaceMassEditingRouteArgs(
            key: key,
            marketplace: marketplace,
          ),
          initialChildren: children,
        );

  static const String name = 'MarketplaceMassEditingRoute';

  static const _i14.PageInfo<MarketplaceMassEditingRouteArgs> page =
      _i14.PageInfo<MarketplaceMassEditingRouteArgs>(name);
}

class MarketplaceMassEditingRouteArgs {
  const MarketplaceMassEditingRouteArgs({
    this.key,
    required this.marketplace,
  });

  final _i15.Key? key;

  final _i16.Marketplace marketplace;

  @override
  String toString() {
    return 'MarketplaceMassEditingRouteArgs{key: $key, marketplace: $marketplace}';
  }
}

/// generated route for
/// [_i5.MarketplaceOverviewScreen]
class MarketplaceOverviewRoute extends _i14.PageRouteInfo<void> {
  const MarketplaceOverviewRoute({List<_i14.PageRouteInfo>? children})
      : super(
          MarketplaceOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'MarketplaceOverviewRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i6.ProductDetailScreen]
class ProductDetailRoute extends _i14.PageRouteInfo<ProductDetailRouteArgs> {
  ProductDetailRoute({
    _i15.Key? key,
    required _i17.ProductBloc productBloc,
    required _i6.ProductCreateOrEdit productCreateOrEdit,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          ProductDetailRoute.name,
          args: ProductDetailRouteArgs(
            key: key,
            productBloc: productBloc,
            productCreateOrEdit: productCreateOrEdit,
          ),
          initialChildren: children,
        );

  static const String name = 'ProductDetailRoute';

  static const _i14.PageInfo<ProductDetailRouteArgs> page =
      _i14.PageInfo<ProductDetailRouteArgs>(name);
}

class ProductDetailRouteArgs {
  const ProductDetailRouteArgs({
    this.key,
    required this.productBloc,
    required this.productCreateOrEdit,
  });

  final _i15.Key? key;

  final _i17.ProductBloc productBloc;

  final _i6.ProductCreateOrEdit productCreateOrEdit;

  @override
  String toString() {
    return 'ProductDetailRouteArgs{key: $key, productBloc: $productBloc, productCreateOrEdit: $productCreateOrEdit}';
  }
}

/// generated route for
/// [_i7.ProductImportScreen]
class ProductImportRoute extends _i14.PageRouteInfo<void> {
  const ProductImportRoute({List<_i14.PageRouteInfo>? children})
      : super(
          ProductImportRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductImportRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i8.ProductsOverviewScreen]
class ProductsOverviewRoute extends _i14.PageRouteInfo<void> {
  const ProductsOverviewRoute({List<_i14.PageRouteInfo>? children})
      : super(
          ProductsOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductsOverviewRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i9.RegisterUserDataScreen]
class RegisterUserDataRoute extends _i14.PageRouteInfo<void> {
  const RegisterUserDataRoute({List<_i14.PageRouteInfo>? children})
      : super(
          RegisterUserDataRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterUserDataRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i10.ResetPasswordScreen]
class ResetPasswordRoute extends _i14.PageRouteInfo<void> {
  const ResetPasswordRoute({List<_i14.PageRouteInfo>? children})
      : super(
          ResetPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i11.SignInScreen]
class SignInRoute extends _i14.PageRouteInfo<void> {
  const SignInRoute({List<_i14.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i12.SignUpScreen]
class SignUpRoute extends _i14.PageRouteInfo<void> {
  const SignUpRoute({List<_i14.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i13.SplashPage]
class SplashRoute extends _i14.PageRouteInfo<SplashRouteArgs> {
  SplashRoute({
    _i15.Key? key,
    _i13.ComeFromToSplashPage? comeFrom,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          SplashRoute.name,
          args: SplashRouteArgs(
            key: key,
            comeFrom: comeFrom,
          ),
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i14.PageInfo<SplashRouteArgs> page =
      _i14.PageInfo<SplashRouteArgs>(name);
}

class SplashRouteArgs {
  const SplashRouteArgs({
    this.key,
    this.comeFrom,
  });

  final _i15.Key? key;

  final _i13.ComeFromToSplashPage? comeFrom;

  @override
  String toString() {
    return 'SplashRouteArgs{key: $key, comeFrom: $comeFrom}';
  }
}
