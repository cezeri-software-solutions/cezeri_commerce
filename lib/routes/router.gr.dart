// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i18;
import 'package:cezeri_commerce/1_presentation/auth/register_user_data/register_user_data_screen.dart'
    as _i12;
import 'package:cezeri_commerce/1_presentation/auth/reset_password/reset_password_screen.dart'
    as _i13;
import 'package:cezeri_commerce/1_presentation/auth/sign_in/sign_in_screen.dart'
    as _i14;
import 'package:cezeri_commerce/1_presentation/auth/sign_up/sign_up_screen.dart'
    as _i15;
import 'package:cezeri_commerce/1_presentation/client/customer/customers_overview_screen.dart'
    as _i3;
import 'package:cezeri_commerce/1_presentation/core/widgets/my_fullscreen_image_page.dart'
    as _i7;
import 'package:cezeri_commerce/1_presentation/e_commerce/marketplace_overview/marketplace_overview_screen.dart'
    as _i6;
import 'package:cezeri_commerce/1_presentation/e_commerce/product_import/product_import_screen.dart'
    as _i10;
import 'package:cezeri_commerce/1_presentation/home_screen.dart' as _i4;
import 'package:cezeri_commerce/1_presentation/product/product_detail/product_detail_screen.dart'
    as _i9;
import 'package:cezeri_commerce/1_presentation/product/products_overview/products_overview_screen.dart'
    as _i11;
import 'package:cezeri_commerce/1_presentation/receipt/appointment_detail/appointment_detail_screen.dart'
    as _i1;
import 'package:cezeri_commerce/1_presentation/receipt/appointments_overview/appointments_overview_screen.dart'
    as _i2;
import 'package:cezeri_commerce/1_presentation/settings/payment_method/payment_method_screen.dart'
    as _i8;
import 'package:cezeri_commerce/1_presentation/settings/settings/main_settings_screen.dart'
    as _i5;
import 'package:cezeri_commerce/1_presentation/settings/tax_rules/tax_rules_screen.dart'
    as _i17;
import 'package:cezeri_commerce/1_presentation/splash_page.dart' as _i16;
import 'package:cezeri_commerce/2_application/firebase/appointment/appointment_bloc.dart'
    as _i20;
import 'package:cezeri_commerce/2_application/firebase/product/product_bloc.dart'
    as _i22;
import 'package:cezeri_commerce/3_domain/entities/marketplace/marketplace.dart'
    as _i21;
import 'package:flutter/material.dart' as _i19;

abstract class $AppRouter extends _i18.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i18.PageFactory> pagesMap = {
    AppointmentDetailRoute.name: (routeData) {
      final args = routeData.argsAs<AppointmentDetailRouteArgs>();
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AppointmentDetailScreen(
          key: args.key,
          appointmentBloc: args.appointmentBloc,
          listOfMarketplaces: args.listOfMarketplaces,
          receiptCreateOrEdit: args.receiptCreateOrEdit,
        ),
      );
    },
    AppointmentsOverviewRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AppointmentsOverviewScreen(),
      );
    },
    CustomersOverviewRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.CustomersOverviewScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.HomeScreen(),
      );
    },
    MainSettingsRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.MainSettingsScreen(),
      );
    },
    MarketplaceOverviewRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.MarketplaceOverviewScreen(),
      );
    },
    MyFullscreenImageRoute.name: (routeData) {
      final args = routeData.argsAs<MyFullscreenImageRouteArgs>();
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.MyFullscreenImagePage(
          key: args.key,
          imagePaths: args.imagePaths,
          initialIndex: args.initialIndex,
          isNetworkImage: args.isNetworkImage,
        ),
      );
    },
    PaymentMethodRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.PaymentMethodScreen(),
      );
    },
    ProductDetailRoute.name: (routeData) {
      final args = routeData.argsAs<ProductDetailRouteArgs>();
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.ProductDetailScreen(
          key: args.key,
          productBloc: args.productBloc,
          productCreateOrEdit: args.productCreateOrEdit,
        ),
      );
    },
    ProductImportRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.ProductImportScreen(),
      );
    },
    ProductsOverviewRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.ProductsOverviewScreen(),
      );
    },
    RegisterUserDataRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.RegisterUserDataScreen(),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.ResetPasswordScreen(),
      );
    },
    SignInRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.SignInScreen(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.SignUpScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      final args = routeData.argsAs<SplashRouteArgs>(
          orElse: () => const SplashRouteArgs());
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i16.SplashPage(
          key: args.key,
          comeFrom: args.comeFrom,
        ),
      );
    },
    TaxRulesRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.TaxRulesScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.AppointmentDetailScreen]
class AppointmentDetailRoute
    extends _i18.PageRouteInfo<AppointmentDetailRouteArgs> {
  AppointmentDetailRoute({
    _i19.Key? key,
    required _i20.AppointmentBloc appointmentBloc,
    required List<_i21.Marketplace> listOfMarketplaces,
    required _i1.ReceiptCreateOrEdit receiptCreateOrEdit,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          AppointmentDetailRoute.name,
          args: AppointmentDetailRouteArgs(
            key: key,
            appointmentBloc: appointmentBloc,
            listOfMarketplaces: listOfMarketplaces,
            receiptCreateOrEdit: receiptCreateOrEdit,
          ),
          initialChildren: children,
        );

  static const String name = 'AppointmentDetailRoute';

  static const _i18.PageInfo<AppointmentDetailRouteArgs> page =
      _i18.PageInfo<AppointmentDetailRouteArgs>(name);
}

class AppointmentDetailRouteArgs {
  const AppointmentDetailRouteArgs({
    this.key,
    required this.appointmentBloc,
    required this.listOfMarketplaces,
    required this.receiptCreateOrEdit,
  });

  final _i19.Key? key;

  final _i20.AppointmentBloc appointmentBloc;

  final List<_i21.Marketplace> listOfMarketplaces;

  final _i1.ReceiptCreateOrEdit receiptCreateOrEdit;

  @override
  String toString() {
    return 'AppointmentDetailRouteArgs{key: $key, appointmentBloc: $appointmentBloc, listOfMarketplaces: $listOfMarketplaces, receiptCreateOrEdit: $receiptCreateOrEdit}';
  }
}

/// generated route for
/// [_i2.AppointmentsOverviewScreen]
class AppointmentsOverviewRoute extends _i18.PageRouteInfo<void> {
  const AppointmentsOverviewRoute({List<_i18.PageRouteInfo>? children})
      : super(
          AppointmentsOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppointmentsOverviewRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i3.CustomersOverviewScreen]
class CustomersOverviewRoute extends _i18.PageRouteInfo<void> {
  const CustomersOverviewRoute({List<_i18.PageRouteInfo>? children})
      : super(
          CustomersOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'CustomersOverviewRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i4.HomeScreen]
class HomeRoute extends _i18.PageRouteInfo<void> {
  const HomeRoute({List<_i18.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i5.MainSettingsScreen]
class MainSettingsRoute extends _i18.PageRouteInfo<void> {
  const MainSettingsRoute({List<_i18.PageRouteInfo>? children})
      : super(
          MainSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainSettingsRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i6.MarketplaceOverviewScreen]
class MarketplaceOverviewRoute extends _i18.PageRouteInfo<void> {
  const MarketplaceOverviewRoute({List<_i18.PageRouteInfo>? children})
      : super(
          MarketplaceOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'MarketplaceOverviewRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i7.MyFullscreenImagePage]
class MyFullscreenImageRoute
    extends _i18.PageRouteInfo<MyFullscreenImageRouteArgs> {
  MyFullscreenImageRoute({
    _i19.Key? key,
    required List<String> imagePaths,
    required int initialIndex,
    required bool isNetworkImage,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          MyFullscreenImageRoute.name,
          args: MyFullscreenImageRouteArgs(
            key: key,
            imagePaths: imagePaths,
            initialIndex: initialIndex,
            isNetworkImage: isNetworkImage,
          ),
          initialChildren: children,
        );

  static const String name = 'MyFullscreenImageRoute';

  static const _i18.PageInfo<MyFullscreenImageRouteArgs> page =
      _i18.PageInfo<MyFullscreenImageRouteArgs>(name);
}

class MyFullscreenImageRouteArgs {
  const MyFullscreenImageRouteArgs({
    this.key,
    required this.imagePaths,
    required this.initialIndex,
    required this.isNetworkImage,
  });

  final _i19.Key? key;

  final List<String> imagePaths;

  final int initialIndex;

  final bool isNetworkImage;

  @override
  String toString() {
    return 'MyFullscreenImageRouteArgs{key: $key, imagePaths: $imagePaths, initialIndex: $initialIndex, isNetworkImage: $isNetworkImage}';
  }
}

/// generated route for
/// [_i8.PaymentMethodScreen]
class PaymentMethodRoute extends _i18.PageRouteInfo<void> {
  const PaymentMethodRoute({List<_i18.PageRouteInfo>? children})
      : super(
          PaymentMethodRoute.name,
          initialChildren: children,
        );

  static const String name = 'PaymentMethodRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i9.ProductDetailScreen]
class ProductDetailRoute extends _i18.PageRouteInfo<ProductDetailRouteArgs> {
  ProductDetailRoute({
    _i19.Key? key,
    required _i22.ProductBloc productBloc,
    required _i9.ProductCreateOrEdit productCreateOrEdit,
    List<_i18.PageRouteInfo>? children,
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

  static const _i18.PageInfo<ProductDetailRouteArgs> page =
      _i18.PageInfo<ProductDetailRouteArgs>(name);
}

class ProductDetailRouteArgs {
  const ProductDetailRouteArgs({
    this.key,
    required this.productBloc,
    required this.productCreateOrEdit,
  });

  final _i19.Key? key;

  final _i22.ProductBloc productBloc;

  final _i9.ProductCreateOrEdit productCreateOrEdit;

  @override
  String toString() {
    return 'ProductDetailRouteArgs{key: $key, productBloc: $productBloc, productCreateOrEdit: $productCreateOrEdit}';
  }
}

/// generated route for
/// [_i10.ProductImportScreen]
class ProductImportRoute extends _i18.PageRouteInfo<void> {
  const ProductImportRoute({List<_i18.PageRouteInfo>? children})
      : super(
          ProductImportRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductImportRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i11.ProductsOverviewScreen]
class ProductsOverviewRoute extends _i18.PageRouteInfo<void> {
  const ProductsOverviewRoute({List<_i18.PageRouteInfo>? children})
      : super(
          ProductsOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductsOverviewRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i12.RegisterUserDataScreen]
class RegisterUserDataRoute extends _i18.PageRouteInfo<void> {
  const RegisterUserDataRoute({List<_i18.PageRouteInfo>? children})
      : super(
          RegisterUserDataRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterUserDataRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i13.ResetPasswordScreen]
class ResetPasswordRoute extends _i18.PageRouteInfo<void> {
  const ResetPasswordRoute({List<_i18.PageRouteInfo>? children})
      : super(
          ResetPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i14.SignInScreen]
class SignInRoute extends _i18.PageRouteInfo<void> {
  const SignInRoute({List<_i18.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i15.SignUpScreen]
class SignUpRoute extends _i18.PageRouteInfo<void> {
  const SignUpRoute({List<_i18.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i16.SplashPage]
class SplashRoute extends _i18.PageRouteInfo<SplashRouteArgs> {
  SplashRoute({
    _i19.Key? key,
    _i16.ComeFromToSplashPage? comeFrom,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          SplashRoute.name,
          args: SplashRouteArgs(
            key: key,
            comeFrom: comeFrom,
          ),
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i18.PageInfo<SplashRouteArgs> page =
      _i18.PageInfo<SplashRouteArgs>(name);
}

class SplashRouteArgs {
  const SplashRouteArgs({
    this.key,
    this.comeFrom,
  });

  final _i19.Key? key;

  final _i16.ComeFromToSplashPage? comeFrom;

  @override
  String toString() {
    return 'SplashRouteArgs{key: $key, comeFrom: $comeFrom}';
  }
}

/// generated route for
/// [_i17.TaxRulesScreen]
class TaxRulesRoute extends _i18.PageRouteInfo<void> {
  const TaxRulesRoute({List<_i18.PageRouteInfo>? children})
      : super(
          TaxRulesRoute.name,
          initialChildren: children,
        );

  static const String name = 'TaxRulesRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}
