import 'package:flutter/material.dart';

import '../classes/list_of_countries.dart';

class MyDropdownButtonCountries extends StatelessWidget {
  final Object value;
  final Function(Object?)? onChanged;
  final double? menuMaxHeight;
  const MyDropdownButtonCountries({
    super.key,
    required this.value,
    required this.onChanged,
    this.menuMaxHeight,
  });

  final List<String> listOfCountries = Countries.listOfCountries;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final String country = value.toString() != '' ? value.toString() : listOfCountries[0];
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        isExpanded: true,
        borderRadius: BorderRadius.circular(14),
        menuMaxHeight: menuMaxHeight,
        value: country,
        items: listOfCountries
            .map((String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: themeData.textTheme.bodyMedium,
                )))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
