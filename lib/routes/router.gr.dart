// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i38;
import 'package:cezeri_commerce/1_presentation/auth/register_user_data/register_user_data_screen.dart'
    as _i27;
import 'package:cezeri_commerce/1_presentation/auth/reset_password/reset_password_screen.dart'
    as _i30;
import 'package:cezeri_commerce/1_presentation/auth/sign_in/sign_in_screen.dart'
    as _i32;
import 'package:cezeri_commerce/1_presentation/auth/sign_up/sign_up_screen.dart'
    as _i33;
import 'package:cezeri_commerce/1_presentation/client/customer/customer_detail/customer_detail_screen.dart'
    as _i5;
import 'package:cezeri_commerce/1_presentation/client/customer/customer_overview/customers_overview_screen.dart'
    as _i6;
import 'package:cezeri_commerce/1_presentation/client/supplier/supplier_detail/supplier_detail_screen.dart'
    as _i35;
import 'package:cezeri_commerce/1_presentation/client/supplier/suppliers_overview/suppliers_overview_screen.dart'
    as _i36;
import 'package:cezeri_commerce/1_presentation/core/widgets/my_fullscreen_image_page.dart'
    as _i15;
import 'package:cezeri_commerce/1_presentation/dashboard/dashboard_screen.dart'
    as _i7;
import 'package:cezeri_commerce/1_presentation/e_commerce/e_mail_automation/e_mail_automation_screen.dart'
    as _i9;
import 'package:cezeri_commerce/1_presentation/e_commerce/marketplace_overview/marketplace_overview_screen.dart'
    as _i14;
import 'package:cezeri_commerce/1_presentation/e_commerce/product_import/product_import_screen.dart'
    as _i24;
import 'package:cezeri_commerce/1_presentation/general_ledger_account/general_ledger_account_screen.dart'
    as _i10;
import 'package:cezeri_commerce/1_presentation/home/home_screen.dart' as _i11;
import 'package:cezeri_commerce/1_presentation/packing_station/packing_station_detail/packing_station_detail_screen.dart'
    as _i18;
import 'package:cezeri_commerce/1_presentation/packing_station/packing_station_overview/packing_station_overview_screen.dart'
    as _i19;
import 'package:cezeri_commerce/1_presentation/packing_station/picklist/picklist_detail/picklist_detail_screen.dart'
    as _i21;
import 'package:cezeri_commerce/1_presentation/packing_station/picklist/picklist_overview/picklists_overview_screen.dart'
    as _i22;
import 'package:cezeri_commerce/1_presentation/product/product_detail/product_detail_screen.dart'
    as _i23;
import 'package:cezeri_commerce/1_presentation/product/products_overview/products_overview_screen.dart'
    as _i26;
import 'package:cezeri_commerce/1_presentation/products_booking/products_booking/products_booking_screen.dart'
    as _i25;
import 'package:cezeri_commerce/1_presentation/receipt/appointment_detail/appointment_detail_screen.dart'
    as _i1;
import 'package:cezeri_commerce/1_presentation/receipt/appointments_overview/appointments_overview_screen.dart'
    as _i2;
import 'package:cezeri_commerce/1_presentation/receipt/appointments_overview/delivery_notes_overview_screen.dart'
    as _i8;
import 'package:cezeri_commerce/1_presentation/receipt/appointments_overview/invoices_overview_screen.dart'
    as _i12;
import 'package:cezeri_commerce/1_presentation/receipt/appointments_overview/offers_overview_screen.dart'
    as _i16;
import 'package:cezeri_commerce/1_presentation/reorder/reorder_detail/reorder_detail_screen.dart'
    as _i28;
import 'package:cezeri_commerce/1_presentation/reorder/reorders_overview/reorders_overview_screen.dart'
    as _i29;
import 'package:cezeri_commerce/1_presentation/settings/carrier/carrier_detail/carrier_detail_screen.dart'
    as _i3;
import 'package:cezeri_commerce/1_presentation/settings/carrier/carriers_overview/carriers_overview_screen.dart'
    as _i4;
import 'package:cezeri_commerce/1_presentation/settings/packaging_box/packaging_box_screen.dart'
    as _i17;
import 'package:cezeri_commerce/1_presentation/settings/payment_method/payment_method_screen.dart'
    as _i20;
import 'package:cezeri_commerce/1_presentation/settings/settings/main_settings_screen.dart'
    as _i13;
import 'package:cezeri_commerce/1_presentation/settings/tax_rules/tax_rules_screen.dart'
    as _i37;
import 'package:cezeri_commerce/1_presentation/shipping_label/shipping_label_screen.dart'
    as _i31;
import 'package:cezeri_commerce/1_presentation/splash_page.dart' as _i34;
import 'package:cezeri_commerce/2_application/firebase/appointment/appointment_bloc.dart'
    as _i40;
import 'package:cezeri_commerce/2_application/firebase/customer/customer_bloc.dart'
    as _i43;
import 'package:cezeri_commerce/2_application/firebase/supplier/supplier_bloc.dart'
    as _i47;
import 'package:cezeri_commerce/2_application/packing_station/packing_station_bloc.dart'
    as _i44;
import 'package:cezeri_commerce/3_domain/entities/marketplace/marketplace.dart'
    as _i41;
import 'package:cezeri_commerce/3_domain/entities/product/product.dart' as _i45;
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt.dart' as _i42;
import 'package:cezeri_commerce/3_domain/entities/reorder/supplier.dart'
    as _i46;
import 'package:flutter/material.dart' as _i39;

abstract class $AppRouter extends _i38.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i38.PageFactory> pagesMap = {
    AppointmentDetailRoute.name: (routeData) {
      final args = routeData.argsAs<AppointmentDetailRouteArgs>();
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AppointmentDetailScreen(
          key: args.key,
          appointmentBloc: args.appointmentBloc,
          listOfMarketplaces: args.listOfMarketplaces,
          receiptCreateOrEdit: args.receiptCreateOrEdit,
          receiptTyp: args.receiptTyp,
        ),
      );
    },
    AppointmentsOverviewRoute.name: (routeData) {
      final args = routeData.argsAs<AppointmentsOverviewRouteArgs>();
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.AppointmentsOverviewScreen(
          key: args.key,
          receiptTyp: args.receiptTyp,
        ),
      );
    },
    CarrierDetailRoute.name: (routeData) {
      final args = routeData.argsAs<CarrierDetailRouteArgs>();
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.CarrierDetailScreen(
          key: args.key,
          index: args.index,
        ),
      );
    },
    CarriersOverviewRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.CarriersOverviewScreen(),
      );
    },
    CustomerDetailRoute.name: (routeData) {
      final args = routeData.argsAs<CustomerDetailRouteArgs>();
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.CustomerDetailScreen(
          key: args.key,
          customerBloc: args.customerBloc,
          customerCreateOrEdit: args.customerCreateOrEdit,
        ),
      );
    },
    CustomersOverviewRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.CustomersOverviewScreen(),
      );
    },
    DashboardRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.DashboardScreen(),
      );
    },
    DeliveryNotesOverviewRoute.name: (routeData) {
      final args = routeData.argsAs<DeliveryNotesOverviewRouteArgs>();
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.DeliveryNotesOverviewScreen(
          key: args.key,
          receiptTyp: args.receiptTyp,
        ),
      );
    },
    EMailAutomationRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.EMailAutomationScreen(),
      );
    },
    GeneralLedgerAccountRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.GeneralLedgerAccountScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.HomeScreen(),
      );
    },
    InvoicesOverviewRoute.name: (routeData) {
      final args = routeData.argsAs<InvoicesOverviewRouteArgs>();
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.InvoicesOverviewScreen(
          key: args.key,
          receiptTyp: args.receiptTyp,
        ),
      );
    },
    MainSettingsRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.MainSettingsScreen(),
      );
    },
    MarketplaceOverviewRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.MarketplaceOverviewScreen(),
      );
    },
    MyFullscreenImageRoute.name: (routeData) {
      final args = routeData.argsAs<MyFullscreenImageRouteArgs>();
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.MyFullscreenImagePage(
          key: args.key,
          imagePaths: args.imagePaths,
          initialIndex: args.initialIndex,
          isNetworkImage: args.isNetworkImage,
        ),
      );
    },
    OffersOverviewRoute.name: (routeData) {
      final args = routeData.argsAs<OffersOverviewRouteArgs>();
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i16.OffersOverviewScreen(
          key: args.key,
          receiptTyp: args.receiptTyp,
        ),
      );
    },
    PackagingBoxesRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.PackagingBoxesScreen(),
      );
    },
    PackingStationDetailRoute.name: (routeData) {
      final args = routeData.argsAs<PackingStationDetailRouteArgs>();
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i18.PackingStationDetailScreen(
          key: args.key,
          packingStationBloc: args.packingStationBloc,
          marketplace: args.marketplace,
        ),
      );
    },
    PackingStationOverviewRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i19.PackingStationOverviewScreen(),
      );
    },
    PaymentMethodRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i20.PaymentMethodScreen(),
      );
    },
    PicklistDetailRoute.name: (routeData) {
      final args = routeData.argsAs<PicklistDetailRouteArgs>();
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i21.PicklistDetailScreen(
          key: args.key,
          packingStationBloc: args.packingStationBloc,
        ),
      );
    },
    PicklistsOverviewRoute.name: (routeData) {
      final args = routeData.argsAs<PicklistsOverviewRouteArgs>();
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i22.PicklistsOverviewScreen(
          key: args.key,
          packingStationBloc: args.packingStationBloc,
        ),
      );
    },
    ProductDetailRoute.name: (routeData) {
      final args = routeData.argsAs<ProductDetailRouteArgs>();
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i23.ProductDetailScreen(
          key: args.key,
          productId: args.productId,
          listOfProducts: args.listOfProducts,
        ),
      );
    },
    ProductImportRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i24.ProductImportScreen(),
      );
    },
    ProductsBookingRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i25.ProductsBookingScreen(),
      );
    },
    ProductsOverviewRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i26.ProductsOverviewScreen(),
      );
    },
    RegisterUserDataRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i27.RegisterUserDataScreen(),
      );
    },
    ReorderDetailRoute.name: (routeData) {
      final args = routeData.argsAs<ReorderDetailRouteArgs>();
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i28.ReorderDetailScreen(
          key: args.key,
          reorderCreateOrEdit: args.reorderCreateOrEdit,
          supplier: args.supplier,
          reorderId: args.reorderId,
        ),
      );
    },
    ReordersOverviewRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i29.ReordersOverviewScreen(),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i30.ResetPasswordScreen(),
      );
    },
    ShippingLabelRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i31.ShippingLabelScreen(),
      );
    },
    SignInRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i32.SignInScreen(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i33.SignUpScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      final args = routeData.argsAs<SplashRouteArgs>(
          orElse: () => const SplashRouteArgs());
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i34.SplashPage(
          key: args.key,
          comeFrom: args.comeFrom,
        ),
      );
    },
    SupplierDetailRoute.name: (routeData) {
      final args = routeData.argsAs<SupplierDetailRouteArgs>();
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i35.SupplierDetailScreen(
          key: args.key,
          supplierBloc: args.supplierBloc,
          supplierCreateOrEdit: args.supplierCreateOrEdit,
        ),
      );
    },
    SuppliersOverviewRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i36.SuppliersOverviewScreen(),
      );
    },
    TaxRulesRoute.name: (routeData) {
      return _i38.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i37.TaxRulesScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.AppointmentDetailScreen]
class AppointmentDetailRoute
    extends _i38.PageRouteInfo<AppointmentDetailRouteArgs> {
  AppointmentDetailRoute({
    _i39.Key? key,
    required _i40.AppointmentBloc appointmentBloc,
    required List<_i41.Marketplace> listOfMarketplaces,
    required _i1.ReceiptCreateOrEdit receiptCreateOrEdit,
    required _i42.ReceiptTyp receiptTyp,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          AppointmentDetailRoute.name,
          args: AppointmentDetailRouteArgs(
            key: key,
            appointmentBloc: appointmentBloc,
            listOfMarketplaces: listOfMarketplaces,
            receiptCreateOrEdit: receiptCreateOrEdit,
            receiptTyp: receiptTyp,
          ),
          initialChildren: children,
        );

  static const String name = 'AppointmentDetailRoute';

  static const _i38.PageInfo<AppointmentDetailRouteArgs> page =
      _i38.PageInfo<AppointmentDetailRouteArgs>(name);
}

class AppointmentDetailRouteArgs {
  const AppointmentDetailRouteArgs({
    this.key,
    required this.appointmentBloc,
    required this.listOfMarketplaces,
    required this.receiptCreateOrEdit,
    required this.receiptTyp,
  });

  final _i39.Key? key;

  final _i40.AppointmentBloc appointmentBloc;

  final List<_i41.Marketplace> listOfMarketplaces;

  final _i1.ReceiptCreateOrEdit receiptCreateOrEdit;

  final _i42.ReceiptTyp receiptTyp;

  @override
  String toString() {
    return 'AppointmentDetailRouteArgs{key: $key, appointmentBloc: $appointmentBloc, listOfMarketplaces: $listOfMarketplaces, receiptCreateOrEdit: $receiptCreateOrEdit, receiptTyp: $receiptTyp}';
  }
}

/// generated route for
/// [_i2.AppointmentsOverviewScreen]
class AppointmentsOverviewRoute
    extends _i38.PageRouteInfo<AppointmentsOverviewRouteArgs> {
  AppointmentsOverviewRoute({
    _i39.Key? key,
    required _i42.ReceiptTyp receiptTyp,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          AppointmentsOverviewRoute.name,
          args: AppointmentsOverviewRouteArgs(
            key: key,
            receiptTyp: receiptTyp,
          ),
          initialChildren: children,
        );

  static const String name = 'AppointmentsOverviewRoute';

  static const _i38.PageInfo<AppointmentsOverviewRouteArgs> page =
      _i38.PageInfo<AppointmentsOverviewRouteArgs>(name);
}

class AppointmentsOverviewRouteArgs {
  const AppointmentsOverviewRouteArgs({
    this.key,
    required this.receiptTyp,
  });

  final _i39.Key? key;

  final _i42.ReceiptTyp receiptTyp;

  @override
  String toString() {
    return 'AppointmentsOverviewRouteArgs{key: $key, receiptTyp: $receiptTyp}';
  }
}

/// generated route for
/// [_i3.CarrierDetailScreen]
class CarrierDetailRoute extends _i38.PageRouteInfo<CarrierDetailRouteArgs> {
  CarrierDetailRoute({
    _i39.Key? key,
    required int index,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          CarrierDetailRoute.name,
          args: CarrierDetailRouteArgs(
            key: key,
            index: index,
          ),
          initialChildren: children,
        );

  static const String name = 'CarrierDetailRoute';

  static const _i38.PageInfo<CarrierDetailRouteArgs> page =
      _i38.PageInfo<CarrierDetailRouteArgs>(name);
}

class CarrierDetailRouteArgs {
  const CarrierDetailRouteArgs({
    this.key,
    required this.index,
  });

  final _i39.Key? key;

  final int index;

  @override
  String toString() {
    return 'CarrierDetailRouteArgs{key: $key, index: $index}';
  }
}

/// generated route for
/// [_i4.CarriersOverviewScreen]
class CarriersOverviewRoute extends _i38.PageRouteInfo<void> {
  const CarriersOverviewRoute({List<_i38.PageRouteInfo>? children})
      : super(
          CarriersOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'CarriersOverviewRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i5.CustomerDetailScreen]
class CustomerDetailRoute extends _i38.PageRouteInfo<CustomerDetailRouteArgs> {
  CustomerDetailRoute({
    _i39.Key? key,
    required _i43.CustomerBloc customerBloc,
    required _i5.CustomerCreateOrEdit customerCreateOrEdit,
    List<_i38.PageRouteInfo>? children,
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

  static const _i38.PageInfo<CustomerDetailRouteArgs> page =
      _i38.PageInfo<CustomerDetailRouteArgs>(name);
}

class CustomerDetailRouteArgs {
  const CustomerDetailRouteArgs({
    this.key,
    required this.customerBloc,
    required this.customerCreateOrEdit,
  });

  final _i39.Key? key;

  final _i43.CustomerBloc customerBloc;

  final _i5.CustomerCreateOrEdit customerCreateOrEdit;

  @override
  String toString() {
    return 'CustomerDetailRouteArgs{key: $key, customerBloc: $customerBloc, customerCreateOrEdit: $customerCreateOrEdit}';
  }
}

/// generated route for
/// [_i6.CustomersOverviewScreen]
class CustomersOverviewRoute extends _i38.PageRouteInfo<void> {
  const CustomersOverviewRoute({List<_i38.PageRouteInfo>? children})
      : super(
          CustomersOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'CustomersOverviewRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i7.DashboardScreen]
class DashboardRoute extends _i38.PageRouteInfo<void> {
  const DashboardRoute({List<_i38.PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i8.DeliveryNotesOverviewScreen]
class DeliveryNotesOverviewRoute
    extends _i38.PageRouteInfo<DeliveryNotesOverviewRouteArgs> {
  DeliveryNotesOverviewRoute({
    _i39.Key? key,
    required _i42.ReceiptTyp receiptTyp,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          DeliveryNotesOverviewRoute.name,
          args: DeliveryNotesOverviewRouteArgs(
            key: key,
            receiptTyp: receiptTyp,
          ),
          initialChildren: children,
        );

  static const String name = 'DeliveryNotesOverviewRoute';

  static const _i38.PageInfo<DeliveryNotesOverviewRouteArgs> page =
      _i38.PageInfo<DeliveryNotesOverviewRouteArgs>(name);
}

class DeliveryNotesOverviewRouteArgs {
  const DeliveryNotesOverviewRouteArgs({
    this.key,
    required this.receiptTyp,
  });

  final _i39.Key? key;

  final _i42.ReceiptTyp receiptTyp;

  @override
  String toString() {
    return 'DeliveryNotesOverviewRouteArgs{key: $key, receiptTyp: $receiptTyp}';
  }
}

/// generated route for
/// [_i9.EMailAutomationScreen]
class EMailAutomationRoute extends _i38.PageRouteInfo<void> {
  const EMailAutomationRoute({List<_i38.PageRouteInfo>? children})
      : super(
          EMailAutomationRoute.name,
          initialChildren: children,
        );

  static const String name = 'EMailAutomationRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i10.GeneralLedgerAccountScreen]
class GeneralLedgerAccountRoute extends _i38.PageRouteInfo<void> {
  const GeneralLedgerAccountRoute({List<_i38.PageRouteInfo>? children})
      : super(
          GeneralLedgerAccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'GeneralLedgerAccountRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i11.HomeScreen]
class HomeRoute extends _i38.PageRouteInfo<void> {
  const HomeRoute({List<_i38.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i12.InvoicesOverviewScreen]
class InvoicesOverviewRoute
    extends _i38.PageRouteInfo<InvoicesOverviewRouteArgs> {
  InvoicesOverviewRoute({
    _i39.Key? key,
    required _i42.ReceiptTyp receiptTyp,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          InvoicesOverviewRoute.name,
          args: InvoicesOverviewRouteArgs(
            key: key,
            receiptTyp: receiptTyp,
          ),
          initialChildren: children,
        );

  static const String name = 'InvoicesOverviewRoute';

  static const _i38.PageInfo<InvoicesOverviewRouteArgs> page =
      _i38.PageInfo<InvoicesOverviewRouteArgs>(name);
}

class InvoicesOverviewRouteArgs {
  const InvoicesOverviewRouteArgs({
    this.key,
    required this.receiptTyp,
  });

  final _i39.Key? key;

  final _i42.ReceiptTyp receiptTyp;

  @override
  String toString() {
    return 'InvoicesOverviewRouteArgs{key: $key, receiptTyp: $receiptTyp}';
  }
}

/// generated route for
/// [_i13.MainSettingsScreen]
class MainSettingsRoute extends _i38.PageRouteInfo<void> {
  const MainSettingsRoute({List<_i38.PageRouteInfo>? children})
      : super(
          MainSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainSettingsRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i14.MarketplaceOverviewScreen]
class MarketplaceOverviewRoute extends _i38.PageRouteInfo<void> {
  const MarketplaceOverviewRoute({List<_i38.PageRouteInfo>? children})
      : super(
          MarketplaceOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'MarketplaceOverviewRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i15.MyFullscreenImagePage]
class MyFullscreenImageRoute
    extends _i38.PageRouteInfo<MyFullscreenImageRouteArgs> {
  MyFullscreenImageRoute({
    _i39.Key? key,
    required List<String> imagePaths,
    required int initialIndex,
    required bool isNetworkImage,
    List<_i38.PageRouteInfo>? children,
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

  static const _i38.PageInfo<MyFullscreenImageRouteArgs> page =
      _i38.PageInfo<MyFullscreenImageRouteArgs>(name);
}

class MyFullscreenImageRouteArgs {
  const MyFullscreenImageRouteArgs({
    this.key,
    required this.imagePaths,
    required this.initialIndex,
    required this.isNetworkImage,
  });

  final _i39.Key? key;

  final List<String> imagePaths;

  final int initialIndex;

  final bool isNetworkImage;

  @override
  String toString() {
    return 'MyFullscreenImageRouteArgs{key: $key, imagePaths: $imagePaths, initialIndex: $initialIndex, isNetworkImage: $isNetworkImage}';
  }
}

/// generated route for
/// [_i16.OffersOverviewScreen]
class OffersOverviewRoute extends _i38.PageRouteInfo<OffersOverviewRouteArgs> {
  OffersOverviewRoute({
    _i39.Key? key,
    required _i42.ReceiptTyp receiptTyp,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          OffersOverviewRoute.name,
          args: OffersOverviewRouteArgs(
            key: key,
            receiptTyp: receiptTyp,
          ),
          initialChildren: children,
        );

  static const String name = 'OffersOverviewRoute';

  static const _i38.PageInfo<OffersOverviewRouteArgs> page =
      _i38.PageInfo<OffersOverviewRouteArgs>(name);
}

class OffersOverviewRouteArgs {
  const OffersOverviewRouteArgs({
    this.key,
    required this.receiptTyp,
  });

  final _i39.Key? key;

  final _i42.ReceiptTyp receiptTyp;

  @override
  String toString() {
    return 'OffersOverviewRouteArgs{key: $key, receiptTyp: $receiptTyp}';
  }
}

/// generated route for
/// [_i17.PackagingBoxesScreen]
class PackagingBoxesRoute extends _i38.PageRouteInfo<void> {
  const PackagingBoxesRoute({List<_i38.PageRouteInfo>? children})
      : super(
          PackagingBoxesRoute.name,
          initialChildren: children,
        );

  static const String name = 'PackagingBoxesRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i18.PackingStationDetailScreen]
class PackingStationDetailRoute
    extends _i38.PageRouteInfo<PackingStationDetailRouteArgs> {
  PackingStationDetailRoute({
    _i39.Key? key,
    required _i44.PackingStationBloc packingStationBloc,
    required _i41.Marketplace marketplace,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          PackingStationDetailRoute.name,
          args: PackingStationDetailRouteArgs(
            key: key,
            packingStationBloc: packingStationBloc,
            marketplace: marketplace,
          ),
          initialChildren: children,
        );

  static const String name = 'PackingStationDetailRoute';

  static const _i38.PageInfo<PackingStationDetailRouteArgs> page =
      _i38.PageInfo<PackingStationDetailRouteArgs>(name);
}

class PackingStationDetailRouteArgs {
  const PackingStationDetailRouteArgs({
    this.key,
    required this.packingStationBloc,
    required this.marketplace,
  });

  final _i39.Key? key;

  final _i44.PackingStationBloc packingStationBloc;

  final _i41.Marketplace marketplace;

  @override
  String toString() {
    return 'PackingStationDetailRouteArgs{key: $key, packingStationBloc: $packingStationBloc, marketplace: $marketplace}';
  }
}

/// generated route for
/// [_i19.PackingStationOverviewScreen]
class PackingStationOverviewRoute extends _i38.PageRouteInfo<void> {
  const PackingStationOverviewRoute({List<_i38.PageRouteInfo>? children})
      : super(
          PackingStationOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'PackingStationOverviewRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i20.PaymentMethodScreen]
class PaymentMethodRoute extends _i38.PageRouteInfo<void> {
  const PaymentMethodRoute({List<_i38.PageRouteInfo>? children})
      : super(
          PaymentMethodRoute.name,
          initialChildren: children,
        );

  static const String name = 'PaymentMethodRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i21.PicklistDetailScreen]
class PicklistDetailRoute extends _i38.PageRouteInfo<PicklistDetailRouteArgs> {
  PicklistDetailRoute({
    _i39.Key? key,
    required _i44.PackingStationBloc packingStationBloc,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          PicklistDetailRoute.name,
          args: PicklistDetailRouteArgs(
            key: key,
            packingStationBloc: packingStationBloc,
          ),
          initialChildren: children,
        );

  static const String name = 'PicklistDetailRoute';

  static const _i38.PageInfo<PicklistDetailRouteArgs> page =
      _i38.PageInfo<PicklistDetailRouteArgs>(name);
}

class PicklistDetailRouteArgs {
  const PicklistDetailRouteArgs({
    this.key,
    required this.packingStationBloc,
  });

  final _i39.Key? key;

  final _i44.PackingStationBloc packingStationBloc;

  @override
  String toString() {
    return 'PicklistDetailRouteArgs{key: $key, packingStationBloc: $packingStationBloc}';
  }
}

/// generated route for
/// [_i22.PicklistsOverviewScreen]
class PicklistsOverviewRoute
    extends _i38.PageRouteInfo<PicklistsOverviewRouteArgs> {
  PicklistsOverviewRoute({
    _i39.Key? key,
    required _i44.PackingStationBloc packingStationBloc,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          PicklistsOverviewRoute.name,
          args: PicklistsOverviewRouteArgs(
            key: key,
            packingStationBloc: packingStationBloc,
          ),
          initialChildren: children,
        );

  static const String name = 'PicklistsOverviewRoute';

  static const _i38.PageInfo<PicklistsOverviewRouteArgs> page =
      _i38.PageInfo<PicklistsOverviewRouteArgs>(name);
}

class PicklistsOverviewRouteArgs {
  const PicklistsOverviewRouteArgs({
    this.key,
    required this.packingStationBloc,
  });

  final _i39.Key? key;

  final _i44.PackingStationBloc packingStationBloc;

  @override
  String toString() {
    return 'PicklistsOverviewRouteArgs{key: $key, packingStationBloc: $packingStationBloc}';
  }
}

/// generated route for
/// [_i23.ProductDetailScreen]
class ProductDetailRoute extends _i38.PageRouteInfo<ProductDetailRouteArgs> {
  ProductDetailRoute({
    _i39.Key? key,
    String? productId,
    required List<_i45.Product> listOfProducts,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          ProductDetailRoute.name,
          args: ProductDetailRouteArgs(
            key: key,
            productId: productId,
            listOfProducts: listOfProducts,
          ),
          initialChildren: children,
        );

  static const String name = 'ProductDetailRoute';

  static const _i38.PageInfo<ProductDetailRouteArgs> page =
      _i38.PageInfo<ProductDetailRouteArgs>(name);
}

class ProductDetailRouteArgs {
  const ProductDetailRouteArgs({
    this.key,
    this.productId,
    required this.listOfProducts,
  });

  final _i39.Key? key;

  final String? productId;

  final List<_i45.Product> listOfProducts;

  @override
  String toString() {
    return 'ProductDetailRouteArgs{key: $key, productId: $productId, listOfProducts: $listOfProducts}';
  }
}

/// generated route for
/// [_i24.ProductImportScreen]
class ProductImportRoute extends _i38.PageRouteInfo<void> {
  const ProductImportRoute({List<_i38.PageRouteInfo>? children})
      : super(
          ProductImportRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductImportRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i25.ProductsBookingScreen]
class ProductsBookingRoute extends _i38.PageRouteInfo<void> {
  const ProductsBookingRoute({List<_i38.PageRouteInfo>? children})
      : super(
          ProductsBookingRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductsBookingRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i26.ProductsOverviewScreen]
class ProductsOverviewRoute extends _i38.PageRouteInfo<void> {
  const ProductsOverviewRoute({List<_i38.PageRouteInfo>? children})
      : super(
          ProductsOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductsOverviewRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i27.RegisterUserDataScreen]
class RegisterUserDataRoute extends _i38.PageRouteInfo<void> {
  const RegisterUserDataRoute({List<_i38.PageRouteInfo>? children})
      : super(
          RegisterUserDataRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterUserDataRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i28.ReorderDetailScreen]
class ReorderDetailRoute extends _i38.PageRouteInfo<ReorderDetailRouteArgs> {
  ReorderDetailRoute({
    _i39.Key? key,
    required _i28.ReorderCreateOrEdit reorderCreateOrEdit,
    _i46.Supplier? supplier,
    String? reorderId,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          ReorderDetailRoute.name,
          args: ReorderDetailRouteArgs(
            key: key,
            reorderCreateOrEdit: reorderCreateOrEdit,
            supplier: supplier,
            reorderId: reorderId,
          ),
          initialChildren: children,
        );

  static const String name = 'ReorderDetailRoute';

  static const _i38.PageInfo<ReorderDetailRouteArgs> page =
      _i38.PageInfo<ReorderDetailRouteArgs>(name);
}

class ReorderDetailRouteArgs {
  const ReorderDetailRouteArgs({
    this.key,
    required this.reorderCreateOrEdit,
    this.supplier,
    this.reorderId,
  });

  final _i39.Key? key;

  final _i28.ReorderCreateOrEdit reorderCreateOrEdit;

  final _i46.Supplier? supplier;

  final String? reorderId;

  @override
  String toString() {
    return 'ReorderDetailRouteArgs{key: $key, reorderCreateOrEdit: $reorderCreateOrEdit, supplier: $supplier, reorderId: $reorderId}';
  }
}

/// generated route for
/// [_i29.ReordersOverviewScreen]
class ReordersOverviewRoute extends _i38.PageRouteInfo<void> {
  const ReordersOverviewRoute({List<_i38.PageRouteInfo>? children})
      : super(
          ReordersOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReordersOverviewRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i30.ResetPasswordScreen]
class ResetPasswordRoute extends _i38.PageRouteInfo<void> {
  const ResetPasswordRoute({List<_i38.PageRouteInfo>? children})
      : super(
          ResetPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i31.ShippingLabelScreen]
class ShippingLabelRoute extends _i38.PageRouteInfo<void> {
  const ShippingLabelRoute({List<_i38.PageRouteInfo>? children})
      : super(
          ShippingLabelRoute.name,
          initialChildren: children,
        );

  static const String name = 'ShippingLabelRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i32.SignInScreen]
class SignInRoute extends _i38.PageRouteInfo<void> {
  const SignInRoute({List<_i38.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i33.SignUpScreen]
class SignUpRoute extends _i38.PageRouteInfo<void> {
  const SignUpRoute({List<_i38.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i34.SplashPage]
class SplashRoute extends _i38.PageRouteInfo<SplashRouteArgs> {
  SplashRoute({
    _i39.Key? key,
    _i34.ComeFromToSplashPage? comeFrom,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          SplashRoute.name,
          args: SplashRouteArgs(
            key: key,
            comeFrom: comeFrom,
          ),
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i38.PageInfo<SplashRouteArgs> page =
      _i38.PageInfo<SplashRouteArgs>(name);
}

class SplashRouteArgs {
  const SplashRouteArgs({
    this.key,
    this.comeFrom,
  });

  final _i39.Key? key;

  final _i34.ComeFromToSplashPage? comeFrom;

  @override
  String toString() {
    return 'SplashRouteArgs{key: $key, comeFrom: $comeFrom}';
  }
}

/// generated route for
/// [_i35.SupplierDetailScreen]
class SupplierDetailRoute extends _i38.PageRouteInfo<SupplierDetailRouteArgs> {
  SupplierDetailRoute({
    _i39.Key? key,
    required _i47.SupplierBloc supplierBloc,
    required _i35.SupplierCreateOrEdit supplierCreateOrEdit,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          SupplierDetailRoute.name,
          args: SupplierDetailRouteArgs(
            key: key,
            supplierBloc: supplierBloc,
            supplierCreateOrEdit: supplierCreateOrEdit,
          ),
          initialChildren: children,
        );

  static const String name = 'SupplierDetailRoute';

  static const _i38.PageInfo<SupplierDetailRouteArgs> page =
      _i38.PageInfo<SupplierDetailRouteArgs>(name);
}

class SupplierDetailRouteArgs {
  const SupplierDetailRouteArgs({
    this.key,
    required this.supplierBloc,
    required this.supplierCreateOrEdit,
  });

  final _i39.Key? key;

  final _i47.SupplierBloc supplierBloc;

  final _i35.SupplierCreateOrEdit supplierCreateOrEdit;

  @override
  String toString() {
    return 'SupplierDetailRouteArgs{key: $key, supplierBloc: $supplierBloc, supplierCreateOrEdit: $supplierCreateOrEdit}';
  }
}

/// generated route for
/// [_i36.SuppliersOverviewScreen]
class SuppliersOverviewRoute extends _i38.PageRouteInfo<void> {
  const SuppliersOverviewRoute({List<_i38.PageRouteInfo>? children})
      : super(
          SuppliersOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'SuppliersOverviewRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}

/// generated route for
/// [_i37.TaxRulesScreen]
class TaxRulesRoute extends _i38.PageRouteInfo<void> {
  const TaxRulesRoute({List<_i38.PageRouteInfo>? children})
      : super(
          TaxRulesRoute.name,
          initialChildren: children,
        );

  static const String name = 'TaxRulesRoute';

  static const _i38.PageInfo<void> page = _i38.PageInfo<void>(name);
}
