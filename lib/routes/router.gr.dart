// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i22;
import 'package:cezeri_commerce/1_presentation/auth/register_user_data/register_user_data_screen.dart'
    as _i15;
import 'package:cezeri_commerce/1_presentation/auth/reset_password/reset_password_screen.dart'
    as _i16;
import 'package:cezeri_commerce/1_presentation/auth/sign_in/sign_in_screen.dart'
    as _i18;
import 'package:cezeri_commerce/1_presentation/auth/sign_up/sign_up_screen.dart'
    as _i19;
import 'package:cezeri_commerce/1_presentation/client/customer/customer_detail/customer_detail_screen.dart'
    as _i5;
import 'package:cezeri_commerce/1_presentation/client/customer/customer_overview/customers_overview_screen.dart'
    as _i6;
import 'package:cezeri_commerce/1_presentation/core/widgets/my_fullscreen_image_page.dart'
    as _i10;
import 'package:cezeri_commerce/1_presentation/e_commerce/marketplace_overview/marketplace_overview_screen.dart'
    as _i9;
import 'package:cezeri_commerce/1_presentation/e_commerce/product_import/product_import_screen.dart'
    as _i13;
import 'package:cezeri_commerce/1_presentation/home_screen.dart' as _i7;
import 'package:cezeri_commerce/1_presentation/product/product_detail/product_detail_screen.dart'
    as _i12;
import 'package:cezeri_commerce/1_presentation/product/products_overview/products_overview_screen.dart'
    as _i14;
import 'package:cezeri_commerce/1_presentation/receipt/appointment_detail/appointment_detail_screen.dart'
    as _i1;
import 'package:cezeri_commerce/1_presentation/receipt/appointments_overview/appointments_overview_screen.dart'
    as _i2;
import 'package:cezeri_commerce/1_presentation/settings/carrier/carrier_detail/carrier_detail_screen.dart'
    as _i3;
import 'package:cezeri_commerce/1_presentation/settings/carrier/carriers_overview/carriers_overview_screen.dart'
    as _i4;
import 'package:cezeri_commerce/1_presentation/settings/payment_method/payment_method_screen.dart'
    as _i11;
import 'package:cezeri_commerce/1_presentation/settings/settings/main_settings_screen.dart'
    as _i8;
import 'package:cezeri_commerce/1_presentation/settings/tax_rules/tax_rules_screen.dart'
    as _i21;
import 'package:cezeri_commerce/1_presentation/shipping_label/shipping_label_screen.dart'
    as _i17;
import 'package:cezeri_commerce/1_presentation/splash_page.dart' as _i20;
import 'package:cezeri_commerce/2_application/firebase/appointment/appointment_bloc.dart'
    as _i24;
import 'package:cezeri_commerce/2_application/firebase/customer/customer_bloc.dart'
    as _i26;
import 'package:cezeri_commerce/2_application/firebase/product/product_bloc.dart'
    as _i27;
import 'package:cezeri_commerce/3_domain/entities/marketplace/marketplace.dart'
    as _i25;
import 'package:flutter/material.dart' as _i23;

abstract class $AppRouter extends _i22.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i22.PageFactory> pagesMap = {
    AppointmentDetailRoute.name: (routeData) {
      final args = routeData.argsAs<AppointmentDetailRouteArgs>();
      return _i22.AutoRoutePage<dynamic>(
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
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AppointmentsOverviewScreen(),
      );
    },
    CarrierDetailRoute.name: (routeData) {
      final args = routeData.argsAs<CarrierDetailRouteArgs>();
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.CarrierDetailScreen(
          key: args.key,
          index: args.index,
        ),
      );
    },
    CarriersOverviewRoute.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.CarriersOverviewScreen(),
      );
    },
    CustomerDetailRoute.name: (routeData) {
      final args = routeData.argsAs<CustomerDetailRouteArgs>();
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.CustomerDetailScreen(
          key: args.key,
          customerBloc: args.customerBloc,
          customerCreateOrEdit: args.customerCreateOrEdit,
        ),
      );
    },
    CustomersOverviewRoute.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.CustomersOverviewScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.HomeScreen(),
      );
    },
    MainSettingsRoute.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.MainSettingsScreen(),
      );
    },
    MarketplaceOverviewRoute.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.MarketplaceOverviewScreen(),
      );
    },
    MyFullscreenImageRoute.name: (routeData) {
      final args = routeData.argsAs<MyFullscreenImageRouteArgs>();
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i10.MyFullscreenImagePage(
          key: args.key,
          imagePaths: args.imagePaths,
          initialIndex: args.initialIndex,
          isNetworkImage: args.isNetworkImage,
        ),
      );
    },
    PaymentMethodRoute.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.PaymentMethodScreen(),
      );
    },
    ProductDetailRoute.name: (routeData) {
      final args = routeData.argsAs<ProductDetailRouteArgs>();
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.ProductDetailScreen(
          key: args.key,
          productBloc: args.productBloc,
          productCreateOrEdit: args.productCreateOrEdit,
        ),
      );
    },
    ProductImportRoute.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.ProductImportScreen(),
      );
    },
    ProductsOverviewRoute.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.ProductsOverviewScreen(),
      );
    },
    RegisterUserDataRoute.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.RegisterUserDataScreen(),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.ResetPasswordScreen(),
      );
    },
    ShippingLabelRoute.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.ShippingLabelScreen(),
      );
    },
    SignInRoute.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i18.SignInScreen(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i19.SignUpScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      final args = routeData.argsAs<SplashRouteArgs>(
          orElse: () => const SplashRouteArgs());
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i20.SplashPage(
          key: args.key,
          comeFrom: args.comeFrom,
        ),
      );
    },
    TaxRulesRoute.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i21.TaxRulesScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.AppointmentDetailScreen]
class AppointmentDetailRoute
    extends _i22.PageRouteInfo<AppointmentDetailRouteArgs> {
  AppointmentDetailRoute({
    _i23.Key? key,
    required _i24.AppointmentBloc appointmentBloc,
    required List<_i25.Marketplace> listOfMarketplaces,
    required _i1.ReceiptCreateOrEdit receiptCreateOrEdit,
    List<_i22.PageRouteInfo>? children,
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

  static const _i22.PageInfo<AppointmentDetailRouteArgs> page =
      _i22.PageInfo<AppointmentDetailRouteArgs>(name);
}

class AppointmentDetailRouteArgs {
  const AppointmentDetailRouteArgs({
    this.key,
    required this.appointmentBloc,
    required this.listOfMarketplaces,
    required this.receiptCreateOrEdit,
  });

  final _i23.Key? key;

  final _i24.AppointmentBloc appointmentBloc;

  final List<_i25.Marketplace> listOfMarketplaces;

  final _i1.ReceiptCreateOrEdit receiptCreateOrEdit;

  @override
  String toString() {
    return 'AppointmentDetailRouteArgs{key: $key, appointmentBloc: $appointmentBloc, listOfMarketplaces: $listOfMarketplaces, receiptCreateOrEdit: $receiptCreateOrEdit}';
  }
}

/// generated route for
/// [_i2.AppointmentsOverviewScreen]
class AppointmentsOverviewRoute extends _i22.PageRouteInfo<void> {
  const AppointmentsOverviewRoute({List<_i22.PageRouteInfo>? children})
      : super(
          AppointmentsOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppointmentsOverviewRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i3.CarrierDetailScreen]
class CarrierDetailRoute extends _i22.PageRouteInfo<CarrierDetailRouteArgs> {
  CarrierDetailRoute({
    _i23.Key? key,
    required int index,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          CarrierDetailRoute.name,
          args: CarrierDetailRouteArgs(
            key: key,
            index: index,
          ),
          initialChildren: children,
        );

  static const String name = 'CarrierDetailRoute';

  static const _i22.PageInfo<CarrierDetailRouteArgs> page =
      _i22.PageInfo<CarrierDetailRouteArgs>(name);
}

class CarrierDetailRouteArgs {
  const CarrierDetailRouteArgs({
    this.key,
    required this.index,
  });

  final _i23.Key? key;

  final int index;

  @override
  String toString() {
    return 'CarrierDetailRouteArgs{key: $key, index: $index}';
  }
}

/// generated route for
/// [_i4.CarriersOverviewScreen]
class CarriersOverviewRoute extends _i22.PageRouteInfo<void> {
  const CarriersOverviewRoute({List<_i22.PageRouteInfo>? children})
      : super(
          CarriersOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'CarriersOverviewRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i5.CustomerDetailScreen]
class CustomerDetailRoute extends _i22.PageRouteInfo<CustomerDetailRouteArgs> {
  CustomerDetailRoute({
    _i23.Key? key,
    required _i26.CustomerBloc customerBloc,
    required _i5.CustomerCreateOrEdit customerCreateOrEdit,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          CustomerDetailRoute.name,
          args: CustomerDetailRouteArgs(
            key: key,
            customerBloc: customerBloc,
            customerCreateOrEdit: customerCreateOrEdit,
          ),
          initialChildren: children,
        );

  static const String name = 'CustomerDetailRoute';

  static const _i22.PageInfo<CustomerDetailRouteArgs> page =
      _i22.PageInfo<CustomerDetailRouteArgs>(name);
}

class CustomerDetailRouteArgs {
  const CustomerDetailRouteArgs({
    this.key,
    required this.customerBloc,
    required this.customerCreateOrEdit,
  });

  final _i23.Key? key;

  final _i26.CustomerBloc customerBloc;

  final _i5.CustomerCreateOrEdit customerCreateOrEdit;

  @override
  String toString() {
    return 'CustomerDetailRouteArgs{key: $key, customerBloc: $customerBloc, customerCreateOrEdit: $customerCreateOrEdit}';
  }
}

/// generated route for
/// [_i6.CustomersOverviewScreen]
class CustomersOverviewRoute extends _i22.PageRouteInfo<void> {
  const CustomersOverviewRoute({List<_i22.PageRouteInfo>? children})
      : super(
          CustomersOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'CustomersOverviewRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i7.HomeScreen]
class HomeRoute extends _i22.PageRouteInfo<void> {
  const HomeRoute({List<_i22.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i8.MainSettingsScreen]
class MainSettingsRoute extends _i22.PageRouteInfo<void> {
  const MainSettingsRoute({List<_i22.PageRouteInfo>? children})
      : super(
          MainSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainSettingsRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i9.MarketplaceOverviewScreen]
class MarketplaceOverviewRoute extends _i22.PageRouteInfo<void> {
  const MarketplaceOverviewRoute({List<_i22.PageRouteInfo>? children})
      : super(
          MarketplaceOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'MarketplaceOverviewRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i10.MyFullscreenImagePage]
class MyFullscreenImageRoute
    extends _i22.PageRouteInfo<MyFullscreenImageRouteArgs> {
  MyFullscreenImageRoute({
    _i23.Key? key,
    required List<String> imagePaths,
    required int initialIndex,
    required bool isNetworkImage,
    List<_i22.PageRouteInfo>? children,
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

  static const _i22.PageInfo<MyFullscreenImageRouteArgs> page =
      _i22.PageInfo<MyFullscreenImageRouteArgs>(name);
}

class MyFullscreenImageRouteArgs {
  const MyFullscreenImageRouteArgs({
    this.key,
    required this.imagePaths,
    required this.initialIndex,
    required this.isNetworkImage,
  });

  final _i23.Key? key;

  final List<String> imagePaths;

  final int initialIndex;

  final bool isNetworkImage;

  @override
  String toString() {
    return 'MyFullscreenImageRouteArgs{key: $key, imagePaths: $imagePaths, initialIndex: $initialIndex, isNetworkImage: $isNetworkImage}';
  }
}

/// generated route for
/// [_i11.PaymentMethodScreen]
class PaymentMethodRoute extends _i22.PageRouteInfo<void> {
  const PaymentMethodRoute({List<_i22.PageRouteInfo>? children})
      : super(
          PaymentMethodRoute.name,
          initialChildren: children,
        );

  static const String name = 'PaymentMethodRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i12.ProductDetailScreen]
class ProductDetailRoute extends _i22.PageRouteInfo<ProductDetailRouteArgs> {
  ProductDetailRoute({
    _i23.Key? key,
    required _i27.ProductBloc productBloc,
    required _i12.ProductCreateOrEdit productCreateOrEdit,
    List<_i22.PageRouteInfo>? children,
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

  static const _i22.PageInfo<ProductDetailRouteArgs> page =
      _i22.PageInfo<ProductDetailRouteArgs>(name);
}

class ProductDetailRouteArgs {
  const ProductDetailRouteArgs({
    this.key,
    required this.productBloc,
    required this.productCreateOrEdit,
  });

  final _i23.Key? key;

  final _i27.ProductBloc productBloc;

  final _i12.ProductCreateOrEdit productCreateOrEdit;

  @override
  String toString() {
    return 'ProductDetailRouteArgs{key: $key, productBloc: $productBloc, productCreateOrEdit: $productCreateOrEdit}';
  }
}

/// generated route for
/// [_i13.ProductImportScreen]
class ProductImportRoute extends _i22.PageRouteInfo<void> {
  const ProductImportRoute({List<_i22.PageRouteInfo>? children})
      : super(
          ProductImportRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductImportRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i14.ProductsOverviewScreen]
class ProductsOverviewRoute extends _i22.PageRouteInfo<void> {
  const ProductsOverviewRoute({List<_i22.PageRouteInfo>? children})
      : super(
          ProductsOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductsOverviewRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i15.RegisterUserDataScreen]
class RegisterUserDataRoute extends _i22.PageRouteInfo<void> {
  const RegisterUserDataRoute({List<_i22.PageRouteInfo>? children})
      : super(
          RegisterUserDataRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterUserDataRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i16.ResetPasswordScreen]
class ResetPasswordRoute extends _i22.PageRouteInfo<void> {
  const ResetPasswordRoute({List<_i22.PageRouteInfo>? children})
      : super(
          ResetPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i17.ShippingLabelScreen]
class ShippingLabelRoute extends _i22.PageRouteInfo<void> {
  const ShippingLabelRoute({List<_i22.PageRouteInfo>? children})
      : super(
          ShippingLabelRoute.name,
          initialChildren: children,
        );

  static const String name = 'ShippingLabelRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i18.SignInScreen]
class SignInRoute extends _i22.PageRouteInfo<void> {
  const SignInRoute({List<_i22.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i19.SignUpScreen]
class SignUpRoute extends _i22.PageRouteInfo<void> {
  const SignUpRoute({List<_i22.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i20.SplashPage]
class SplashRoute extends _i22.PageRouteInfo<SplashRouteArgs> {
  SplashRoute({
    _i23.Key? key,
    _i20.ComeFromToSplashPage? comeFrom,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          SplashRoute.name,
          args: SplashRouteArgs(
            key: key,
            comeFrom: comeFrom,
          ),
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i22.PageInfo<SplashRouteArgs> page =
      _i22.PageInfo<SplashRouteArgs>(name);
}

class SplashRouteArgs {
  const SplashRouteArgs({
    this.key,
    this.comeFrom,
  });

  final _i23.Key? key;

  final _i20.ComeFromToSplashPage? comeFrom;

  @override
  String toString() {
    return 'SplashRouteArgs{key: $key, comeFrom: $comeFrom}';
  }
}

/// generated route for
/// [_i21.TaxRulesScreen]
class TaxRulesRoute extends _i22.PageRouteInfo<void> {
  const TaxRulesRoute({List<_i22.PageRouteInfo>? children})
      : super(
          TaxRulesRoute.name,
          initialChildren: children,
        );

  static const String name = 'TaxRulesRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}
