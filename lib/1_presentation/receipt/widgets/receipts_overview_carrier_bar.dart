import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../3_domain/entities/carrier/parcel_tracking.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../constants.dart';

final logger = Logger();

class ReceiptsOverviewCarrierBar extends StatelessWidget {
  final Receipt receipt;

  const ReceiptsOverviewCarrierBar({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final isLinkExists = receipt.listOfParcelTracking.isNotEmpty &&
        receipt.listOfParcelTracking.first.trackingUrl.isNotEmpty &&
        receipt.listOfParcelTracking.first.trackingNumber.isNotEmpty;

    final isPdfExists = receipt.listOfParcelTracking.isNotEmpty && receipt.listOfParcelTracking.first.pdfString.isNotEmpty;

    final parcelCount = receipt.listOfParcelTracking.length;

    return Column(
      children: [
        Stack(
          children: [
            Tooltip(
              message: 'Sendeverfolgungslink öffnen',
              child: IconButton(
                onPressed: () async {
                  if (parcelCount == 0) return;
                  if (parcelCount == 1 && isLinkExists) {
                    await _openTrackingLink(
                      context,
                      receipt.listOfParcelTracking.first.trackingUrl + receipt.listOfParcelTracking.first.trackingNumber,
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    builder: (context) => _TrackingListDialog(
                      listOfParcelTracking: receipt.listOfParcelTracking,
                      isPrinting: false,
                    ),
                  );
                },
                icon: Icon(Icons.open_in_browser, color: isLinkExists ? Colors.green : null),
              ),
            ),
            if (parcelCount > 1)
              Positioned(
                right: 0,
                top: 0,
                child: Badge(
                  label: Text(parcelCount.toString(), style: const TextStyle(color: Colors.white)),
                  backgroundColor: Colors.red,
                ),
              ),
          ],
        ),
        Tooltip(
          message: 'Versandetikett Drucken',
          child: IconButton(
            onPressed: () async {
              if (parcelCount == 0) return;
              if (parcelCount == 1 && isPdfExists) {
                await _openPrintingDialog(receipt.listOfParcelTracking.first.pdfString);
                return;
              }

              showDialog(
                context: context,
                builder: (context) => _TrackingListDialog(
                  listOfParcelTracking: receipt.listOfParcelTracking,
                  isPrinting: true,
                ),
              );
            },
            icon: Icon(Icons.print, color: isLinkExists ? Colors.green : null),
          ),
        ),
      ],
    );
  }
}

class _TrackingListDialog extends StatelessWidget {
  final List<ParcelTracking> listOfParcelTracking;
  final bool isPrinting;

  const _TrackingListDialog({super.key, required this.listOfParcelTracking, required this.isPrinting});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Dialog(
      child: SizedBox(
        // height: screenHeight > 1000 ? 1000 : screenHeight - 400,
        width: screenWidth > 500 ? 500 : screenWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: listOfParcelTracking.length,
                itemBuilder: (context, index) {
                  final parcel = listOfParcelTracking[index];
                  final isLinkExists = parcel.trackingUrl.isNotEmpty && parcel.trackingNumber.isNotEmpty;
                  final isPrintExisting = parcel.trackingUrl.isNotEmpty && parcel.pdfString.isNotEmpty;
                  return ListTile(
                    title: Text((index + 1).toString()),
                    trailing: switch (isPrinting) {
                      false => Icon(Icons.open_in_browser, color: isLinkExists ? Colors.green : null),
                      _ => Icon(Icons.print, color: isPrintExisting ? CustomColors.primaryColor : null)
                    },
                    onTap: () async => switch (isPrinting) {
                      false => isLinkExists ? _openTrackingLink(context, parcel.trackingUrl + parcel.trackingNumber) : null,
                      _ => isPrintExisting ? _openPrintingDialog(parcel.pdfString) : null,
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _openTrackingLink(BuildContext context, String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    try {
      await launchUrl(uri);
    } catch (e) {
      logger.e('Sendeverfolgungslink konnte nicht geöffnet werden: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sendeverfolgungslink konnte nicht geöffnet werden: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

Future<void> _openPrintingDialog(String pdfString) async {
  final pdfBytes = base64.decode(pdfString);
  await Printing.layoutPdf(onLayout: (_) => pdfBytes);
}
