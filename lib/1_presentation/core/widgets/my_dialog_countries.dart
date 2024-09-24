import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../3_domain/entities/country.dart';
import '../../../constants.dart';
import '../core.dart';

class MyDialogSelectCountry extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final String selectedCountry;
  final void Function(Country country) onSelectCountry;
  final TextCapitalization textCapitalization;
  final int maxLines;

  const MyDialogSelectCountry(
      {super.key,
      required this.labelText,
      this.hintText,
      required this.selectedCountry,
      required this.onSelectCountry,
      this.textCapitalization = TextCapitalization.none,
      this.maxLines = 1});

  @override
  State<MyDialogSelectCountry> createState() => _MyDialogSelectCountryState();
}

class _MyDialogSelectCountryState extends State<MyDialogSelectCountry> {
  late Country selectedCountry;

  @override
  void initState() {
    super.initState();
    selectedCountry = Country.countryList.where((e) => e.name == widget.selectedCountry).first;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDialog(
          context: context,
          builder: (context) {
            final screenHeight = MediaQuery.sizeOf(context).height;
            final screenWidth = MediaQuery.sizeOf(context).width;
            return SelectVehicleDialog(onSelectCountry: _selectVehicleBrand, screenHeight: screenHeight, screenWidth: screenWidth);
          }),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: const TextStyle().copyWith(letterSpacing: 0),
          hintText: widget.hintText,
          hintStyle: const TextStyle().copyWith(letterSpacing: 0),
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.red),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: CustomColors.borderColorLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: CustomColors.primaryColor),
          ),
        ),
        child: Row(
          children: [
            MyCountryFlag(country: selectedCountry),
            const SizedBox(width: 15),
            Text(selectedCountry.name, style: TextStyles.h3),
          ],
        ),
      ),
    );
  }

  void _selectVehicleBrand(Country country) => setState(() {
        selectedCountry = country;
        widget.onSelectCountry(country);
      });
}

class SelectVehicleDialog extends StatefulWidget {
  final void Function(Country country) onSelectCountry;
  final double screenHeight;
  final double screenWidth;

  const SelectVehicleDialog({super.key, required this.onSelectCountry, required this.screenHeight, required this.screenWidth});

  @override
  State<SelectVehicleDialog> createState() => _SelectVehicleDialogState();
}

final _controller = TextEditingController();

class _SelectVehicleDialogState extends State<SelectVehicleDialog> {
  @override
  Widget build(BuildContext context) {
    List<Country> countryList = Country.countryList;

    if (_controller.text.isNotEmpty) countryList = countryList.where((e) => e.name.toLowerCase().contains(_controller.text.toLowerCase())).toList();

    return Dialog(
      child: SizedBox(
        height: widget.screenHeight > 1000 ? 1000 : widget.screenHeight - 400,
        width: widget.screenWidth > 500 ? 500 : widget.screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoSearchTextField(
                controller: _controller,
                onChanged: (value) => setState(() {}),
                onSuffixTap: () => _controller.clear(),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: countryList.length,
                  itemBuilder: ((context, index) {
                    final country = countryList[index];
                    return Column(
                      children: [
                        if (index == 0) Gaps.h10,
                        ListTile(
                          leading: SizedBox(
                            width: 40,
                            child: MyAvatar(
                              name: country.isoCode,
                              imageUrl: country.flagUrl,
                              radius: 18,
                              fontSize: 14,
                              fit: BoxFit.scaleDown,
                              shape: BoxShape.rectangle,
                            ),
                          ),
                          title: Text(country.name),
                          onTap: () {
                            print('onTap: ${country.name}');
                            _controller.clear();
                            widget.onSelectCountry(country);
                            context.router.maybePop();
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
