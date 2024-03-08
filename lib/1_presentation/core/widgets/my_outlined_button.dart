import 'package:cezeri_commerce/1_presentation/core/widgets/my_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class MyOutlinedButton extends StatelessWidget {
  final String buttonText;
  final bool isLoading;
  final Color? buttonBackgroundColor;
  final Color textColor;
  final Color isLoadingIndicatorColor;
  final VoidCallback onPressed;

  const MyOutlinedButton({
    super.key,
    required this.buttonText,
    this.isLoading = false,
    this.buttonBackgroundColor = CustomColors.primaryColor,
    this.textColor = Colors.white,
    this.isLoadingIndicatorColor = Colors.white,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: !isLoading ? onPressed : null,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(100.0, 36.0),
        backgroundColor: buttonBackgroundColor,
        foregroundColor: textColor,
      ),
      child: isLoading ? const MyCircularProgressIndicator(color: Colors.white) : Text(buttonText),
    );
  }
}
