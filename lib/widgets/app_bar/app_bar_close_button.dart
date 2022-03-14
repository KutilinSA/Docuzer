import 'package:flutter/material.dart';

class AppBarCloseButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AppBarCloseButton({ Key? key, this.onPressed }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(6),
      icon: const Icon(Icons.close_rounded, size: 28),
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.maybePop(context);
        }
      },
    );
  }
}