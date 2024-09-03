import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../../3_domain/entities/settings/tax.dart';
import '../../../constants.dart';
import 'my_country_flag.dart';

class MyDialogTaxes extends StatelessWidget {
  final Function(Tax) onChanged;

  const MyDialogTaxes({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    final taxList = context.read<MainSettingsBloc>().state.mainSettings!.taxes;

    return Dialog(
      child: SizedBox(
        height: screenHeight > 1000 ? 1000 : screenHeight - 400,
        width: screenWidth > 500 ? 500 : screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: taxList.length,
                  itemBuilder: ((context, index) {
                    final taxRule = taxList[index];
                    return Column(
                      children: [
                        if (index == 0) Gaps.h10,
                        ListTile(
                          leading: MyCountryFlag(country: taxRule.country),
                          title: Row(
                            children: [
                              Text(taxRule.country.name),
                              Text(' / ${taxRule.taxRate.toString()}%'),
                            ],
                          ),
                          subtitle: Text(taxRule.taxName),
                          onTap: () {
                            context.router.pop();
                            onChanged(taxRule);
                          },
                        ),
                        const Divider(height: 0),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
