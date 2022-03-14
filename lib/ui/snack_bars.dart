import 'package:flutter/material.dart';

class SnackBars {
  static void showSuccessSnackBar(BuildContext context, { required String text, VoidCallback? onTap, Duration duration = const Duration(seconds: 2) }) {
    _showSnackBar(context, text: text, onTap: onTap, duration: duration, icon: const Icon(
      Icons.check_circle_outline_outlined,
      color: Colors.green,
      size: 28,
    ));
  }

  static void showErrorSnackBar(BuildContext context, { required String text, VoidCallback? onTap, Duration duration = const Duration(seconds: 2) }) {
    _showSnackBar(context, text: text, onTap: onTap, duration: duration, icon: Icon(
      Icons.cancel_outlined,
      color: Theme.of(context).errorColor,
      size: 28,
    ));
  }

  static void _showSnackBar(BuildContext context, { required String text, Icon? icon, VoidCallback? onTap, Duration duration = const Duration(seconds: 2) }) {
    final snackContent = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          if (icon != null)
            icon,
          if (icon != null)
            const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
            ),
          ),
          if (onTap != null)
            const SizedBox(width: 16),
          if (onTap != null)
            const Icon(Icons.arrow_forward_ios_rounded, size: 24),
        ],
      ),
    );
    if (onTap != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        padding: EdgeInsets.zero,
        duration: duration,
        content: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
          child: snackContent,
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        padding: EdgeInsets.zero,
        duration: duration,
        content: snackContent,
      ));
    }
  }
}
