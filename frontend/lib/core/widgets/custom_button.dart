import 'package:flutter/material.dart';
import  '../../core/theme/app_colors.dart'; // adjust the path as needed

enum ButtonType {
  primary,
  gray,
  red,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isLoading;
  final ButtonType type;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
    this.type = ButtonType.primary,
  });

  Color _getBackgroundColor() {
    if (!isEnabled) {
      return const Color.fromARGB(128, 255, 238, 227); // 50% opacity
    }

    switch (type) {
      case ButtonType.primary:
        return AppColors.accent;
      case ButtonType.gray:
        return const Color.fromARGB(153, 79, 82, 85); // 60% opacity
      case ButtonType.red:
        return Colors.red.shade600;
    }
  }

  Color _getTextColor() {
    if (!isEnabled) {
      return const Color.fromARGB(179, 79, 82, 85); // 70% opacity
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: _getBackgroundColor(),
        foregroundColor: _getTextColor(),
        disabledBackgroundColor: const Color.fromARGB(128, 255, 238, 227),
        disabledForegroundColor: const Color.fromARGB(179, 79, 82, 85),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(text),
    );
  }
}
