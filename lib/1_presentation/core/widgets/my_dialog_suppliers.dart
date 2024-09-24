import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/3_domain/entities/reorder/supplier.dart';
import '/constants.dart';

class MyDialogSuppliers extends StatefulWidget {
  final List<Supplier> listOfSuppliers;
  final void Function(Supplier) onChanged;
  final bool withEmptySupplier;

  const MyDialogSuppliers({super.key, required this.listOfSuppliers, required this.onChanged, this.withEmptySupplier = true});

  @override
  State<MyDialogSuppliers> createState() => _MyDialogSuppliersState();
}

class _MyDialogSuppliersState extends State<MyDialogSuppliers> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    final suppliersList = switch (_controller.text) {
      '' => widget.listOfSuppliers,
      _ => widget.listOfSuppliers.where((e) => e.company.toLowerCase().contains(_controller.text.toLowerCase())).toList(),
    };

    if (widget.withEmptySupplier && suppliersList.isNotEmpty && suppliersList.first.company != '') suppliersList.insert(0, Supplier.empty());

    return Dialog(
      child: SizedBox(
        height: screenHeight > 1200 ? 1200 : screenHeight,
        width: screenWidth > 600 ? 600 : screenWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: CupertinoSearchTextField(
                controller: _controller,
                onChanged: (_) => setState(() {}),
                onSuffixTap: () => _controller.clear(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: suppliersList.length,
                itemBuilder: ((context, index) {
                  final supplier = suppliersList[index];
                  return Column(
                    children: [
                      if (index == 0) Gaps.h10,
                      if (index == 0) const Divider(height: 0),
                      ListTile(
                        title: Text(supplier.company),
                        subtitle: supplier.name.isNotEmpty && supplier.name != ' ' ? Text(supplier.name) : null,
                        onTap: () {
                          context.router.maybePop();
                          widget.onChanged(supplier);
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
    );
  }
}
