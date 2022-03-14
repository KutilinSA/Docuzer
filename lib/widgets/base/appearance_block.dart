import 'package:docuzer/ui/themes.dart';
import 'package:flutter/material.dart';

class AppearanceBlock extends StatelessWidget {
  final Widget child;
  final bool isAppeared;
  final double? inset;
  final Widget Function(Widget)? wrapperBuilder;

  const AppearanceBlock({ required this.child, this.isAppeared = false,
    this.inset = 160, this.wrapperBuilder, Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animatedOpacity = AnimatedOpacity(
      opacity: isAppeared ? 1.0 : 0.0,
      duration: Themes.appearanceAnimationDuration,
      curve: Themes.appearanceAnimationCurve,
      child: child,
    );

    if (wrapperBuilder == null) {
      if (inset == null) {
        return animatedOpacity;
      }
      return AnimatedPadding(
        duration: Themes.appearanceAnimationDuration,
        curve: Themes.appearanceAnimationCurve,
        padding: EdgeInsets.only(top: isAppeared ? 0.0 : inset!),
        child: animatedOpacity,
      );
    }

    return wrapperBuilder!.call(animatedOpacity);
  }
}