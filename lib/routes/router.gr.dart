// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i42;
import 'package:cezeri_commerce/1_presentation/auth/register_user_data/register_user_data_screen.dart'
    as _i31;
import 'package:cezeri_commerce/1_presentation/auth/reset_password/reset_password_screen.dart'
    as _i34;
import 'package:cezeri_commerce/1_presentation/auth/sign_in/sign_in_screen.dart'
    as _i36;
import 'package:cezeri_commerce/1_presentation/auth/sign_up/sign_up_screen.dart'
    as _i37;
import 'package:cezeri_commerce/1_presentation/client/customer/customer_detail/customer_detail_screen.dart'
    as _i4;
import 'package:cezeri_commerce/1_presentation/client/customer/customer_overview/customers_overview_screen.dart'
    as _i5;
import 'package:cezeri_commerce/1_presentation/client/supplier/supplier_detail/supplier_detail_screen.dart'
    as _i39;
import 'package:cezeri_commerce/1_presentation/client/supplier/suppliers_overview/suppliers_overview_screen.dart'
    as _i40;
import 'package:cezeri_commerce/1_presentation/core/widgets/my_fullscreen_image_page.dart'
    as _i14;
import 'package:cezeri_commerce/1_presentation/dashboard/dashboard_screen.dart'
    as _i6;
import 'package:cezeri_commerce/1_presentation/e_commerce/e_mail_automation/e_mail_automation_screen.dart'
    as _i8;
import 'package:cezeri_commerce/1_presentation/e_commerce/marketplace_overview/marketplaces_overview_screen.dart'
    as _i13;
import 'package:cezeri_commerce/1_presentation/e_commerce/product_export/product_export_screen.dart'
    as _i26;
import 'package:cezeri_commerce/1_presentation/e_commerce/product_import/product_import_screen.dart'
    as _i27;
import 'package:cezeri_commerce/1_presentation/general_ledger_account/general_ledger_account_screen.dart'
    as _i9;
import 'package:cezeri_commerce/1_presentation/home/home_screen.dart' as _i10;
import 'package:cezeri_commerce/1_presentation/packing_station/packing_station_detail/packing_station_detail_screen.dart'
    as _i17;
import 'package:cezeri_commerce/1_presentation/packing_station/packing_station_overview/packing_station_overview_screen.dart'
    as _i18;
import 'package:cezeri_commerce/1_presentation/packing_station/picklist/picklist_detail/picklist_detail_screen.dart'
    as _i20;
import 'package:cezeri_commerce/1_presentation/packing_station/picklist/picklist_overview/picklists_overview_screen.dart'
    as _i21;
import 'package:cezeri_commerce/1_presentation/pos/pos_detail/pos_detail_screen.dart'
    as _i22;
import 'package:cezeri_commerce/1_presentation/pos/pos_overview_screen.dart'
    as _i23;
import 'package:cezeri_commerce/1_presentation/product/product_detail/product_detail_screen.dart'
    as _i25;
import 'package:cezeri_commerce/1_presentation/product/product_detail/widgets/product_description_page.dart'
    as _i24;
import 'package:cezeri_commerce/1_presentation/product/products_overview/products_overview_screen.dart'
    as _i29;
import 'package:cezeri_commerce/1_presentation/products_booking/products_booking/products_booking_screen.dart'
    as _i28;
import 'package:cezeri_commerce/1_presentation/receipt/receipt_detail/receipt_detail_screen.dart'
    as _i30;
import 'package:cezeri_commerce/1_presentation/receipt/receipts_overview/appointments_overview_screen.dart'
    as _i1;
import 'package:cezeri_commerce/1_presentation/receipt/receipts_overview/delivery_notes_overview_screen.dart'
    as _i7;
import 'package:cezeri_commerce/1_presentation/receipt/receipts_overview/invoices_overview_screen.dart'
    as _i11;
import 'package:cezeri_commerce/1_presentation/receipt/receipts_overview/offers_overview_screen.dart'
    as _i15;
import 'package:cezeri_commerce/1_presentation/reorder/reorder_detail/reorder_detail_screen.dart'
    as _i32;
import 'package:cezeri_commerce/1_presentation/reorder/reorders_overview/reorders_overview_screen.dart'
    as _i33;
import 'package:cezeri_commerce/1_presentation/settings/carrier/carrier_detail/carrier_detail_screen.dart'
    as _i2;
import 'package:cezeri_commerce/1_presentation/settings/carrier/carriers_overview/carriers_overview_screen.dart'
    as _i3;
import 'package:cezeri_commerce/1_presentation/settings/packaging_box/packaging_box_screen.dart'
    as _i16;
import 'package:cezeri_commerce/1_presentation/settings/payment_method/payment_method_screen.dart'
    as _i19;
import 'package:cezeri_commerce/1_presentation/settings/settings/main_settings_screen.dart'
    as _i12;
import 'package:cezeri_commerce/1_presentation/settings/tax_rules/tax_rules_screen.dart'
    as _i41;
import 'package:cezeri_commerce/1_presentation/shipping_label/shipping_label_screen.dart'
    as _i35;
import 'package:cezeri_commerce/1_presentation/splash_page.dart' as _i38;
import 'package:cezeri_commerce/2_application/database/product_detail/product_detail_bloc.dart'
    as _i49;
import 'package:cezeri_commerce/2_application/database/supplier/supplier_bloc.dart'
    as _i51;
import 'package:cezeri_commerce/2_application/packing_station/packing_station_bloc.dart'
    as _i45;
import 'package:cezeri_commerce/3_domain/entities/customer/customer.dart'
    as _i48;
import 'package:cezeri_commerce/3_domain/entities/marketplace/abstract_marketplace.dart'
    as _i46;
import 'package:cezeri_commerce/3_domain/entities/marketplace/marketplace_shop.dart'
    as _i47;
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt.dart' as _i44;
import 'package:cezeri_commerce/3_domain/entities/reorder/supplier.dart'
    as _i50;
import 'package:flutter/material.dart' as _i43;

/// generated route for
/// [_i1.AppointmentsOverviewScreen]
class AppointmentsOverviewRoute
    extends _i42.PageRouteInfo<AppointmentsOverviewRouteArgs> {
  AppointmentsOverviewRoute({
    _i43.Key? key,
    required _i44.ReceiptType receiptTyp,
    List<_i42.PageRouteInfo>? children,
  }) : super(
          AppointmentsOverviewRoute.name,
          args: AppointmentsOverviewRouteArgs(
            key: key,
            receiptTyp: receiptTyp,
          ),
          initialChildren: children,
        );

  static const String name = 'AppointmentsOverviewRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppointmentsOverviewRouteArgs>();
      return _i1.AppointmentsOverviewScreen(
        key: args.key,
        receiptTyp: args.receiptTyp,
      );
    },
  );
}

class AppointmentsOverviewRouteArgs {
  const AppointmentsOverviewRouteArgs({
    this.key,
    required this.receiptTyp,
  });

  final _i43.Key? key;

  final _i44.ReceiptType receiptTyp;

  @override
  String toString() {
    return 'AppointmentsOverviewRouteArgs{key: $key, receiptTyp: $receiptTyp}';
  }
}

/// generated route for
/// [_i2.CarrierDetailScreen]
class CarrierDetailRoute extends _i42.PageRouteInfo<CarrierDetailRouteArgs> {
  CarrierDetailRoute({
    _i43.Key? key,
    required int index,
    List<_i42.PageRouteInfo>? children,
  }) : super(
          CarrierDetailRoute.name,
          args: CarrierDetailRouteArgs(
            key: key,
            index: index,
          ),
          initialChildren: children,
        );

  static const String name = 'CarrierDetailRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CarrierDetailRouteArgs>();
      return _i2.CarrierDetailScreen(
        key: args.key,
        index: args.index,
      );
    },
  );
}

class CarrierDetailRouteArgs {
  const CarrierDetailRouteArgs({
    this.key,
    required this.index,
  });

  final _i43.Key? key;

  final int index;

  @override
  String toString() {
    return 'CarrierDetailRouteArgs{key: $key, index: $index}';
  }
}

/// generated route for
/// [_i3.CarriersOverviewScreen]
class CarriersOverviewRoute extends _i42.PageRouteInfo<void> {
  const CarriersOverviewRoute({List<_i42.PageRouteInfo>? children})
      : super(
          CarriersOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'CarriersOverviewRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i3.CarriersOverviewScreen();
    },
  );
}

/// generated route for
/// [_i4.CustomerDetailScreen]
class CustomerDetailRoute extends _i42.PageRouteInfo<CustomerDetailRouteArgs> {
  CustomerDetailRoute({
    _i43.Key? key,
    required String? customerId,
    List<_i42.PageRouteInfo>? children,
  }) : super(
          CustomerDetailRoute.name,
          args: CustomerDetailRouteArgs(
            key: key,
            customerId: customerId,
          ),
          initialChildren: children,
        );

  static const String name = 'CustomerDetailRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CustomerDetailRouteArgs>();
      return _i4.CustomerDetailScreen(
        key: args.key,
        customerId: args.customerId,
      );
    },
  );
}

class CustomerDetailRouteArgs {
  const CustomerDetailRouteArgs({
    this.key,
    required this.customerId,
  });

  final _i43.Key? key;

  final String? customerId;

  @override
  String toString() {
    return 'CustomerDetailRouteArgs{key: $key, customerId: $customerId}';
  }
}

/// generated route for
/// [_i5.CustomersOverviewScreen]
class CustomersOverviewRoute extends _i42.PageRouteInfo<void> {
  const CustomersOverviewRoute({List<_i42.PageRouteInfo>? children})
      : super(
          CustomersOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'CustomersOverviewRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i5.CustomersOverviewScreen();
    },
  );
}

/// generated route for
/// [_i6.DashboardScreen]
class DashboardRoute extends _i42.PageRouteInfo<void> {
  const DashboardRoute({List<_i42.PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i6.DashboardScreen();
    },
  );
}

/// generated route for
/// [_i7.DeliveryNotesOverviewScreen]
class DeliveryNotesOverviewRoute
    extends _i42.PageRouteInfo<DeliveryNotesOverviewRouteArgs> {
  DeliveryNotesOverviewRoute({
    _i43.Key? key,
    required _i44.ReceiptType receiptTyp,
    List<_i42.PageRouteInfo>? children,
  }) : super(
          DeliveryNotesOverviewRoute.name,
          args: DeliveryNotesOverviewRouteArgs(
            key: key,
            receiptTyp: receiptTyp,
          ),
          initialChildren: children,
        );

  static const String name = 'DeliveryNotesOverviewRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DeliveryNotesOverviewRouteArgs>();
      return _i7.DeliveryNotesOverviewScreen(
        key: args.key,
        receiptTyp: args.receiptTyp,
      );
    },
  );
}

class DeliveryNotesOverviewRouteArgs {
  const DeliveryNotesOverviewRouteArgs({
    this.key,
    required this.receiptTyp,
  });

  final _i43.Key? key;

  final _i44.ReceiptType receiptTyp;

  @override
  String toString() {
    return 'DeliveryNotesOverviewRouteArgs{key: $key, receiptTyp: $receiptTyp}';
  }
}

/// generated route for
/// [_i8.EMailAutomationScreen]
class EMailAutomationRoute extends _i42.PageRouteInfo<void> {
  const EMailAutomationRoute({List<_i42.PageRouteInfo>? children})
      : super(
          EMailAutomationRoute.name,
          initialChildren: children,
        );

  static const String name = 'EMailAutomationRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i8.EMailAutomationScreen();
    },
  );
}

/// generated route for
/// [_i9.GeneralLedgerAccountScreen]
class GeneralLedgerAccountRoute extends _i42.PageRouteInfo<void> {
  const GeneralLedgerAccountRoute({List<_i42.PageRouteInfo>? children})
      : super(
          GeneralLedgerAccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'GeneralLedgerAccountRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i9.GeneralLedgerAccountScreen();
    },
  );
}

/// generated route for
/// [_i10.HomeScreen]
class HomeRoute extends _i42.PageRouteInfo<void> {
  const HomeRoute({List<_i42.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i10.HomeScreen();
    },
  );
}

/// generated route for
/// [_i11.InvoicesOverviewScreen]
class InvoicesOverviewRoute
    extends _i42.PageRouteInfo<InvoicesOverviewRouteArgs> {
  InvoicesOverviewRoute({
    _i43.Key? key,
    required _i44.ReceiptType receiptTyp,
    List<_i42.PageRouteInfo>? children,
  }) : super(
          InvoicesOverviewRoute.name,
          args: InvoicesOverviewRouteArgs(
            key: key,
            receiptTyp: receiptTyp,
          ),
          initialChildren: children,
        );

  static const String name = 'InvoicesOverviewRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InvoicesOverviewRouteArgs>();
      return _i11.InvoicesOverviewScreen(
        key: args.key,
        receiptTyp: args.receiptTyp,
      );
    },
  );
}

class InvoicesOverviewRouteArgs {
  const InvoicesOverviewRouteArgs({
    this.key,
    required this.receiptTyp,
  });

  final _i43.Key? key;

  final _i44.ReceiptType receiptTyp;

  @override
  String toString() {
    return 'InvoicesOverviewRouteArgs{key: $key, receiptTyp: $receiptTyp}';
  }
}

/// generated route for
/// [_i12.MainSettingsScreen]
class MainSettingsRoute extends _i42.PageRouteInfo<void> {
  const MainSettingsRoute({List<_i42.PageRouteInfo>? children})
      : super(
          MainSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainSettingsRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i12.MainSettingsScreen();
    },
  );
}

/// generated route for
/// [_i13.MarketplacesOverviewScreen]
class MarketplacesOverviewRoute
    extends _i42.PageRouteInfo<MarketplacesOverviewRouteArgs> {
  MarketplacesOverviewRoute({
    _i43.Key? key,
    bool comeFromPos = false,
    List<_i42.PageRouteInfo>? children,
  }) : super(
          MarketplacesOverviewRoute.name,
          args: MarketplacesOverviewRouteArgs(
            key: key,
            comeFromPos: comeFromPos,
          ),
          initialChildren: children,
        );

  static const String name = 'MarketplacesOverviewRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MarketplacesOverviewRouteArgs>(
          orElse: () => const MarketplacesOverviewRouteArgs());
      return _i13.MarketplacesOverviewScreen(
        key: args.key,
        comeFromPos: args.comeFromPos,
      );
    },
  );
}

class MarketplacesOverviewRouteArgs {
  const MarketplacesOverviewRouteArgs({
    this.key,
    this.comeFromPos = false,
  });

  final _i43.Key? key;

  final bool comeFromPos;

  @override
  String toString() {
    return 'MarketplacesOverviewRouteArgs{key: $key, comeFromPos: $comeFromPos}';
  }
}

/// generated route for
/// [_i14.MyFullscreenImagePage]
class MyFullscreenImageRoute
    extends _i42.PageRouteInfo<MyFullscreenImageRouteArgs> {
  MyFullscreenImageRoute({
    _i43.Key? key,
    required List<String> imagePaths,
    required int initialIndex,
    required bool isNetworkImage,
    List<_i42.PageRouteInfo>? children,
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

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MyFullscreenImageRouteArgs>();
      return _i14.MyFullscreenImagePage(
        key: args.key,
        imagePaths: args.imagePaths,
        initialIndex: args.initialIndex,
        isNetworkImage: args.isNetworkImage,
      );
    },
  );
}

class MyFullscreenImageRouteArgs {
  const MyFullscreenImageRouteArgs({
    this.key,
    required this.imagePaths,
    required this.initialIndex,
    required this.isNetworkImage,
  });

  final _i43.Key? key;

  final List<String> imagePaths;

  final int initialIndex;

  final bool isNetworkImage;

  @override
  String toString() {
    return 'MyFullscreenImageRouteArgs{key: $key, imagePaths: $imagePaths, initialIndex: $initialIndex, isNetworkImage: $isNetworkImage}';
  }
}

/// generated route for
/// [_i15.OffersOverviewScreen]
class OffersOverviewRoute extends _i42.PageRouteInfo<OffersOverviewRouteArgs> {
  OffersOverviewRoute({
    _i43.Key? key,
    required _i44.ReceiptType receiptTyp,
    List<_i42.PageRouteInfo>? children,
  }) : super(
          OffersOverviewRoute.name,
          args: OffersOverviewRouteArgs(
            key: key,
            receiptTyp: receiptTyp,
          ),
          initialChildren: children,
        );

  static const String name = 'OffersOverviewRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OffersOverviewRouteArgs>();
      return _i15.OffersOverviewScreen(
        key: args.key,
        receiptTyp: args.receiptTyp,
      );
    },
  );
}

class OffersOverviewRouteArgs {
  const OffersOverviewRouteArgs({
    this.key,
    required this.receiptTyp,
  });

  final _i43.Key? key;

  final _i44.ReceiptType receiptTyp;

  @override
  String toString() {
    return 'OffersOverviewRouteArgs{key: $key, receiptTyp: $receiptTyp}';
  }
}

/// generated route for
/// [_i16.PackagingBoxesScreen]
class PackagingBoxesRoute extends _i42.PageRouteInfo<void> {
  const PackagingBoxesRoute({List<_i42.PageRouteInfo>? children})
      : super(
          PackagingBoxesRoute.name,
          initialChildren: children,
        );

  static const String name = 'PackagingBoxesRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i16.PackagingBoxesScreen();
    },
  );
}

/// generated route for
/// [_i17.PackingStationDetailScreen]
class PackingStationDetailRoute
    extends _i42.PageRouteInfo<PackingStationDetailRouteArgs> {
  PackingStationDetailRoute({
    _i43.Key? key,
    required _i45.PackingStationBloc packingStationBloc,
    required _i46.AbstractMarketplace marketplace,
    List<_i42.PageRouteInfo>? children,
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

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PackingStationDetailRouteArgs>();
      return _i17.PackingStationDetailScreen(
        key: args.key,
        packingStationBloc: args.packingStationBloc,
        marketplace: args.marketplace,
      );
    },
  );
}

class PackingStationDetailRouteArgs {
  const PackingStationDetailRouteArgs({
    this.key,
    required this.packingStationBloc,
    required this.marketplace,
  });

  final _i43.Key? key;

  final _i45.PackingStationBloc packingStationBloc;

  final _i46.AbstractMarketplace marketplace;

  @override
  String toString() {
    return 'PackingStationDetailRouteArgs{key: $key, packingStationBloc: $packingStationBloc, marketplace: $marketplace}';
  }
}

/// generated route for
/// [_i18.PackingStationOverviewScreen]
class PackingStationOverviewRoute extends _i42.PageRouteInfo<void> {
  const PackingStationOverviewRoute({List<_i42.PageRouteInfo>? children})
      : super(
          PackingStationOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'PackingStationOverviewRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i18.PackingStationOverviewScreen();
    },
  );
}

/// generated route for
/// [_i19.PaymentMethodScreen]
class PaymentMethodRoute extends _i42.PageRouteInfo<void> {
  const PaymentMethodRoute({List<_i42.PageRouteInfo>? children})
      : super(
          PaymentMethodRoute.name,
          initialChildren: children,
        );

  static const String name = 'PaymentMethodRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i19.PaymentMethodScreen();
    },
  );
}

/// generated route for
/// [_i20.PicklistDetailScreen]
class PicklistDetailRoute extends _i42.PageRouteInfo<PicklistDetailRouteArgs> {
  PicklistDetailRoute({
    _i43.Key? key,
    required _i45.PackingStationBloc packingStationBloc,
    List<_i42.PageRouteInfo>? children,
  }) : super(
          PicklistDetailRoute.name,
          args: PicklistDetailRouteArgs(
            key: key,
            packingStationBloc: packingStationBloc,
          ),
          initialChildren: children,
        );

  static const String name = 'PicklistDetailRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PicklistDetailRouteArgs>();
      return _i20.PicklistDetailScreen(
        key: args.key,
        packingStationBloc: args.packingStationBloc,
      );
    },
  );
}

class PicklistDetailRouteArgs {
  const PicklistDetailRouteArgs({
    this.key,
    required this.packingStationBloc,
  });

  final _i43.Key? key;

  final _i45.PackingStationBloc packingStationBloc;

  @override
  String toString() {
    return 'PicklistDetailRouteArgs{key: $key, packingStationBloc: $packingStationBloc}';
  }
}

/// generated route for
/// [_i21.PicklistsOverviewScreen]
class PicklistsOverviewRoute
    extends _i42.PageRouteInfo<PicklistsOverviewRouteArgs> {
  PicklistsOverviewRoute({
    _i43.Key? key,
    required _i45.PackingStationBloc packingStationBloc,
    List<_i42.PageRouteInfo>? children,
  }) : super(
          PicklistsOverviewRoute.name,
          args: PicklistsOverviewRouteArgs(
            key: key,
            packingStationBloc: packingStationBloc,
          ),
          initialChildren: children,
        );

  static const String name = 'PicklistsOverviewRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PicklistsOverviewRouteArgs>();
      return _i21.PicklistsOverviewScreen(
        key: args.key,
        packingStationBloc: args.packingStationBloc,
      );
    },
  );
}

class PicklistsOverviewRouteArgs {
  const PicklistsOverviewRouteArgs({
    this.key,
    required this.packingStationBloc,
  });

  final _i43.Key? key;

  final _i45.PackingStationBloc packingStationBloc;

  @override
  String toString() {
    return 'PicklistsOverviewRouteArgs{key: $key, packingStationBloc: $packingStationBloc}';
  }
}

/// generated route for
/// [_i22.PosDetailScreen]
class PosDetailRoute extends _i42.PageRouteInfo<PosDetailRouteArgs> {
  PosDetailRoute({
    _i43.Key? key,
    required _i47.MarketplaceShop marketplace,
    required _i48.Customer customer,
    List<_i42.PageRouteInfo>? children,
  }) : super(
          PosDetailRoute.name,
          args: PosDetailRouteArgs(
            key: key,
            marketplace: marketplace,
            customer: customer,
          ),
          initialChildren: children,
        );

  static const String name = 'PosDetailRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PosDetailRouteArgs>();
      return _i22.PosDetailScreen(
        key: args.key,
        marketplace: args.marketplace,
        customer: args.customer,
      );
    },
  );
}

class PosDetailRouteArgs {
  const PosDetailRouteArgs({
    this.key,
    required this.marketplace,
    required this.customer,
  });

  final _i43.Key? key;

  final _i47.MarketplaceShop marketplace;

  final _i48.Customer customer;

  @override
  String toString() {
    return 'PosDetailRouteArgs{key: $key, marketplace: $marketplace, customer: $customer}';
  }
}

/// generated route for
/// [_i23.PosOverviewScreen]
class PosOverviewRoute extends _i42.PageRouteInfo<void> {
  const PosOverviewRoute({List<_i42.PageRouteInfo>? children})
      : super(
          PosOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'PosOverviewRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i23.PosOverviewScreen();
    },
  );
}

/// generated route for
/// [_i24.ProductDescriptionPage]
class ProductDescriptionRoute
    extends _i42.PageRouteInfo<ProductDescriptionRouteArgs> {
  ProductDescriptionRoute({
    _i43.Key? key,
    required _i49.ProductDetailBloc productDetailBloc,
    required String description,
    required String descriptionShort,
    required bool isDescriptionChanged,
    List<_i42.PageRouteInfo>? children,
  }) : super(
          ProductDescriptionRoute.name,
          args: ProductDescriptionRouteArgs(
            key: key,
            productDetailBloc: productDetailBloc,
            description: description,
            descriptionShort: descriptionShort,
            isDescriptionChanged: isDescriptionChanged,
          ),
          initialChildren: children,
        );

  static const String name = 'ProductDescriptionRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductDescriptionRouteArgs>();
      return _i24.ProductDescriptionPage(
        key: args.key,
        productDetailBloc: args.productDetailBloc,
        description: args.description,
        descriptionShort: args.descriptionShort,
        isDescriptionChanged: args.isDescriptionChanged,
      );
    },
  );
}

class ProductDescriptionRouteArgs {
  const ProductDescriptionRouteArgs({
    this.key,
    required this.productDetailBloc,
    required this.description,
    required this.descriptionShort,
    required this.isDescriptionChanged,
  });

  final _i43.Key? key;

  final _i49.ProductDetailBloc productDetailBloc;

  final String description;

  final String descriptionShort;

  final bool isDescriptionChanged;

  @override
  String toString() {
    return 'ProductDescriptionRouteArgs{key: $key, productDetailBloc: $productDetailBloc, description: $description, descriptionShort: $descriptionShort, isDescriptionChanged: $isDescriptionChanged}';
  }
}

/// generated route for
/// [_i25.ProductDetailScreen]
class ProductDetailRoute extends _i42.PageRouteInfo<ProductDetailRouteArgs> {
  ProductDetailRoute({
    _i43.Key? key,
    String? productId,
    List<_i42.PageRouteInfo>? children,
  }) : super(
          ProductDetailRoute.name,
          args: ProductDetailRouteArgs(
            key: key,
            productId: productId,
          ),
          initialChildren: children,
        );

  static const String name = 'ProductDetailRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductDetailRouteArgs>(
          orElse: () => const ProductDetailRouteArgs());
      return _i25.ProductDetailScreen(
        key: args.key,
        productId: args.productId,
      );
    },
  );
}

class ProductDetailRouteArgs {
  const ProductDetailRouteArgs({
    this.key,
    this.productId,
  });

  final _i43.Key? key;

  final String? productId;

  @override
  String toString() {
    return 'ProductDetailRouteArgs{key: $key, productId: $productId}';
  }
}

/// generated route for
/// [_i26.ProductExportScreen]
class ProductExportRoute extends _i42.PageRouteInfo<void> {
  const ProductExportRoute({List<_i42.PageRouteInfo>? children})
      : super(
          ProductExportRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductExportRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i26.ProductExportScreen();
    },
  );
}

/// generated route for
/// [_i27.ProductImportScreen]
class ProductImportRoute extends _i42.PageRouteInfo<void> {
  const ProductImportRoute({List<_i42.PageRouteInfo>? children})
      : super(
          ProductImportRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductImportRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i27.ProductImportScreen();
    },
  );
}

/// generated route for
/// [_i28.ProductsBookingScreen]
class ProductsBookingRoute extends _i42.PageRouteInfo<void> {
  const ProductsBookingRoute({List<_i42.PageRouteInfo>? children})
      : super(
          ProductsBookingRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductsBookingRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i28.ProductsBookingScreen();
    },
  );
}

/// generated route for
/// [_i29.ProductsOverviewScreen]
class ProductsOverviewRoute extends _i42.PageRouteInfo<void> {
  const ProductsOverviewRoute({List<_i42.PageRouteInfo>? children})
      : super(
          ProductsOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductsOverviewRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i29.ProductsOverviewScreen();
    },
  );
}

/// generated route for
/// [_i30.ReceiptDetailScreen]
class ReceiptDetailRoute extends _i42.PageRouteInfo<ReceiptDetailRouteArgs> {
  ReceiptDetailRoute({
    _i43.Key? key,
    required String? receiptId,
    required _i44.Receipt? newEmptyReceipt,
    required _i44.ReceiptType receiptTyp,
    List<_i42.PageRouteInfo>? children,
  }) : super(
          ReceiptDetailRoute.name,
          args: ReceiptDetailRouteArgs(
            key: key,
            receiptId: receiptId,
            newEmptyReceipt: newEmptyReceipt,
            receiptTyp: receiptTyp,
          ),
          initialChildren: children,
        );

  static const String name = 'ReceiptDetailRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReceiptDetailRouteArgs>();
      return _i30.ReceiptDetailScreen(
        key: args.key,
        receiptId: args.receiptId,
        newEmptyReceipt: args.newEmptyReceipt,
        receiptTyp: args.receiptTyp,
      );
    },
  );
}

class ReceiptDetailRouteArgs {
  const ReceiptDetailRouteArgs({
    this.key,
    required this.receiptId,
    required this.newEmptyReceipt,
    required this.receiptTyp,
  });

  final _i43.Key? key;

  final String? receiptId;

  final _i44.Receipt? newEmptyReceipt;

  final _i44.ReceiptType receiptTyp;

  @override
  String toString() {
    return 'ReceiptDetailRouteArgs{key: $key, receiptId: $receiptId, newEmptyReceipt: $newEmptyReceipt, receiptTyp: $receiptTyp}';
  }
}

/// generated route for
/// [_i31.RegisterUserDataScreen]
class RegisterUserDataRoute extends _i42.PageRouteInfo<void> {
  const RegisterUserDataRoute({List<_i42.PageRouteInfo>? children})
      : super(
          RegisterUserDataRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterUserDataRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i31.RegisterUserDataScreen();
    },
  );
}

/// generated route for
/// [_i32.ReorderDetailScreen]
class ReorderDetailRoute extends _i42.PageRouteInfo<ReorderDetailRouteArgs> {
  ReorderDetailRoute({
    _i43.Key? key,
    required _i32.ReorderCreateOrEdit reorderCreateOrEdit,
    _i50.Supplier? supplier,
    String? reorderId,
    List<_i42.PageRouteInfo>? children,
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

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReorderDetailRouteArgs>();
      return _i32.ReorderDetailScreen(
        key: args.key,
        reorderCreateOrEdit: args.reorderCreateOrEdit,
        supplier: args.supplier,
        reorderId: args.reorderId,
      );
    },
  );
}

class ReorderDetailRouteArgs {
  const ReorderDetailRouteArgs({
    this.key,
    required this.reorderCreateOrEdit,
    this.supplier,
    this.reorderId,
  });

  final _i43.Key? key;

  final _i32.ReorderCreateOrEdit reorderCreateOrEdit;

  final _i50.Supplier? supplier;

  final String? reorderId;

  @override
  String toString() {
    return 'ReorderDetailRouteArgs{key: $key, reorderCreateOrEdit: $reorderCreateOrEdit, supplier: $supplier, reorderId: $reorderId}';
  }
}

/// generated route for
/// [_i33.ReordersOverviewScreen]
class ReordersOverviewRoute extends _i42.PageRouteInfo<void> {
  const ReordersOverviewRoute({List<_i42.PageRouteInfo>? children})
      : super(
          ReordersOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReordersOverviewRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i33.ReordersOverviewScreen();
    },
  );
}

/// generated route for
/// [_i34.ResetPasswordScreen]
class ResetPasswordRoute extends _i42.PageRouteInfo<void> {
  const ResetPasswordRoute({List<_i42.PageRouteInfo>? children})
      : super(
          ResetPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i34.ResetPasswordScreen();
    },
  );
}

/// generated route for
/// [_i35.ShippingLabelScreen]
class ShippingLabelRoute extends _i42.PageRouteInfo<void> {
  const ShippingLabelRoute({List<_i42.PageRouteInfo>? children})
      : super(
          ShippingLabelRoute.name,
          initialChildren: children,
        );

  static const String name = 'ShippingLabelRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i35.ShippingLabelScreen();
    },
  );
}

/// generated route for
/// [_i36.SignInScreen]
class SignInRoute extends _i42.PageRouteInfo<void> {
  const SignInRoute({List<_i42.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i36.SignInScreen();
    },
  );
}

/// generated route for
/// [_i37.SignUpScreen]
class SignUpRoute extends _i42.PageRouteInfo<void> {
  const SignUpRoute({List<_i42.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i37.SignUpScreen();
    },
  );
}

/// generated route for
/// [_i38.SplashPage]
class SplashRoute extends _i42.PageRouteInfo<SplashRouteArgs> {
  SplashRoute({
    _i43.Key? key,
    _i38.ComeFromToSplashPage? comeFrom,
    List<_i42.PageRouteInfo>? children,
  }) : super(
          SplashRoute.name,
          args: SplashRouteArgs(
            key: key,
            comeFrom: comeFrom,
          ),
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<SplashRouteArgs>(orElse: () => const SplashRouteArgs());
      return _i38.SplashPage(
        key: args.key,
        comeFrom: args.comeFrom,
      );
    },
  );
}

class SplashRouteArgs {
  const SplashRouteArgs({
    this.key,
    this.comeFrom,
  });

  final _i43.Key? key;

  final _i38.ComeFromToSplashPage? comeFrom;

  @override
  String toString() {
    return 'SplashRouteArgs{key: $key, comeFrom: $comeFrom}';
  }
}

/// generated route for
/// [_i39.SupplierDetailScreen]
class SupplierDetailRoute extends _i42.PageRouteInfo<SupplierDetailRouteArgs> {
  SupplierDetailRoute({
    _i43.Key? key,
    required _i51.SupplierBloc supplierBloc,
    required _i39.SupplierCreateOrEdit supplierCreateOrEdit,
    List<_i42.PageRouteInfo>? children,
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

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SupplierDetailRouteArgs>();
      return _i39.SupplierDetailScreen(
        key: args.key,
        supplierBloc: args.supplierBloc,
        supplierCreateOrEdit: args.supplierCreateOrEdit,
      );
    },
  );
}

class SupplierDetailRouteArgs {
  const SupplierDetailRouteArgs({
    this.key,
    required this.supplierBloc,
    required this.supplierCreateOrEdit,
  });

  final _i43.Key? key;

  final _i51.SupplierBloc supplierBloc;

  final _i39.SupplierCreateOrEdit supplierCreateOrEdit;

  @override
  String toString() {
    return 'SupplierDetailRouteArgs{key: $key, supplierBloc: $supplierBloc, supplierCreateOrEdit: $supplierCreateOrEdit}';
  }
}

/// generated route for
/// [_i40.SuppliersOverviewScreen]
class SuppliersOverviewRoute extends _i42.PageRouteInfo<void> {
  const SuppliersOverviewRoute({List<_i42.PageRouteInfo>? children})
      : super(
          SuppliersOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'SuppliersOverviewRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i40.SuppliersOverviewScreen();
    },
  );
}

/// generated route for
/// [_i41.TaxRulesScreen]
class TaxRulesRoute extends _i42.PageRouteInfo<void> {
  const TaxRulesRoute({List<_i42.PageRouteInfo>? children})
      : super(
          TaxRulesRoute.name,
          initialChildren: children,
        );

  static const String name = 'TaxRulesRoute';

  static _i42.PageInfo page = _i42.PageInfo(
    name,
    builder: (data) {
      return const _i41.TaxRulesScreen();
    },
  );
}
