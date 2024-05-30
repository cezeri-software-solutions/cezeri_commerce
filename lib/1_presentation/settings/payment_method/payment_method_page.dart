import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../../3_domain/entities/settings/main_settings.dart';
import '../../../3_domain/entities/settings/payment_method.dart';
import '../../../constants.dart';
import '../../app_drawer.dart';
import 'widgets/add_edti_payment_method_marketplace_name.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainSettingsBloc, MainSettingsState>(
      builder: (context, state) {
        final appBar = AppBar(
          title: const Text('Zahlungsarten'),
          actions: [IconButton(onPressed: () => context.read<MainSettingsBloc>().add(GetMainSettingsEvent()), icon: const Icon(Icons.refresh))],
        );

        const drawer = AppDrawer();

        if ((state.mainSettings == null && state.firebaseFailure == null) || state.isLoadingMainSettingsOnObserve) {
          return Scaffold(appBar: appBar, drawer: drawer, body: const Center(child: CircularProgressIndicator()));
        }

        if (state.firebaseFailure != null && state.isAnyFailure) {
          return Scaffold(appBar: appBar, drawer: drawer, body: const Center(child: Text('Ein Fehler ist aufgetreten.')));
        }

        final unusedPaymentMethods =
            PaymentMethod.paymentMethodList.where((e) => !state.mainSettings!.paymentMethods.any((f) => e.name == f.name)).toList();
        return Scaffold(
          appBar: appBar,
          drawer: drawer,
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gaps.h42,
                  const Text('Meine Zahlungsarten', style: TextStyles.h2),
                  Gaps.h16,
                  if (state.mainSettings!.paymentMethods.isEmpty)
                    const SizedBox(
                      height: 150,
                      child: Center(
                        child: Text('Keine Zahlungsarten vorhanden'),
                      ),
                    ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.mainSettings!.paymentMethods.length,
                    itemBuilder: (context, index) {
                      final paymentMethod = state.mainSettings!.paymentMethods[index];
                      return _PaymentMethodListTile(paymentMethod: paymentMethod, mainSettings: state.mainSettings!);
                    },
                  ),
                  Gaps.h42,
                  const Text('Verfügbare Zahlungsarten', style: TextStyles.h2),
                  Gaps.h16,
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: unusedPaymentMethods.length,
                    itemBuilder: (context, index) {
                      final paymentMethod = unusedPaymentMethods[index];
                      return _PaymentMethodListTile(paymentMethod: paymentMethod, mainSettings: state.mainSettings!);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PaymentMethodListTile extends StatelessWidget {
  final PaymentMethod paymentMethod;
  final MainSettings mainSettings;

  const _PaymentMethodListTile({required this.paymentMethod, required this.mainSettings});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 0),
        Container(
          color: Colors.white,
          child: ListTile(
            leading: Image.asset(paymentMethod.logoPath, height: 25, width: 65, fit: BoxFit.scaleDown),
            title: Text(paymentMethod.name),
            trailing: Switch.adaptive(
              value: mainSettings.paymentMethods.any((e) => e.name == paymentMethod.name),
              onChanged: (value) =>
                  context.read<MainSettingsBloc>().add(EnableOrDisablePaymentMethodEvent(value: value, paymentMethod: paymentMethod)),
            ),
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (context) => AddEditPaymentMethodMarketplaceName(paymentMethod: paymentMethod),
            ),
          ),
        ),
        const Divider(height: 0),
      ],
    );
  }
}
