import 'package:flutter/material.dart';

import '../../../constants.dart';

class MyElevatedButton extends StatelessWidget {
  final String buttonText;
  final bool isLoading;
  final Color? buttonBackgroundColor;
  final Color textColor;
  final Color isLoadingIndicatorColor;
  final Widget widget;
  final VoidCallback onPressed;
  final double buttonHeight;
  final double buttonWidth;

  const MyElevatedButton({
    Key? key,
    required this.buttonText,
    this.isLoading = false,
    this.buttonBackgroundColor,
    this.textColor = Colors.white,
    this.isLoadingIndicatorColor = Colors.white,
    this.widget = const Icon(null),
    required this.onPressed,
    this.buttonHeight = 42,
    this.buttonWidth = 600,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth > 600 ? 600 : buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBackgroundColor ?? CustomColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          maximumSize: const Size(600, 42),
        ),
        onPressed: onPressed,
        child: isLoading
            ? const SizedBox(height: 34, child: CircularProgressIndicator())
            : Text(buttonText, style: TextStyle(color: textColor, fontSize: 18)),
      ),
    );
  }
}
