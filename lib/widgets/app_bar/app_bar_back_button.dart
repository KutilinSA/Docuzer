import 'package:flutter/material.dart';

class AppBarBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AppBarBackButton({ Key? key, this.onPressed }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24),
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